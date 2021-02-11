function(input, output, session) {
   output$appTitle <- renderText({ 
      name = YATAFactory$getDBName()
      if (is.null(name)) name = "Sin conexion"
      paste("YATA", name, sep = "-")
   })
   observeEvent(input$mainMenu,{
        eval(parse(text=paste0("mod", titleCase(input$mainMenu), "Server(input$mainMenu, '')")))
    })
}
