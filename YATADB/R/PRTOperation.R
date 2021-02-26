PRTOperations = R6::R6Class("PART.OPERATION"
    ,inherit    = TBLOperations
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
         initialize = function(name, db=NULL) {
             super$initialize(name, db=db)
             private$tblOperControl = TBLOperControl$new("OperControl", db)
             private$tblOperLog     = TBLOperLog$new("OperLog", db)
         }
        ,add = function(lstData) {
            super$add(lstData)
            tblOperControl$add(lstData)
            if (!is.null(lstData$comment)) {
                lstData$id = lstData$idLog
                tblOperLog$add(lstData)
                #JGG Falta el tipo de log
            }
        }
        ,getOperations = function(...) {
            df = super$table(...)
            if (nrow(df) > 0) {
                dfc = tblOperControl$table(inValues=list(id=as.list(df$id)))
                df = dplyr::left_join(df,dfc,by="id")
            }
            df
        }
        ,select = function(idOper) {
            super$select(id=idOper)
            tblOperControl$select(id=idOper)
        }
     )
     ,private = list (
         tblOperControl = NULL
        ,tblOperLog     = NULL
     )
)
