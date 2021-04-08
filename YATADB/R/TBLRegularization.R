TBLRegularization = R6::R6Class("TBLREGULARIZATION"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
         initialize = function(name, db=NULL) {
             super$initialize(name, fields=private$fields,key=key, db=db)
         }
        ,getRegularizations = function() {
            stmt = paste("SELECT CAMERA, CURRENCY, MAX(LAST) AS LAST FROM REGULARIZATION GROUP BY CAMERA, CURRENCY")
            df = queryRaw(stmt)
            colnames(df) = c("camera", "counter", "last")
            df
        }
        ,getRegularizationDate = function(camera, currency) {
            stmt = paste("SELECT MAX(LAST) AS LAST")
            df = sql(stmt, where=list(camera=camera, currency=currency))
            if (nrow(df) == 0)
                from = as.POSIXct(1, origin="1970-01-01")
            else {
                from = df[1,"last"]
            }
            from
        }
     )
     ,private = list (
           key    = c("camera", "currency")
          ,fields = list(
              camera    = "CAMERA"
             ,currency  = "CURRENCY"
             ,balance   = "BALANCE"
             ,available = "AVAILABLE"
             ,buy       = "BUY"
             ,sell      = "SELL"
             ,price     = "PRICE"
             ,since     = "SINCE"
             ,last      = "LAST"
          )
     )
)
