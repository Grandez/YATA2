TBLPosition = R6::R6Class("TBLPOSITION"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
         initialize = function(name, db=NULL) {
             super$initialize(name, fields=private$fields,key=key, db=db)
         }
        ,updateOper = function(camera, currency, amount, price, taxes) {
            browser()
        }
        ,getGlobalPosition = function() {
            stmt = paste("SELECT  CURRENCY, SUM(BALANCE) AS BALANCE, SUM(AVAILABLE) AS AVAILABLE"
                               ,",AVG(BUY) AS BUY, AVG(SELL) AS SELL, AVG(PRICE) AS PRICE"
                               ,",AVG(PRICEBUY) AS PRICEBUY, AVG(PRICESELL) AS PRICESELL"
                               ,",MIN(SINCE) AS SINCE, MAX(LAST) AS LAST")
            group = c("CURRENCY")
            sql(stmt, group=group)
        }
        ,getCameraPosition = function(camera, balance=FALSE, available=FALSE) {
            df = table(camera=camera)
            if (balance)   df = df[df$balance   > 0,]
            if (available) df = df[df$available > 0,]
            df
        }
        ,getCurrencyPosition = function(currency) { table(currency=currency) }
        ,getPosition = function(camera, currency) { table(camera= camera, currency=currency) }
        ,getCameras  = function() { uniques(c("camera")) }
     )
     ,private = list (
           key    = c("camera", "currency")
          ,fields = list(
              camera    = "CAMERA"
             ,currency  = "CURRENCY"
             ,balance   = "BALANCE"
             ,available = "AVAILABLE"
             ,price     = "PRICE"
             ,buy       = "BUY"
             ,sell      = "SELL"
             ,priceBuy  = "PRICEBUY"
             ,priceSell = "PRICESELL"
             ,since     = "SINCE"
             ,last      = "LAST"
             ,cc        = "CC"
          )
     )
)
