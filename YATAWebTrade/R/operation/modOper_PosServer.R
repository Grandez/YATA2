modOperPosServer = function(id, full, pnlParent, parent) {
   ns = NS(id)
   ns2 = NS(full)
   PNLPosOper = R6::R6Class("PNL.POS.OPER"
        ,inherit    = YATAPanel
        ,cloneable  = FALSE
        ,lock_class = TRUE
        ,public = list(
            session    = NULL
           ,operations = NULL
           ,cameras    = NULL
           ,plot       = NULL
           ,nextAction = NULL
           ,action     = NULL 
           ,info = list(
                observer = "modebar"
               ,id   = "plotOpen"
               ,ui   = "plotOpen"
               ,plot = "plotOpen"
               ,src  = "price"
               ,ype = "Linear"
           )
           ,valid = FALSE
           ,initialize     = function(id, pnlParent, session) {
               YATAWEB$beg("PNLPosOper init")          
               super$initialize(id, pnlParent, session)
               self$operations = self$factory$getObject("Operation")
               self$session    = self$factory$getObject(self$codes$object$session)
               self$cameras    = self$factory$getObject(self$codes$object$cameras)
               self$loadData()
               self$plot = YATAPlot$new("plotPos", type="Line", scale="date")
               self$vars$layout = c("plotOpen", "data")
               self$data$dfHist = list()
#               private$applyCookies(session)
               YATAWEB$end("PNLPosOper init")          
           }
        ,loadData = function() {
            self$data$lstHist    = list()
            self$data$dfOpen     = self$operations$getOpen()
            self$data$dfPending  = self$operations$getPending()
            self$data$dfAccepted = self$operations$getAccepted()
        }
        ,addHistory = function(sym, df) {
           df$tms = as.Date(df$tms)
           self$data$lstHist[[sym]] = df
           invisible(self)
        }
#        ,selectOperation = function(info, status) {
        ,selectOperation = function(row, status) {            
            # self$action = info$action
            # row = info$row
            
            if (status == 0) private$selected = self$data$dfPending [row, "id"]
            if (status == 1) private$selected = self$data$dfAccepted[row, "id"]
            if (status == 2) private$selected = self$data$dfOpen    [row, "id"]
             
            name = self$codes$xlateStatus(status)
            self$operations$select(private$selected)
            self$cameras$select(self$operations$current$camera)
               
            self$data        = list.merge(self$data, self$operations$current)
            self$data$camera = self$cameras$current
            self$data$names = list()
            self$data$names$camera  = self$cameras$current$name
            self$data$names$base    = YATAWEB$getCTCLabel(self$data$base, "medium")
            self$data$names$counter = YATAWEB$getCTCLabel(self$data$counter, "medium")
            row
         }
        ,getOpenCurrency = function() { self$data$dfOpen[,c("counter", "tms")] }
        ,prepareOpen = function () {
            df = self$data$dfOpen
            df = df[,c("camera", "counter", "amount", "price", "target", "stop", "deadline")]
            colnames(df) = c("camera", "currency", "amount", "price", "target", "stop", "deadline")
            df$value = df$price * df$amount

            last = self$session$getLast()
      
            if (is.null(last)) {
                df = add_column(df, act   = 0, .after = "price")
                df = add_column(df, var   = 0, .after = "act")
            } else {
                dfl = last[,c("symbol", "price")]
                colnames(dfl) = c("currency", "act")
                df = left_join(df, dfl, by="currency")
                df$var = (df$act / df$price) - 1
                df = df[,c("camera", "currency","amount","price", "act", "var", "target", "stop", "deadline")]
            }

            today = Sys.Date()
            df$deadline = today + df$deadline
            df[df$deadline == today, "deadline"] = NA

            labels     = YATAWEB$getCTCLabels(unique(df$currency), type="full")
            df$currency = labels[df$currency]
            cameras = YATAWEB$getCameraNames(unique(df$camera))
            df$camera = cameras[df$camera]
      # df$cost = df$price
      # 
      # for (idx in 1:nrow(df)) {
      #      cc = df[idx, "counter"]
      #      if (!is.null(last[[cc]])) df[idx, "price"] = last[[cc]]$price
      # }
      # df$delta = (df$price / df$cost) - 1
      # df$balance = df$delta * df$cost * df$amount
      # df = df[,c("camera", "counter", "amount", "cost", "price", "delta", "value", "balance")]
            self$data$tblOpen = df
            
             # btns = c( yuiTblButton(full, table, "Close", yuiBtnIconCash())
             #          ,yuiTblButton(full, table, "View", yuiBtnIconView())
             # )
            tblDef = list()
              tblDef$info=list( event=ns2("tableOpen"), target="Open"
#                               , types=list(prc = c("Hour", "Day", "Week", "Month"))
                               ,buttons = list(btnClose=yuiBtnIconCash(), btnView=yuiBtnIconView())
                              )
              tblDef$df = df
            
            tblDef
        }
        ,prepareNotOpen = function (df) {
            df = df[,c("camera", "counter", "amount", "price")]
            colnames(df) = c("camera", "currency", "amount", "price")
            df$value = df$price * df$amount

            labels     = YATAWEB$getCTCLabels(unique(df$currency), type="full")
            df$currency = labels[df$currency]
            cameras = YATAWEB$getCameraNames(unique(df$camera))
            df$camera = cameras[df$camera]
            df
        }

       ,cboReasons   = function(type) { self$makeCombo(self$operations$getReasons(type)) }            
     )
      ,private = list(
          selected = NULL
      )
   )
   
   moduleServer(id, function(input, output, session) {
     YATAWEB$beg("modOper_Pos")
      pnl = YATAWEB$getPanel(full)
      if (is.null(pnl)) pnl = YATAWEB$addPanel(PNLPosOper$new(full, pnlParent, session))

       flags = reactiveValues(
            opClose   = 0
           ,best      = FALSE
           ,history   = 15
           ,refresh   = FALSE
           ,update    = FALSE
           ,plotsBest = FALSE
           ,plotPos   = FALSE
           ,table     = FALSE
           # ,tblBest   = getReactableState("tblBest", "selected")
           # ,tblTop    = getReactableState("tblTop", "selected")
           # ,tblFav   = getReactableState("tblFav", "selected")
           # 
       )
      
       updateLeftSide = function() {
          updCombo("cboUp",   selected = pnl$vars$layout[1])
          updCombo("cboDown", selected = pnl$vars$layout[2])
      }

      refresh = function(reload) {
          pnl$loadData()
          pnl$nextAction = NULL
          YATAFormClose()
          loadHistory()
          renderData()
      }       
      renderPlot = function(df, symbol) {
         if (!is.data.frame(df)) {
             message("ha ido mal 3")
             return()
         }
         output$plotOpen = pnl$plot$addData(df, symbol, "plotOpen")$render("plotOpen")
         # browser()
         # output$plotOpen = updPlot(pnl$plot, "plotOpen") # %>% event_register("plotly_legendclick") %>%
      }
      
       ###########################################################
       ### Reactives
       ###########################################################

       observeEvent(flags$opClose, ignoreInit = TRUE, {
          pnl$data$type = pnl$codes$oper$close
          pnl$vars$nextAction = pnl$codes$status$closed
          pnl$data$reasons = pnl$cboReasons(DBParms$reasons$close)
          pnl$data$act     = pnl$data$tblOpen[flags$opClose, "act"]
#          pnl$action       = "close"
          data = yuiFormUI(ns2("form"), "OperClose", data=pnl$data)
          output$form = renderUI({data})
          formChangeInit()
       })
      
      observeEvent(input$tableOpen, {
          if (!str_starts(input$tableOpen$colName, "btn")) return()
          row = pnl$selectOperation(input$tableOpen$row, pnl$codes$status$executed)
          if (input$tableOpen$colName == "btnClose") flags$opClose = isolate(row)
          if (input$tableOpen$colName == "btnView")  flags$opView  = isolate(!flags$opView)
      })

#       renderPlot = function(symbol) { 
#           if (missing(symbol)) {
#               return (NULL)
#           }
#           df = pnl$data$lstHist[[symbol]]
#           df = df[,c("tms", "close")]#
#           colnames(df) = c("Date", symbol)
#           pnl$plot = pnl$plot %>% yataPlotLine(df)
#           #(data=df, x=df[,1],y=df[,2],type="scatter", mode="lines", name=symbol)
#           output$plotOpen = updPlot(pnl$plot %>% event_register("plotly_legendclick") %>%
#       event_register("plotly_legenddoubleclick")
# , "plotOpen")
#       }
      ######################################################
      ### REST                                          ###
      #####################################################
# Los eventos aqui                  
# https://plotly-r.com/linking-views-with-shiny.html#shiny-plotly-inputs                  

       getHistorical = function(symbol,since) {
           id = YATAWEB$getCTCID(symbol)
           if (id == 0) return()
           to = Sys.Date()
           from = since - as.difftime(7, unit="days")
#           YATAWEB$log("hist: %d - %s - %s", id,from,to)
           df = restdfsync("hist",id=id,from=from,to=to)
           renderPlot(restdfsync("hist",id=id,from=from,to=to), symbol)
           # restdf("hist",id=id,from=from,to=to) %>%
           #        then( renderPlot(df)
           #             ,function(err)    {
           #                YATAWEB$log("hist resp: %d - %s - %s", id,from,to)
           #                browser()
           #                message("ha ido mal 3") ; message(err)
           #            })
        }
      
      renderOpen = function(table) {

         if (nrow(pnl$data$dfOpen) == 0) return() 
          makejs = function(table) {
             stmt = paste0( "function(rowInfo, colInfo) { "
                           ,"yataTableclick('", ns2(table), "', rowInfo, colInfo)}" )
             JS(stmt) 
          }
          data = pnl$prepareOpen()
          
             table = "open"
             btns = c( yuiTblButton(full, table, "Close", yuiBtnIconCash())
                      ,yuiTblButton(full, table, "View", yuiBtnIconView())
             )
#             dfb = yataDTButtons(df, btns)

             # opts = list(sortable=FALSE
             #     
             #     ,types = list(dat = c("Deadline"), prc = c("Var"), btn=c(ncol(dfb)))
             #    ,color = list( var = c("Var")
             #                  ,date = c("Deadline")
             #                   )
             # )
             # df2 = cbind(df, close=NA, view=NA)
             # 
             # cols = list(
             #      close = colDef(name="", sortable=FALSE, cell = function() yuiBtnIconCash("Close"))
             #     ,view  = colDef(name="", sortable=FALSE, cell = function() yuiBtnIconView("View"))
             # )
             #              stmt = paste0( "function(rowInfo, colInfo) { "
             #               ,"yataclick('", ns(table), "', rowInfo, colInfo)}" )
             #  stmt = paste0("function(rowInfo, colInfo) { alert('Pulsado'); };")
             #  stmt = paste0("function(rowInfo, colInfo) {",
             #      "window.alert('Details for row ' + rowInfo.index + ':\\n' + JSON.stringify(rowInfo.row, null, 2))",
             #      "};"
             #      )


#             output$tblOpen = renderReactable(reactable(df2, columns=cols, onClick=makejs("btnTableOpen")

             output$tblOpen = updTable(data) 
                 # , onClick=JS("function(rowInfo, colInfo) {
                 #                  window.alert('Details for row ' + rowInfo.index + ':\\n'
                 #                 + JSON.stringify(rowInfo.row, null, 2))
                 #              }"
                 #  )
             #))
      }
      renderPending = function() {
         if (nrow(pnl$data$dfPending) == 0) {
             output$tblPending = NULL
             return()
         }
         df = pnl$prepareNotOpen(pnl$data$dfPending)

         shinyjs::toggle(ns("opPending"))
         table = "pending"
             btns = c(  yuiTblButton(full, table, "Accept",   yuiBtnIconOK())
                       ,yuiTblButton(full, table, "Rejected", yuiBtnIconRefuse())
                       ,yuiTblButton(full, table, "Cancel",   yuiBtnIconDel()))
             df = yataDTButtons(df, btns)
             output$tblPending = yataDFOutput({df}, type='operation')
         
      }
      renderAccepted = function() {
         if (nrow(pnl$data$dfAccepted) == 0) {
             output$tblAccepted = NULL
             return()
         }
         df = pnl$prepareNotOpen(pnl$data$dfAccepted)

         shinyjs::toggle(ns("opAccepted"))
         table = "accepted"
         btns = c(yuiTblButton(full, table, "Executed", yuiBtnIconCloud("Executed")))
         df = yataDTButtons(df, btns)
         output$tblAccepted = yataDFOutput({df}, type='operation')
      } 
     showBoxes = function() {
         .show = function(cond, obj) {if (cond) shinyjs::show(obj) else shinyjs::hide(obj) }
         .show(nrow(pnl$data$dfOpen)     == 0, "noOpen")
         .show(nrow(pnl$data$dfPending)  == 0, "noPending")
         .show(nrow(pnl$data$dfAccepted) == 0, "noAccepted")
         .show(nrow(pnl$data$dfPending)  == 0 && nrow(pnl$data$dfAccepted) == 0, "divPend")
     } 
     renderData = function() {
        renderOpen()
        showBoxes() 
        renderPending()
        renderAccepted()
     }
     loadHistory = function() {
         df = pnl$getOpenCurrency()
        if (nrow(df) > 0) lapply(1:nrow(df), function(x) getHistorical(df[x,1], df[x,2]))
     }
      if (!pnl$loaded) updateLeftSide()
      if (!pnl$loaded || !pnl$parent$valid) {
          refresh(TRUE)
          pnl$loaded = TRUE
          pnl$parent$valid = TRUE
      }

#       loadPosition   = function() { 
#          df = pnl$operations$getOpen()
#          if (nrow(df) > 0) {
#              pnl$data$dfOpen = df
#              dfo   = prepareOpen(df, pnl)
#              dfi = df[,c("counter", "tms")]
# 
# #             shinyjs::toggle(ns("opOpen"))
#              table = "open"
#              btns = c( yuiTblButton(full, table, "Close", yuiBtnIconCash())
#                       ,yuiTblButton(full, table, "View", yuiBtnIconView())
#              )
#              dfb = yataDTButtons(dfo, btns)
#              types = list(dat = c("deadline"), prc = c("var"))
# 
#              output$tblOpen = yataDFOutput(dfb, types=types,colorize=c("var"), type="operation")  # yataDFOutput({df}, type='operation')
#              for (row in 1:nrow(dfi)) getHistorical(dfi[row,1], dfi[row,2])
#              
#       # types = list(dat = c("since"), prc = c("day", "week", "month"))
#       # df =  df %>% select(currency,balance, priceBuy, priceSell, price, day, week, month, since)
#       # df$since = as.Date(df$since)
#       # colnames(df) = c("currency", "balance", "cost", "return", "net", "day", "week", "month", "since")
#       # yataDT(df,types=types,colorize=c("day", "week", "month"))
#       # 
#       #              
#          }
#          
#          df = pnl$operations$getPending()
#          if (nrow(df) > 0) {
#              shinyjs::toggle(ns("opPending"))
#              table = "pending"
#              btns = c(  yuiTblButton(full, table, "Accept",   yuiBtnIconOK())
#                        ,yuiTblButton(full, table, "Rejected", yuiBtnIconRefuse())
#                        ,yuiTblButton(full, table, "Cancel",   yuiBtnIconDel())
#              )
#              df = yataDTButtons(df, btns)
#              output$tblPending = yataDFOutput({df}, type='operation')
#          }
# 
#          df = pnl$operations$getAccepted()
#          if (nrow(df) > 0) {
#              shinyjs::toggle(ns("opAccepted"))
#              table = "accepted"
#              btns = c(yuiTblButton(full, table, "Executed", yuiBtnIconCloud("Executed")))
#              df = yataDTButtons(df, btns)
#              output$tblAccepted = yataDFOutput({df}, type='operation')
#          }
# 
#          pnl$valid = TRUE
#       }
      formChangeInit = function() {
         title = ""
         if (pnl$vars$nextAction == pnl$codes$status$accepted) title = YATAWEB$MSG$title("OPER.ACCEPT")
         if (pnl$vars$nextAction == pnl$codes$status$executed) title = YATAWEB$MSG$title("OPER.EXECUTE")
         if (pnl$vars$nextAction == pnl$codes$status$rejected) title = YATAWEB$MSG$title("OPER.REJECT")
         if (pnl$vars$nextAction == pnl$codes$status$closed)   title = YATAWEB$MSG$title("OPER.CLOSE")
         
         output$formLblOper    = updLabelText( title )
         output$formLblCamera  = updLabelText( pnl$data$names$camera  )
         output$formLblBase    = updLabelText( pnl$data$names$base    )
         output$formLblCounter = updLabelText( pnl$data$names$counter )

         updNumericInput("ImpAmount", value=pnl$data$amount) 
         if (pnl$vars$nextAction == pnl$codes$status$closed) {
             updNumericInput("formImpPrice",  value=pnl$data$act) 
             updateSelectInput(session=session, inputId="formcboReasons", choices = pnl$cboReasons(DBParms$reasons$close), selected=0)
         } else {
           updNumericInput("ImpPrice",  value=pnl$data$price)     
         }
                  
      }
# output$click <- renderPrint({
#     event_data("plotly_legendclick")
#   })

  # output$doubleclick <- renderPrint({
  #   event_data("plotly_legenddoubleclick")
  # })      
  #     observe({
  #         browser()
  #         res = event_data("plotly_legendclick")
  #         browser()
  #     })
  #     observe({
  #         browser()
  #         res = event_data("plotly_afterplot")
  #         browser()
  #     })
      observeEvent(input$btnTablePending, {
          YATAWEB$beg("Table Pending")
          pnl$selectOperation(input$btnTablePending, pnl$codes$status$pending)
          if (pnl$action == "accept") {
              pnl$vars$nextAction = pnl$codes$status$accepted
              data = yuiFormUI(ns2("form"), "OperChange", data=pnl$data)
              output$form = renderUI({data})
              formChangeInit()
          }
          if (pnl$action == "cancel") {
              pnl$vars$nextAction = pnl$codes$status$cancelled
              data = yuiFormUI(ns2("form"), "OperCancel", data=pnl$data)
              output$form = renderUI({data})
              formChangeInit()
              output$formLblAmount = updLabelNumber(pnl$data$amount)
              output$formLblPrice  = updLabelNumber(pnl$data$price)
          }
          if (pnl$action == "rejected") {
              pnl$vars$nextAction = pnl$codes$status$rejected
              data = yuiFormUI(ns2("form"), "OperReject", data=pnl$data)
              output$form = renderUI({data})
              formChangeInit()
          }
          YATAWEB$end("Table Pending")
      }, ignoreInit = TRUE, ignoreNULL = TRUE)
       observeEvent(input$btnTableAccepted, {
          YATAWEB$beg("Table Accepted")
          pnl$selectOperation(input$btnTableAccepted, pnl$codes$status$accepted)
          pnl$vars$nextAction = pnl$codes$status$executed
          data = yuiFormUI(ns2("form"), "OperChange", data=pnl$data)
          output$form = renderUI({data})
          formChangeInit()
          YATAWEB$end("Table Accepted")
       }, ignoreInit = TRUE, ignoreNULL = TRUE)
       observeEvent(input$btnTableOpen, {
          row = pnl$selectOperation(input$btnTableOpen, pnl$codes$status$executed)
          if (pnl$action == "close") {
              pnl$data$type = pnl$codes$oper$close
              pnl$vars$nextAction = pnl$codes$status$closed
              pnl$data$reasons = pnl$cboReasons(DBParms$reasons$close)
              pnl$data$act     = pnl$data$tblOpen[row, "act"]
              data = yuiFormUI(ns2("form"), "OperClose", data=pnl$data)
              output$form = renderUI({data})
              formChangeInit()
          }
          if (pnl$action == "view") {
              lbl = paste(pnl$data$base, pnl$data$counter, sep="/")
              id = paste(ns2("detail"), pnl$data$id, sep="_")
              insertTab( "pnlOpType",tabPanel(lbl,value=id, YATAModule("oper-detail",lbl, mod="OperDetail"))
                        ,"oper-hist", position="after", select=TRUE, session=parent)
          }
          
       }, ignoreInit = TRUE, ignoreNULL = TRUE)

       observeEvent(input$btnTable, {
         browser()
          # me devuelve: tabla - operacion - fila
          data = strsplit(toLower(input$btnTable), "-")[[1]]
      #   showModal(modalDialog(
      #   title = "Important message",
      #   "This is an important message!"
      # ))
        
        id = pnl$getOperationID(data[1], as.integer(data[3]))

      # selectedRow <- as.numeric(strsplit(input$select_button, "_")[[1]][2])
      # myValue$employee <<- paste('click on ',df$data[selectedRow,1])
    })
      ##############################################
      # Modales
      # El mismo boton para todos
      ##############################################
      observeEvent(input$operBtnOK, {
          if (pnl$vars$nextAction == pnl$codes$status$accepted) {
              pnl$operations$accept( price  = input$formImpPrice
                                    ,amount = input$formImpAmount
                                    ,fee    = 0
                                    ,id     = pnl$data$id
              )
          }
          if (pnl$vars$nextAction == pnl$codes$status$cancelled) {
              pnl$operations$cancel( delete = input$formSwDelete, id = pnl$data$id)
          }
          if (pnl$vars$nextAction == pnl$codes$status$executed) {
              pnl$operations$execute(gas = 0, id = pnl$data$id)
              pnl$invalidate(panel$pos)
          }
          # pnl$codes$oper$close
          # if (pnl$action %in% c("cancel", "rejected") ) {
          #     cmt = trimws(input$formComment)
          #     cmt2 = NULL
          #     if (nchar(cmt) > 0) cmt2 = cmt
          #     pnl$operations$reject(comment=cmt2, id=pnl$data$id)
          # }
          if (pnl$vars$nextAction == pnl$codes$status$closed) {
              pnl$operations$close( id      = pnl$data$id
                                   ,amount  = input$formImpAmount
                                   ,price   = input$formImpPrice
                                   ,reason  = input$formcboReason
                                   ,comment = input$formcomment
                                   ,rank    = input$formSlRank)
          }
          refresh(TRUE)
      }, ignoreInit = TRUE, ignoreNULL = TRUE)
      # Los botones van prefijados
      observeEvent(input$operBtnKO, { refresh(FALSE) }, ignoreInit = TRUE, ignoreNULL = TRUE)

      observeEvent(input$btnAdd, {
          # updateTabsetPanel(session = parent, inputId = "pnlOpType", selected = "Operar")
          insertTab("pnlOpType",tabPanel("Prueba2",     value="prueba", h3("Un tab")),"oper-detail", position="after", session=parent)
      }, ignoreInit = TRUE, ignoreNULL = TRUE)

     #################################################
     ### Panel Izquierdo
     #################################################
    
      observeEvent(input$cboUp, {
         session$sendCustomMessage('yataShowBlock',list(ns=full,row=1,col=0,block=input$cboUp))
      }, ignoreNULL = TRUE)
      observeEvent(input$cboDown, {
         session$sendCustomMessage('yataShowBlock',list(ns=full,row=2,col=0,block=input$cboDown))
      }, ignoreNULL = TRUE)

     YATAWEB$end("modOper_Pos")
          
  })
}

