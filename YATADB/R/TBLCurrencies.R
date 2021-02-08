TBLCurrencies = R6::R6Class("TBL.CURRENCIES"
    ,inherit    = YATATableSimple
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,public = list(
          initialize    = function(name,  db=NULL) {
             super$initialize(name, fields=private$fields, db=db)
          }
          ,getNames     = function(codes, all=FALSE) {
              df = getData(codes, all)
              df[,c("id", "name")]
          }
          ,getFullNames = function(codes, all=FALSE) {
              df = getNames(codes, all)
              df$name = paste(df$id, "-", df$name)
              df
          }
     )
     ,private = list (
           fields = list(
              id        = "SYMBOL"
              ,name     = "NAME"
              ,decimals = "DECIMALS"
              ,active   = "ACTIVE"
              ,prty     = "PRTY"
              ,fee      = "FEE"
              ,icon     = "ICON"
          )
         ,getData = function(codes, all) {
             parms = list(active = YATACodes$flag$active)
             if (all) parms = list()
             if (missing(codes) || length(codes) == 0) {
                 df = table(parms) # Fuerza el IN
             }
             else {
                 if (is.vector(codes)) codes = as.list(codes)
                 df = table(parms, inValues=list(id=codes)) # Fuerza el IN
             }
             df
         }

     )
)
