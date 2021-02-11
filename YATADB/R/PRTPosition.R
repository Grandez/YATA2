PRTPosition = R6::R6Class("PART.POSITION"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
         initialize = function(name, db=NULL) {
             super$initialize(name, fields=private$fields,key=key, db=db)
             private$tblPosition       = TBLPosition$new("Position", db)
             private$tblRegularization = TBLRegularization$new("Regularization", db)

         }
        ,getGlobalPosition = function() {
            tblPosition$getGlobalPosition()
        }
        # ,getCameraPosition = function(camera, balance=FALSE, available=FALSE) {
        #     df = table(camera=camera)
        #     if (balance)   df = df[df$balance   > 0,]
        #     if (available) df = df[df$available > 0,]
        #     df
        # }
        # ,getPosition = function(camera, currency) { table(camera= camera, currency=currency) }
        ,getCameras  = function() { tblPosition$uniques(c("camera")) }

     )
     ,private = list (
           key    = c("camera", "currency")
          ,tblPosition = NULL
          ,tblRegularization = NULL
          ,fields = list(
              camera    = "CAMERA"
             ,currency  = "CURRENCY"
             ,balance   = "BALANCE"
             ,available = "AVAILABLE"
             ,buy       = "COST"
             ,net       = "NET"
             ,tms       = "TMS"
             ,cc        = "CC"
          )
     )
)
