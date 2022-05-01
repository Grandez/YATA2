TBLSession = R6::R6Class("TBL.SESSION"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,public = list(
          initialize    = function(name,  db=NULL) {
             super$initialize(name, fields=private$fields, db=db)
          }
          ,update    = function(data) {
              bulkAdd(data, append=TRUE)
          }
          ,getLatest = function() {
              qry = "SELECT * FROM SESSION AS A"
              subquery = "(SELECT ID AS ID, MAX(LAST) AS LAST FROM SESSION GROUP BY ID) AS B"
              where = "WHERE A.ID = B.ID AND A.LAST = B.LAST"
              query = paste(qry, ",", subquery, where)
              df = queryRaw(query)
              df[,1:(ncol(df) - 2)]
          }
     )
     ,private = list (
         fields = list(
             id        = "ID"
            ,symbol    = "SYMBOL"
            ,token     = "TOKEN"
            ,rank      = "RANK"
            ,price     = "PRICE"
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
            ,last      = "LAST"
          )
     )
)
