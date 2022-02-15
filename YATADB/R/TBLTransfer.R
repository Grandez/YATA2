TBLTransfers = R6::R6Class("TBL.XFER"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,public = list(
          initialize    = function(name,  db=NULL) {
             super$initialize(name, fields=private$fields, key=private$key,db=db)
          }
     )
     ,private = list (
           fields = list(
               id        = "ID_XFER"
              ,cameraIn  = "CAMERA_IN"
              ,cameraOut = "CAMERA_OUT"
              ,currency  = "CURRENCY"
              ,amount    = "AMOUNT"
              ,value     = "VALUE"
              ,tms       = "TMS"
          )
     )
)
