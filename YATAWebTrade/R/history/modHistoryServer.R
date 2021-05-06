# Cada modulo lleva asociado un objeto
# es el que gestiona la creacion del objeto y guarda sus variables

modHistServer <- function(id, full, pnlParent, invalidate=FALSE, parent=NULL) {
   ns = NS(id)
   PNLHist = R6::R6Class("PNL.HISTORY"
      ,inherit = YATAPanel
      ,cloneable  = FALSE
      ,lock_class = TRUE
      ,public = list(
          position    = NULL
         ,operation   = NULL
         ,cameras     = NULL
         ,session     = NULL
         ,monitors    = NULL
         ,active      = NULL
         ,data        = NULL
         ,act         = NULL
         ,plotChanged = 0
         ,tab = "" 
         ,initialize    = function(session) {
             private$defaultValues()
             super$initialize(id, pnlParent, session, ns)
             self$position  = self$factory$getObject(self$codes$object$position)
             self$operation = self$factory$getObject(self$codes$object$operation)
             private$initPanel()
         }
         ,ctcLoaded = function(id) { ifelse(is.null(private$tabs[[id]]), FALSE, TRUE) } 
         ,ctcLoad   = function(df) {
             symbol = self$active
             df$tms = as.Date(df$tms)
             dfs = self$data$dfSymbols[self$data$dfSymbols$symbol == symbol,]
             flows = self$operation$getFlowsByCurrency(symbol)
             private$tabs[[symbol]] = list(symbol=symbol, id=dfs$id, label=dfs$label, active=TRUE
                                          , df=df, flows=flows
                                          , plotTypes = list("session", "", "volume", "")
                                          , plots     = list("session", "", "volume", "")
                                      )
             self$act = private$tabs[[symbol]]
         }
         ,stackAdd = function(symbol) {
             self$active = symbol
             private$stack = c(private$stack, symbol)
         }
         ,stackRemove = function(symbol) {
             idx = which(private$stack == symbol)
             private$stack = private$stack[-idx]
         }
         ,stackTop = function() { private$stack[length(private$stack)]}
         ,updateActive = function()   { private$tabs[[self$active]] = self$act }
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
         tabs = list()
        ,stack = c("summ")
        ,defaultValues = function() {
             # self$cookies$interval = 15
             # self$cookies$best = list(top = 10, from = 2)
             # self$cookies$history = 15
             # self$cookies$layout = matrix(c("plotHist","blkTop","plotSession","Position"),ncol=2)
             # self$cookies$position = "All"
        }
       ,initPanel = function() {
          df     = self$position$getHistoryCurrencies()
          labels = YATAWEB$getCTCLabels(df$symbol, invert=TRUE)
          dfl    = as.data.frame(labels)
          dfl    = cbind(dfl, row.names(dfl))
          colnames(dfl) = c("symbol", "label")
          row.names(dfl) = NULL
          
          df  = inner_join(df, dfl, by="symbol")
          id  = YATAWEB$getCTCID(df$symbol)
          df2 = as.data.frame(id)
          df2 = cbind(row.names(df2), df2)
          colnames(df2) = c("symbol", "id")
          row.names(df2) = NULL
          df = inner_join(df, df2, by="symbol")
          df$since = as.Date(df$since) - as.difftime(7, unit="days")
          self$data$dfSymbols = df
          
          info = list()
          invisible(self)
       }
       )
    )
    moduleServer(id, function(input, output, session) {
       YATAWEB$beg("History Server")
       pnl = YATAWEB$getPanel(id)
       if (is.null(pnl)) pnl = YATAWEB$addPanel(PNLHist$new(session))
        flags = reactiveValues(
           currency = NULL
          ,update   = FALSE
          ,plots    = 0
        )
        initPage = function() {
           choices        = pnl$data$dfSymbols$symbol
           names(choices) = pnl$data$dfSymbols$label
           updListBox("lstCurrencies", choices = choices)
        }
       updateLeftPanel = function() {
           browser
       }
       ###########################################################
       ### Reactives
       ###########################################################
        observeEvent(flags$currency, ignoreInit = TRUE, {
            pnl$stackAdd(flags$currency)
            if (!pnl$ctcLoaded(pnl$active)) YATATabAppend(ns("tab"), pnl$active, pnl$active)
            updateTabsetPanel(session, inputId="tabsHist", selected="dummy")
            updateTabsetPanel(session, inputId="tabsHist", selected="detail")
            updateLeftPanel()
        })
        observeEvent(flags$plots, ignoreInit = TRUE, {
            if (is.null(pnl$active)) return()
            if (flags$plots == 1) pnl$act$plotTypes[[1]] = input$cboPlot_1_1
            if (flags$plots == 2) pnl$act$plotTypes[[2]] = input$cboPlot_1_2
            if (flags$plots == 3) pnl$act$plotTypes[[3]] = input$cboPlot_2_1
            if (flags$plots == 4) pnl$act$plotTypes[[4]] = input$cboPlot_2_2
            pnl$plotChanged = flags$plots
            #modHistDetailServer(pnl$active, full, pnl,parent=session)
            updateTabsetPanel(session, inputId="tabsHist", selected="dummy")
            updateTabsetPanel(session, inputId="tabsHist", selected="detail")
        })

       ###########################################################
       ### END Reactives
       ###########################################################
      # updCombo("cboPlot_1_1", selected=pnl$act$plots[[1]])
      # updCombo("cboPlot_1_2", selected=pnl$act$plots[[2]])
      # updCombo("cboPlot_2_1", selected=pnl$act$plots[[3]])
      # updCombo("cboPlot_2_2", selected=pnl$act$plots[[4]])



      #####################################################
      ### Observers                                     ###
      #####################################################

      observeEvent(input$tabClick, {
        browser()
          if (input$tabClick != pnl$active) flags$currency = isolate(input$tabClick)
      })
      observeEvent(input$tabClose, {
          YATATabRemove(ns("tab"), input$tabClose)
          pnl$stackRemove(input$tabClose)
          if (pnl$active == input$tabClose) flags$currency = isolate(pnl$stackTop())
      })
      
      observeEvent(input$tabsHist, {
         if (input$tabsHist == "dummy") return()
         act = input$tabsHist
         if (act != "detail") pnl$active = NULL
         module = paste0("modHist", titleCase(act),"Server")
         eval(parse(text=paste0(module, "(act, full, pnl, parent=session)")))
      })
      observeEvent(input$btnClose, {
         browser()
      })

      #################################################
      ### Panel Izquierdo
      ### Es comun para todos
      #################################################

     observeEvent(input$lstCurrencies, ignoreInit = TRUE, { flags$currency = isolate(input$lstCurrencies) })
        
      if (!pnl$loaded || pnl$isInvalid(pnl$id)) {
          yuiLoading()
          initPage()
          yuiLoaded()
      }
      
      observeEvent(input$cboPlot_1_1, ignoreInit = TRUE, { flags$plots = isolate(1) })
      observeEvent(input$cboPlot_1_2, ignoreInit = TRUE, { flags$plots = isolate(2) })
      observeEvent(input$cboPlot_2_1, ignoreInit = TRUE, { flags$plots = isolate(3) })
      observeEvent(input$cboPlot_2_2, ignoreInit = TRUE, { flags$plots = isolate(4) })

      YATAWEB$end("History Server")
   })
}    

