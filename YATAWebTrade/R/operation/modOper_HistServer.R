modOperHistServer = function(id, full, pnlParent, parent) {
   ns = NS(id)
   ns2 = NS(full)
   PNLPosHist = R6::R6Class("PNL.POS.HIST"
        ,inherit    = YATAPanel
        ,cloneable  = FALSE
        ,lock_class = TRUE
        ,public = list(
            operations = NULL
           ,cameras    = NULL
           ,rowClosed  = 0
           ,initialize     = function(id, pnlParent, session) {
               super$initialize(id, pnlParent, session)
               self$operations = self$factory$getObject(self$codes$object$operation)
               self$cameras    = self$factory$getObject(self$codes$object$cameras)
               self$data$texts = list()
           }
           ,loadData = function() {
              self$data$dfExec   = self$operations$getHistory()
              self$data$dfClosed = self$operations$getClosed()
              ids = self$data$dfClosed$id
              self$data$dfSell   = self$operations$getSons(ids, self$codes$oper$sell)
              cams = unique(c(unique(self$data$dfExec$camera), unique(self$data$dfClosed$camera)))
              self$data$texts$cameras = self$cameras$getCameraName(cams)
              self$data$texts$oper = self$MSG$getBlock(1)
              ctc = unique(c(unique(self$data$dfExec$counter), unique(self$data$dfClosed$counter)))
              self$data$texts$counters = YATAWEB$getCTCLabels(ctc,type="long")
           }
         ,prepareClosed = function() {
             df = private$prepare(self$data$dfClosed)
             df[,c("status", "parent")] = list(NULL)    
             dfOut = self$data$dfSell[,c("parent", "amount", "price")]
             colnames(dfOut) = c("id","amountOut", "priceOut")
             
             df = inner_join(df, dfOut, by="id")
             df$amountOut = abs(df$amountOut)
             df = df[,c("camera", "counter", "amountIn", "priceIn", "amount", "price", "amountOut", "priceOut")]
             df$revenue = (df$priceOut / df$price) - 1
             df$profit = df$amountOut * (df$priceOut - df$price)
             
             
#             df = df[,c()]
             df
             
         }
         ,prepareExec = function(input) {
             df = self$data$dfExec
             if (!input$chkCancelled) df = df[df$status != self$codes$status$cancelled,]
             if (!input$chkCancelled) df = df[df$status != self$codes$status$rejected, ]
             if (!input$chkSon)    df = df[df$parent != 0, ]
             df = private$prepare(df)
             df[,-1]
         }
     )
      ,private = list(
          prepare = function(df) {
             df[,c("base", "active", "rank")] = list(NULL)
             df$type = self$data$texts$oper[as.character(df$type)]
             df$counter = self$data$texts$counters[df$counter]
             df$camera = self$data$texts$cameras[df$camera]
             df
         }    

      )
   )
   moduleServer(id, function(input, output, session) {
       message("SERVER History")
      pnl = YATAWEB$getPanel(full)
      if (is.null(pnl)) pnl = YATAWEB$addPanel(PNLPosHist$new(full, pnlParent, session))

      if (!pnl$loaded) {
          pnl$loadData()
#          output$plotOpen = updPlot(pnl$plot$render(), "plotOpen")
          # updateLeftSide()
          # refresh(TRUE)
          pnl$loaded = TRUE
      }
      output$tblDetClosed = yataDFOutput(pnl$prepareClosed(), type="operation")
      output$tblDetExec   = yataDFOutput(pnl$prepareExec(input),   type="operation")
 
      isolate({
       observeEvent(input$tblDetClosed_cell_clicked, {
           # se generan varios clicks. no se por que
          if (length(input$tblDetClosed_cell_clicked) == 0) return()
          row = input$tblDetClosed_cell_clicked$row
          if (pnl$rowClosed == row) return()
          pnl$rowClosed = row
          item = as.list(as.list(pnl$data$dfClosed[row,]))
          pnlParent$idOper = item$id
          # lbl = paste0(item$counter, " (", item$id, ")")
          # idl = paste("detail", item$id, sep="_")
          # insertTab( "pnlOpType",tabPanel(lbl,value=idl, tags$div(id= sub(id, item$id,full)))
          #               ,"oper-hist", position="after", select=TRUE, session=parent)
          updateTabsetPanel(parent, "pnlOpType", selected = "oper-detail")          
       }, ignoreInit = TRUE, ignoreNULL = TRUE)
          
      })
           
      observeEvent(input$chkCancelled, { 
         output$tblDetExec = yataDFOutput(pnl$prepareExec(input),   type="operation") 
      }, ignoreInit = TRUE)
      observeEvent(input$chkSon, {
         output$tblDetExec = yataDFOutput(pnl$prepareExec(input),   type="operation") 
      }, ignoreInit = TRUE)
   })
}