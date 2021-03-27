modOperPosServer = function(id, full, pnl, parent) {
   ns = NS(id)
   ns2 = NS(full)
   validate = function() {
    
   }
   moduleServer(id, function(input, output, session) {
      loadPosition   = function() { 
         data = FALSE
         df = pnl$loadOperations(pnl$codes$status$pending)
         shinyjs::hide("opPending")
         btns = NULL
         if (nrow(df) > 0) {
             data = TRUE
             shinyjs::show(ns("opPending"))
             df = prepareTable(df)
             table = "pending"
             btns = c(  yuiTblButton(full, table, "Accept",   yuiBtnIconOK())
                       ,yuiTblButton(full, table, "Rejected", yuiBtnIconRefuse())
                       ,yuiTblButton(full, table, "Cancel",   yuiBtnIconDel())
             )
         }
         output$tblPending = updTableOperations(df, buttons=btns)
         
         df = pnl$loadOperations(pnl$codes$status$accepted)
         shinyjs::hide("opAccepted")
         btns = NULL         
         if (nrow(df) > 0) {
             data = TRUE
             shinyjs::show("opAccepted")
             table = "accepted"
             df = prepareTable(df)
             btns = c(yuiTblButton(full, table, "Executed", yuiBtnIconCloud("Executed")))
         }
         output$tblAccepted = updTableOperations(df, buttons=btns)

         shinyjs::hide("opExecuted")
         btns = NULL         
         df = pnl$loadOperations(pnl$codes$status$executed)
         df = prepareOpen(df, pnl)

         if (nrow(df) > 0) {
             data = TRUE
             table = "open"
             btns = c( yuiTblButton(full, table, "Close", yuiBtnIconCash())
                      ,yuiTblButton(full, table, "View", yuiBtnIconView())
             )
         }

         output$tblOpen = updTableOperations(df, buttons=btns)
         pnl$valid = TRUE
      }
      selectOperation = function(row, status) {
          # me devuelve: operacion - fila
          data = strsplit(toLower(row), "-")[[1]]
          pnl$action = data[1]
          index = as.integer(data[2])
          pnl$selectOperation(status, index)
      }
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
         updNumericInput("ImpPrice",  value=pnl$data$price) 
         if (pnl$vars$nextAction == pnl$codes$status$closed) {
#             updateSelectInput(session=session, inputId="formcboReasons", choices = pnl$cboReasons(DBParms$reasons$close), selected=0)
         }
                  
      }
      
      observeEvent(input$btnTablePending, {
          if (pnl$vars$inForm) return()
          pnl$vars$inForm  = TRUE
          pnl$vars$inEvent = FALSE
          selectOperation(input$btnTablePending, pnl$codes$status$pending)
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
      })
       observeEvent(input$btnTableAccepted, {
          if (pnl$vars$inForm) return()           
          pnl$vars$inForm  = TRUE 
          pnl$vars$inEvent = FALSE
          selectOperation(input$btnTableAccepted, pnl$codes$status$accepted)
          pnl$vars$nextAction = pnl$codes$status$executed
          data = yuiFormUI(ns2("form"), "OperChange", data=pnl$data)
          output$form = renderUI({data})
          formChangeInit()
       })
       observeEvent(input$btnTableOpen, {
          if (pnl$vars$inForm) return()           
          pnl$vars$inForm = TRUE 
          pnl$vars$inEvent = FALSE
          selectOperation(input$btnTableOpen, pnl$codes$status$executed)
          if (pnl$action == "close") {
              pnl$data$type = pnl$codes$oper$close
              pnl$vars$nextAction = pnl$codes$status$closed
              pnl$data$reasons = pnl$cboReasons(DBParms$reasons$close)
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
          
       })

       observeEvent(input$btnTable, {
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
      ##############################################
      observeEvent(input$btnOK, {
         pnl$vars$inEvent = !pnl$vars$inEvent
         if (!pnl$vars$inEvent) {
             pnl$vars$inEvent = !pnl$vars$inEvent
             return()
         }

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
              pnl$getRoot()$invalidate(panels$pos)
          }
          if (pnl$action %in% c("cancel", "rejected") ) {
              cmt = trimws(input$formComment)
              cmt2 = NULL
              if (nchar(cmt) > 0) cmt2 = cmt
              pnl$operations$reject(comment=cmt2, id=pnl$data$id)
          }
          if (pnl$vars$nextAction == pnl$codes$status$closed) {
              pnl$operations$close( id      = pnl$data$id
                                   ,amount  = input$formImpAmount
                                   ,price   = input$formImpPrice
                                   ,reason  = input$formcboReason
                                   ,comment = input$formcomment
                                   ,rank    = input$formSlRank)
          }
          pnl$vars$inForm = YATAFormClose()
          loadPosition()
          pnl$vars$nextAction = 0 # Parece que a veces lanza 2 triggers
      })
      observeEvent(input$formBtnKO, {
          pnl$nextAction = NULL
          pnl$vars$inForm = YATAFormClose()
      })

      observeEvent(input$btnAdd, {
          # updateTabsetPanel(session = parent, inputId = "pnlOpType", selected = "Operar")
          insertTab("pnlOpType",tabPanel("Prueba2",     value="prueba", h3("Un tab")),"oper-detail", position="after", session=parent)
      })
    loadPosition()
  })
}

