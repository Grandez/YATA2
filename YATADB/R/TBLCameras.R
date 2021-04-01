TBLCameras = R6::R6Class("TBL.CAMERAS"
    ,inherit    = YATATableSimple
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,public = list(
        initialize = function(name, db=NULL) {
            super$initialize(name, fields=private$fields, db=db)
          }
         ,getCameras = function(all=FALSE) { getTable(all)  }
         ,getCameraNames = function(codes, full=FALSE) {
            df = table()
            if (!missing(codes) && length(codes) > 0) {
                df = df[df$id %in% codes,]
            }
            else {
                df = df[df$active == YATACodes$flag$active,]
            }
            df$f = df$name
            if (full) df$f = paste(df$id,df$name, sep=" - ")
            data = as.list(df$id)
            names(data) = df$f
            data
        }
     )
     ,private = list (
           key = c("id")
          ,fields = list(
              id     = "CAMERA"
             ,name   = "NAME"
             ,active = "ACTIVE"
             ,maker  = "MAKER"
             ,taker  = "TAKER"
             ,token  = "TOKEN"
             ,usr    = "USR"
             ,pwd    = "PWD"
             ,icon   = "ICON"
             ,url    = "URL"
          )

     )
)
