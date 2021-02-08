modOperPosServer = function(id, full, pnl) {
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
#      loadPosition   = function(input, output, session) {
      loadPosition   = function() {          
         df = pnl$loadOperations(YATACodes$status$pending)
         if (nrow(df) > 0) {
             df = prepareTable(df)
             table = "pending"
             output$tblPending = yataRenderTable(df, 
                                       buttons= c( yataTblButton(full, table, "Accept", yataBtnIconOK())
                                                  ,yataTblButton(full, table, "Rejected", yataBtnIconRefuse())
                                                  ,yataTblButton(full, table, "Cancel", yataBtnIconDel())
                                                   )
                 )
         }
         df = pnl$loadOperations(YATACodes$status$accepted)
         if (nrow(df) > 0) {
             table = "accepted"
             df = prepareTable(df)
             output$tblAccepted = yataRenderTable(id=ns("accepted"), df, 
                                                  c( yataTblButton(full, table, "Executed", yataBtnIconCloud("Executed"))))
         }
         
         df = pnl$loadOperations(YATACodes$status$executed)
         if (nrow(df) > 0) {
             table = "executed"
             df = prepareTable(df)
             output$tblExecuted = yataRenderTable(id=ns("executed"), df, 
                                                  c( yataTblButton(full, "Executed", "Close", yataBtnIconOK())))
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
         
         output$changeLblOper = renderText({ paste(title, "operacion") })
         
         output$changeLblCamera  = renderText({ pnl$data$camera })
         output$changeLblBase    = renderText({ pnl$data$base })
         output$changeLblCounter = renderText({ pnl$data$counter })
         
      }
      
      if (!pnl$valid) loadPosition() #input, output, session)
      observeEvent(input$btnTablePending, {
          selectOperation(input$btnTablePending, YATACodes$status$pending)
          if (pnl$action == "accept") {
              pnl$vars$nextAction = YATACodes$status$accepted
              data = YATAFormUI(ns2("form"), "OperChange", data=pnl$data)
              output$form = renderUI({data})
              formChangeInit()
          }
          if (pnl$action == "cancel") {
              pnl$vars$nextAction = YATACodes$status$cancelled
              data = YATAFormUI(ns2("form"), "OperCancel", data=pnl$data)
              output$form = renderUI({data})
          }
          if (pnl$action == "rejected") {
              pnl$vars$nextAction = YATACodes$status$rejected
              data = YATAFormUI(ns2("form"), "OperReject", data=pnl$data)
              output$form = renderUI({data})
          }
      })
       observeEvent(input$btnTableAccepted, {
          selectOperation(input$btnTableAccepted, YATACodes$status$accepted)
          pnl$vars$nextAction = YATACodes$status$executed
          data = YATAFormUI(ns2("form"), "OperChange", data=pnl$data)
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
      observeEvent(input$formBtnOK, {
          browser()
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

