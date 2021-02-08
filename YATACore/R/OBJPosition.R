OBJPosition = R6::R6Class("OBJ.POSITION"
    ,inherit    = OBJBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        print           = function() { message("Positions Object")}
       ,initialize      = function() {
           super$initialize()
           private$tblPosition = YATAFactory$getTable(YATACodes$tables$Position)
       }
       ,getCameras = function() {
          df = tblPosition$getCameras()
          as.list(df[,1])
       }
       ,getGlobalPosition = function() {
          df = tblPosition$getGlobalPosition()
          df$value = df$balance * df$price
          yataClasses(df)
       }
       ,getPosition     = function(camera, currency) {
           df = tblPosition$getPosition(camera, currency)
           browser()
           df
       }
       ,getCameraPosition = function(camera, balance=FALSE, available = FALSE) {
           df = tblPosition$getCameraPosition(camera, balance, available)
           df$value = df$balance * df$price
           yataClasses(df, dat=c(6))
       }
      ##################################################
      ### Caches
      ##################################################
    )
    ,private = list(
        tblPosition  = NULL
    )
)
