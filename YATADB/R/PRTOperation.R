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
            info = splitFields(lstData)
            super$add(info$oper)
            tblOperControl$add(info$ctrl)
            tblOperLog$add(info$log)
        }
        ,update = function(lstData) {
            info = splitFields(lstData)
            super$set(info$oper)
            super$apply()
            info$ctrl$price  = NULL   # quitamos precio y amount
            info$ctrl$amount = NULL   # Solo se informan en add
            tblOperControl$set(info$ctrl)
            tblOperControl$apply()
            info$log$id = current$id
            tblOperLog$add(info$log)
        }
        ,getOperations = function(...) {
            df = super$table(...)
            if (nrow(df) > 0) {
                dfc = tblOperControl$table(inValues=list(id=as.list(df$id)))
                df = dplyr::left_join(df,dfc,by="id")
            }
            df
        }
        ,select = function(idOper, create=FALSE) {
            super$select(id=idOper, create=create)
            tblOperControl$select(id=idOper, create=create)
        }
     )
     ,private = list (
         tblOperControl = NULL
        ,tblOperLog     = NULL
        ,splitFields    = function(data) {
            operInfo = data[names(data) %in% names(fields)]
            ctrlInfo = data[names(data) %in% names(tblOperControl$getColNames())]
            logInfo  = data[names(data) %in% names(tblOperLog$getColNames())]
            list(oper=operInfo, ctrl=ctrlInfo,log=logInfo)
        }
     )
)
