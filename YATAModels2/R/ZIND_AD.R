IND_AD <- R6Class("IND_AD", inherit=IND__Base,
    public = list(
        name="Accumulation/Distribution"
        ,symbol="AD"
        ,initialize = function() { super$initialize() }
        ,calculate = function(TTickers, date) {
            threshold  = self$getParameter("threshold")
            if (!(threshold < 1 )) threshold = threshold / 100
            xt     = private$getXTS(TTickers, pref=prev)

            private$data = (xt[,TTickers$CLOSE] - xt[,TTickers$OPEN]) * xt[,TTickers$VOLUME] /
                           (xt[,TTickers$HIGH]  - xt[,TTickers$LOW])
            colnames(private$data) = self$symbol
            private$setDataTypes("number", self$symbol)
            private$calcVariation(self$symbol)
        }
        # Dibuja sus graficos
        ,plot = function(p, TTickers) {
            if (!is.null(private$data)) {
                p = YATACore::plotLine(p, TTickers$df[,self$xAxis], private$data[,self$symbol],hoverText=self$symbol)
            }
            p
        }

    )
)
