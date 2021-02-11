IND_BBandS <- R6Class("IND_BBandS", inherit=IND_MA,
   public = list(
        name="Bollinger Bands Simple"
       ,symbol="BBS"
       ,initialize = function(parms=NULL) {
           super$initialize(NULL)
           self$target$value = self$target$CLOSE
           super$initialize(c(sd=0.74, maType="EMA"))
       }
       ,calculate = function(TSession) {
           window = self$getParameter("window")
           sd     = self$getParameter("sd")
           maType = self$getParameter("maType", "EMA")
           xt     = private$getXTS(TSession)
           pos    = private$getColPosition(xt)

           bb = TTR::BBands(xt[,pos], n=window, maType=maType, sd=sd)
           private$data = as.data.frame(bb[(window + 1):nrow(bb),])
           private$setDataTypes("ctc", c("dn", "mavg", "up"))
           private$setDataTypes("percentage", "pctB")
           private$setColNames()
       }

       ,plot = function(p, xAxis) {
           attr=private$line.attr
           line.attr = private$line.attr.equ
           if (private$model$coefficients["x"] < 0) line.attr = private$line.attr.neg
           if (private$model$coefficients["x"] > 0) line.attr = private$line.attr.pos
           val = private$model %>% fitted.values()
           YATACore::plotLine(p, x=xAxis, y=val, attr=private$line.attr, title = self$symbol)
       }


        # ,plot = function(p, TTickers) {
        #     if (nrow(private$data) == 0) return(p)
        #     cols = c("dn", "mavg", "up")
        #     texts = c(self$symbol, "Down", "Average", "Up")
        #     YATACore::plotLines(p, TTickers$df[,self$xAxis], private$data[,private$setColNames(cols)], hoverText=texts)
        # }

   )
)
