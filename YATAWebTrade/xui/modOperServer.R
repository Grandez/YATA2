modOperServer <- function(id, full) {
   ns = NS(id)
   PNLOper = R6::R6Class("PNL.OPER"
        ,inherit    = YATAPanel
        ,cloneable  = FALSE
        ,lock_class = TRUE
        ,public = list(
            cameras      = NULL
           ,operations   = NULL
           ,currencies   = NULL
           ,position     = NULL
           ,bases        = NULL
           ,counters     = NULL
           ,valid        = FALSE
           ,nextAction   = NULL
           ,action       = NULL 
           ,data         = NULL
           ,initialize     = function(id) {
               super$initialize(id)
               self$cameras    = YATAFactory$getObject("Cameras")
               self$operations = YATAFactory$getObject("Operation")
               self$currencies = YATAFactory$getObject("Currencies")
               self$position   = YATAFactory$getObject("Position")
               self$cameras$loadCameras()
           }
           ,cboOpen = function() { private$asCombo(self$currencies$getCurrencyNames()) }
           ,cboCamerasCounter = function(counter) { self$currencies$getCameras(counter) }
           ,cboCameras   = function(exclude, full=FALSE) {
              data = self$cameras$getCameras(full)
              if (!missing(exclude)) data = data[!data$id %in% exclude,]
              private$asCombo(data)
          }
           ,cboCurrency  = function(camera, available) {
               if (missing(camera)) {
                   private$asCombo(YATAWEB$getCurrencyNames())
               }
               else {
                  if (camera == "CASH") {
                      data = data.frame(id="EUR", name="EUR - EURO")
                  }
                  else {
                     df = self$cameras$getCameraPosition(camera, available = available) 
                     data = YATAWEB$getCurrencyNames(df$currency, full=TRUE)
                  }
                  private$asCombo(data)
               }
           }
           ,cboCameraCurrencies  =function (camera) {
               private$asCombo(self$getCamerasCurrency(camera))
           }
            ,selectCamera = function(camera) { self$cameras$select(camera) }
           ,operation    = function(type, ...) {
               tryCatch({self$operations$add(type, ...)
                         FALSE
               }
               ,error = function(cond) {
                   browser()
                   TRUE
                 }
               )
           } 
           ,loadOperations = function(status) {
               ignore = c("id", "type", "active", "tms", "status", "parent", "alert", "dtAlert")               
               df = self$operations$getOperationsExt(status = status)
               if (nrow(df) > 0) {
                   df$id = as.numeric(df$id)
                   df = add_column(df, value = df$price * df$amount, .after = "price")
                   stname = YATACodes$xlateStatus(status)
                   private$opIdx[stname] = df$id
                   df = df[,!is.na(colnames(df))]
                   df = df [, ! names(df) %in% ignore, drop = FALSE]
               }
               df
           }
           ,selectOperation = function(status, row) {
               name = YATACodes$xlateStatus(status)
               private$selected = private$opIdx[[name]][[row]]
               self$operations$select(private$selected)
               self$cameras$select(self$operations$current$camera)
               self$data = self$cameras$current
               self$data = list.merge(self$data, self$operations$current)
           }
        )
       ,private = list(
           opIdx     = list()
           ,selected = NULL
       )
    )
    # createOperation = function() {
    #   # Graba la operacion
    #   op = Operation$new(type=input$opType, clearing=input)
    #   with(input, op$set(type=opType, clearing=cboCamera, base=cboBase, counter=cboCounter)
    #   )
    #   op$apply()
    # }
    # initPage = function(input, output, session) {
    #   pnl = YATAWEB$addPanel(PNLOper$new(id))
    #   updateSelectInput(session, "cboCamera",  choices=pnl$cboCameras())
    #   # updateSelectInput(session, "cboBase",    choices=pnl$bases$toCombo())
    #   # updateSelectInput(session, "cboCounter", choices=pnl$counters$toCombo())
    #   pnl
    # }
    # removeModal = function(session) {
    #   session$sendCustomMessage("toggleModal", "nada")
    #   removeUI("#operModal", immediate=TRUE)
    # }
    moduleServer(id, function(input, output, session) {
        pnl = YATAWEB$panel(id)
        if (is.null(pnl)) pnl = YATAWEB$addPanel(PNLOper$new(id))
        
        # observeEvent(input$cboCamera,{
        #     pnl$cameras$select(input$cboCamera)
        #     updateSelectInput(session, "cboBase",  choices=pnl$cboBase(input$cboCamera, input$opBuy))
        #     updateSelectInput(session, "cboCounter",  choices=pnl$cboBase(input$cboCamera))
        # }, ignoreInit = TRUE)
        observeEvent(input$pnlOpType, {
            act = yataActiveNS(input$pnlOpType)
#            gralServer("tab1", input$subtab3) # modTab31Server("tab1", input$subtab3)
            #mod = strsplit(input$pnlOpType, "-")[[1]][2]
            module = paste0("modOper", titleCase(act),"Server")
            eval(parse(text=paste0(module, "(act, input$pnlOpType, pnl)")))
        })
    })
}    
