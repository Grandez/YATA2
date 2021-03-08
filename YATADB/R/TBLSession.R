TBLSession = R6::R6Class("TBL.SESSION"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,public = list(
          initialize    = function(name,  db=NULL) {
             super$initialize(name, fields=private$fields, db=db)
          }
          ,update    = function(data, append=FALSE) {
              bulkAdd(data, append=append, isolated=TRUE)
          }
          ,getLastUpdate = function() {
              df = sql("SELECT MAX(TMS) AS TMS")
              as.list(df)
           }
          ,getLatest     = function() {
              last = getLastUpdate()
              if (is.na(last)) return (data.frame())
              df = table(tms=last)
              df
           }
     )
     ,private = list (
         fields = list(
             symbol   = "SYMBOL"
            ,tms      = "TMS"
            ,name     = "NAME"
            ,id       = "ID"
            ,price    = "PRICE"
            ,change01 = "CHANGE01"
            ,change24 = "CHANGE24"
            ,change07 = "CHANGE07"
            ,change30 = "CHANGE30"
            ,change60 = "CHANGE60"
            ,change90 = "CHANGE90"
            ,volume   = "VOLUME"
          )
     )
)
