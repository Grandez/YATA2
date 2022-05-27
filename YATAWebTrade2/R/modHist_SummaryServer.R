modHistSummServer = function(id, full, parent, session) {
ns = NS(id)
ns2 = NS(full)
PNLHistSummary = R6::R6Class("PNL.HISTORY.SUMMARY"
   ,inherit    = WEBPanel
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,public = list(
       available  = 0
      ,balance    = 0
      ,objTable   = NULL
      ,initialize = function(id, parent, session) {
          super$initialize(id, parent, session)
          private$oper     = self$factory$getObject(self$codes$object$operation)
          private$objPos   = self$factory$getObject(self$codes$object$position)
          self$vars = list(oper = 0, currency = "",camera   = "", date=NULL)
          self$data$dfPos = private$objPos$getFullPosition()
          self$objTable = WDGTableOper$new("oper", self$factory)
      }
      ,reload = function() {
          dfOpers = NULL
          dfPos   = self$data$dfPos
          cameras = nrow(dfPos)
          if (cameras == 0) return (NULL)
          for (row in 1:cameras) {
              df = private$oper$getHistoryByCamera(dfPos[row, "camera"], dfPos[row,"since"])
              if (nrow(df) > 0) dfOpers = rbind(dfOpers, df)
          }
          self$data$dfOpers = setorderv(dfOpers, "tms", -1)
          self$loaded = TRUE
          invisible(self)
      }
      ,prepareTable = function(df) {
          if (nrow(df) == 0) return()
          include = c("tms", "camera", "base", "counter", "amount", "value", "price", "fee", "gas")
          exclude =  c("id", "parent", "priceIn", "priceOut", "alive", "rank")
          exclude = c(exclude, "acive", "status")
          exclude = c(exclude, "acive", "status")
          #df[exclude] = list(NULL)
          df = df[,include]
          types = list( imp = c("amount", "value","price")
                        )
          data = list(df = df, cols=NULL, info=NULL)
          data$info=list( types=types) #event=ns("tablePos"), target=table,types=types)
          data
       }
  )
  ,private = list(
       oper      = NULL
      ,objPos = NULL
    )
)
moduleServer(id, function(input, output, session) {
   flags = reactiveValues(
      refresh  = FALSE
   )

   pnl = WEB$getPanel(PNLHistSummary, full, parent, session)
   if (!pnl$loaded) {
       pnl$reload()
       flags$refresh = isolate(!flags$refresh)
   }

   observeEvent(flags$refresh, {
      if (nrow(pnl$data$dfOpers) == 0) return()
      mfilter = ""
      if (pnl$vars$oper != 0) mfilter = paste("type == ", pnl$vars$oper)
      if (nchar(pnl$vars$currency) > 0) {
          if (nchar(mfilter) > 0) mfilter = paste(mfilter, "&")
          mfilter = paste(mfilter, "(base == ", pnl$vars$currency, "| counter == ", pnl$vars$currency, ")")
      }
      if (nchar(pnl$vars$camera) > 0) {
          if (nchar(mfilter) > 0) mfilter = paste(mfilter, "&")
          mfilter = paste(mfilter, "camera == ", pnl$vars$camera)
      }
      if (!is.null(pnl$vars$date)) {
          if (nchar(mfilter) > 0) mfilter = paste(mfilter, "&")
          mfilter = paste(mfilter, "tms >= ", pnl$vars$date)
      }
      df = pnl$data$dfOpers
      if (nchar(mfilter) > 0) {
          df = eval(parse(text=paste("filter(", pnl$data$dfOpers, ",", mfilter, ")")))
      }
#       data = pnl$prepareTable (df)

       output$tblHistory = pnl$objTable$render(df) # updTable(data)
   })
   observeEvent(input$cboOper, {
      df = pnl$data$dfOpers
      pnl$vars$oper = as.integer(input$cboOper)
      pnl$vars$buy  = (pnl$vars$oper %% 2) == 0

      if (input$cboOper == 0) {
          pnl$vars$buy = NULL
          choices=WEB$combo$operations(all=TRUE)
          updCombo("cboCurrency", choices=choices)
      } else {
          currency = ifelse(pnl$vars$buy, "counter", "base")
          currencies = unique(df[,currency])
          choices=WEB$combo$currencies(all=TRUE, set=currencies)
          updCombo("cboCurrency", choices=choices)
      }
      flags$refresh = isolate(!flags$refresh)
   }, ignoreInit = TRUE, ignoreNULL = TRUE)
   observeEvent(input$cboCurrency, {
      pnl$vars$currency = trimws(input$cboCurrency)
      flags$refresh = isolate(!flags$refresh)
   }, ignoreInit = TRUE, ignoreNULL = TRUE)
   observeEvent(input$cboCamera, {
      pnl$vars$camera = trimws(input$cboCamera)
      flags$refresh = isolate(!flags$refresh)
   }, ignoreInit = TRUE, ignoreNULL = TRUE)
   observeEvent(input$dtDate, {
      pnl$vars$date = input$dtDate
      flags$refresh = isolate(!flags$refresh)
   }, ignoreInit = TRUE, ignoreNULL = TRUE)

})
}
#
# modHistSummServer = function(id, full, pnlParent, parent) {
#    ns = NS(id)
#    ns2 = NS(full)
#    PNLHistSumm = R6::R6Class("PNL.HIST.SUMM"
#         ,inherit    = WEBPanel
#         ,cloneable  = FALSE
#         ,lock_class = TRUE
#         ,public = list(
#             operations = NULL
#            ,cameras    = NULL
#            ,position   = NULL
#            ,rowClosed  = 0
#            ,initialize     = function(id, pnlParent, session) {
#                super$initialize(id, pnlParent, session)
#                self$operations = self$factory$getObject(self$codes$object$operation)
#                self$cameras    = self$factory$getObject(self$codes$object$cameras)
#                self$position   = self$factory$getObject(self$codes$object$position)
#                self$data$texts = list()
#            }
#            ,loadData = function() {
#               df   = self$position$getGlobalPosition(TRUE)
#               self$data$dfGlobal = df[df$currency != self$factory$fiat,]
#
#               df = self$operations$getOperations()
#               df = df[df$camera != self$factory$fiat,]
#               self$data$dfOper = df
#
#            }
#      )
#       ,private = list(
#           prepare = function(df) {
#              df[,c("base", "active", "rank")] = list(NULL)
#              df$type = self$data$texts$oper[as.character(df$type)]
#              df$counter = self$data$texts$counters[df$counter]
#              df$camera = self$data$texts$cameras[df$camera]
#              df
#          }
#
#       )
#    )
#    moduleServer(id, function(input, output, session) {
#       pnl = WEB$getPanel(id)
#       if (is.null(pnl)) pnl = WEB$addPanel(PNLHistSumm$new(full, pnlParent, session))
#
#       flags = reactiveValues(
#           refresh = FALSE
#       )
#       prepareRevenue = function() {
#           df = pnl$data$dfOper
#           df = df[,c("type", "camera","base", "counter", "amount", "price", "tms")]
#           df$tms = as.Date(df$tms)
#           df = df %>% arrange(tms, type)
#           list(df=df)
#       }
#       renderPie = function() {
#          #JGG Ajustar LABEL.RANK.X
#           df = pnl$data$dfOper %>% group_by(rank) %>% summarize(count = n())
#           plt = plotly::plot_ly()
#           plt = plt %>% add_pie(data=df, labels=~rank, values=~count)
#            output$plotRank = plotly::renderPlotly({plt})
#       }
#       renderRevenue = function() {
#           data = prepareRevenue()
#           output$tblRevenue = updTable(data)
#       }
#        ###########################################################
#        ### Reactives
#        ###########################################################
#
#        observeEvent(flags$refresh, ignoreInit = TRUE, {
#            df = pnl$data$dfGlobal
#            dfs = (df$priceSell / df$priceBuy) - 1
#        })
#       refresh = function() {
#            browser()
#            df = pnl$data$dfGlobal
#            plot = YATAPlot$new("revenue", type="Bar", data=df[,c("currency","profit")])
#            output$plotRevenue = plot$render()
#            # El otro grafico
#            # Por cada dia, el saldo en eur, el valor, y el resultado
# #JGG       renderPie()
# #JGG       renderRevenue()
#
#       }
# #       headerClosed = htmltools::withTags(table(class = 'display', thead(
# #          tr( th(colspan = 2, class="yata_dt_header_false", '')
# #             ,th(colspan = 2, class="yata_dt_header", 'In')
# #             ,th(colspan = 2, class="yata_dt_header", 'Real')
# #             ,th(colspan = 2, class="yata_dt_header", 'Out')
# #             ,th(colspan = 2, class="yata_dt_header_false", ' ')
# #          )
# #         ,tr( th('Camera'),th('Counter')
# #             ,th('Amount'),th('Price'),th('Amount'),th('Price'),th('Amount'),th('Price')
# #             ,th('Revenue'),th('Profit'))
# #       )))
# #
#       if (!pnl$loaded) {
#           browser()
#           pnl$loadData()
#           flags$refresh = isolate(!flags$refresh)
#
#           refresh()
#           pnl$loaded = TRUE
#       }
# #       opts = list(sortable=FALSE)
# #       output$tblDetClosed = yataDFOutput(pnl$prepareClosed(), header= headerClosed, opts=opts, type="operation")
# #       output$tblDetExec   = yataDFOutput(pnl$prepareExec(input),   type="operation")
# #
# #       isolate({
# #        observeEvent(input$tblDetClosed_cell_clicked, {
# #            # se generan varios clicks. no se por que
# #           if (length(input$tblDetClosed_cell_clicked) == 0) return()
# #           row = input$tblDetClosed_cell_clicked$row
# #           if (pnl$rowClosed == row) return()
# #           pnl$rowClosed = row
# #           item = as.list(as.list(pnl$data$dfClosed[row,]))
# #           pnlParent$idOper = item$id
# #           # lbl = paste0(item$counter, " (", item$id, ")")
# #           # idl = paste("detail", item$id, sep="_")
# #           # insertTab( "pnlOpType",tabPanel(lbl,value=idl, tags$div(id= sub(id, item$id,full)))
# #           #               ,"oper-hist", position="after", select=TRUE, session=parent)
# #           updateTabsetPanel(parent, "pnlOpType", selected = "oper-detail")
# #        }, ignoreInit = TRUE, ignoreNULL = TRUE)
# #
# #       })
# #
# #       observeEvent(input$chkCancelled, {
# #          output$tblDetExec = yataDFOutput(pnl$prepareExec(input),   type="operation")
# #       }, ignoreInit = TRUE)
# #       observeEvent(input$chkSon, {
# #          output$tblDetExec = yataDFOutput(pnl$prepareExec(input),   type="operation")
# #       }, ignoreInit = TRUE)
#    })
# }
