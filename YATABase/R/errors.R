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
     ,error = function(msg, action=NULL, origin=NULL, subclass=NULL, ...) {
         err = structure( list( message = msg,action = action, origin, ...)
                         ,class = c("YATAERROR", subclass, "error", "condition")
          )
          stop(err)
     }
     ,SQL = function(msg, action=NULL, origin=NULL, ...) {
        self$error(msg,action=action,origin=origin, subclass="SQL", ...)
     }
     ,HTTP = function(msg, action=NULL, origin=NULL, ...) {
        self$error(msg,action=action,origin=origin, subclass="HTTP", ...)
      }
     ,logical = function(msg, action=NULL, origin=NULL, ...) {
           self$error(msg,action=action,origin=origin, subclass="LOGICAL", ...)
      }
   )
)
