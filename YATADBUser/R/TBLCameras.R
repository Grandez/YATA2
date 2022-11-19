TBLCameras = R6::R6Class("TBL.CAMERAS"
    ,inherit    = YATATableSimple
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,public = list(
        initialize = function(name, db=NULL) {
            super$initialize(name, private$tblName, fields=private$fields, db=db)
          }
         ,getCameras = function(all=FALSE) { getTable(all)  }
         ,getCameraNames = function(codes, full=FALSE) {
            df = table()
            df = df[df$active == YATACodes$flag$active,]
            if (!missing(codes) && length(codes) > 0) {
                df = df[df$id %in% codes,]
            }
            df$f = df$name
            if (full) df$f = paste(df$id,df$name, sep=" - ")
            data = as.list(df$id)
            names(data) = df$f
            data
        }
     )
     ,private = list (
           tblName = "CAMERAS"
          ,key = c("id")
          ,fields = list(
              camera   = "CAMERA"
             ,name     = "NAME"
             ,exchange = "EXCHANGE"
             ,active   = "ACTIVE"
             ,token    = "TOKEN"
             ,usr      = "USR"
             ,pwd      = "PWD"
             ,CC       = "CC"
          )
     )
)
