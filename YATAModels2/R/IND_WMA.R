source("R/IND_MA.R")

IND_WMA <- R6Class("IND_WMA", inherit=IND_MA,
   public = list(
         name="Weigthed Moving Average"
        ,symbol="WMA"
        ,initialize = function() {
           super$initialize(list(window=7,offset=0.5,sigma=6))
           ind1 = YATAIndicator$new( self$name, self$symbol, type=IND_LINE, blocks=3
                                    ,parms=list(window=7,  offset=0.5,  sigma=6))
           private$addIndicators(ind1)
        }
       # ,calculate <- function(data, ind, columns, n, offset, sigma) {
       ,calculate = function(data, ind) {
           if (ind$name != "ALMA") return (super$calculate(data, ind))
           xt=private$getXTS(data)
           n      = private$parameters[["window"]]
           offset = private$parameters[["offset"]]
           sigma  = private$parameters[["sigma" ]]
           res1 = TTR::ALMA(xt[,data$PRICE] ,n,offset,sigma)
           res2 = TTR::ALMA(xt[,data$VOLUME],n,offset,sigma)

           list(list(private$setDF(res1, ind$columns)), list(private$setDF(res2, paste0(ind$columns, "_v"))))
        }
   )
)


