TBLHistory = R6::R6Class("TBL.HISTORY"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,public = list(
        initialize    = function(name,  db=NULL) {
           super$initialize(name, fields=private$fields,key=key, db=db)
        }
        ,getRange = function(idList) {
            parms = NULL
            sql = paste("SELECT ", fields$id, ",", fields$symbol)
            sql = paste(sql, ",MIN(", fields$timestamp, ") AS min, MAX(", fields$timestamp, ") AS max ")
            sql = paste(sql, "FROM ", tblName)
            sql = paste(sql, "GROUP BY", fields$id, ",", fields$symbol)
            if (!missing(idList)) {
                sql = paste(sql, "WHERE ", fields$id, "IN (")
                values = rep(",?", length(idList))
                values = substr(values, 2, nchar(values))
                sql = paste(sql, values, ")")
                parms = idList
            }

            df = queryRaw(sql, parms)
            colnames(df) = c("id", "symbol", "min", "max")
            df
        }
        ,getDates = function(symbol) {
            stop("TBLHIstory - getDates - DESDE DONDE SE LLAMA")
            "SELECT "
            query2(fields$tms, symbol=symbol)
        }
        ,getHistory = function(symbol, from, to) {
            if (is.numeric(symbol)) {
                tableInterval(from=from, to=to, id=symbol)
            } else {
                tableInterval(from=from, to=to, symbol=symbol)
            }
        }
     )
     ,private = list (
         fields = list(
             id         = "ID"
            ,symbol     = "SYMBOL"
            ,open       = "OPEN"
            ,close      = "CLOSE"
            ,high       = "HIGH"
            ,low        = "LOW"
            ,volume     = "VOLUME"
            ,market_cap = "MKTCAP"
            ,timestamp  = "TMS"
            ,tms        = "TMS"
          )
         ,key    = c("id", "tms")
     )
)
