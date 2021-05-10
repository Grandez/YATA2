# Conponente de monitorizacion de monedas
     ###########################################
     ### Widget para sacar la contizacion en tiempo real de las monedas
     ### Crea los tags: id - fila
     ###                id - fila - value
     ###########################################

OBJMonitors = R6::R6Class("YATA.WEB.MONITORS"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,public = list(
      initialize = function(id, pnl, env) {
          private$monitors = HashMap$new()
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
         private$last = sess$getLatest(ctc)
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
      ,sess     = NULL
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

          private$sess = pnl$factory$getObject("Session")
          private$pos  = pnl$factory$getObject("Position")
          dfs          = sess$getLatest(ctc)
          names        = YATAWEB$getCTCLabels(ctc, type="name")
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
                     img(src=paste0("icons/", data$id, ".png"),width="60px", height="60px",
                     onerror="this.onerror=null;this.src='icons2/YATA.png';"))
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
                     img(src="icons/euro03.png",width="60px", height="60px",
                     onerror="this.onerror=null;this.src='icons2/YATA.png';"))
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
