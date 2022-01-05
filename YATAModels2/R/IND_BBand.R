source("R/IND_MA.R")

IND_BBand <- R6Class("IND_BBand", inherit=IND_MA,
   public = list(
         name="Bollinger Bands"
        ,symbol="BB"
        ,initialize = function() { super$initialize() }
        ,calculate = function(TTickers, date) {
            window = self$getParameter("window")
            sd     = self$getParameter("sd")
            maType = self$getParameter("matype", "EMA")
            xt     = private$getXTS(TTickers, pref=window)
            if (nrow(xt) < window) return (NULL)
            bb = TTR::BBands(xt[,TTickers$PRICE], n=window, maType=maType, sd=sd)
            private$data = as.data.frame(bb[(window + 1):nrow(bb),])
            private$setDataTypes("ctc", c("dn", "mavg", "up"))
            private$setDataTypes("percentage", "pctB")
            private$setColNames()
        }
        ,plot = function(p, TTickers) {
            if (nrow(private$data) == 0) return(p)
            cols = c("dn", "mavg", "up")
            texts = c(self$symbol, "Down", "Average", "Up")
            YATACore::plotLines(p, TTickers$df[,self$xAxis], private$data[,private$setColNames(cols)], hoverText=texts)
        }

   )
)
