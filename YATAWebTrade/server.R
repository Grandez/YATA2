function(input, output, session) {
   output$appTitle <- renderText({ 
      name = YATAFactory$getDBName()
      if (is.null(name)) name = "Sin conexion"
      paste("YATA", name, sep = "-")
   })
   observeEvent(input$mainMenu,{
        if (input$mainMenu == pnl$pos)    modPositionServer(input$mainMenu, "")
        if (input$mainMenu == pnl$oper)   modOperServer    (input$mainMenu, "")
        if (input$mainMenu == pnl$config) modConfigServer  (input$mainMenu, "")
    })
}
