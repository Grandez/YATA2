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
     ,error = function(msg, subclass, ...) {
         data = list(...)
         data$message = msg
         err = structure( data, class = c("YATAERROR", subclass, "error", "condition"))
         stop(err)
     }
     ,SQL = function(msg, action=NULL, origin=NULL, ...) {
        self$error(msg,action=action,origin=origin, subclass="SQL", ...)
     }
     ,HTTP = function(msg, action=NULL, origin=NULL, ...) {
        self$error(msg,action=action,origin=origin, subclass="HTTP", ...)
     }
     ,EXEC = function(msg, ...) {
        self$error(msg, subclass="EXEC", ...)
      }
     ,logical = function(msg, action=NULL, origin=NULL, ...) {
           self$error(msg,action=action,origin=origin, subclass="LOGICAL", ...)
      }
   )
)
