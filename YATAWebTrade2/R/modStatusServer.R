# Cada modulo lleva asociado un objeto
# es el que gestiona la creacion del objeto y guarda sus variables

modStatusServer <- function(id, full, pnlParent, parent=NULL) {
   ns = NS(id)
   PNLStatus = R6::R6Class("PNL.HISTORY"
      ,inherit = YATAPanel
      ,cloneable  = FALSE
      ,lock_class = TRUE
      ,public = list(
          position    = NULL
         ,operation   = NULL
         ,plotChanged = 0
         ,initialize    = function(session) {
             private$defaultValues()
             super$initialize(id, pnlParent, session, ns)
             self$position  = Factory$getObject(self$codes$object$position)
             self$operation = Factory$getObject(self$codes$object$operation)
             private$initPanel()
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
      # pnl = WEB$getPanel(id)
      # if (is.null(pnl) || pnl$DBID != WEB$DBID) { # first time or DB Changed
      #     pnl = WEB$addPanel(PNLStatus$new(id, pnlParent, session, NS(id)))
      # }

        # flags = reactiveValues(
        #    currency = NULL
        #   ,update   = FALSE
        #   ,plots    = 0
        # )
   })  # END MODULE
} # END SOURCR

