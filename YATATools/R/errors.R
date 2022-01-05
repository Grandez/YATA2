YATAERROR = R6::R6Class("YATA.ERROR"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,public = list(
        type   = NULL
       ,action = NULL
       ,stack  = NULL
       ,cause  = NULL
       ,msg    = "UNKNOW ERROR"
       ,print  = function() { message(msg) }
       ,initialize = function(type, msg, action=NULL, origin=NULL, ...) {
           self$stack = sys.calls()
           args = list(...)
           self$type   = type
           self$msg    = msg
           self$action = action
           if (type == "ERROR")  private$clsType = clsError
           if (type == "WARNING") private$clsType = clsWarning
           if (!is.null(args$action)) self$action = args$action
           if (!is.null(args$cause))  self$cause  = args$cause
       }
       ,getClasses = function() {
            c("YATAErr", "error")
        }
        ,setClasses = function(...) {
            private$cls = c(unlist(list(...)), private$cls)
            return (invisible$self)
        }
    )
    ,private = list(
         clsType  = c("YATAErr"    , "error")
        ,clsError = c("YATAErr"    , "error")
        ,clsWarn  = c("YATAWarning", "warning")
    )


)

yataError = function(msg, action=NULL, origin=NULL, ...) {
    inst = YATAERROR$new("ERROR", msg, action,origin,  ...)
    errorCondition(msg, inst,  class=inst$getClasses())
}
yataErrorSQL = function(msg, action=NULL, origin=NULL, ...) {
    inst = YATAERROR$new("ERROR", msg, action, origin, cls="YATASQL", ...)
    errorCondition(msg, inst, class=inst$getClasses())
}

yataWarning = function(msg, action=NULL, ...) {
    inst = YATAERROR$new("WARNING", msg, action, ...)
    warningCondition(msg, inst,  class=c("YATAWARNING", .yataErrClass(type)))
}
