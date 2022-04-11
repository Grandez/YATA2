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
            if (is.null(info$ctrl$amountIn))  info$ctrl$amountIn  = info$oper$amount
            if (is.null(info$ctrl$amountOut)) info$ctrl$amountOut = info$oper$amount
            if (is.null(info$ctrl$priceIn))   info$ctrl$priceIn   = info$oper$price
            if (is.null(info$ctrl$priceOut))  info$ctrl$priceOut  = info$oper$price
            tblOperControl$add(info$ctrl)
            if (!is.null(info$log$idLog)) tblOperLog$add(info$log)
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
            if (!is.null(current$idLog)) tblOperLog$add(info$log)
        }
        ,get = function(...) {
            df = super$table(...)
            if (nrow(df) > 0) {
                dfc = tblOperControl$table(inValues=list(id=as.list(df$id)))
                df = dplyr::left_join(df,dfc,by="id")
            }
            df
        }
        ,getInactives = function(camera, counter, from) {
            df = self$get(camera=camera, counter=counter, active=DBDict$flag$off)
            df[df$tms >= from,]
        }
        ,getClosed = function(camera, counter, from) {
            df = self$get(camera=camera, counter=counter,active=DBDict$flag$parent)
            df[df$tms >= from,]
        }
        ,select = function(idOper, create=FALSE) {
            super$select(id=idOper, create=create)
            tblOperControl$select(id=idOper, create=create)
        }
        ,getInactiveCounters = function(active) {
            df = uniques(c("camera", "counter"), list(active=active))
            df[df$camera != "XFER",]
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
