source("R/IND_Oscillator.R")

IND_MACD <- R6Class("IND_MACD", inherit=IND_Oscillator,
    public = list(
       name="Convergence-Divergence Average Mobile"
      ,symbol="MACD"
      ,initialize = function() { super$initialize() }
      ,calculate = function(TTickers, date) {
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
