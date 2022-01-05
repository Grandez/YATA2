library(R6)
IND_LinearTrend <- R6Class("IND_LinearTrend", inherit=IND__BASE,
   public = list(
        name="Linear trend"
       ,symbolBase="LT"
       ,symbol="LT"
       ,slope = 0.0
       ,initialize = function(parms=NULL) {
           super$initialize(NULL)
           self$target$value = self$target$CLOSE
       }
       ,calculate = function(TSession) {
           pos = private$getColPosition(TSession$df)

           l  = list(x=seq(1,nrow(TSession$df),1),y=TSession$df[,pos])
           df = as.data.frame(l, col.names=c("x","y"))
           private$model = lm(y ~ x, df)
           # Calculo de la pendiente
           range = abs(TSession$df[nrow(TSession$df),pos] - TSession$df[1,pos])
           self$slope = private$model$coefficients["x"] * 100 / range
       }
       ,plot = function(p, xAxis) {
           attr=private$line.attr
           line.attr = private$line.attr.equ
           if (private$model$coefficients["x"] < 0) line.attr = private$line.attr.neg
           if (private$model$coefficients["x"] > 0) line.attr = private$line.attr.pos
           val = private$model %>% fitted.values()
           YATACore::plotLine(p, x=xAxis, y=val, attr=private$line.attr, title = self$symbol)
       }
       # ,calculateAction    = function(case, portfolio) {
       #     lInd = self$getIndicators()
       #     ind  = lInd[[self$symbol]]
       #     dfi  = as.data.frame(ind$result[[1]])
       #     dft  = case$tickers$df
       #
       #     fila     = case$current
       #     pCurrent = dft[fila, DF_PRICE]
       #     pInd     = dfi[fila, 1]
       #
       #     if (is.na(pInd) || pInd == 0 || pCurrent == pInd) return (c(0,100,100))
       #
       #     var = pCurrent / pInd
       #     if (var == 1) return (c(0,100,100))
       #
       #     prf = case$profile$profile
       #     thres = ifelse(var > 1,private$thresholds[["sell"]],private$thresholds[["buy"]])
       #     action = applyThreshold(prf, var, thres)
       #     action
       # }
       # ,calculateOperation = function(portfolio, case, action) {
       #     reg = case$tickers$df[case$current,]
       #     cap = portfolio$saldo()
       #     pos = portfolio$getActive()$position
       #     sym = case$config$symbol
       #
       #     # Por temas de redondeo, el capital puede ser menor de 0
       #     if (action[1] > 0 && cap  > 1)  return (YATAOperation$new(sym, reg[1,DF_DATE], cap,      reg[1,DF_PRICE]))
       #     if (action[1] < 0 && pos  > 0)  return (YATAOperation$new(sym, reg[1,DF_DATE], pos * -1, reg[1,DF_PRICE]))
       #     NULL
       # }

    )
    ,private = list(
         model = NULL
        # Sets the dash style of lines.
        #Set to a dash type string ("solid", "dot", "dash", "longdash", "dashdot", or "longdashdot")
        #or a dash length list in px (eg "5px,10px,2px,2px").
        ,line.attr.equ = list( color="rgb(0, 0, 0)",  width = 1,dash = "solid")
        ,line.attr.pos = list( color="rgb(0, 255, 0)",width = 1,dash = "solid")
        ,line.attr.neg = list( color="rgb(255, 0, 0)",width = 1,dash = "solid")
    )
)


