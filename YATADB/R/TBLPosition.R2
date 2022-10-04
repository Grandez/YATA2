TBLPosition = R6::R6Class("TBLPOSITION"
  ,inherit    = YATATable
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,public = list(
      initialize = function(name, db=NULL) {
         super$initialize(name, fields=private$fields,key=key, db=db)
      }
     ,getGlobalPosition = function() {
         self$current = NULL
         stmt = paste( "SELECT  CURRENCY, SUM(BALANCE) AS BALANCE, SUM(AVAILABLE) AS AVAILABLE"
                      ,",AVG(BUY_NET)   AS BUY_NET,   AVG(SELL_NET) AS SELL_NET"
                      ,",MAX(BUY_HIGH)  AS BUY_HIGH,  MIN(BUY_LOW)  AS BUY_LOW"
                      ,",MAX(SELL_HIGH) AS SELL_HIGH, MIN(SELL_LOW) AS SELL_LOW"
                      ,",SUM(BUY)       AS BUY,       SUM(SELL)     AS SELL, AVG(NET) AS NET"
                      ,",SUM(PROFIT) AS PROFIT"
                      ,",MIN(SINCE) AS SINCE, MIN(TMS) AS TMS, MAX(LAST) AS LAST")
         group = c("CURRENCY")
         sql(stmt, group=group)
      }
     ,getCameraPosition = function(camera, balance=FALSE, available=FALSE) {
         df = table(camera=camera)
         if (balance)   df = df[df$balance   > 0,]
         if (available) df = df[df$available > 0,]
         self$current = list(df)
         df
      }
     ,getCurrencyPosition = function(currency) { table(currency=currency) }
     ,getPosition = function(camera, currency) { table(camera=camera, currency=currency) }
     ,getCameras  = function() { uniques(c("camera")) }
   )
  ,private = list (
      key    = c("camera", "currency")
     ,fields = list(
         camera    = "CAMERA"
        ,currency  = "CURRENCY"
        ,balance   = "BALANCE"
        ,available = "AVAILABLE"
        ,buy_high  = "BUY_HIGH"
        ,buy_low   = "BUY_LOW"
        ,buy_last  = "BUY_LAST"
        ,buy_net   = "BUY_NET"
        ,sell_high = "SELL_HIGH"
        ,sell_low  = "SELL_LOW"
        ,sell_last = "SELL_LAST"
        ,sell_net  = "SELL_NET"
        ,buy       = "BUY"
        ,sell      = "SELL"
        ,net       = "NET"
        ,profit    = "PROFIT"
        ,since     = "SINCE"
        ,tms       = "TMS"
        ,last      = "LAST"
        ,cc        = "CC"
      )
   )
)
