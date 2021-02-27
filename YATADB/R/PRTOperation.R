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
        ,update = function(lstData) {
            data = lstData
            operInfo = lstData[names(data) %in% names(fields)]
            #quitamos el id
            super$set(operInfo)
            super$apply()
            # quitamos precio y amount
            data$price = NULL
            data$amount = NULL
            ctrlInfo = data[names(data) %in% names(tblOperControl$getColNames())]
            tblOperControl$set(ctrlInfo)
            tblOperControl$apply()
            logInfo = list(idOper=current$id,logType=lstData$logType,reason=lstData$reason)
            tblOperLog$add(logInfo)
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
            super$select(id=idOper, create)
            tblOperControl$select(id=idOper, create)
        }
     )
     ,private = list (
         tblOperControl = NULL
        ,tblOperLog     = NULL
     )
)
