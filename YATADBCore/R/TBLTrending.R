TBLTrending = R6::R6Class("TBL.TRENDING"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,public = list(
        initialize    = function(name,  db=NULL) {
           super$initialize(name, tblName, fields=private$fields, db=db)
        }
     )
     ,private = list (
         tblName = "TRENDING"
        ,fields = list(
             period     = "PERIOD"
            ,prty       = "PRTY"
            ,id         = "ID"
            ,symbol     = "SYMBOL"
            ,type       = "TYPE"
            ,price      = "PRICE"
            ,marketcap  = "MKTCAP"
            ,rank       = "RANK"
            ,pvar01     = "PVAR01"
            ,pvar07     = "PVAR07"
            ,pvar30     = "PVAR30"
            ,vvar01     = "VVAR01"
            ,tms        = "TMS"
          )
         ,key    = c("period", "prty", "id")
     )
)
