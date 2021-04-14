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
     ,render = function(size=2) {
       mons = tags$div(class="yata_monitors")
       mons = tagAppendChildren(mons, lapply(monitors$keys(), function(x) renderMonitor(monitors$get(x), size)))
       eur = tags$div(class="yata_tbl_monitor_fiat", tablePosition())

#       ui = lapply(monitors$keys(), function(x) renderMonitor(monitors$get(x), size))

       insertUI( selector = idDiv, immediate=TRUE, where = "beforeEnd",ui=tagList(mons, eur))
        # lapply(monitors$keys(), function(x) insertUI( selector = idDiv, immediate=TRUE
        #                                    ,where = "beforeEnd"
        #                                    ,ui=tagList(renderMonitor(monitors$get(x), size))))
       #,tags$div(tablePosition()))
        update(TRUE)
     }
     ,update = function(first=FALSE) {
         ctc = monitors$keys()
         private$last = sess$getLatest(ctc)
         updateData = function(sym) {
            lst = as.list(private$last[private$last$symbol == sym,])
            mon  = monitors$get(sym)
            updateMonitor(mon, lst)
            mon = list.merge(mon, lst)
            monitors$put(sym, mon)
         }
         lapply(ctc, function(sym) updateData(sym))
     }
     ,getLast = function() { private$last }
   )
  ,private = list(
       monitors = NULL
      ,pnl      = NULL
      ,env      = NULL
      ,sess     = NULL
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
              pos         = dfPos[dfPos$currency == sym,]
              mon$cost    = ifelse(nrow(pos) > 0,pos[1,"price"], mon$price)
              private$monitors$put(sym, mon)
          }
          df  = pnl$getRoot()$data$dfPosGlobal
          df  = df[df$currency != "EUR",]
          ctc = unique(c(df$currency, "BTC", "ETH"))
          if (length(ctc) > 6) ctc = ctc[1:6]

          private$sess = pnl$factory$getObject("Session")
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
             ,tags$td(class=clsLbl, "Coste")
             ,tags$td(class=clsData,  id=paste0(idMon,"_cost_delta"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, "Sesion")
             ,tags$td(class=clsData, id=paste0(idMon,"_session_delta"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, "Hora")
             ,tags$td(class=clsData, id=paste0(idMon,"_hour_delta"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, "Dia")
             ,tags$td(class=clsData,  id=paste0(idMon,"_day_delta"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, "Semana")
             ,tags$td(class=clsData,  id=paste0(idMon,"_week_delta"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, "Mes")
             ,tags$td(class=clsData,  id=paste0(idMon,"_month_delta"))
           )
          ,tags$tr(
              tags$td(style="padding-bottom: 6px;", class="yata_cell_ctc", substr(data$name, 1, 12))
             ,tags$td(colspan="2", class="yata_cell_data yata_cell_group", style="padding-bottom: 6px;", id=paste0(idMon,"_last"))
          )
        )
     }
     ,tablePosition  = function() {
         tags$table(class="yata_tbl_monitor"
           ,tags$tr(
              tags$td(rowspan="6", class="yata_cell_icon",
                     img(src="icons/euro03.png",width="60px", height="60px",
                     onerror="this.onerror=null;this.src='icons2/YATA.png';"))
             ,tags$td(class=clsLbl, "Coste")
             ,tags$td(class=clsData,  "Dato") #id=paste0(idMon,"_cost_delta"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, "Sesion")
             ,tags$td(class=clsData, "Dato") #id=paste0(idMon,"_session_delta"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, "Hora")
             ,tags$td(class=clsData, "Dato") #id=paste0(idMon,"_hour_delta"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, "Dia")
             ,tags$td(class=clsData,  "Dato") #id=paste0(idMon,"_day_delta"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, "Semana")
             ,tags$td(class=clsData,"Dato") #  id=paste0(idMon,"_week_delta"))
           )
           ,tags$tr(
              tags$td(class=clsLbl, "Mes")
             ,tags$td(class=clsData,  "Dato") #id=paste0(idMon,"_month_delta"))
           )
          # ,tags$tr(
          #     tags$td(style="padding-bottom: 6px;", class="yata_cell_ctc", substr(data$name, 1, 12))
          #    ,tags$td(colspan="2", class="yata_cell_data yata_cell_group", style="padding-bottom: 6px;", id=paste0(idMon,"_last"))
          # )
        )
    }

    ,updateMonitor = function(mon, last) {
        idMon = paste0(substr(idDiv, 2, nchar(idDiv)), "_", last$symbol)
        vcost = ((last$price / mon$cost)    - 1) * 100
        vsess = ((last$price / mon$session) - 1) * 100
        updateRow(paste0(idMon,"_cost_delta"),    mon$cost,    vcost,      TRUE)
        updateRow(paste0(idMon,"_session_delta"), mon$session, vsess,      TRUE)
        updateRow(paste0(idMon,"_hour_delta"),    mon$hour,    last$hour,  TRUE)
        updateRow(paste0(idMon,"_day_delta"),     mon$day,     last$day,   TRUE)
        updateRow(paste0(idMon,"_week_delta"),    mon$week,    last$week,  TRUE)
        updateRow(paste0(idMon,"_month_delta"),   mon$month,   last$month, TRUE)
        updateRow(paste0(idMon,"_last"),          mon$price,   last$price, FALSE)
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
