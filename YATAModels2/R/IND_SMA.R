source("R/IND_MA.R")

IND_SMA <- R6Class("IND_SMA", inherit=IND_MA,
   public = list(
       # Es mas comodo sobreescribir las variables
        name="Media movil simple"
       ,symbol="SMA"
       ,initialize = function(parms=NULL) { super$initialize(parms) }
       ,calculate  = function(TSession) {
           xt=private$getXTS(TSession)
           pos = private$getColPosition(xt)

           private$calcValue(xt[,pos])
           private$calcPercentage(xt[,pos])
           private$calcCycle(private$dfVar[,1])
       }
       ,plot = function(p, xAxis) {
           YATACore::plotLine(p, x=xAxis, y=private$dfVal[,1], attr=private$line.attr, title = self$symbol)
       }

   )
   ,private = list(
       line.attr = list( color="rgb(22, 96, 167)",width = 1,dash = "dash")
       ,calcValue = function(data) {
           win   = private$parameters[["window"]]
           val = TTR::SMA(data ,n=win)
           private$dfVal      = as.data.table(val, keep.rownames = F)
           private$dfVal[, 1] = as.fiat(private$dfVal[, 1])
       }

   )

)


