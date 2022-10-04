TBLCurrencies = R6::R6Class("TBL.CURRENCIES"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,public = list(
          initialize    = function(name,  db=NULL) {
              super$initialize(name, tblName, fields=private$fields, db=db)
#              private$hMap = YATABase$map
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
         ,getCurrencyNames = function() {
             df = table(active = 1)
             df = df[,c("symbol", "name", "rank")]
             colnames(df) = c("id", "name", "rank")
             df
         }
         # ,getID = function (symbol) {
         #     id = hMap$get(symbol)
         #     if (is.null(id)) {
         #         df = table(symbol=symbol)
         #         if (nrow(df) > 0) {
         #             id = df[1,"id"]
         #             hMap$put(symbol, id)
         #         }
         #     }
         #     id
         # }
     )
     ,private = list (
           tblName = "CURRENCIES"
          ,fields = list(
              id       = "ID"
              ,name    = "NAME"
              ,symbol  = "SYMBOL"
              ,slug    = "SLUG"
              ,token   = "TOKEN"
              ,rank    = "RANK"
              ,decimals= "DECIMALS"
              ,icon    = "ICON"
              ,since   = "SINCE"
              ,first   = "FIRST"
              ,last    = "LAST"
              ,active  = "ACTIVE"
              ,mktcap  = "MKTCAP"
              ,tms     = "TMS"
          )
#         ,hMap = NULL
         ,getData = function(codes, all) {
             params = list(active = YATACodes$flag$active)
             if (all) params = list()
             if (missing(codes) || length(codes) == 0) {
                 df = table(params) # Fuerza el IN
             }
             else {
                 if (is.vector(codes)) codes = as.list(codes)
                 df = table(params, inValues=list(id=codes)) # Fuerza el IN
             }
             df
         }

     )
)
