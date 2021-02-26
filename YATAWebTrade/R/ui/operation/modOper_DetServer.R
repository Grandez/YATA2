modOperDetailServer = function(id, full, pnl) {
   ns = NS(id)
   ns2 = NS(full)
   validate = function() {
    
   }
   moduleServer(id, function(input, output, session) {
      prepareTable   = function (df) {
         data       = pnl$cameras$getCameras()
         df$camera  = data[data$id == df$camera,"name"]
         data       = pnl$currencies$getNames(df$base)
         df$base    = data[data$id == df$base,"name"]
         data       = pnl$currencies$getNames(df$counter, full=TRUE)
         df$counter = data[data$id == df$counter,"name"]
         df
      }
      loadPosition   = function() { 
         data = FALSE
         df = pnl$loadOperations(YATACodes$status$pending)
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
         
         df = pnl$loadOperations(YATACodes$status$accepted)
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
         df = pnl$loadOperations(YATACodes$status$executed)
         shinyjs::hide("opExecuted")
         btns = NULL         

         if (nrow(df) > 0) {
             data = TRUE
             shinyjs::show("opExecuted")
             table = "executed"
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
         if (pnl$vars$nextAction == YATACodes$status$accepted) title = "Aceptar"
         if (pnl$vars$nextAction == YATACodes$status$executed) title = "Ejecutar"
         if (pnl$vars$nextAction == YATACodes$status$rejected) title = "Rechazar"
         if (pnl$vars$nextAction == YATACodes$status$closed)   title = "Cerrar"
         
         output$formLblOper    = updLabelText( paste(title, "operacion") )
         output$formLblCamera  = updLabelText( pnl$data$cameraName  )
         output$formLblBase    = updLabelText( pnl$data$baseName    )
         output$formLblCounter = updLabelText( pnl$data$counterName )
         
      }
      
      # if (!pnl$valid) loadPosition() #input, output, session)
      observeEvent(input$btnTablePending, {
          selectOperation(input$btnTablePending, YATACodes$status$pending)
          if (pnl$action == "accept") {
              pnl$vars$nextAction = YATACodes$status$accepted
              data = yuiFormUI(ns2("form"), "OperChange", data=pnl$data)
              output$form = renderUI({data})
              formChangeInit()
          }
          if (pnl$action == "cancel") {
              pnl$vars$nextAction = YATACodes$status$cancelled
              data = yuiFormUI(ns2("form"), "OperCancel", data=pnl$data)
              output$form = renderUI({data})
          }
          if (pnl$action == "rejected") {
              pnl$vars$nextAction = YATACodes$status$rejected
              data = yuiFormUI(ns2("form"), "OperReject", data=pnl$data)
              output$form = renderUI({data})
          }
      })
       observeEvent(input$btnTableAccepted, {
          selectOperation(input$btnTableAccepted, YATACodes$status$accepted)
          pnl$vars$nextAction = YATACodes$status$executed
          data = yuiFormUI(ns2("form"), "OperChange", data=pnl$data)
          output$form = renderUI({data})
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
          if (pnl$vars$nextAction == YATACodes$status$accepted) {
              pnl$operations$accept( price  = input$formImpPrice
                                    ,amount = input$formImpAmount
                                    ,fee    = 0
                                    ,id     = pnl$data$id
              )
          }
          if (pnl$vars$nextAction == YATACodes$status$cancelled) {
              pnl$operations$cancel( delete = input$formSwDelete, id = pnl$data$id)
          }
          if (pnl$vars$nextAction == YATACodes$status$executed) {
              pnl$operations$execute(gas = 0, id = pnl$data$id)
          }
          if (pnl$action %in% c("cancel", "rejected") ) {
              cmt = trimws(input$formComment)
              cmt2 = NULL
              if (nchar(cmt) > 0) cmt2 = cmt
              pnl$operations$reject(comment=cmt2, id=pnl$data$id)
          }
          YATAFormClose()
          loadPosition()
      })
      observeEvent(input$formBtnKO, {
          pnl$nextAction = NULL
          YATAFormClose()
      })
      # observeEvent(input$BtnOK, {
      #     browser()
      # })
      
    #   updateSelectInput(session, "cboCamera",    choices=pnl$cboClearings())
    #   updateSelectInput(session, "cboCounter",   choices=pnl$cboCurrency())
    #   observeEvent(input$cboCamera, {
    #      pnl$selectClearing(input$cboCamera)
    #      # updateSelectInput(session, "cboTo",       choices=pnl$cboClearings(input$cboFrom))
    #      updateSelectInput(session, "cbofull", choices=pnl$cboCurrency(input$cboCamera, TRUE))
    # 
    #   }, ignoreInit = TRUE)
    # 
    loadPosition()
  })
}

