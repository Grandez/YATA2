function(input, output, session) {
#    window_height <- JS('window.innerHeight')
# window_width <- JS('window.innerWidth')
   output$appTitle <- renderText({ 
      name = YATAFactory$getDBName()
      if (is.null(name)) name = "Sin conexion"
      paste("YATA", name, sep = "-")
   })
   observeEvent(input$mainMenu,{
        data = eval(parse(text=paste0("mod", titleCase(input$mainMenu), "Server('", input$mainMenu, "', '')")))
    })
}
