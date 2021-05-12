TBLSession = R6::R6Class("TBL.SESSION"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,public = list(
          initialize    = function(name,  db=NULL) {
             super$initialize(name, fields=private$fields, db=db)
          }
          ,update    = function(data, append=TRUE) {
              bulkAdd(data, append=append, isolated=TRUE)
              execRaw("UPDATE SESSION_CTRL SET TMS = CURRENT_TIMESTAMP", isolated=TRUE);
          }
          ,getLastUpdate = function() {
              df = queryRaw("SELECT TMS FROM SESSION_CTRL")
              if (nrow(df) == 0) {
                  df = sql("SELECT MAX(TMS) AS TMS")
                  if (is.na(df)) return(as.POSIXct(0, origin="1970-01-01"))
              }
              df[1,1]
           }
          ,getLatest     = function() {
              last = getLastUpdate()
              if (is.na(last)) return (data.frame())
              table(tms=last)
           }
     )
     ,private = list (
         fields = list(
             id        = "ID"
            ,symbol    = "SYMBOL"
            ,price     = "PRICE"
            ,rank      = "RANK"
            ,hour      = "VAR01"
            ,day       = "VAR24"
            ,week      = "VAR07"
            ,month     = "VAR30"
            ,bimonth   = "VAR60"
            ,quarter   = "VAR90"
            ,volume    = "VOLUME"
            ,volday    = "VOL24"
            ,volweek   = "VOL07"
            ,volmonth  = "VOL30"
            ,dominance = "DOMINANCE"
            ,turnover  = "TURNOVER"
            ,tms       = "TMS"
          )
     )
)
