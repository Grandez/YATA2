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
      initialize = function(id, pnl, data) {
         private$base = YATABase$new()
         private$monitors = YATABase::map()
         private$idDiv = paste0("#", id)
         private$pnl = pnl
         private$labels = pnl$factory$MSG$getBlock(pnl$factory$CODES$labels$monitors)
         initMonitors(data)
     }
     ,render = function(size=2) {
         mons = tags$div(class="yata_monitors")
         mons = tagAppendChildren(mons, lapply(monitors$keys(), function(x) renderMonitor(monitors$get(x), size)))
         eur = tags$div(class="yata_tbl_monitor_fiat", tablePosition())
         insertUI( selector = idDiv, immediate=TRUE, where = "beforeEnd",ui=tagList(mons, eur))
         update(TRUE)
      }
     ,update = function(first=FALSE) {
         ctc = as.integer(monitors$keys())
         private$last = session$getLatest(0, ctc)
         updateData = function(sym) {
             if (nrow(private$last[private$last$id == sym,]) == 1) {
                 last = as.list(private$last[private$last$id == sym,])
                  mon  = monitors$get(sym)
                  updateMonitor(mon, last)
                  mon = list.merge(mon, last)
                  monitors$put(sym, mon)
             }
         }
         lapply(ctc, function(sym) updateData(sym))
         data = pos$getFiatPosition("$FIAT")
         data$invest = round(data$invest)
         updateFiat(data)
     }
     ,getLast = function() { private$last }
   )
  ,private = list(
       monitors = NULL
      ,pnl      = NULL
      ,labels   = NULL
      ,session  = NULL
      ,pos      = NULL
      ,favorites = NULL
      ,last     = NULL
      ,idDiv    = NULL  # DIV donde va el monitor
      ,base      = NULL
      ,clsUp    = "yata_cell_data_up"
      ,clsDown  = "yata_cell_data_down"
      ,clsLbl   = "yata_cell_label"
      ,clsData  = "yata_cell_data"

      ,initMonitors  = function(data) {
          createMonitor = function(id, dfPos, dfLast, names) {
              mon         = as.list(dfLast[dfLast$id == id,])
              mon$name    = names[[as.character(id)]]
              mon$session = mon$price
              if (!is.null(dfPos)) {
                  pos         = dfPos[dfPos$id == id,]
                  mon$cost    = ifelse(nrow(pos) > 0,pos[1,"value"], "N/A")
              }
              else {
                  mon$cost = mon$price
              }
              private$monitors$put(id, mon)
          }

          private$session   = pnl$factory$getObject(pnl$codes$object$session)
          private$pos       = pnl$factory$getObject(pnl$codes$object$position)
          private$favorites = pnl$factory$getObject(pnl$codes$object$favorites)

          currencies = pnl$factory$getObject(pnl$codes$object$currencies)

          dfp = data # pnl$getGlobalPosition()
          dff = favorites$get()
          prefixed = c("BTC", "ETH", "USDT", "BNB", "XRP", "LUNA", "CARDANO", "SOLANA")
          ctc = unique(c(dfp$currency, dff$symbol, prefixed))
          if (length(ctc) > 7) ctc = ctc[1:7]
          dfc = currencies$getCurrencies(ctc)
          dfc = dfc[,c("id", "icon")]

          dfs   = session$getLatest(0, dfc$id)
          dfs   = dplyr::left_join(dfc,dfs, by=c("id"))

          labels = WEB$combo$currencies(id=TRUE, set=dfs$id, merge = FALSE, invert=TRUE)

          lapply(dfs$id, function(id) createMonitor(id, dfp, dfs, labels))
      }
      ,renderData    = function(first=FALSE) {
          render = function(key) {
             mon = monitors$get(key)
             idMon = paste0(idDiv, "_", mon$name)
             shinyjs::html(paste0(idMon, "_price"), base$str$number2string(mon$price), asis=TRUE)
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
                     img( src=paste0("icons/currencies/", data$icon)
                         ,width  = YATAWEBDEF$iconSize
                         ,height = YATAWEBDEF$iconSize,
                     onerror=paste0("this.onerror=null;this.src=", YATAWEBDEF$icon, ";")))
             ,tags$td(class=clsLbl, labels$COST)
             ,tags$td(class=clsData,  id=paste0(idMon,"_cost_delta"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, labels$SESSION)
             ,tags$td(class=clsData, id=paste0(idMon,"_session_delta"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, labels$HOUR)
             ,tags$td(class=clsData, id=paste0(idMon,"_hour_delta"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, labels$DAY)
             ,tags$td(class=clsData,  id=paste0(idMon,"_day_delta"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, labels$WEEK)
             ,tags$td(class=clsData,  id=paste0(idMon,"_week_delta"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, labels$MONTH)
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
                     img(src="icons/currencies/EUR.png",width=YATAWEBDEF$iconSize, height=YATAWEBDEF$iconSize,
                     onerror=paste0("this.onerror=null;this.src=", YATAWEBDEF$iconDef, ";")))
             ,tags$td(class=clsLbl, labels$TOTAL)
             ,tags$td(class=clsData,  id=paste0(base,"total"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, labels$REIMB)
             ,tags$td(class=clsData, id=paste0(base,"reimb"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, labels$SUBTOTAL)
             ,tags$td(class=clsData, id=paste0(base,"subtotal"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, labels$AVAILABLE)
             ,tags$td(class=clsData,id=paste0(base,"available"))
           )
          ,tags$tr(
              tags$td(class=clsLbl, labels$INVEST)
             ,tags$td(class=clsData, id=paste0(base,"invest"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, labels$VALUE)
             ,tags$td(class=clsData, id=paste0(base,"value"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, labels$ACT)
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

        vcost = ifelse(is.numeric(mon$cost), ((last$price / mon$cost)    - 1) * 100, mon$cost)
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
         txt = act
         if (is.numeric(act)) {
             txt = ifelse (prc, base$str$percentage2string(act / 100), base$str$number2string(act))
         }

         shinyjs::html(id, html = txt, asis = TRUE)
     }

  )
)
