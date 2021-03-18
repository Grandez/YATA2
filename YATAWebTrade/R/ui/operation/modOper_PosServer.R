modOperPosServer = function(id, full, pnl) {
   ns = NS(id)
   ns2 = NS(full)
   validate = function() {
    
   }
   moduleServer(id, function(input, output, session) {
      prepareTable   = function (df) {
          asList = function(data) {
             labels = data$name
             names(labels) = data$id
             labels
          }
         labels     = asList(pnl$cameras$getCameras())
         df$camera  = labels[df$camera]
         labels     = asList(pnl$currencies$getNames(df$base))
         df$base    = labels[df$base]
         labels     = asList(pnl$currencies$getNames(df$counter))
         df$counter = labels[df$counter]
         df
      }
      prepareTableOpen = function (df) {
         if (nrow(df) == 0) return(df)
         last = pnl$getRoot()$getLatestSession()
         df$cost = df$price

         for (idx in 1:nrow(df)) {
             cc = df[idx, "counter"]
             if (!is.null(last[[cc]])) df[idx, "price"] = last[[cc]]$last
         }
         df$delta = (df$price / df$cost) - 1
         df$balance = df$delta * df$cost * df$amount
         df = df[,c("camera", "base", "counter", "amount", "cost", "price", "delta", "value", "balance")]
         yataSetClasses(df, prc=c(7), imp=c(4,5,6,8,9))
      }
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
         df = prepareTableOpen(df)

         if (nrow(df) > 0) {
             data = TRUE
             shinyjs::show("opOpen")
             table = "open"
             df = prepareTable(df)
             btns = c( yuiTblButton(full, table, "Close", yuiBtnIconCash())
                      ,yuiTblButton(full, table, "View", yuiBtnIconView())
             )
         }

         output$tblOpen = updTableOperations(df, buttons=btns)
         if (data) {
             hide("nodata")
             show("data")
         } else {
             hide("data")
             show("nodata")
         }
         
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
         output$formLblCounter = updLabelText( pnl$data$names$counte  )

         updNumericInput("ImpAmount", value=pnl$data$amount) 
         updNumericInput("ImpPrice",  value=pnl$data$price) 
         if (pnl$vars$nextAction == pnl$codes$status$closed) {
#             updateSelectInput(session=session, inputId="formcboReasons", choices = pnl$cboReasons(DBParms$reasons$close), selected=0)
         }
                  
      }
      
      # if (!pnl$valid) loadPosition() #input, output, session)
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

    loadPosition()
  })
}

