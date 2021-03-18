modParmsGralServer = function(id, full, pnl) {
   ns = NS(id)
   old = list()
   moduleServer(id, function(input, output, session) {
      if (is.null(pnl)) pnl = YATAWEB$addPanel(PNLGral$new(id))
       loadData = function() {
           pnl$oldGral$Plugins   = pnl$parms$pluginsDirectory() 
           pnl$oldGral$defaultDB = pnl$parms$getDefaultDbId()
           pnl$oldGral$autoOpen  = pnl$parms$autoConnect()
           pnl$oldGral$alert     = pnl$parms$getAlertDays()

          updateTextInput   (session, "txtPlugins", value = pnl$oldGral$Plugins)
          updateSwitchInput (session, "swAutoOpen", value = pnl$oldGral$autoOpen)
          updateNumericInput(session, "intAlert",   value = pnl$oldGral$alert)
          updateSelectInput (session, "cboDB",      choices=pnl$makeCombo(pnl$dbNames)
                                                  , selected=pnl$oldGral$defaultDB)
       }
       loadData()
       observeEvent(input$btnOK, {
           changes = list()
           if (is.null(pnl$oldGral$Plugins)   || input$txtPlugins != pnl$oldGral$Plugins  ) changes$Plugins   = input$txtPlugins
           if (is.null(pnl$oldGral$defaultDB) || input$cboDB      != pnl$oldGral$defaultDB) changes$defaultDB = input$cboDB
           if (is.null(pnl$oldGral$autoOpen)  || input$swAutoOpen != pnl$oldGral$autoOpen ) changes$autoOpen  = input$swAutoOpen
           if (is.null(pnl$oldGral$alert)     || input$intAlert   != pnl$oldGral$alert    ) changes$alert     = input$intAlert
           if (length(changes) > 0) {
               browser()
               pnl$parms$updateParmsBulk(changes)
           }
       })
       observeEvent(input$btnEsc, { loadData() })
       
  })
}

