# Conponente de monitorizacion de monedas
     ###########################################
     ### Widget para sacar la contizacion en tiempo real de las monedas
     ### Crea los tags: id - fila
     ###                id - fila - value
     ###########################################

BLK.MONITORS = R6::R6Class("YATA.WEB.BLOCK.MONITORS"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,public = list(
      initialize = function(pnl, env) {
          private$monitors = HashMap$new()
          private$pnl = pnl
          private$env = env
          initMonitors()
     }
     ,setMonitor = function(name, monitor) { rivate$monitors$put(name, monitor) }
     ,getMonitor = function(name) {
         def = tpl
         if (is.null(monitors$get(name))) {
             def$name = name
             monitors$put(name, def)
         }
         monitors$get(name)
     }
    ,render = function(id, size=2) {
        private$idDiv = paste0("#", id)
      # (ns(paste0("monitor-",x))))))
        mon = monitors$values()
        lst = lapply(seq_len(ncol(mon)), function(i) mon[,i])
        lapply(lst, function(x) insertUI( selector = idDiv, immediate=TRUE
                                           ,where = "beforeEnd"
                                           ,ui=tagList(renderMonitor(id, x, size))))
     }
     ,update = function() {
         data = pnl$getLatestSession()
#         lapply(names(data), function(x) updateMonitor(ns(paste0("monitor-",x)), pnl$getMonitor(x), data[[x]]$price))
         lapply(names(data), function(x) updateMonitor(x))
     }
   )
  ,private = list(
       monitors = NULL
      ,pnl      = NULL
      ,env      = NULL
      ,idDiv    = NULL  # DIV donde va el monitor
      ,tpl  = list(
                 name    = ""
                ,last    = 0
                ,session = 0
                ,day     = 0
                ,week    = 0
                ,price   = 0
                ,id      = 0
             )

      ,initMonitors = function() {
          df = pnl$getRoot()$data$dfPosGlobal
          df = df[df$currency != "EUR",]
          df = df[order(df$balance, decreasing=TRUE),]
          ctc = df$currency
          if (length(ctc) < 6 && !("BTC" %in% ctc)) ctc = c("BTC", ctc)
          if (length(ctc) < 6 && !("ETH" %in% ctc)) ctc = c("ETH", ctc)
          if (length(ctc) > 6) ctc = ctc[1:6]
          ctc

          ids = env$getCurrenciesID(ctc)
          lapply(ctc, function(item) getMonitor(item))
#          setMonitorsID(ids)
         lapply(names(ids), function(x) {
                mon = monitors$get(x)
                mon$id = ids[[x]]
                private$monitors$put(x, mon)
         })

          # idDiv = paste0("#", ns("monitor"))
          # lapply(pnl$getMonitor, function(x) insertUI( selector = idDiv, immediate=TRUE
          #                                  ,where = "beforeEnd"
          #                                  ,ui=tagList(yuiYataMonitor(ns(paste0("monitor-",x$code)), x))))
          # monitors = pnl$getMonitor()
          # data     = pnl$getLatestSession()
          # df       = pnl$getGlobalPosition()
          #
          # for (ctc in monitors$keys()) {
          #      monitor         = monitors$get(ctc)
          #      monitor$last    = data[[ctc]]$price
          #      monitor$session = data[[ctc]]$price
          #      monitor$hour    = data[[ctc]]$var01
          #      monitor$day     = data[[ctc]]$var24
          #      monitor$week    = data[[ctc]]$var07
          #      monitor$price   = 0
          #      if (nrow(df) > 0 && nrow(df[df$currency == ctc,]) > 0) {
          #         monitor$price = df[df$currency == ctc, "price"]
          #      }
          #      pnl$setMonitor(ctc, monitor)
          #      updYataMonitor(ns(paste0("monitor-",ctc)), monitor) # No poner last
          # }
      }
    ,renderMonitor = function(id, x, size=2) {
        idMon = paste0(id, "-monitor_", x$name)
        tags$div(column(size,tableMonitor(idMon,x)))
     }
    ,tableMonitor = function(idMon,data) {
         tags$table(class="yata_tbl_monitor"
           ,tags$tr(
              tags$td(rowspan="3", class="yata_cell_icon",
                     img(src=paste0("icons/", data$id, ".png"),width="48px", height="48px",
                     onerror="this.onerror=null;this.src='icons2/YATA.png';"))
             ,tags$td(class="yata_cell_label", "Coste")
             ,tags$td(class="yata_cell_data",  id=paste0(idMon,"_price"))
             ,tags$td(class="yata_cell_data",  id=paste0(idMon,"_price_delta"))
           )
           ,tags$tr(
              tags$td(class="yata_cell_label yataCellGroup", "Semana")
             ,tags$td(class="yata_cell_data  yataCellGroup",  id=paste0(idMon,"_week"))
             ,tags$td(class="yata_cell_data"               ,  id=paste0(idMon,"_week_delta"))
           )
           ,tags$tr(
              tags$td(class="yata_cell_label", "Dia")
             ,tags$td(class="yata_cell_data",  id=paste0(idMon,"_day"))
             ,tags$td(class="yata_cell_data",  id=paste0(idMon,"_day_delta"))
           )
           ,tags$tr(
              tags$td(rowspan="2", tags$span(class="yata_cell_ctc", data$name))
             ,tags$td(class="yata_cell_label", "Sesion")
             ,tags$td(class="yata_cell_data",  id=paste0(idMon,"_session"))
             ,tags$td(class="yata_cell_data",  id=paste0(idMon,"_session_delta"))
           )
          ,tags$tr(
              tags$td(class="yata_cell_label", "Ultimo")
             ,tags$td(class="yata_cell_data yata_cell_group", id=paste0(idMon,"_last"))
             ,tags$td(class="yata_cell_data yata_cell_group", id=paste0(idMon,"_last_delta"))
          )
        )
#  )
}

,updateMonitor = function(id, monitor, last) {
    idMon = paste0(id, "-monitor_", monitor$name)
#         lapply(names(data), function(x) updateMonitor(ns(paste0("monitor-",x)), pnl$getMonitor(x), data[[x]]$price))
   repDiv = function (parent, child, ...) {
      removeUI(selector = paste0("#", child), immediate=TRUE)
      insertUI(selector = paste0("#", parent), where = "beforeEnd", immediate=TRUE, ui=tagList(...))
   }
   getClass = function(value) {
      cls = "yataDeltaNone"
      if (value > 0) cls = "yataDeltaUp"
      if (value < 0) cls =" yataDeltaDown"
      cls
   }

   cls = "yataDeltaNone"

  # Precio
   id0 =  paste0(id, "_price")
   id1 = "_value"
   id2 = paste0(id0, "_delta")
   id3 = "_delta_value"

   if (missing(last)) {
       insertUI(selector = paste0("#", id, "_price"), where = "beforeEnd", immediate=TRUE
                ,ui=tags$span(class=cls, number2string(monitor$price, 2)))
       insertUI(selector = paste0("#", id, "_session"), where = "beforeEnd", immediate=TRUE
                ,ui=tags$span(class=cls, number2string(monitor$last, 2)))
       insertUI(selector = paste0("#", id, "_day"), where = "beforeEnd", immediate=TRUE
                ,ui=tags$span(class=cls, number2string(monitor$day, 2)))
       insertUI(selector = paste0("#", id, "_week"), where = "beforeEnd", immediate=TRUE
                ,ui=tags$span(class=cls, number2string(monitor$week, 2)))
       last = monitor$last
       insertUI(selector = paste0("#", id,"_price_delta"), where = "beforeEnd", immediate=TRUE
                ,ui=tags$span(class=cls, id= paste0(id,"_price_delta_value"), "0"))
       insertUI(selector = paste0("#", id,"-session_delta"), where = "beforeEnd", immediate=TRUE
                ,ui=tags$span(class=cls, id= paste0(id,"-session_delta_value"), "0"))
       insertUI(selector = paste0("#", id,"_day_delta"), where = "beforeEnd", immediate=TRUE
                ,ui=tags$span(class=cls, id= paste0(id,"_day_delta_value"), "0"))
       insertUI(selector = paste0("#", id,"_week_delta"), where = "beforeEnd", immediate=TRUE
                ,ui=tags$span(class=cls, id= paste0(id,"_week_delta_value"), "0"))

   }
   # for (idx in c("price", "session","day","week","last")) {
   #     cls = "yataDeltaNone"
   #     value = 0
   #     if (monitor[[idx]] != 0) value = (last / monitor[[idx]]) - 1
   #     if (value != 0) cls = ifelse(value > 0, "yataDeltaUp", "yataDeltaDown")
   #     id0   =  paste0(id, "-", idx, "_delta")
   #     id1   =  paste0(id0, "_value")
   #     repDiv(id0, id1, tags$span(class=cls, id=id1, number2percentage(value, 2)))
   # }

   # Last
   # id0 =  paste0(id, "-last")
   # id1 =  paste0(id0, "_value")
   # repDiv(id0, id1, tags$span(class=cls, id=id1, number2string(monitor$last, 2)))
}

  )
)
