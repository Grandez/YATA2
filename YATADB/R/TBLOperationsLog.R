TBLOperLog   = R6::R6Class("TBL.OPER.LOG"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
          initialize = function(name,db=NULL) {
             super$initialize( name,fields=private$fields,key=private$key,db=db)
         }
     )
     ,private = list (
           key = c("idOper", "idLog")
          ,fields = list(
              idOper = "ID_OPER"
             ,idLog  = "ID_LOG"
             ,type   = "TYPE"
             ,tms    = "TMS"
             ,comment   = "COMMENT"
            )
     )
)
