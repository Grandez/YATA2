
function(input, output, session) {
    output$appTitle = renderText({"YATA - Config"})
    observeEvent(input$mainMenu,{
        if (input$mainMenu == "parms")  modParmsServer      (input$mainMenu, "")  
        if (input$mainMenu == "data")   modDataServer       (input$mainMenu, "")
        if (input$mainMenu == "camera") modCamerasServer    (input$mainMenu, "")
        if (input$mainMenu == "ctc")    modCurrenciesServer (input$mainMenu, "")
        if (input$mainMenu == "prov")   modProvidersServer  (input$mainMenu, "")
    })
}
