# Componente de monitorizacion de monedas
     ###########################################
     ### Widget para sacar la contizacion en tiempo real de las monedas
     ### Crea los tags: id - fila
     ###                id - fila - value
     ###########################################

WDGMonitor = R6::R6Class("YATA.WEB.MONITORS"
  ,portable   = FALSE
  ,lock_class = TRUE
  ,public = list(
      initialize = function(id, pnl, env) {
          private$monitors = YATABase::map()
          private$idDiv = paste0("#", id)
          private$pnl = pnl
          private$env = env
          private$msg = pnl$factory$MSG$getBlockAsMap(10)
          initMonitors()
     }
     ,render = function(size=2) {
        mons = tags$div(class="yata_monitors")
        mons = tagAppendChildren(mons, lapply(monitors$keys(), function(x) renderMonitor(monitors$get(x), size)))
        eur = tags$div(class="yata_tbl_monitor_fiat", tablePosition())
        insertUI( selector = idDiv, immediate=TRUE, where = "beforeEnd",ui=tagList(mons, eur))
        update(TRUE)
     }
     ,update = function(first=FALSE) {
         ctc = monitors$keys()
         private$last = session$getLatest(ctc)
         updateData = function(sym) {
             if (nrow(private$last[private$last$symbol == sym,]) == 1) {
                 last = as.list(private$last[private$last$symbol == sym,])
                  mon  = monitors$get(sym)
                  updateMonitor(mon, last)
                  mon = list.merge(mon, last)
                  monitors$put(sym, mon)
             }
         }
         lapply(ctc, function(sym) updateData(sym))
         data = pos$getFiatPosition("EUR")
         data$invest = round(data$invest)
         updateFiat(data)

     }
     ,getLast = function() { private$last }
   )
  ,private = list(
       monitors = NULL
      ,pnl      = NULL
      ,msg      = NULL
      ,env      = NULL
      ,session  = NULL
      ,pos      = NULL
      ,last     = NULL
      ,idDiv    = NULL  # DIV donde va el monitor
      ,clsUp    = "yata_cell_data_up"
      ,clsDown  = "yata_cell_data_down"
      ,clsLbl   = "yata_cell_label"
      ,clsData  = "yata_cell_data"
      ,initMonitors  = function() {
          createMonitor = function(sym, dfPos, dfLast, names) {
              mon         = as.list(dfLast[dfLast$symbol == sym,])
              mon$name    = names[[sym]]
              mon$session = mon$price
              if (!is.null(dfPos)) {
                  pos         = dfPos[dfPos$currency == sym,]
                  mon$cost    = ifelse(nrow(pos) > 0,pos[1,"price"], mon$price)
              }
              else {
                  mon$cost = mon$price
              }
              private$monitors$put(sym, mon)
          }
          df  = pnl$getGlobalPosition()
          ctc = unique(c(df$currency, "BTC", "ETH"))
          if (length(ctc) > 6) ctc = ctc[1:6]

          private$session = pnl$factory$getObject(pnl$codes$object$session)
          private$pos     = pnl$factory$getObject(pnl$codes$object$position)
          dfs             = session$getLatest(ctc)
          names           = WEB$getCTCLabels(ctc, type="name")
          lapply(ctc, function(sym) createMonitor(sym, df, dfs, names))
      }
      ,renderData    = function(first=FALSE) {
          render = function(key) {
             mon = monitors$get(key)
             idMon = paste0(idDiv, "_", mon$name)
             shinyjs::html(paste0(idMon, "_price"), number2string(mon$price), asis=TRUE)
         }
         lapply(monitors$keys(), function(key) render(key))
      }
     ,renderMonitor = function(x, size) {
         idMon = paste0(substr(idDiv, 2, nchar(idDiv)), "_", x$symbol)
         tags$div(class="yata_monitor_container",tags$div(tableMonitor(idMon,x)))
      }
     ,tableMonitor  = function(idMon,data) {
         tags$table(class="yata_tbl_monitor"
           ,tags$tr(
              tags$td(rowspan="6", class="yata_cell_icon",
                     img( src=paste0("icons/", data$id, ".png")
                         ,width  = YATAWEBDEF$iconSize
                         ,height = YATAWEBDEF$iconSize,
                     onerror=paste0("this.onerror=null;this.src=", YATAWEBDEF$icon, ";")))
             ,tags$td(class=clsLbl, msg$get("MON.CTC.COST"))
             ,tags$td(class=clsData,  id=paste0(idMon,"_cost_delta"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, msg$get("MON.CTC.SESSION"))
             ,tags$td(class=clsData, id=paste0(idMon,"_session_delta"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, msg$get("MON.CTC.HOUR"))
             ,tags$td(class=clsData, id=paste0(idMon,"_hour_delta"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, msg$get("MON.CTC.DAY"))
             ,tags$td(class=clsData,  id=paste0(idMon,"_day_delta"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, msg$get("MON.CTC.WEEK"))
             ,tags$td(class=clsData,  id=paste0(idMon,"_week_delta"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, msg$get("MON.CTC.MONTH"))
             ,tags$td(class=clsData,  id=paste0(idMon,"_month_delta"))
           )
          ,tags$tr(
              tags$td(style="padding-bottom: 6px;", class="yata_cell_ctc", substr(data$name, 1, 12))
             ,tags$td(colspan="2", class="yata_cell_data yata_cell_group", style="padding-bottom: 6px;", id=paste0(idMon,"_last"))
          )
        )
     }
     ,tablePosition  = function() {
         base = paste0(substr(idDiv, 2, nchar(idDiv)), "_fiat_")
         tags$table(class="yata_tbl_monitor"
           ,tags$tr(
              tags$td(rowspan="6", class="yata_cell_icon",
                     img(src=YATAWEBDEF$iconMain,width=YATAWEBDEF$iconSize, height=YATAWEBDEF$iconSize,
                     onerror=paste0("this.onerror=null;this.src=", YATAWEBDEF$iconDef, ";")))
             ,tags$td(class=clsLbl, msg$get("MON.FIAT.TOTAL"))
             ,tags$td(class=clsData,  id=paste0(base,"total"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, msg$get("MON.FIAT.REIMB"))
             ,tags$td(class=clsData, id=paste0(base,"reimb"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, msg$get("MON.FIAT.SUBTOTAL"))
             ,tags$td(class=clsData, id=paste0(base,"subtotal"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, msg$get("MON.FIAT.AVAILABLE"))
             ,tags$td(class=clsData,id=paste0(base,"available"))
           )
          ,tags$tr(
              tags$td(class=clsLbl, msg$get("MON.FIAT.INVEST"))
             ,tags$td(class=clsData, id=paste0(base,"invest"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, msg$get("MON.FIAT.VALUE"))
             ,tags$td(class=clsData, id=paste0(base,"value"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, msg$get("MON.FIAT.ACT"))
             ,tags$td(class=clsData, id=paste0(base,"act"))
           )

          # ,tags$tr(
          #     tags$td(style="padding-bottom: 6px;", class="yata_cell_ctc", substr(data$name, 1, 12))
          #    ,tags$td(colspan="2", class="yata_cell_data yata_cell_group", style="padding-bottom: 6px;", id=paste0(idMon,"_last"))
          # )
        )
    }

    ,updateMonitor = function(mon, last) {
        browser()
        idMon = paste0(substr(idDiv, 2, nchar(idDiv)), "_", last$symbol, "_")
        vcost = ((last$price / mon$cost)    - 1) * 100
        vsess = ((last$price / mon$session) - 1) * 100
        updateRow(paste0(idMon,"cost_delta"),    mon$cost,    vcost,      TRUE)
        updateRow(paste0(idMon,"session_delta"), mon$session, vsess,      TRUE)
        updateRow(paste0(idMon,"hour_delta"),    mon$hour,    last$hour,  TRUE)
        updateRow(paste0(idMon,"day_delta"),     mon$day,     last$day,   TRUE)
        updateRow(paste0(idMon,"week_delta"),    mon$week,    last$week,  TRUE)
        updateRow(paste0(idMon,"month_delta"),   mon$month,   last$month, TRUE)
        updateRow(paste0(idMon,"last"),          mon$price,   last$price, FALSE)
    }
    ,updateFiat = function(data) {
        subtotal = data$total - data$reimb
        disp     = subtotal - data$invest
        idMon = paste0(substr(idDiv, 2, nchar(idDiv)), "_fiat_")
        updateRow(paste0(idMon,"total"),     data$total,    data$total,  FALSE)
        updateRow(paste0(idMon,"reimb"),     data$reimb,    data$reimb,  FALSE)
        updateRow(paste0(idMon,"subtotal"),  subtotal,      subtotal,    FALSE)
        updateRow(paste0(idMon,"invest"),    data$invest,   data$invest, FALSE)
        updateRow(paste0(idMon,"available"), disp,          disp,        FALSE)
    }

    ,updateRow     = function(id, old, act, prc) {
         if (prc) {
             shinyjs::removeCssClass(id, class = clsDown, asis=TRUE)
             shinyjs::removeCssClass(id, class = clsUp  , asis=TRUE)
             if (act > 0 ) shinyjs::addCssClass(id, class=clsUp,   asis=TRUE)
             if (act < 0 ) shinyjs::addCssClass(id, class=clsDown, asis=TRUE)
         }
         if (!prc && act != 0) {
             shinyjs::removeCssClass(id, class = clsDown , asis = TRUE)
             shinyjs::removeCssClass(id, class = clsUp   , asis = TRUE)
             if (old < act) shinyjs::addCssClass(id, class = clsUp   , asis = TRUE)
             if (old > act) shinyjs::addCssClass(id, class = clsUp   , asis = TRUE)
         }
         txt = ifelse (prc, percentage2string(act / 100), number2string(act))
         shinyjs::html(id, html = txt, asis = TRUE)
     }

  )
)

# yuiYataMonitor = function(id, data, size=2) {
# #    column(size, .yuiMonitorTable(id))
#    tags$div(column(size,.yuiMonitorTable(id,data)))
#}

###########################################
### Widget para sacar la contizacion en tiempo real de las monedas
### Crea los tags: id - fila
###                id - fila - value
###########################################
# .yuiMonitorTable = function(id,data) {
#    browser()
#   ns = strsplit(id, "-")[[1]]
#   code = ns[length(ns)]
#   base = paste(ns[1:length(ns)-1], sep = "-")
# #  tags$div(
#       tags$table(class="yata-tbl-monitor"
#         ,tags$tr(
#            tags$td(rowspan="3", class="yataCellIcon",
#               img(src=paste0("icons/", code, ".png"),width="48px", height="48px",
#                   onerror="this.onerror=null;this.src='icons/YATA.png';"))
#           ,tags$td(class="yata-cell-label", "Coste")
#           ,tags$td(class="yata-cell-data",  id=paste0(id,"-price"))
#           ,tags$td(class="yata-cell-data",  id=paste0(id,"-price-delta"))
#         )
#         ,tags$tr(
#            tags$td(rowspan="2", tags$span(class="yataCellCTC", code))
#           ,tags$td(class="yata-cell-label yataCellGroup", "Semana")
#           ,tags$td(class="yata-cell-data  yataCellGroup",  id=paste0(id,"-week"))
#           ,tags$td(class="yata-cell-data"               ,  id=paste0(id,"-week-delta"))
#         )
#         ,tags$tr(
#            tags$td(class="yata-cell-label", "Dia")
#           ,tags$td(class="yata-cell-data",  id=paste0(id,"-day"))
#           ,tags$td(class="yata-cell-data",  id=paste0(id,"-day-delta"))
#         )
#         ,tags$tr(
#            tags$td(class="yata-cell-label", "Sesion")
#           ,tags$td(class="yata-cell-data",  id=paste0(id,"-session"))
#           ,tags$td(class="yata-cell-data",  id=paste0(id,"-session-delta"))
#         )
#         ,tags$tr(
#             tags$td(class="yata-cell-label", "Ultimo")
#            ,tags$td(class="yata-cell-data yataCellGroup", id=paste0(id,"-last"))
#            ,tags$td(class="yata-cell-data yataCellGroup", id=paste0(id,"-last-delta"))
#         )
#       )
# #  )
# }
#
# updYataMonitor = function(id, monitor, last) {
#    repDiv = function (parent, child, ...) {
#       removeUI(selector = paste0("#", child), immediate=TRUE)
#       insertUI(selector = paste0("#", parent), where = "beforeEnd", immediate=TRUE, ui=tagList(...))
#    }
#    getClass = function(value) {
#       cls = "yataDeltaNone"
#       if (value > 0) cls = "yataDeltaUp"
#       if (value < 0) cls =" yataDeltaDown"
#       cls
#    }
#
#    cls = "yataDeltaNone"
#
#   # Precio
#    id0 =  paste0(id, "-price")
#    id1 = "-value"
#    id2 = paste0(id0, "-delta")
#    id3 = "-delta-value"
#
#    if (missing(last)) {
#        insertUI(selector = paste0("#", id, "-price"), where = "beforeEnd", immediate=TRUE
#                 ,ui=tags$span(class=cls, number2string(monitor$price, 2)))
#        insertUI(selector = paste0("#", id, "-session"), where = "beforeEnd", immediate=TRUE
#                 ,ui=tags$span(class=cls, number2string(monitor$last, 2)))
#        insertUI(selector = paste0("#", id, "-day"), where = "beforeEnd", immediate=TRUE
#                 ,ui=tags$span(class=cls, number2string(monitor$day, 2)))
#        insertUI(selector = paste0("#", id, "-week"), where = "beforeEnd", immediate=TRUE
#                 ,ui=tags$span(class=cls, number2string(monitor$week, 2)))
#        last = monitor$last
#        insertUI(selector = paste0("#", id,"-price-delta"), where = "beforeEnd", immediate=TRUE
#                 ,ui=tags$span(class=cls, id= paste0(id,"-price-delta-value"), "0"))
#        insertUI(selector = paste0("#", id,"-session-delta"), where = "beforeEnd", immediate=TRUE
#                 ,ui=tags$span(class=cls, id= paste0(id,"-session-delta-value"), "0"))
#        insertUI(selector = paste0("#", id,"-day-delta"), where = "beforeEnd", immediate=TRUE
#                 ,ui=tags$span(class=cls, id= paste0(id,"-day-delta-value"), "0"))
#        insertUI(selector = paste0("#", id,"-week-delta"), where = "beforeEnd", immediate=TRUE
#                 ,ui=tags$span(class=cls, id= paste0(id,"-week-delta-value"), "0"))
#
#    }
#    # for (idx in c("price", "session","day","week","last")) {
#    #     cls = "yataDeltaNone"
#    #     value = 0
#    #     if (monitor[[idx]] != 0) value = (last / monitor[[idx]]) - 1
#    #     if (value != 0) cls = ifelse(value > 0, "yataDeltaUp", "yataDeltaDown")
#    #     id0   =  paste0(id, "-", idx, "-delta")
#    #     id1   =  paste0(id0, "-value")
#    #     repDiv(id0, id1, tags$span(class=cls, id=id1, number2percentage(value, 2)))
#    # }
#
#    # Last
#    # id0 =  paste0(id, "-last")
#    # id1 =  paste0(id0, "-value")
#    # repDiv(id0, id1, tags$span(class=cls, id=id1, number2string(monitor$last, 2)))
# }
# yuiRank = function(id1, id2, n=5) {
#    parent = tags$div(class="yata-ranks")
#    if (!missing(id1)) parent = tagAppendChild(parent, yuiTableRank(id1, n))
#    if (!missing(id2)) parent = tagAppendChild(parent, yuiTableRank(id2, n))
#    parent
# }
#
# yuiTableRank = function(id, n) {
#   tbl = tags$table( class="yata-tbl-monitor")
#   for (idx in 1:n) {
#       id1 = paste0(id, "lbl", idx)
#       id2 = paste0(id, "val", idx)
#       tbl = tagAppendChild(tbl, tags$tr( tags$td(yuiLabelText(id=id1)),tags$td(yuiLabelPercentage(id=id2))))
#   }
#   tbl
# }
