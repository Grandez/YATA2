YATAException = R6::R6Class("YATA.EXCEPTION"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,public = list(
        source = NULL
       ,type   = NULL
       ,action = NULL
       ,stack  = NULL
       ,cause  = NULL
       ,msg    = "No error"
       ,print  = function() { message(msg) }
       ,initialize = function(type, msg, source=NULL, action=NULL, ...) {
           self$stack = sys.calls()
           args = list(...)
           self$type   = type
           self$msg    = msg
           self$source = source
           self$action = action
           if (!is.null(args$action)) self$action = args$action
           if (!is.null(args$cause))  self$cause  = args$cause
       }
    )

)

.yataErrClass = function(type) { c(paste0("YATA", toupper(type)), "YATAEXCEPTION") }
yataError = function(msg, src, action, ...) {

    inst = YATAException$new("ERROR", msg, src, action, ...)
    R.oo::Exception(inst)
#    errorCondition(msg, inst,  class=c("YATAERROR", .yataErrClass(type)))
}
yataWarning = function(msg, src, type, action, ...) {
    inst = YATAException$new(type="WARNING", msg, src, type, action, ...)
    errorCondition(msg, inst,  class=c("YATAWARNING", .yataErrClass(type)))
}
