TBLHistory = R6::R6Class("TBL.HISTORY"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,public = list(
        initialize    = function(name,  db=NULL) {
           super$initialize(name, fields=private$fields,key=key, db=db)
        }
        ,getRange = function() {
            sql = paste("SELECT ", fields$symbol, ",MIN(", fields$tms, ") AS min, MAX(", fields$tms, ") AS max ")
            sql = paste(sql, "FROM ", tblName)
            sql = paste(sql, "GROUP BY", fields$symbol)
            df = query(sql)
            colnames(df) = c("symbol", "min", "max")
            df
        }
        ,getDates = function(symbol) {
            query2(fields$tms, symbol=symbol)
        }
     )
     ,private = list (
         fields = list(
             symbol = "SYMBOL"
            ,high   = "HIGH"
            ,low    = "LOW"
            ,open   = "OPEN"
            ,close  = "CLOSE"
            ,volume = "VOLUME"
            ,market_cap = "MKTCAP"
            ,tms    = "TMS"
          )
         ,key    = c("symbol", "tms")
     )
)
