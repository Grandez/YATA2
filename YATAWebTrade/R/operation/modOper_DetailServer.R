modOperDetailServer = function(id, full, pnl, parent) {
   ns = NS(id)
   ns2 = NS(full)
   moduleServer(id, function(input, output, session) {
      YATAWEB$beg("modHist_Detail")

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
         browser()
         plot  = mergeSubPlots(plot1, plot2)
         output$plot = updSubPlots(plot)
      }
      updatePage = function() {
         output$title = renderText({pnl$act$label}) 
         renderPlots(flags$plots)
         output$session = updTable(prepareSession())
         output$flows   = updTable(prepareFlows())
         yuiLoaded()
      }      
      flags = reactiveValues(
          load   = NULL
         ,update = FALSE
         ,plots  = 0
       )

      #####################################################
      ### Reactives                                     ###
      #####################################################
      observeEvent(flags$load, ignoreInit = TRUE, { 
         if (!is.data.frame(flags$load)) return()
         pnl$ctcLoad(flags$load)
         flags$update = isolate(!flags$update)
      })
      observeEvent(flags$update, ignoreInit = TRUE, { 
          browser()
         updatePage() 
         renderPlots(flags$plots) 
         yuiLoaded()
         browser()
      })
      yuiLoading()

      #####################################################
      ### REST                                          ###
      #####################################################

      getHistorical = function() {
          sym = pnl$active
          dfs = pnl$data$dfSymbols 
          df = dfs[dfs$symbol == sym,]
          WEB$REST$DF("hist",id=df$id,from=df$since,to=Sys.Date())  %>% then(
                 function(df) { flags$load = isolate(df)}, function(err) { })
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

      if (pnl$ctcLoaded(pnl$active)) {
          updatePage()
      } else {
          getHistorical()
      }
      
      YATAWEB$end("modHist_Detail")
   })
}