TBLOperations   = R6::R6Class("TBL.OPERATIONS"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
          initialize = function(name, db=NULL) {
             super$initialize(name, fields=private$fields,db=db)
          }
        ,getDateBegin = function (counter) {
            stmt = "SELECT COUNTER, MIN(TMS) AS TMS"
            filter = list(active = DBDict$flag$on)
            if (!missing(counter)) {
                filter = list.merge(filter, counter = counter)
            }
            sql(stmt, where=filter, group=c("COUNTER"))
        }
         # Operaciones sobre la tabla
        ,open = function() {
            # Operaciones abiertas
            table(list(status=0))
        }
        ,close = function(price) {

        }
     )
     ,private = list (
           key = c("id")
          ,fields = list(
              id       = "ID_OPER"
             ,type     = "TYPE"
             ,camera   = "CAMERA"
             ,base     = "BASE"
             ,counter  = "COUNTER"
             ,amount   = "AMOUNT"
             ,price    = "PRICE"
             ,active   = "ACTIVE"
             ,status   = "STATUS"
             ,alert    = "ALERT"
             ,parent   = "PARENT"
             ,tms      = "TMS"
             ,tmsLast  = "TMS_LAST"
             ,dtAlert  = "TMS_ALERT"
            )
     )
)
