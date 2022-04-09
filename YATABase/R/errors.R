YATABaseCond = R6::R6Class("YATA.BASE.COND"
   ,portable  = FALSE
   ,cloneable = FALSE
   ,lock_class = TRUE
   ,public = list(
      Warning = function(msg, action=NULL, subclass=NULL, ...) {
         warn = structure( list( message = msg, subclass=subclass, action = action, ...)
                          ,class = c("YATAWARNING", "warning", "condition")
          )
          warning(warn)
      }
     ,error = function(msg, subclass, action, origin, ...) {
         data = list(...)
         data$message = msg
         data$subclass = subclass
         data$stack   = sys.calls()
         err = structure( data, class = c("YATAERROR", "error", "condition"))
         stop(err)
     }
     ,SQL = function(msg, action=NULL, origin=NULL, ...) {
        self$error(msg, subclass="SQL", action=action,origin=origin,  ...)
     }
     ,HTTP = function(msg,  ...) {
        self$error(msg, subclass="HTTP",  ...)
     }
     ,EXEC = function(msg, ...) {
        self$error(msg, subclass="EXEC", NULL, NULL, ...)
     }
     ,logical = function(msg, action=NULL, origin=NULL, ...) {
           self$error(msg, subclass="LOGICAL", action=action,origin=origin, ...)
     }
     ,propagateError = function(cond) {
        stop(cond)
     }
   )
)
.error = function(msg, subclass, ...) {
   logger = YATALogger$new("ERROR")
   data = list(...)
   data$message = msg
   data$subclass = subclass
   errdata = structure( data, class = c("YATAERROR", "error", "condition"))
   logger$fail(errdata)
   stop(errdata)
}

# No se exportan para no tener efectos colaterales
Warning = function(msg, action=NULL, subclass=NULL, ...) {
   warn = structure( list( message = msg,action = action, ...)
                    ,class = c("YATAWARNING", subclass, "warning", "condition")
    )
    warning(warn)
}
 error = function(msg, ...) {
    .error(msg, subclass="UNHANDLED", ...)
}
 SQL = function(msg, ...) {
      data = list(...)
      msg = paste0(msg, " (", data$sqlcode, ")")
     .error(msg, subclass="SQL", ...)
}
HTTP = function(msg, ...) {
     .error(msg, subclass="HTTP", ...)
}
EXEC = function(msg, ...) {
     .error(msg, subclass="EXEC", ...)
}
logical = function(msg, ...) {
     .error(msg, subclass="LOGICAL", ...)
}
propagateError = function(cond) { stop(cond) }
propagate      = function(cond) { stop(cond) }
