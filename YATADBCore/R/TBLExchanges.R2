# Tabla con los cambios que ofrece cada proveedor
TBLExchanges = R6::R6Class("TBL.EXCHANGES"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,public = list(
        initialize     = function(name, db=NULL) {
           super$initialize(name, fields=private$fields, db=db)
        }
        ,getExchangesForCameras = function(cameras) {
            table(inValues=list(id=cameras))
        }
     )
     ,private = list (
          fields = list(
               id     = "ID"
              ,symbol = "SYMBOL"
              ,name   = "NAME"
              ,slug   = "SLUG"
              ,icon   = "ICON"
              ,url    = "URL"
              ,rank   = "RANK"
              ,maker  = "MAKER"
              ,taker  = "TAKER"
              ,active = "ACTIVE"
          )
     )
)

