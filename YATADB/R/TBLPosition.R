TBLPosition = R6::R6Class("TBLPOSITION"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
         initialize = function(name, db=NULL) {
             super$initialize(name, fields=private$fields,key=key, db=db)
         }
        # ,updateOper = function(camera, currency, amount, price, taxes) {
        #     browser()
        # }
        ,getGlobalPosition = function() {
            self$current = NULL
            stmt = paste("SELECT  CURRENCY, SUM(BALANCE) AS BALANCE, SUM(AVAILABLE) AS AVAILABLE"
                               ,",SUM(BUY) AS BUY, SUM(SELL) AS SELL, AVG(VALUE) AS VALUE"
                               ,",AVG(BUY_NET) AS BUY_NET, AVG(SELL_NET) AS SELL_NET"
                               ,",AVG(PROFIT) AS PROFIT"
                               ,",MIN(SINCE) AS SINCE, MAX(LAST) AS LAST")
            group = c("CURRENCY")
            sql(stmt, group=group)
        }
        ,getCameraPosition = function(camera, balance=FALSE, available=FALSE) {
            df = table(camera=camera)
            if (balance)   df = df[df$balance   > 0,]
            if (available) df = df[df$available > 0,]
            browser()
            self$current = list(df)
            df
        }
        ,getCurrencyPosition = function(currency) { table(currency=currency) }
        ,getPosition = function(camera, currency) {
            table(camera=camera, currency=currency)
         }
        ,getCameras  = function() { uniques(c("camera")) }
     )
     ,private = list (
           key    = c("camera", "currency")
          ,fields = list(
              camera    = "CAMERA"
             ,currency  = "CURRENCY"
             ,balance   = "BALANCE"
             ,available = "AVAILABLE"
             ,buyHigh   = "BUY_HIGH"
             ,buyLow    = "BUY_LOW"
             ,buyLast   = "BUY_LAST"
             ,buyNet    = "BUY_NET"
             ,sellHigh  = "SELL_HIGH"
             ,sellLow   = "SELL_LOW"
             ,sellLast  = "SELL_LAST"
             ,sellNet   = "SELL_NET"
             ,buy       = "BUY"
             ,sell      = "SELL"
             ,value     = "VALUE"
             ,profit    = "PROFIT"
             ,since     = "SINCE"
             ,last      = "LAST"
             ,cc        = "CC"
          )
     )
)
