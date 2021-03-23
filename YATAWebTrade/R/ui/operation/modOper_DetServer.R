modOperDetailServer = function(id, full, pnloper, parent) {
   ns = NS(id)
   ns2 = NS(full)
   PNLDetail = R6::R6Class("PNL.DETAIL"
        ,inherit    = YATAPanel
        ,cloneable  = FALSE
        ,lock_class = TRUE
        ,public = list(
            names = list()
           ,oper  = NULL
           ,plots = c( "Plot1"          = "plot1"
                      ,"Plot2"          = "plot2"
                      ,"Plot3"          = "plot3"
                      ,"Plot4"          = "plot4"
            )
           ,initialize     = function(id, pnlParent, session) {
               super$initialize("oper-detail", pnlParent, session)
               private$getObjects()
               private$loadOperation(id)
               private$loadPanel()
           }
           ,getCameraName = function() {  }
        )
       ,private = list(
           operation = NULL
          ,camera    = NULL
          ,getObjects = function() {
               private$operation = self$factory$getObject(self$codes$object$operation)
               private$camera    = self$factory$getObject(self$codes$object$cameras)
          }
          ,loadOperation = function(id) {
               private$operation$select(id)
               private$camera$select(private$operation$current$camera)
          }
          ,loadPanel = function() {
              self$oper = private$operation$current
              self$names$camera = private$camera$getCameraName()[[1]]
              lbls = YATAWEB$getCurrencyLabel(c(self$oper$base, self$oper$counter))
              self$names$base    = lbls[[1]]
              self$names$counter = lbls[[2]]
              #self$dataIn$
          } 
           
       )
    )
   
   moduleServer(id, function(input, output, session) {
        pnl = pnloper$getOper(pnloper$idOper)
        if (is.null(pnl)) pnl = pnloper$setOper(pnloper$idOper, PNLDetail$new(pnloper$idOper, pnloper, session))

        updCombo("cboPlot1Left",  choices=pnl$plots, selected=pnl$plots[1])
        updCombo("cboPlot1Right", choices=pnl$plots, selected=pnl$plots[2])
        updCombo("cboPlot2Left",  choices=pnl$plots, selected=pnl$plots[3])
        updCombo("cboPlot2Right", choices=pnl$plots, selected=pnl$plots[4])
                
        output$lblCamera  = updLabelText(pnl$names$camera)
        output$lblBase    = updLabelText(pnl$names$base)
        output$lblCounter = updLabelText(pnl$names$counter)
        output$lblAmount  = updLabelText(number2string(pnl$oper$amount))
        output$lblPriceIn = updLabelText(number2string(pnl$oper$price))
        output$lblValueIn = updLabelText(number2string(pnl$oper$price * pnl$oper$amount))

        observeEvent(input$btnPlotOK,{
            if (input$cboPlot1Left == input$cboPlot1Right) {
                shinyjs::toogle("plot1")
                shinyjs::toogle("plot1x")
            }
            if (input$cboPlot2Left == input$cboPlot2Right) {
                shinyjs::toogle("plot2")
                shinyjs::toogle("plot2x")
            }
            
        })
     observeEvent(input$btnTest, {
         browser()
     })
  })
}

