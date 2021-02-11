
IND_DEMA <- R6Class("IND_DEMA", inherit=IND_MA,
     public = list(
          name="Double-Exponential Moving Average"
         ,symbol="DEMA"
         ,initialize = function() { super$initialize() }
         ,calculate = function(TTickers, date) {
             window = self$getParameter("window")
             xt     = private$getXTS(TTickers, pref=(window * 2))
             if (nrow(xt) < window) return (NULL)

             DEMA = TTR::DEMA(xt[,TTickers$PRICE], n=window, wilder=FALSE)
             private$data = as.data.frame(DEMA[((window * 2)+ 1):nrow(DEMA),])
             private$setDataTypes("ctc", "DEMA")
             private$calcVariation("DEMA")
             private$setColNames()
         }
         ,plot = function(p, TTickers) {
             if (nrow(private$data) == 0) return(p)
             col1 = private$setColNames(self$symbol)
             YATACore::plotLine(p, TTickers$df[,self$xAxis], private$data[,col1],hoverText=self$symbol)
         }

     )
)
