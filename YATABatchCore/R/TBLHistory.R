TBLHistory = R6::R6Class("TBL.HISTORY"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,public = list(
        initialize    = function(name,  db=NULL) {
           super$initialize(name, tblName, fields=private$fields, db=db)
        }
        ,getRange = function(idList) {
            params = NULL
            sql = paste("SELECT ", fields$id, ",", fields$symbol)
            sql = paste(sql, ",MIN(", fields$timestamp, ") AS min, MAX(", fields$timestamp, ") AS max ")
            sql = paste(sql, "FROM ", tblName)
            if (!missing(idList)) {
                sql = paste(sql, "WHERE ", fields$id, "IN (")
                values = rep(",?", length(idList))
                values = substr(values, 2, nchar(values))
                sql = paste(sql, values, ")")
                params = idList
            }
            sql = paste(sql, "GROUP BY", fields$id)
            df = queryRaw(sql, params)
            colnames(df) = c("id", "symbol", "min", "max")
            #JGG En algun momento hemos almacenado el simbolo con \r
            df$symbol = gsub("\\r", "", df$symbol)
            df
        }
        ,getDates = function(symbol) {
            stop("TBLHIstory - getDates - DESDE DONDE SE LLAMA")
            "SELECT "
            query2(fields$tms, symbol=symbol)
        }
        ,getHistory = function(symbol, from=NULL, to=NULL, periods=0) {
            params=list(id=symbol)
            sql = paste("SELECT * FROM ", getDBTableName(), "WHERE")

            if (is.numeric(symbol))
                sql = paste(sql, "ID = ?")
            else
                sql = paste(sql, "SYMBOL = ?")
            if (!is.null(from)) {
                sql = paste(sql, "AND TMS BETWEEN ? AND ?")
                params$from = from
                params$to = ifelse (is.null(to), Sys.Date(), as.character(to))
            }
            sql = paste(sql, "ORDER BY TMS DESC")
            if (periods > 0) {
                sql = paste(sql, "LIMIT ?")
                params$limit = periods
            }
            queryRaw(sql, params)
        }
     )
     ,private = list (
         tblName = "HISTORY"
        ,fields = list(
             id         = "ID"
            ,symbol     = "SYMBOL"
            ,open       = "OPEN"
            ,close      = "CLOSE"
            ,high       = "HIGH"
            ,low        = "LOW"
            ,volume     = "VOLUME"
            ,marketCap  = "MKTCAP"
            ,timestamp  = "TMS"
            ,tms        = "TMS"
            ,timeHigh   = "TMSHIGH"
            ,timeLow    = "TMSLOW"

          )
         ,key    = c("id", "tms")
     )
)
