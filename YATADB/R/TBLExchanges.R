# Tabla con los cambios que ofrece cada proveedor
TBLExchanges = R6::R6Class("TBL.EXCHANGES"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,public = list(
        initialize     = function(name, db=NULL) {
           super$initialize(name, fields=private$fields, key=private$key, db=db)
        }
        ,updateBulk    = function(data, ...) {
            delete(...)
            bulkAdd(data)
        }
        ,getCameras    = function(symbol) { table(symbol=symbol, active = DBDict$flag$on) }
        ,getCurrencies = function(camera) { table(camera=camera, active = DBDict$flag$on) }
        ,getExchanges  = function() {
            sql = paste("SELECT DISTINCT(", fields$symbol, ")")
            sql = paste(sql, "FROM", tblName)
            sql = paste(sql, "WHERE ", fields$camera, "<> 'MKTCAP'")
            sqlraw(sql,NULL)
        }
        ,table = function(..., full=FALSE) {
              if (full) {
                  super$table(...)
              }
              else {
                  super$table(list.append(list(...), active=YATACodes$flag$active))
              }
         }
     )
     ,private = list (
           key = c("camera", "symbol")
          ,fields = list(
              camera  = "CAMERA"
             ,symbol  = "SYMBOL"
             ,active  = "ACTIVE"
             ,id      = "ID"
          )
     )
)
