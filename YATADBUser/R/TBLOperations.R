TBLOperations   = R6::R6Class("TBL.OPERATIONS"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
          initialize = function(name, db=NULL) {
             super$initialize(name, private$tblName, fields=private$fields,db=db)
          }
        ,getDateBegin = function (counter) {
            stmt = "SELECT COUNTER, MIN(TMS) AS TMS"
            filter = list(active = DBDict$flag$on)
            if (!missing(counter)) {
                filter = jgg_list_merge_list(filter, counter = counter)
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
           tblName = "OPERATIONS"
          ,key = c("id")
          ,fields = list(
              id       = "ID_OPER"
             ,dateOper = "DATEOPER"
             ,dateVal  = "DATEVAL"
             ,type     = "TYPE"
             ,camera   = "CAMERA"
             ,base     = "BASE"
             ,counter  = "COUNTER"
             ,amount   = "AMOUNT"
             ,value    = "VALUE"
             ,price    = "PRICE"
             ,active   = "ACTIVE"
             ,status   = "STATUS"
             ,parent   = "PARENT"
             ,tms      = "TMS"
             ,tmsLast  = "TMS_LAST"
             ,result   = "RESULT"
            )
     )
)
