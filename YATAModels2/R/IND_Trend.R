library(R6)
IND_Trend <- R6Class("IND_Trend", inherit=IND__BASE,
   public = list(
        name="Linear trend"
       ,symbolBase="LT"
       ,symbol="LT"
       ,plot.attr = list( colors=c("#FF0000","#00FF00")
                         ,sizes=c(1,2,3)
                         ,styles=c("dashed", "dashed"))
       ,initialize = function(parms=NULL) { super$initialize(parms) }
       ,calculate = function(TTickers, date) {
           l  = list(x=seq(1,nrow(TTickers$df),1),y=TTickers$df[,self$target])
           df = as.data.frame(l, col.names=c("x","y"))
           private$model = lm(y ~ x, df)
       }
       ,plot = function(p, TTickers) {
           val = private$model %>% fitted.values()
           line.attr=list( color=self$plot.attr[["colors"]][1]
                          , width=self$plot.attr[["sizes"]][1])
           p = p %>% add_trace(x=TTickers$df[,self$xAxis], y=val, line=line.attr)
           p
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
    )
)


