modHistSummServer = function(id, full, pnlParent, parent) {
   ns = NS(id)
   ns2 = NS(full)
   PNLHistSumm = R6::R6Class("PNL.HIST.SUMM"
        ,inherit    = YATAPanel
        ,cloneable  = FALSE
        ,lock_class = TRUE
        ,public = list(
            operations = NULL
           ,cameras    = NULL
           ,position   = NULL
           ,rowClosed  = 0
           ,initialize     = function(id, pnlParent, session) {
               super$initialize(id, pnlParent, session)
               self$operations = self$factory$getObject(self$codes$object$operation)
               self$cameras    = self$factory$getObject(self$codes$object$cameras)
               self$position   = self$factory$getObject(self$codes$object$position)
               self$data$texts = list()
           }
           ,loadData = function() {
               
              df   = self$position$getGlobalPosition(TRUE)
              self$data$dfGlobal = df[df$currency != "EUR",]
              
              df = self$operations$getOperations()
              df = df[df$camera != "XFER",]
              self$data$dfOper = df
              
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
      YATAWEB$beg("modHist_Summary")

      pnl = YATAWEB$getPanel(id)
      if (is.null(pnl)) pnl = YATAWEB$addPanel(PNLHistSumm$new(full, pnlParent, session))

      flags = reactiveValues(
          refresh = FALSE
      )
      prepareRevenue = function() {
          df = pnl$data$dfOper
          df = df[,c("type", "camera","base", "counter", "amount", "price", "tms")]
          df$tms = as.Date(df$tms)
          df = df %>% arrange(tms, type)
          list(df=df)
      }
      renderPie = function() {
         #JGG Ajustar LABEL.RANK.X
          df = pnl$data$dfOper %>% group_by(rank) %>% summarize(count = n())
          plt = plotly::plot_ly()
          plt = plt %>% add_pie(data=df, labels=~rank, values=~count)
           output$plotRank = plotly::renderPlotly({plt})
      }
      renderRevenue = function() {
          data = prepareRevenue()
          output$tblRevenue = updTable(data)
      }
       ###########################################################
       ### Reactives
       ###########################################################

       observeEvent(flags$refresh, ignoreInit = TRUE, {
           YATAWEB$beg("flags$refresh")
           df = pnl$data$dfGlobal
           dfs = (df$priceSell / df$priceBuy) - 1
           YATAWEB$end("flags$refresh")
       })       
      refresh = function() {
           YATAWEB$beg("flags$refresh")
           df = pnl$data$dfGlobal
           dfr = data.frame(currency=df$currency, revenue=((df$priceSell / df$priceBuy) - 1) * 100)
           plot = YATAPlot$new("revenue", type="Bar", data=dfr)
           output$plotRevenue = plot$render()
           # El otro grafico
           # Por cada dia, el saldo en eur, el valor, y el resultado
           renderPie()
           renderRevenue()
           YATAWEB$end("flags$refresh")
          
      }
#       headerClosed = htmltools::withTags(table(class = 'display', thead(
#          tr( th(colspan = 2, class="yata_dt_header_false", '')
#             ,th(colspan = 2, class="yata_dt_header", 'In')
#             ,th(colspan = 2, class="yata_dt_header", 'Real')
#             ,th(colspan = 2, class="yata_dt_header", 'Out')
#             ,th(colspan = 2, class="yata_dt_header_false", ' ') 
#          )
#         ,tr( th('Camera'),th('Counter')
#             ,th('Amount'),th('Price'),th('Amount'),th('Price'),th('Amount'),th('Price')
#             ,th('Revenue'),th('Profit'))
#       )))      
# 
      if (!pnl$loaded) {
          pnl$loadData()
          flags$refresh = isolate(!flags$refresh)
          
          refresh()
          pnl$loaded = TRUE
      }
#       opts = list(sortable=FALSE)
#       output$tblDetClosed = yataDFOutput(pnl$prepareClosed(), header= headerClosed, opts=opts, type="operation")
#       output$tblDetExec   = yataDFOutput(pnl$prepareExec(input),   type="operation")
#  
#       isolate({
#        observeEvent(input$tblDetClosed_cell_clicked, {
#            # se generan varios clicks. no se por que
#           if (length(input$tblDetClosed_cell_clicked) == 0) return()
#           row = input$tblDetClosed_cell_clicked$row
#           if (pnl$rowClosed == row) return()
#           pnl$rowClosed = row
#           item = as.list(as.list(pnl$data$dfClosed[row,]))
#           pnlParent$idOper = item$id
#           # lbl = paste0(item$counter, " (", item$id, ")")
#           # idl = paste("detail", item$id, sep="_")
#           # insertTab( "pnlOpType",tabPanel(lbl,value=idl, tags$div(id= sub(id, item$id,full)))
#           #               ,"oper-hist", position="after", select=TRUE, session=parent)
#           updateTabsetPanel(parent, "pnlOpType", selected = "oper-detail")          
#        }, ignoreInit = TRUE, ignoreNULL = TRUE)
#           
#       })
#            
#       observeEvent(input$chkCancelled, { 
#          output$tblDetExec = yataDFOutput(pnl$prepareExec(input),   type="operation") 
#       }, ignoreInit = TRUE)
#       observeEvent(input$chkSon, {
#          output$tblDetExec = yataDFOutput(pnl$prepareExec(input),   type="operation") 
#       }, ignoreInit = TRUE)
       YATAWEB$end("modHist_Summary")
   })
}