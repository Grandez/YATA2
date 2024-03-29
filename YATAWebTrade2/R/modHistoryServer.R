# Cada modulo lleva asociado un objeto
# es el que gestiona la creacion del objeto y guarda sus variables

modHistServer <- function(id, full, parent, session) {
   ns = NS(id)
   PNLHist = R6::R6Class("PNL.HISTORY"
      ,inherit = WEBPanel
      ,cloneable  = FALSE
      ,lock_class = TRUE
      ,public = list(
          position    = NULL
         ,operation   = NULL
         ,plotChanged = 0
         ,initialize    = function(id, parent, session) {
             super$initialize(id, parent, session)
             private$defaultValues()
             self$position  = self$factory$getObject(self$codes$object$position)
             self$operation = self$factory$getObject(self$codes$object$operation)
#             private$initPanel()
         }
         ,ctcLoaded = function(symbol) {
             res = symbol %in% self$vars$tabs
             if (!res) self$vars$tabs = c(self$vars$tabs, symbol)
             res
          }
         ,stackAdd  = function(symbol) {
             self$active = symbol
             private$stack = c(private$stack, symbol)
         }
         ,stackRemove = function(symbol) {
             idx = which(private$stack == symbol)
             private$stack = private$stack[-idx]
         }
         ,stackTop = function() { private$stack[length(private$stack)]}
#         ,updateActive = function()   { private$tabs[[self$active]] = self$act }
         ,getHistory = function(symbol) { self$act$lstHist[[symbol]]$df   }
         ,getPlotInfo = function(idPlot, uiPlot) {
             # Un mismo plot puede estar en los dos con info diferente
             info = self$vars$info$uiPlot$idPlot
             if (is.null(info)) {
                 info = list()
                 info$observer = ns("modebar")
                 info$id   = ns(idPlot)
                 info$ui   = uiPlot
                 info$render = idPlot
                 info$datavalue = "Value"
                 if (idPlot %in% c("plotSession", "plotHist")) {
                     info$datasource  = "value"
                     info$plot = "Line"
                     info$type = "Line"
                 }
                 else {
                     info$datasource  = "session"
                     info$plot = "Candlestick"
                     info$type = "Candlestick"
                 }
                 self$vars$info[[uiPlot]][[idPlot]] = info
             }
             info
         }
    )
    ,private = list(
         stack = c("summ")
        ,defaultValues = function() {
            self$vars$tabs = NULL
             # self$cookies$interval = 15
             # self$cookies$best = list(top = 10, from = 2)
             # self$cookies$history = 15
             # self$cookies$layout = matrix(c("plotHist","blkTop","plotSession","Position"),ncol=2)
             # self$cookies$position = "All"
        }
       ,initPanel = function() {
          df     = self$position$getCurrenciesHistory()
          if (nrow(df) == 0) return()
          labels = WEB$getCTCLabels(df$currency, invert=TRUE)
          dfl    = as.data.frame(labels)
          dfl    = cbind(dfl, row.names(dfl))
          colnames(dfl) = c("currency", "label")
          row.names(dfl) = NULL

          df  = inner_join(df, dfl, by="currency")
          id  = WEB$getCTCID(df$currency)
          df2 = as.data.frame(id)
          df2 = cbind(row.names(df2), df2)
          colnames(df2) = c("currency", "id")
          row.names(df2) = NULL
          df = inner_join(df, df2, by="currency")
#          df$since = as.Date(df$since) - as.difftime(7, unit="days")
          self$data$dfSymbols = df

          invisible(self)
       }
     )
   )
moduleServer(id, function(input, output, session) {
   loadPage = function() {
       pnl$loaded = TRUE
           # choices        = pnl$data$dfSymbols$currency
           # names(choices) = pnl$data$dfSymbols$label
           # updListBox("lstCurrencies", choices = choices)
   }

   pnl = WEB$getPanel(PNLHist, id, parent, session)
   if (!pnl$loaded) loadPage()

        flags = reactiveValues(
           currency = NULL
          ,update   = FALSE
          ,plots    = 0
        )
#        updateLeftPanel = function() {
#            browser()
#        }
#        ###########################################################
#        ### Reactives
#        ###########################################################
#         observeEvent(flags$currency, ignoreInit = TRUE, {
# #            pnl$stackAdd(flags$currency)
#             pnl$vars$active = flags$currency
#             pnl$setCommareaItem("detail", flags$currency)
#             if (!pnl$ctcLoaded(flags$currency)) YATATabAppend(ns("tabDetail"), flags$currency)
#
#             updateTabsetPanel(session, inputId="tabHist", selected=ns("dummy"))
#             updateTabsetPanel(session, inputId="tabHist", selected=ns("detail"))
# #            updateLeftPanel()
#         })
#         observeEvent(flags$plots, ignoreInit = TRUE, {
#            if (is.null(pnl$active)) return()
#            if (flags$plots == 1) pnl$act$plotTypes[[1]] = input$cboPlot_1_1
#            if (flags$plots == 2) pnl$act$plotTypes[[2]] = input$cboPlot_1_2
#            if (flags$plots == 3) pnl$act$plotTypes[[3]] = input$cboPlot_2_1
#            if (flags$plots == 4) pnl$act$plotTypes[[4]] = input$cboPlot_2_2
#            pnl$plotChanged = flags$plots
#            #modHistDetailServer(pnl$active, full, pnl,parent=session)
#            updateTabsetPanel(session, inputId="tabHist", selected=ns("dummy"))
#            updateTabsetPanel(session, inputId="tabHist", selected=ns("detail"))
#         })
#
#        ###########################################################
#        ### END Reactives
#        ###########################################################
#
#       #####################################################
#       ### Observers                                     ###
#       #####################################################
#
#
      observeEvent(input$mnuHist, {
          act = jgg_get_active_ns(input$mnuHist)
         # act = yataActiveNS(input$mnuHist)
         module = paste0("modHist", str_to_title(act),"Server")
         eval(parse(text=paste0(module, "(act, input$mnuHist, pnl, session)")))
      })
#       observeEvent(input$btnClose, {
#          browser()
#       })
#
#       #################################################
#       ### Navegacion dinamica
#       #################################################
#
#       observeEvent(input$tabDetail_click, {
#           if (input$tabDetail_click != pnl$vars$active)
#               flags$currency = isolate(input$tabDetail_click)
#       })
#       observeEvent(input$tabDetail_close, {
#           YATATabRemove(ns("tabDetail"), input$tabDetail_close)
#           pnl$stackRemove(input$tabdetail_close)
#           if (pnl$active == input$tabdetail_close) flags$currency = isolate(pnl$stackTop())
#       })
#
#       #################################################
#       ### Panel Izquierdo
#       ### Es comun para todos
#       #################################################
#
#       observeEvent(input$lstCurrencies, ignoreInit = TRUE, { flags$currency = isolate(input$lstCurrencies) })
#
#       observeEvent(input$cboPlot_1_1, ignoreInit = TRUE, { flags$plots = isolate(1) })
#       observeEvent(input$cboPlot_1_2, ignoreInit = TRUE, { flags$plots = isolate(2) })
#       observeEvent(input$cboPlot_2_1, ignoreInit = TRUE, { flags$plots = isolate(3) })
#       observeEvent(input$cboPlot_2_2, ignoreInit = TRUE, { flags$plots = isolate(4) })
#
   })
}

