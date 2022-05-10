modOperServer <- function(id, full, parent, session) {
ns = NS(id)
PNLOper = R6::R6Class("PNL.OPER"
  ,inherit    = WEBPanel
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
     ,fiat = "__FIAT__"
     ,initialize     = function(id, parent, session) {
         super$initialize(id, parent, session)
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
     #,getCounters = function() {self$currencies$getCurrencyNames() }
     ,getCboCameras = function (currency) {
         # Si currency es FIAT es una compra
         df = self$position$getByCurrency(currency, available = TRUE)
         self$makeCombo(self$cameras$getForCombo(cameras=df$camera))
         # if (currency == self$factory$fiat) {
         #
         # } else {
         #     df = self$position$getByCurrency(currency, available = TRUE)
         #     return(self$makeCombo(self$cameras$getForCombo(cameras=df$camera)))
         # }
         # if (missing(currency)) return(self$makeCombo(self$cameras$getForCombo()))
         # df = self$position$getCurrencyPosition(currency)
         # df = df[df$camera != self$factory$camera,]
         # df = df[df$available > 0,]
         # df = self$cameras$getCameras(as.vector(df$camera))
         # df = df[,c("camera", "desc")]
         # colnames(df) = c("id", "name")
         # self$makeCombo(df)
     }

     ,cboReasons   = function(type) { self$makeCombo(self$operations$getReasons(type)) }
     ,cboCameras   = function(exclude = NULL) {
         self$makeCombo(self$cameras$getForCombo(cameras=NULL, exclude=exclude))
     }
     ,cboCamerasCounter = function(counter) { self$currencies$getCameras(counter) }
     ,getCurrenciesBuy  = function() {
         self$currencies$getCurrencyNames()
       }
     ,getCurrenciesSell = function() {
          data = self$position$getCurrencies(available = TRUE)
          if (length(data) == 0) return (NULL)
          idx = which(data == self$factory$fiat)
          if (length(idx) > 0) data = data[-idx]
          if (length(data) == 0) return (NULL)
          self$currencies$getCurrencyNames(data)
     }
     ,cboCurrency  = function(camera, available) {
         message("ESTO SE USA")
         browser()
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
     ,makeCombo = function(df, invert=FALSE) {
         cols = c(1,2)
         if (invert) cols = c(2,1)
         lst = df[,cols[1]]
         names(lst) = df[,cols[2]]
         lst
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
    pnl = WEB$getPanel(PNLOper, id, parent, session)

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

    observeEvent(input$mnuOper, {
       act = yataActiveNS(input$mnuOper)
       module = paste0("modOper", str_to_title(act),"Server")
       carea = pnl$getCommarea()

       if (is.null(carea$pending) || !carea$pending) {
           eval(parse(text=paste0(module, "(act, input$mnuOper, pnl, session)")))
       } else {
           carea$pending = FALSE
           pnl$setCommarea(carea)
           updateTabsetPanel(session, "mnuOper", selected=ns("dummy"))
       }
    })
})
}
