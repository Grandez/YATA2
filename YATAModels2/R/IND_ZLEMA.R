source("R/IND_MA.R")

IND_ZLEMA <- R6Class("IND_ZLEMA", inherit=IND_MA,
   public = list(
         name="Zero Lag Exponential Moving Average"
        ,symbol="ZLEMA"
        ,initialize = function() {
           super$initialize(list(window=7))
           ind1 = YATAIndicator$new( self$name, self$symbol, type=IND_LINE, blocks=3
                                    ,parms=list(window=7))
           private$addIndicators(ind1)
        }
       # ,calculate <- function(data, ind, columns, n, offset, sigma) {
       ,calculate = function(data, ind) {
           if (ind$name != self$name) return (super$calculate(data, ind))
           xt=private$getXTS(data)
           n      = private$parameters[["window"]]
           res1 = TTR::ZLEMA(xt[,data$PRICE] ,n)
           res2 = TTR::ZLEMA(xt[,data$VOLUME],n)

           list(list(private$setDF(res1, ind$columns)), list(private$setDF(res2, paste0(ind$columns, "_v"))))
        }

   )
)


