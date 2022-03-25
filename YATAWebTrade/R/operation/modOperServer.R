modOperServer <- function(id, full, pnlParent, parent=NULL) {
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
           ,session      = NULL
           ,bases        = NULL
           ,counters     = NULL
           ,valid        = FALSE
           ,data         = NULL
           ,idOper       = NULL    
           ,initialize     = function(id, pnlParent, session) {
               super$initialize(id, pnlParent, session)
               private$createObjects()
               self$vars$inForm  = FALSE
               self$vars$inEvent = FALSE
               self$vars$panel = ""
               private$opers   = YATABase$map
           }
           ,getOper = function (id)        { private$opers$get(id)       }
           ,setOper = function (id, oper)  { 
               private$opers$put(id, oper) 
               oper
            }
           ,getCounters = function() {self$currencies$getCurrencyNames() }
           ,cboCamerasCounter = function(counter) { self$currencies$getCameras(counter) }
           ,getCboCameras = function (currency) {
               if (missing(currency)) return(self$makeCombo(self$cameras$getForCombo()))
               df = self$position$getCurrencyPosition(currency)   
               df = df[df$camera != self$factory$camera,]
               df = df[df$available > 0,]
               df = self$cameras$getCameras(as.vector(df$camera))
               df = df[,c("camera", "desc")]
               colnames(df) = c("id", "name")
               self$makeCombo(df)
           }
            
           ,cboReasons   = function(type) { self$makeCombo(self$operations$getReasons(type)) }                        
           ,cboCameras   = function(exclude) {
               excl = ifelse(missing(exclude), NULL, exclude)
               self$makeCombo(self$cameras$getForcombo(exclude=exclude))
           }
           ,getCurrenciesSell = function() {
                df = self$position$getGlobalPosition()
                df = df[df$currency != "EUR" & df$available > 0,]
                if (nrow(df) > 0) df = currencies$getCurrencyNames(df$currency, TRUE)
                df
           }    
           ,cboCurrency  = function(camera, available) {
               # if (missing(camera)) {
               #     private$asCombo(WEB$getCurrencyNames())
               # }
               # else {
                  if (camera == self$factory$camera) {
                      data = data.frame(id=self$factory$fiat, name="EUR - EURO")
                      self$makeCombo(data)
                  }
                  else {
                      #JGG Por ahora solo EUR
                     # df = self$cameras$getCameraPosition(camera, available = available) 
                     # if (nrow(df) > 0) {
                         WEB$getCTCLabels("EUR", invert = TRUE)
                     # }
                  }
               # }
           }
           # ,cboCameraCurrencies  =function (camera) {
           #     private$asCombo(self$getCamerasCurrency(camera))
           # }
           ,selectCamera = function(camera) { self$cameras$select(camera) }
           # ,operation    = function(...) {
           #     data = args2list(...)
           #     if (is.null(data)) data = self$data
           #     tryCatch({self$operations$add(data$type, data)
           #               FALSE
           #     }
           #     ,error = function(cond) {
           #         return (yataErrGeneral(0, WEB$txtError, input, output, session))
           #         TRUE
           #       }
           #     )
           # } 
           ,loadOperations = function(status) {
               df = self$operations$getOperations(active = self$codes$flag$active, status = status)
               # Guardar los id               
               stname = self$codes$xlateStatus(status)
               private$opIdx[[stname]] = df$id
               prepareOperation(df)
           }            
        )
       ,private = list(
            opIdx    = list() # Contiene los id de las operaciones
           ,opers    = NULL
           ,definition = list(id = "", left=0, right=0, son=NULL, submodule=FALSE)
           ,createObjects = function() {
               self$cameras    = self$factory$getObject(self$codes$object$cameras)
               self$operations = self$factory$getObject(self$codes$object$operation)
               self$currencies = self$factory$getObject(self$codes$object$currencies)
               self$position   = self$factory$getObject(self$codes$object$position)
               self$session    = self$factory$getObject(self$codes$object$session)
           }
        )
   )   
    moduleServer(id, function(input, output, session) {
        pnl = WEB$getPanel(id)
        if (is.null(pnl)) pnl = WEB$addPanel(PNLOper$new(id, pnlParent, session))
        
        flags = reactiveValues(
            commarea  = FALSE
        )

       ###########################################################
       ### Reactives
       ###########################################################

       observeEvent(flags$commarea, ignoreInit = TRUE, {
           carea = pnl$getCommarea()
           carea$pending = FALSE
           pnl$setCommarea(carea)
       })       
        
        observeEvent(input$pnlOpType, { 
           act = yataActiveNS(input$pnlOpType)
           module = paste0("modOper", str_to_title(act),"Server")
           carea = pnl$getCommarea()

           if (is.null(carea$pending) || !carea$pending) {
               eval(parse(text=paste0(module, "(act, input$pnlOpType, pnl,parent=session)")))
           } else {
               carea$pending = FALSE
               pnl$setCommarea(carea)
               updateTabsetPanel(session, "pnlOpType", selected=ns("dummy"))
           }
        })
    })
}    
