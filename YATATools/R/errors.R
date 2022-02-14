# YATAERROR = R6::R6Class("YATA.ERROR"
#    ,portable   = FALSE
#    ,cloneable  = FALSE
#    ,lock_class = TRUE
#    ,public = list(
#         type   = NULL
#        ,action = NULL
#        ,stack  = NULL
#        ,cause  = NULL
#        ,msg    = "UNKNOW ERROR"
#        ,print  = function() { message(msg) }
#        ,initialize = function(type, msg, action=NULL, origin=NULL, ...) {
#            self$stack = sys.calls()
#            args = list(...)
#            self$type   = type
#            self$msg    = msg
#            self$action = action
#            if (type == "ERROR")  private$clsType = clsError
#            if (type == "WARNING") private$clsType = clsWarning
#            if (!is.null(args$action)) self$action = args$action
#            if (!is.null(args$cause))  self$cause  = args$cause
#        }
#        ,getClasses = function() {
#             c("YATAErr", "error")
#         }
#         ,setClasses = function(...) {
#             private$cls = c(unlist(list(...)), private$cls)
#             return (invisible$self)
#         }
#     )
#     ,private = list(
#          clsType  = c("YATAErr"    , "error")
#         ,clsError = c("YATAErr"    , "error")
#         ,clsWarn  = c("YATAWarning", "warning")
#     )
#
#
# )
yataWarning = function(msg, action=NULL, subclass=NULL, ...) {
  warn = structure(
              list( message = msg,action = action, ...)
             ,class = c("YATAWARNING", subclass, "warning", "condition")
          )
  warning(warn)
}

yataError = function(msg, action=NULL, origin=NULL, subclass=NULL, ...) {
  browser()
    err = structure(
              list( message = msg,action = action, origin, ...)
             ,class = c("YATAERROR", subclass, "error", "condition")
          )
  stop(err)
}
yataErrorSQL = function(msg, action=NULL, origin=NULL, ...) {
    yataError(msg,action=action,origin=origin, subclass="SQL", ...)
    # inst = YATAERROR$new("ERROR", msg, action, origin, cls="YATASQL", ...)
    # errorCondition(msg, inst, class=inst$getClasses())
}

