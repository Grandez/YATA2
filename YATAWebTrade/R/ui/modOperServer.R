modOperServer <- function(id, full, pnlParent, invalidate=FALSE) {
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
           ,parms        = NULL
           ,bases        = NULL
           ,counters     = NULL
           ,valid        = FALSE
           ,panel        = NULL
           ,nextAction   = NULL
           ,action       = NULL 
           ,data         = NULL
           ,defCtc       = NULL
           ,detail       = NULL    
           ,initialize     = function(id, pnlParent, session) {
               super$initialize(id, pnlParent, session)
               self$cameras    = YATAFactory$getObject("Cameras")
               self$operations = YATAFactory$getObject("Operation")
               self$currencies = YATAFactory$getObject("Currencies")
               self$position   = YATAFactory$getObject("Position")
               self$parms      = YATAFactory$getParms()
               self$defCtc     = self$parms$getDefCurrency()
               self$cameras$loadCameras()               
           }
           ,getCounters = function() {self$currencies$getCurrencyNames()  }
           ,cboCamerasCounter = function(counter) { self$currencies$getCameras(counter) }
           ,cboCameras   = function(exclude, full=FALSE) {
              data = self$cameras$getCameras(full)
              if (!missing(exclude)) data = data[!data$id %in% exclude,]
              self$makeCombo(data)
           }
           ,getCurrenciesSell = function() {
                df = self$position$getGlobalPosition()
                df = df[df$currency != "EUR" & df$available > 0,]
                if (nrow(df) > 0) df = currencies$getCurrencyNames(df$currency, TRUE)
                df
           }    
           ,cboCurrency  = function(camera, available) {
               if (missing(camera)) {
                   private$asCombo(YATAWEB$getCurrencyNames())
               }
               else {
                  if (camera == "CASH") {
                      data = data.frame(id="EUR", name="EUR - EURO")
                      self$makeCombo(data)
                  }
                  else {
                     df = self$cameras$getCameraPosition(camera, available = available) 
                     if (nrow(df) > 0) {
                         data = self$currencies$getNames(df$currency, full=TRUE)
                         self$makeCombo(data)
                     }
                  }
               }
           }
           # ,cboCameraCurrencies  =function (camera) {
           #     private$asCombo(self$getCamerasCurrency(camera))
           # }
           ,cboReasons   = function(type) { self$makeCombo(self$operations$getReasons(type)) }
           ,selectCamera = function(camera) { self$cameras$select(camera) }
           ,operation    = function(...) {
               data = args2list(...)
               if (is.null(data)) data = self$data
               tryCatch({self$operations$add(data$type, data)
                         FALSE
               }
               ,error = function(cond) {
                   browser()
                   TRUE
                 }
               )
           } 
           ,loadOperations = function(status) {
               df = self$operations$getOperations(active = YATACodes$flag$active, status = status)
               # Guardar los id               
               stname = YATACodes$xlateStatus(status)
               private$opIdx[[stname]] = df$id
               prepareOperation(df)
           }
           ,selectOperation = function(status, row) {
               name = YATACodes$xlateStatus(status)
               private$selected = private$opIdx[[name]][[row]]
               self$operations$select(private$selected)
               self$cameras$select(self$operations$current$camera)
               self$data = self$cameras$current
               self$data$cameraName = self$cameras$current$name
               self$data = list.merge(self$data, self$operations$current)
               self$data$baseName    = self$currencies$getCurrencyName(self$data$base,    TRUE)
               self$data$counterName = self$currencies$getCurrencyName(self$data$counter, TRUE)
           }
          ,getOperation = function() {
              self$operations$current
          }
        )
       ,private = list(
           opIdx     = list() # Contiene los id de las operaciones
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
        pnl = YATAWEB$getPanel(id)
        if (is.null(pnl)) pnl = YATAWEB$addPanel(PNLOper$new(id, pnlParent, session))
        
        # observeEvent(input$cboCamera,{
        #     pnl$cameras$select(input$cboCamera)
        #     updateSelectInput(session, "cboBase",  choices=pnl$cboBase(input$cboCamera, input$opBuy))
        #     updateSelectInput(session, "cboCounter",  choices=pnl$cboBase(input$cboCamera))
        # }, ignoreInit = TRUE)
        observeEvent(input$pnlOpType, {
            pnl$panel = input$pnlOpType
            act = yataActiveNS(input$pnlOpType)
            module = paste0("modOper", titleCase(act),"Server")
            eval(parse(text=paste0(module, "(act, input$pnlOpType, pnl)")))
        })
    })
}    
