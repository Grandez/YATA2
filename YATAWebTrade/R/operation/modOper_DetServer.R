modOperDetailServer = function(id, full, pnlParent, parent) {
   ns = NS(id)
   ns2 = NS(full)

   PNLDetail = R6::R6Class("PNL.DETAIL"
        ,inherit    = YATAPanel
        ,cloneable  = FALSE
        ,lock_class = TRUE
        ,public = list(
            names = list()
           ,oper  = NULL
           ,currency = NULL
           ,plots = c( "Session"         = "plotSession"
                      # ,"Marker Linear"  = "plotDayMarker"
                      # ,"Marker Log"     = "plotDayMarkerLog"
                      ,"Price Linear"   = "plotPrice"
#                      ,"Price Log"      = "plotDayLog"
                      ,"Volume"         = "plotVolume"
#                      ,"Variation"      = "plotVariation"
            )
           ,initialize     = function(id, pnlParent, session) {
               super$initialize("oper-detail", pnlParent, session)
               private$getObjects(id)
               private$loadPanel()
               self$vars$first = 1
           }
        )
       ,private = list(
           operation  = NULL
          ,camera     = NULL
          ,currencies = NULL 
          ,getObjects = function(id) {
               private$operation  = self$factory$getObject(self$codes$object$operation)
               private$camera     = self$factory$getObject(self$codes$object$cameras)
               private$currencies = self$factory$getObject(self$codes$object$currencies)
               
               private$operation$select(id)
               self$oper = private$operation$current
               private$camera$select(self$oper$camera)
               private$currencies$select(symbol = self$oper$counter)
               self$currency = private$currencies$current
               self$vars$plots = private$initPlotsInfo()
               private$getHistorical()
          }
          ,loadPanel = function() {
              self$names$camera = private$camera$getCameraName()[[1]]
              lbls = YATAWEB$getCTCLabels(c(self$oper$base, self$oper$counter))
              self$names$base    = lbls[[1]]
              self$names$counter = lbls[[2]]
              #self$dataIn$
          } 
           
       ,getHistorical = function() {
           to = Sys.Date()
           
           from = self$oper$tms - as.difftime(7, unit="days")
           restdf("hist",id=self$currency$id,from=from,to=to)  %>%
              then( function(df) {
                  df$tms = as.Date(df$tms)
                  self$data$dfHist = df
                  },function(err)    {
                      message("ha ido mal 3") ; message(err)})
       }
        ,initPlotsInfo = function() {
            tpl = list(observer = ns2("modebar"), idPlot=NA, src="session", symbol=self$oper$counter)
            lst = list()
            for (idx1 in 1:2) {
                for (idx2 in 0:2) {
                    tpl$ui = paste0("plot", idx1, idx2)
                    lst = list.append(lst, tpl)
                }
            }
            lst
        }
      )
    )
   
   moduleServer(id, function(input, output, session) {
       message("SERVER Detalle Cerrada")
        pnl = pnlParent$getOper(pnlParent$idOper)
        if (is.null(pnl)) pnl = pnlParent$setOper(pnlParent$idOper, PNLDetail$new(pnlParent$idOper, pnlParent, session))
    #     selectPlots = function() {
    #        if (input$cboPlot1Right == "") {
    #            shinyjs::show("plot1")
    #            shinyjs::hide("plot1x")
    #            pnl$vars$plots[[1]]$plot = input$cboPlot1Left
    #            pnl$vars$plots[[2]]$plot = NA
    #            pnl$vars$plots[[3]]$plot = NA
    #        } else {
    #            shinyjs::hide("plot1")
    #            shinyjs::show("plot1x")
    #            pnl$vars$plots[[1]]$plot = NA
    #            pnl$vars$plots[[2]]$plot = input$cboPlot1Left
    #            pnl$vars$plots[[3]]$plot = input$cboPlot1Right
    #        }
    #        if (input$cboPlot2Right == "") {
    #            shinyjs::show("plot2")
    #            shinyjs::hide("plot2x")
    #            pnl$vars$plots[[4]]$plot = input$cboPlot2Left
    #            pnl$vars$plots[[5]]$plot = NA
    #            pnl$vars$plots[[6]]$plot = NA
    #        } else {
    #            shinyjs::hide("plot2")
    #            shinyjs::show("plot2x")
    #            pnl$vars$plots[[4]]$plot = NA
    #            pnl$vars$plots[[5]]$plot = input$cboPlot2Left
    #            pnl$vars$plots[[6]]$plot = input$cboPlot2Right
    #       }
    #     }
    #     updatePlots = function() {
    #       sfx = c("10", "11","12","20","21","22")    
    #       selectPlots()
    #       # No se puede usar for por que la expresion es retrasada
    #       lapply(1:6, function(x) { 
    #             info = pnl$vars$plots[[x]]
    #             if (is.na(info$plot)) return (NULL)
    #             if (nchar(info$plot) > 0) {
    #             cmd = paste0("output$plot",sfx[x]," = updPlot({", info$plot,"(info, pnl$data$dfHist)})")
    #             eval(parse(text=cmd))
    #             }
    #             #    eval(parse(text=paste0("output$plot",idx1,idx2," = updPlot({", info[[idx]]$plot,"(info[[idx]], pnl$data$dfHist)})")))
    # 
    #           
    #       })    
    #       # for (idx1 in 1:2) {
    #       #      for (idx2 in 0:2) {
    #       #           idx = ((idx1 - 1) * 3) + idx2 + 1
    #       #           info = pnl$vars$plots[[idx]]
    #       #           if (is.na(info$plot)) next
    #       #           cmd = paste0("output$plot",idx1,idx2," = updPlot({", info$plot,"(info, pnl$data$dfHist)})")
    #       #           #eval(parse(text=cmd))
    #       #           eval(parse(text=paste0("output$plot",idx1,idx2," = updPlot({", info[[idx]]$plot,"(info[[idx]], pnl$data$dfHist)})")))
    #       #       }
    #       # }
    # }

        updCombo("cboPlot1Left",  choices=pnl$plots, selected=pnl$plots[1])
        updCombo("cboPlot2Left",  choices=pnl$plots, selected=pnl$plots[3])
        updCombo("cboPlot1Right", choices=c("No plot"="", pnl$plots), selected="")
        updCombo("cboPlot2Right", choices=c("No plot"="", pnl$plots), selected="")
                
        output$lblCamera  = updLabelText(pnl$names$camera)
        output$lblBase    = updLabelText(pnl$names$base)
        output$lblCounter = updLabelText(pnl$names$counter)
        # output$lblAmount  = updLabelText(number2string(pnl$oper$amount))
        # output$lblPriceIn = updLabelText(number2string(pnl$oper$price))
        # output$lblValueIn = updLabelText(number2string(pnl$oper$price * pnl$oper$amount))

        output$icon = renderText({
            paste0('<img src="icons/', pnl$currency$id, '.png"'
                  ,',width="64px", height="64px"'
                  ,',onerror="this.onerror=null;this.src="icons2/YATA.png";>')})

        output$title = updLabelText(YATAWEB$getCTCLabel(pnl$oper$counter))
        output$prueba <- renderText({ "soy una prueba" })
        observeEvent(input$boton, {
            browser()
        })
        observeEvent(input$cboPlot1Left, {
            if (is.null(pnl$vars$count)) pnl$vars$count = 0
            pnl$vars$count = pnl$vars$count + 1
            updateActionButton(session, "boton", label = paste("otra ", pnl$vars$count))
            output$prueba = renderText({ paste("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", pnl$vars$count) })
        })
#        observeEvent(input$btnPlotOK,{ updatePlots() })
        # observeEvent(input$modebar, {
        #     info=input$modebar
        #     message("Recibe click para ", info$ui)
        #     eval(parse(text=paste0("pnl$setCookies(", info$ui, "=info$modebar)")))
        #     cmd = paste0("output$",info$ui," = updPlot({", info$plot,"(info, pnl$data$dfHist)})")
        #     eval(parse(text=cmd))
        # 
        #  })
        
       #####################################################
       ### Timers                                        ###     
       #####################################################
      
#        observe({ # Se ejecuta una sola vez
#          invalidateLater(pnl$vars$first * 1000, session)
#          if (pnl$vars$first > 1 && pnl$vars$first != Inf) {
# #             updatePlots()
#              pnl$vars$first = Inf
#          } else {
#             pnl$vars$first = pnl$vars$first + 1            
#          }
#       })
  })
}

