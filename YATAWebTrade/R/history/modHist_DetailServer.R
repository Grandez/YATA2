modHistDetailServer = function(id, full, pnlParent, parent) {
   ns = NS(id)
   ns2 = NS(full)
   PNLHistDetail = R6::R6Class("PNL.HISTORY.DETAIL"
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
             super$initialize(full, pnlParent, session, ns)
             self$position  = self$factory$getObject(self$codes$object$position)
             self$operation = self$factory$getObject(self$codes$object$operation)
             private$initPanel()
         }
         ,ctcLoaded = function(symbol) { ifelse(is.null(private$tabs[[symbol]]), FALSE, TRUE) } 
         ,ctcLoad   = function() {
             symbol = self$vars$active
             df     = self$vars$df
             df$tms = as.Date(df$tms)
             dfs    = self$data$dfSymbols[self$data$dfSymbols$symbol == symbol,]
             flows  = self$operation$getFlowsByCurrency(symbol)
             private$tabs[[symbol]] = list(symbol=symbol, id=dfs$id, label=dfs$label, active=TRUE
                                          , df=df, flows=flows
                                          , plotTypes = list("session", "", "volume", "")
                                          , plots     = list("session", "", "volume", "")
                                      )
             self$act = private$tabs[[symbol]]
         }
         ,setActive = function() { 
             self$act = private$tabs[[self$vars$active]]
             invisible(self)
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
         tabs = list()     # Datos de detail
        ,stack = c("summ")
        ,defaultValues = function() {
             # self$cookies$interval = 15
             # self$cookies$best = list(top = 10, from = 2)
             # self$cookies$history = 15
             # self$cookies$layout = matrix(c("plotHist","blkTop","plotSession","Position"),ncol=2)
             # self$cookies$position = "All"
        }
       ,initPanel = function() {
           self$data$dfSymbols = pnlParent$data$dfSymbols
           invisible(self)
       }
       )
    )
   
   moduleServer(id, function(input, output, session) {
      YATAWEB$beg("modHist_Detail")
       pnl = YATAWEB$getPanel(full)
       if (is.null(pnl)) pnl = YATAWEB$addPanel(PNLHistDetail$new(session))
      
      prepareSession = function() {
         dff =  pnl$act$flows[,c("amount", "price", "tms")]
         dff$tms = as.Date(dff$tms)
         pnl$act$df$tms = as.Date(pnl$act$df$tms)
         dft = full_join(pnl$act$df, dff, by="tms")
         list(df=dft)
      }
      prepareFlows = function() {
          df = pnl$act$flows
          if (is.null(df) || nrow(df) == 0) return (NULL)
          df[,c("type", "amount", "price", "tms")]
          list(df=df)
      }
      makePlot = function(index, tgt) {
         if (tgt != 0 && index != tgt) return(NULL)
         if (tgt == 0) tgt = index
         df = pnl$act$df
         type = pnl$act$plotTypes[[tgt]]
         if (type == "")        pnl$act$plots[[tgt]] = ""
         if (type == "session") pnl$act$plots[[tgt]] = YATAPlot$new("prueba", type="Candlestick", data=df)
         if (type == "volume")  pnl$act$plots[[tgt]] = YATAPlot$new("prueba", type="Bar", data=df[,c("tms", "volume")])
         if (type == "cap")     pnl$act$plots[[tgt]] = YATAPlot$new("prueba", type="Bar", data=df[,c("tms", "market_cap")])
         if (type == "price")   pnl$act$plots[[tgt]] = YATAPlot$new("prueba", type="Line",data=df) 
      }
      makeSubPlots = function(p1, p2, rows = TRUE) {
         plots = pnl$act$plots
         if (!isPlot(plots[[p1]]) && !isPlot(plots[[p2]])) return (NULL)
         if (!isPlot(plots[[p1]])) return (plots[[p2]])
         if (!isPlot(plots[[p2]])) return (plots[[p1]])
         nrows = ifelse(rows, 2, 1)
         yuiSubPlots(plots[[p1]], plots[[p2]], nrows=nrows)
      }
      mergeSubPlots = function(p1, p2, rows = TRUE) {
         if (!isPlot(p1) && !isPlot(p2)) return (NULL)
         if (!isPlot(p1)) return (p2)
         if (!isPlot(p2)) return (p1)
         nrows = ifelse(rows, 2, 1)
         yuiSubPlots(p1, p2, nrows=nrows)
      }
      renderPlots = function(item) {
         lapply(seq(1,4), function(index) makePlot(index, item))
         plot1 = makeSubPlots(1, 2, FALSE)
         plot2 = makeSubPlots(3, 4, FALSE)
         plot  = mergeSubPlots(plot1, plot2)
         output$plot = updSubPlots(plot)
      }
      refreshPage = function() {
          # esto es flags$refresh, pero ahi veces que no lo lanza
         pnl$setActive()
         output$title = renderText({pnl$act$label}) 
         renderPlots(flags$plots)
         output$session = updTable(prepareSession())
         output$flows   = updTable(prepareFlows())
         renderPlots(flags$plots)
         yuiLoaded()
      }
      
      flags = reactiveValues(
          loaded  = FALSE
         ,update  = FALSE
         ,refresh = FALSE          
         ,plots  = 0

       )

      #####################################################
      ### Reactives                                     ###
      #####################################################
      observeEvent(flags$loaded, ignoreInit = TRUE, { 
         if (!is.data.frame(pnl$vars$df)) return()
         pnl$ctcLoad()
         flags$refresh = isolate(!flags$refresh)
      })
      observeEvent(flags$refresh, ignoreInit = TRUE, {
          refreshPage()
         #  browser()
         # pnl$setActive()
         # output$title = renderText({pnl$act$label}) 
         # renderPlots(flags$plots)
         # output$session = updTable(prepareSession())
         # output$flows   = updTable(prepareFlows())
         # renderPlots(flags$plots)
         # yuiLoaded()
      })


      #####################################################
      ### REST                                          ###
      #####################################################

      getHistorical = function() {
          symbol = pnl$vars$active
          dfs = pnl$data$dfSymbols 
          df = dfs[dfs$symbol == symbol,]
          restdf("hist",id=df$id,from=df$since,to=Sys.Date())  %>% then (
                 function(df) { 
                    pnl$vars$df = df
                    flags$loaded = isolate(!flags$loaded)
                 }, function(err) { }
          )
      }
      getFlows = function() {
          # sym = pnl$active
          # dfs = pnl$act$dfSymbols 
          # df = dfs[dfs$symbol == sym,]
          # restdf("hist",id=df$id,from=df$since,to=Sys.Date())  %>% then(
          #      function(df) {
          #          if (is.data.frame(df)) {
          #              pnl$ctcLoad(sym, df)
          #              updatePage() 
          #          }
          #      }, function(err) { })
      }

      #####################################################
      ### Observers                                     ###
      #####################################################

      observeEvent(input$chkOper, ignoreInit = TRUE, {
         data = pnl$getActive()
         if (input$chkOper && is.null(data$flows)) {
             getFlows()
            return()
         }
         if (!input$chkOper) pnl$plot$removeXLines()
         if (input$chkOper) pnl$plot$addXLines(data$flows)
         output$plot1 = pnl$plot$render()
         
      })
      
      observeEvent(input$modebar, {
          info = input$modebar
          if (!as.logical(info$tagvalue)) info$type = info$tag
          output$plot = pnl$plot$render(info = info)
      })

      yuiLoading() # Reset en refresh
      pnl$vars$active   = pnl$getCommareaItem("detail")
      loaded = pnl$ctcLoaded(pnl$vars$active)
      if ( loaded) {
#          flags$refresh = isolate(!flags$refresh)
          refreshPage()
      }
          
      if (!loaded) getHistorical()

      YATAWEB$end("modHist_Detail")
   })
}