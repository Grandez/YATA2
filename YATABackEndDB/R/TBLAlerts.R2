TBLAlerts = R6::R6Class("TBL.ALERTS"
  ,inherit    = YATATable
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = FALSE
  ,public = list(
     initialize = function(name, db=NULL) {
        super$initialize(name, fields=private$fields, db=db)
     }
  )
  ,private = list (
      fields = list(
         id      = "ID_ALERT"
        ,type    = "TYPE"
        ,subject = "SUBJECT"
        ,matcher = "MATCHER"
        ,target  = "TARGET"
        ,status  = "STATUS"
        ,active  = "ACTIVE"
        ,tms     = "TMS"
     )
  )
)

