IND_OBV <- R6Class("IND_OBV", inherit=IND__Base,
    public = list(
        name="On-Balance Volume"
        ,symbol="OBV"
        ,initialize = function() { super$initialize() }
        ,calculate = function(TTickers, date) {
            threshold  = self$getParameter("threshold")
            if (!(threshold < 1 )) threshold = threshold / 100
            xt     = private$getXTS(TTickers, pref=prev)

            calcVar = function(x) {
                res = x[2] / x[1]
                if (res > (1.0 + threshold)) return (+1)
                if (res < (1.0 - threshold)) return (-1)
                return (0)
            }

            var = rollapply(private$data[,TTIckers$PRICE],  2, calcVar, fill=0, align="right")
            prevVol = rbind(private$data[1,TTIckers$VOLUME], private$data[1:nrow(private$data)-1,TTIckers$VOLUME])
            prevVol = prevVol * var

            private$data = private$data[,TTIckers$VOLUME] + prevVol
            applySign = function(x) {
                if (sign(x[2]) == sign(x[1])) return (0)
                if (sign(x[1]) == -1) return (+1)
                return (-1)
            }

            nFast  = self$getParameter("nfast")
            nSlow  = self$getParameter("nslow")
            nSig   = self$getParameter("nsig")
            maType = self$getParameter("matype", "EMA")
            prev   = max(nFast, nSlow, nSig)
            xt     = private$getXTS(TTickers, pref=prev)

            if (nrow(xt) < prev) return (NULL)

            tryCatch({
                macd = TTR::MACD(xt[,TTickers$PRICE], nFast, nSlow, nSig, maType=maType)
                private$data = as.data.frame(macd[(prev + 1):nrow(macd),])
                private$setDataTypes("number", c("macd", "signal"))
                private$calcVariation("macd")
                private$data[,"act"] = rollapply(private$data[,"var"],  2, applySign, fill=0, align="right")
                private$setColNames()
            }
            ,error = function(e) { return (NULL) }
            )
        }
        # Dibuja sus graficos
        ,plot = function(p, TTickers) {
            if (!is.null(private$data)) {
                p = YATACore::plotBar (p, TTickers$df[,self$xAxis], private$data[,private$setColNames("macd")],hoverText=self$symbol)
                p = YATACore::plotLine(p, TTickers$df[,self$xAxis], private$data[,private$setColNames("signal")],hoverText=c(self$symbol, "Signal"))
            }
            p
        }

    )
)
