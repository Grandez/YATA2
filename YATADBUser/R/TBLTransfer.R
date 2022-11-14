TBLTransfers = R6::R6Class("TBL.XFER"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,public = list(
          initialize    = function(name,  db=NULL) {
             super$initialize(name, private$tblName, fields=private$fields, key=private$key,db=db)
          }
     )
     ,private = list (
          tblName = "TRANSFERS"
         ,fields = list(
             id        = "ID"
            ,cameraIn  = "CAMERA_IN"
            ,cameraOut = "CAMERA_OUT"
            ,currency  = "CURRENCY"
            ,amount    = "AMOUNT"
            ,price     = "PRICE"
            ,date      = "DATEOPER"
            ,tms       = "TMS"
         )
     )
)
