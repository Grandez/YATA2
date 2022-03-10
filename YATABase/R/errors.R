YATABaseCond = R6::R6Class("YATA.BASE.COND"
   ,portable  = FALSE
   ,cloneable = FALSE
   ,lock_class = TRUE
   ,public = list(
      Warning = function(msg, action=NULL, subclass=NULL, ...) {
         warn = structure( list( message = msg,action = action, ...)
                          ,class = c("YATAWARNING", subclass, "warning", "condition")
          )
          warning(warn)
      }
     ,error = function(msg, subclass, action, origin, ...) {
         data = list(...)
         data$message = msg
         err = structure( data, class = c("YATAERROR", subclass, "error", "condition"))
         stop(err)
     }
     ,SQL = function(msg, action=NULL, origin=NULL, ...) {
        self$error(msg, subclass="SQL", action=action,origin=origin,  ...)
     }
     ,HTTP = function(msg, action=NULL, origin=NULL, ...) {
        self$error(msg, subclass="HTTP",action=action,origin=origin,  ...)
     }
     ,EXEC = function(msg, ...) {
        self$error(msg, subclass="EXEC", NULL, NULL, ...)
     }
     ,logical = function(msg, action=NULL, origin=NULL, ...) {
           self$error(msg, subclass="LOGICAL", action=action,origin=origin, ...)
     }
     ,propagate = function(cond) {
        stop(cond)
     }
   )
)
