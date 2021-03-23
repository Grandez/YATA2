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
           ,bases        = NULL
           ,counters     = NULL
           ,valid        = FALSE
           ,panel        = NULL
           ,nextAction   = NULL
           ,action       = NULL 
           ,data         = NULL
           ,idOper       = NULL    
           ,initialize     = function(id, pnlParent, session) {
               super$initialize(id, pnlParent, session)
               self$cameras    = self$factory$getObject("Cameras")
               self$operations = self$factory$getObject("Operation")
               self$currencies = self$factory$getObject("Currencies")
               self$position   = self$factory$getObject("Position")
               self$cameras$loadCameras()               
               self$vars$inForm  = FALSE
               self$vars$inEvent = FALSE
               private$opers = HashMap$new()
           }
           ,getOper = function (id)        { private$opers$get(id)       }
           ,setOper = function (id, oper)  { 
               private$opers$put(id, oper) 
               oper
            }
           ,getCounters = function() {self$currencies$getCurrencyNames() }
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
                         data = YATAWEB$getCurrencyLabel(df$currency)
                         values = names(data)
                         names(values) = data
                         values
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
                   return (yataErrGeneral(0, YATAWEB$txtError, input, output, session))
                   TRUE
                 }
               )
           } 
           ,loadOperations = function(status) {
               df = self$operations$getOperations(active = self$codes$flag$active, status = status)
               # Guardar los id               
               stname = self$codes$xlateStatus(status)
               private$opIdx[[stname]] = df$id
               prepareOperation(df)
           }
           ,selectOperation = function(status, row) {
               name = self$codes$xlateStatus(status)
               private$selected = private$opIdx[[name]][[row]]
               self$operations$select(private$selected)
               self$cameras$select(self$operations$current$camera)
               
               self$data        = self$operations$current
               self$data$camera = self$cameras$current
               self$data$names = list()
               self$data$names$camera  = self$cameras$current$name
               self$data$names$base    = YATAWEB$getCurrencyLabel(self$data$base, 12)
               self$data$names$counter = YATAWEB$getCurrencyLabel(self$data$counter, 12)
           }
        )
       ,private = list(
           opIdx     = list() # Contiene los id de las operaciones
           ,selected = NULL
           ,opers = NULL
       )
    )
    moduleServer(id, function(input, output, session) {
        pnl = YATAWEB$getPanel(id)
        if (is.null(pnl)) pnl = YATAWEB$addPanel(PNLOper$new(id, pnlParent, session))
        
        observeEvent(input$pnlOpType, {
            # recibe oper-pos
            #pone modOperPosServer
            if (grepl("_", input$pnlOpType)) {
                toks = strsplit(input$pnlOpType, "_")[[1]]
                act = yataActiveNS(toks[1])
                pnl$idOper = toks[2]
                idx = str_locate_all(toks[1], "-")[[1]]
                pnl$panel = substr(toks[1], 1, idx[nrow(idx), 1] - 1)
            }
            else {
               pnl$panel = input$pnlOpType 
               act = yataActiveNS(input$pnlOpType)
            }
            module = paste0("modOper", titleCase(act),"Server")
            eval(parse(text=paste0(module, "(act, pnl$panel, pnl,parent=session)")))
        })
    })
}    
