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
             id      = "ID"
            ,name    = "NAME"
            ,symbol  = "SYMBOL"
            ,price   = "PRICE"
            ,slug    = "SLUG"
            ,rank    = "RANK"
            ,hour    = "VAR01"
            ,day     = "VAR24"
            ,week    = "VAR07"
            ,month   = "VAR30"
            ,bimonth = "VAR60"
            ,quarter = "VAR90"
            ,volume  = "VOLUME"
            ,volday   = "VOL24"
            ,volweek  = "VOL07"
            ,volmonth = "VOL30"
            ,dominance = "DOMINANCE"
            ,turnover  = "TURNOVER"
            ,tms       = "TMS"
          )
     )
)
