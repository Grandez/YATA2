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
             id     = "ID"
            ,name   = "NAME"
            ,symbol = "SYMBOL"
            ,price  = "PRICE"
            ,volume = "VOLUME"
            ,slug   = "SLUG"
            ,rank   = "RANK"
            ,var01  = "VAR01"
            ,var24  = "VAR24"
            ,var07  = "VAR07"
            ,var30  = "VAR30"
            ,var60  = "VAR60"
            ,var90  = "VAR90"
            ,vol24  = "VOL24"
            ,vol07  = "VOL07"
            ,vol30  = "VOL30"
            ,dominance = "DOMINANCE"
            ,turnover  = "TURNOVER"
            ,tms       = "TMS"
          )
     )
)
