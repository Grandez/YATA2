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
            stmt = "SELECT CURRENCY, SUM(BALANCE) AS BALANCE, SUM(AVAILABLE) AS AVAILABLE, AVG(PRICE) AS PRICE"
            group = c("CURRENCY")
            sql(stmt, group=group)
        }
        ,getCameraPosition = function(camera, balance=FALSE, available=FALSE) {
            df = table(camera=camera)
            if (balance)   df = df[df$balance   > 0,]
            if (available) df = df[df$available > 0,]
            df
        }
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
             ,tms       = "TMS"
             ,cc        = "CC"
          )
     )
)
