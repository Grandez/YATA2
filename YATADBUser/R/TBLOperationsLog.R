TBLOperLog   = R6::R6Class("TBL.OPER.LOG"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
          initialize = function(name,db=NULL) {
             super$initialize( name, private$tblName, fields=private$fields,key=private$key,db=db)
          }
          ,add = function(data) {
              # En la tabla de log solo grabamos si hay informacion util
              if ((!is.null(data$reason) && data$reason != 0) || !is.null(data$comment)) {
                  super$add(data)
              }
              invisible(self)
          }
     )
     ,private = list (
           tblName = "OPERATIONS_LOG"
          ,key = c("id", "tms")
          ,fields = list(
              id       = "ID_OPER"
             ,idLog    = "ID_LOG"
             ,tms      = "TMS"
             ,logType  = "TYPE"
             ,reason   = "REASON"
             ,comment  = "COMMENT"
            )
     )
)
