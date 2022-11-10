modOperServer <- function(id, parent, session) {
ns = NS(id)
PNLOper = R6::R6Class("YATA.TRADE.PNL.OPER"
  ,inherit    = JGGPanel
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,public = list(
#      ,operations   = NULL
#      ,currencies   = NULL
#      ,session      = NULL
#      ,bases        = NULL
#      ,counters     = NULL
#      ,valid        = FALSE
#      ,data         = NULL
#      ,idOper       = NULL
#      ,fiat = "__FIAT__"
      initialize     = function(id, parent, session) {
         super$initialize(id, parent, session)
         private$createObjects()
#          self$vars$inForm  = FALSE
#          self$vars$inEvent = FALSE
#          self$vars$panel = ""
#          private$opers   = YATABase$map
     }
#      ,getOper = function (id)        { private$opers$get(id)       }
#      ,setOper = function (id, oper)  {
#          private$opers$put(id, oper)
#          oper
#       }
#      #,getCounters = function() {self$currencies$getCurrencyNames() }
     ,getCboCameras = function (currency) {
         # Si currency es FIAT es una compra
         df = private$position$getByCurrency(currency, available = TRUE)
         if (nrow(df) == 0) return (NULL)
         data = private$cameras$getForCombo(cameras=df$camera)
         private$makeCombo(data)
     }
#
#      ,cboReasons   = function(type) { private$makeCombo(self$operations$getReasons(type)) }
#      ,cboCameras   = function(exclude = NULL) {
#          private$makeCombo(self$cameras$getForCombo(cameras=NULL, exclude=exclude))
#      }
#      ,cboCamerasCounter = function(counter) { self$currencies$getCameras(counter) }
#      ,getCurrenciesBuy  = function() {
#          self$currencies$getCurrencyNames()
#        }
#      ,getCurrenciesSell = function() {
#           data = self$position$getCurrencies(available = TRUE)
#           if (length(data) == 0) return (NULL)
#           idx = which(data == self$factory$fiat)
#           if (length(idx) > 0) data = data[-idx]
#           if (length(data) == 0) return (NULL)
#           self$currencies$getCurrencyNames(data)
#      }
#      ,cboCurrency  = function(camera, available) {
#          message("ESTO SE USA")
#          browser()
#          # if (missing(camera)) {
#          #     private$asCombo(WEB$getCurrencyNames())
#          # }
#          # else {
#             if (camera == self$factory$camera) {
#                 data = data.frame(id=self$factory$fiat, name="EUR - EURO")
#                 private$makeCombo(data)
#             }
#             else {
#                 #JGG Por ahora solo EUR
#                # df = self$cameras$getCameraPosition(camera, available = available)
#                # if (nrow(df) > 0) {
#                    WEB$getCTCLabels("EUR", invert = TRUE)
#                # }
#             }
#          # }
#      }
#      # ,cboCameraCurrencies  =function (camera) {
#      #     private$asCombo(self$getCamerasCurrency(camera))
#      # }
#      ,selectCamera = function(camera) { self$cameras$select(camera) }
#      # ,operation    = function(...) {
#      #     data = args2list(...)
#      #     if (is.null(data)) data = self$data
#      #     tryCatch({self$operations$add(data$type, data)
#      #               FALSE
#      #     }
#      #     ,error = function(cond) {
#      #         return (yataErrGeneral(0, WEB$txtError, input, output, session))
#      #         TRUE
#      #       }
#      #     )
#      # }
#      ,loadOperations = function(status) {
#          df = self$operations$getOperations(active = self$codes$flag$active, status = status)
#          # Guardar los id
#          stname = self$codes$xlateStatus(status)
#          private$opIdx[[stname]] = df$id
#          prepareOperation(df)
#      }
   )
  ,private = list(
       cameras      = NULL
      ,position     = NULL
#        opIdx    = list() # Contiene los id de las operaciones
#       ,opers    = NULL
#       ,definition = list(id = "", left=0, right=0, son=NULL, submodule=FALSE)
      ,createObjects = function() {
          private$cameras    = self$factory$getObject("Cameras")
          private$position   = self$factory$getObject("Position")
          # self$operations = self$factory$getObject(self$codes$object$operation)
          # self$currencies = self$factory$getObject(self$codes$object$currencies)

          # self$session    = self$factory$getObject(self$codes$object$session)
      }
     ,makeCombo = function(df, invert=FALSE) {
         cols = c(1,2)
         if (invert) cols = c(2,1)
         lst = df[,cols[1]]
         names(lst) = df[,cols[2]]
         lst
     }

  )
)
moduleServer(id, function(input, output, session) {
   pnl = WEB$getPanel(id, PNLOper, parent, session)
   #
   #  flags = reactiveValues(
   #      commarea  = FALSE
   #  )
   #
   # ###########################################################
   # ### Reactives
   # ###########################################################
   #
   # observeEvent(flags$commarea, ignoreInit = TRUE, {
   #     carea = pnl$getCommarea()
   #     carea$pending = FALSE
   #     pnl$setCommarea(carea)
   # })
   #
   observeEvent(input$mnuOper, {
       act = yataActiveNS(input$mnuOper)
       module = paste0("modOper", jgg_to_title(act),"Server")
   #     carea = pnl$getCommarea()
   #
   #     if (is.null(carea$pending) || !carea$pending) {
            eval(parse(text=paste0(module, "(act, pnl, session)")))
   #     } else {
   #         carea$pending = FALSE
   #         pnl$setCommarea(carea)
   #         updateTabsetPanel(session, "mnuOper", selected=ns("dummy"))
   #     }
   })
})
}

