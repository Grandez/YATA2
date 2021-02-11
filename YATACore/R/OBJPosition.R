OBJPosition = R6::R6Class("OBJ.POSITION"
    ,inherit    = OBJBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        print           = function() { message("Positions Object")}
       ,initialize      = function() {
           super$initialize()
           private$prtPosition = YATAFactory$getTable(YATACodes$tables$Position)
       }
       ,getCameras = function() {
          df = prtPosition$getCameras()
          as.list(df[,1])
       }
       ,getGlobalPosition = function() {
          df = prtPosition$getGlobalPosition()
          df$value = df$balance * df$price
          yataSetClasses(df)
       }
       ,getPosition     = function(camera, currency) {
           df = prtPosition$getPosition(camera, currency)
           df
       }
       ,getCameraPosition = function(camera, balance=FALSE, available = FALSE) {
           df = prtPosition$getCameraPosition(camera, balance, available)
           df$value = df$balance * df$price
           yataSetClasses(df, dat=c(6))
       }
      ##################################################
      ### Caches
      ##################################################
    )
    ,private = list(
        prtPosition  = NULL
    )
)
