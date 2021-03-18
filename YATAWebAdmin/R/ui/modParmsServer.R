modParmsServer = function(id, full) {
   ns = NS(id)
   PNLParms = R6::R6Class("PNL.PARMS"
        ,inherit    = YATAPanel
        ,cloneable  = FALSE
        ,lock_class = TRUE
        ,public = list(
            parms = NULL
           ,dbNames = NULL     
           ,oldGral = list()
           ,initialize     = function(id, session) {
               super$initialize(id, session)
               self$parms = YATAFactory$getParms()
               self$getDBNames()
           }
          ,getDBNames = function () {
              self$dbNames = self$parms$getDBNames()
          }
        )
       ,private = list(
           
       )
    )
   
   moduleServer(id, function(input, output, session) {
      pnl = YATAWEB$panel(id)
      if (is.null(pnl)) pnl = YATAWEB$addPanel(PNLParms$new(id, session))

      observeEvent(input$pnlType, {
            act = yataActiveNS(input$pnlType)
#            gralServer("tab1", input$subtab3) # modTab31Server("tab1", input$subtab3)
            #mod = strsplit(input$pnlOpType, "-")[[1]][2]
            module = paste0("modParms", titleCase(act),"Server")
            eval(parse(text=paste0(module, "(act, input$pnlType, pnl)")))
        })

  })
}

