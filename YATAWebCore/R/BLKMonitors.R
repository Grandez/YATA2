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
      initialize = function(id, pnl, env) {
          private$monitors = HashMap$new()
          private$idDiv = paste0("#", id)
          private$pnl = pnl
          private$env = env
          initMonitors()
     }
     # ,setMonitor = function(name, monitor) { private$monitors$put(name, monitor) }
     # ,getMonitor = function(name) {
     #     def = tpl
     #     if (is.null(monitors$get(name))) {
     #         def$name = name
     #         monitors$put(name, def)
     #     }
     #     monitors$get(name)
     # }
    ,render = function(size=2) {
        mon = monitors$values()
        lst = lapply(seq_len(ncol(mon)), function(i) mon[,i])
        lapply(lst, function(x) insertUI( selector = idDiv, immediate=TRUE
                                           ,where = "beforeEnd"
                                           ,ui=tagList(renderMonitor(x, size))))
     }
     ,update = function(first=FALSE) {
         ctc = monitors$keys()
         dfs   = sess$getLatest(ctc)
         last = as.list(dfs$price)
         names(last) = ctc
         lapply(ctc, function(x) updateMonitor(x, last[[x]]))
     }
   )
  ,private = list(
       monitors = NULL
      ,pnl      = NULL
      ,env      = NULL
      ,sess     = NULL
      ,idDiv    = NULL  # DIV donde va el monitor
      ,tpl  = list(
                 name    = ""
                ,last    = -Inf
                ,session = -Inf
                ,day     = -Inf
                ,week    = -Inf
                ,price   = -Inf
                ,id      = 0
             )

      ,initMonitors = function() {
          createMonitor = function(sym, dfPos, dfLast) {
              last = as.list(dfLast[dfLast$symbol == sym,])
              pos = dfPos[dfPos$symbol == sym,]
              mon  = tpl
              mon$id      = last$id
              mon$name    = sym
              mon$price = ifelse(nrow(pos) > 0, pos[1,"price"], last$price)
              mon$session = last$price
              mon$last    = last$price
              mon$day     = last$price / (1 + (last$var24 / 100))
              mon$week    = last$price / (1 + (last$var07 / 100))
              private$monitors$put(sym, mon)
          }

          df = pnl$getRoot()$data$dfPosGlobal
          df = df[df$currency != "EUR",]
          df = df[order(df$balance, decreasing=TRUE),]
          ctc = df$currency
          if (length(ctc) < 6 && !("BTC" %in% ctc)) ctc = c("BTC", ctc)
          if (length(ctc) < 6 && !("ETH" %in% ctc)) ctc = c("ETH", ctc)
          if (length(ctc) > 6) ctc = ctc[1:6]

          private$sess = pnl$factory$getObject("Session")
          dfs   = sess$getLatest(ctc)

          lapply(ctc, function(sym) createMonitor(sym, df, dfs))
      }
     ,renderData = function(first=FALSE) {
         render = function(key) {
             mon = monitors$get(key)
             idMon = paste0(idDiv, "_", mon$name)
             shinyjs::html(paste0(idMon, "_price"), number2string(mon$price), asis=TRUE)
         }
         lapply(monitors$keys(), function(key) render(key))
     }
    ,renderMonitor = function(x, size) {
        idMon = paste0(substr(idDiv, 2, nchar(idDiv)), "_", x$name)
        tags$div(column(size,tableMonitor(idMon,x)))
     }
    ,tableMonitor = function(idMon,data) {
         cprice = ""
         cday   = ""
         cweek  = ""
         vprice = data$last/data$price
         vday   = data$last/data$day
         vweek  = data$last/data$week
         if (vprice != 1) cprice = ifelse(vprice > 1, "yata_cell_data_up", "yata_cell_data_down")
         if (vday   != 1) cday   = ifelse(vday   > 1, "yata_cell_data_up", "yata_cell_data_down")
         if (vweek  != 1) cweek  = ifelse(vweek  > 1, "yata_cell_data_up", "yata_cell_data_down")
         tags$table(class="yata_tbl_monitor"
           ,tags$tr(
              tags$td(rowspan="3", class="yata_cell_icon",
                     img(src=paste0("icons/", data$id, ".png"),width="48px", height="48px",
                     onerror="this.onerror=null;this.src='icons2/YATA.png';"))
             ,tags$td(class="yata_cell_label", "Coste")
             ,tags$td(class="yata_cell_data",  id=paste0(idMon,"_price"),
                      number2string(data$price,round=TRUE))
             ,tags$td(class=paste("yata_cell_data", cprice),  id=paste0(idMon,"_price_delta"),
                      percentage2string(vprice,calc=TRUE))
           )
           ,tags$tr(
              tags$td(class="yata_cell_label", "Dia")
             ,tags$td(class="yata_cell_data",  id=paste0(idMon,"_day"),
                      number2string(data$day,round=TRUE))
             ,tags$td(class=paste("yata_cell_data", cday),  id=paste0(idMon,"_day_delta"),
                      percentage2string(vday,calc=TRUE))
           )
           ,tags$tr(
              tags$td(class="yata_cell_label yataCellGroup", "Semana")
             ,tags$td(class="yata_cell_data  yataCellGroup",  id=paste0(idMon,"_week"),
                      number2string(data$week,round=TRUE))
             ,tags$td(class=paste("yata_cell_data", cweek),  id=paste0(idMon,"_week_delta"),
                      percentage2string(vweek,calc=TRUE))
           )
           ,tags$tr(
              tags$td(rowspan="2", class="yata_cell_ctc", data$name)
             ,tags$td(class="yata_cell_label", "Sesion")
             ,tags$td(class="yata_cell_data",  id=paste0(idMon,"_session"), number2string(data$session,round=TRUE))
             ,tags$td(class="yata_cell_data",  id=paste0(idMon,"_session_delta"))
           )
          ,tags$tr(
              tags$td(class="yata_cell_label", "Ultimo")
             ,tags$td(class="yata_cell_data yata_cell_group", id=paste0(idMon,"_last"),
                      number2string(data$last,round=TRUE))
             ,tags$td(class="yata_cell_data yata_cell_group", id=paste0(idMon,"_last_delta"))
          )
        )
    }
   ,updateMonitor = function(id, last) {
        idMon = paste0(substr(idDiv, 2, nchar(idDiv)), "_", id)
        mon = monitors$get(id)

        value = last/mon$price
        updateRow(paste0(idMon,"_price_delta"),   value, percentage2string(value, calc=TRUE))
        value = last/mon$day
        updateRow(paste0(idMon,"_day_delta"),     value, percentage2string(value, calc=TRUE))
        value = last/mon$week
        updateRow(paste0(idMon,"_week_delta"),    value, percentage2string(value, calc=TRUE))
        value = last/mon$session
        updateRow(paste0(idMon,"_session_delta"), value, percentage2string(value, calc=TRUE))
        value = last/mon$last
        updateRow(paste0(idMon,"_last_delta"),    value, percentage2string(value, calc=TRUE))
        shinyjs::html(paste0(idMon, "_last"), html = number2string(last, round=TRUE), asis = TRUE)
    }
    ,updateRow = function(id, value, txt) {
         shinyjs::removeCssClass(id, class = "yata_cell_data_up"   , asis = TRUE)
         shinyjs::removeCssClass(id, class = "yata_cell_data_down" , asis = TRUE)
         if (value != 1) cls = ifelse(value > 1, "yata_cell_data_up", "yata_cell_data_down")
         shinyjs::addCssClass(id, class = cls , asis = TRUE)
         shinyjs::html(id, html = txt, asis = TRUE)
     }
  )
)
