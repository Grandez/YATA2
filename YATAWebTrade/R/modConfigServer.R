# Cada modulo lleva asociado un objeto
# es el que gestiona la creacion del objeto y guarda sus variables

modConfigServer <- function(id, full, pnlParent, invalidate=FALSE, parent=NULL) {
   ns = NS(id)
   PNLCfg = R6::R6Class("PNL.CONFIG"
        ,inherit = YATAPanel
        ,cloneable  = FALSE
        ,lock_class = TRUE
        ,public = list(
            data         = NULL
           ,currentDB = NULL
           ,initialize     = function(id, pnlParent, session) {
               super$initialize(id, pnlParent, session)
               private$parms = YATAFactory$getParms() 
               private$databases = private$parms$getDBNames()
               self$updateDB()
           }
           ,cboDB   = function() {
              data = private$databases
              data$id = data$name
              if (!is.null(self$currentDB)) data = data[!(data$name %in% self$currentDB),]
              private$asCombo(data)
           }
          ,updateDB = function() {
               db = YATAFactory$getDB()
               if (!is.null(db)) self$currentDB = db$name
          }    

        )
       ,private = list(
           parms = NULL
          
          ,databases = NULL
          ,selected = NULL
       )
    )
    moduleServer(id, function(input, output, session) {
        message("Ejecutando server para Config")
        pnl = YATAWEB$getPanel(id)
        if (is.null(pnl)) pnl = YATAWEB$addPanel(PNLCfg$new(id, pnlParent, session))
        loadPage = function() {
           updateSelectInput(session, "cboDB",     choices=pnl$cboDB())   
            output$txtDB = renderText({pnl$currentDB})
        }
        
        observeEvent(input$btnDB, {
            if (nchar(input$cboDB) > 0) {
                YATAFactory$changeDB(input$cboDB)
                pnl$updateDB()
                output$txtDB = renderText({pnl$currentDB})
            }
            shinyjs::runjs(paste("document.title = 'YATA -", input$cboDB, "';"))
            # Cambiar el titulo del navegador
        })
        if (!pnl$loaded) { 
            loadPage() 
            pnl$loaded = TRUE
        }
    })
}    
