library(R6)
IND_MA <- R6Class("IND_MA", inherit=IND__BASE,
   public = list(
        name="Mobile Average"
       ,symbolBase="MA"
       ,symbol="MA"
       ,initialize     = function(parms=NULL) {
           super$initialize(c(threshold=3, window=7))
           self$target$value = self$target$CLOSE
       }
       ,hasData = function() { TRUE }
       ,getData = function() { private$dfVal }
       ,calculateAction    = function(date) {
           # Obtiene el registro
           rec = which(private$dfDate == date)

           if (private$applyThreshold(rec)) return(0)

           if (action == 0) return(action)
           # si es engativo mirar threshold compra
           # si es positivo mirar threshold venta

           if (abs(private$dfVar[rec]) < threshold) return (0)
           # Calcular el porcentaje dependeindo de si esta subiendo o bajando y del numero de ciclo
           # Hay que pensar que
           #    Si esta empezando a bajar hay que lanzar un señal de alarma alta
           lInd = self$getIndicators()
           ind  = lInd[[self$symbol]]
           dfi  = as.data.frame(ind$result[[1]])
           dft  = case$tickers$df

           fila     = case$current
           pCurrent = dft[fila, DF_PRICE]
           pInd     = dfi[fila, 1]

           if (is.na(pInd) || pInd == 0 || pCurrent == pInd) return (c(0,100,100))

           var = pCurrent / pInd
           if (var == 1) return (c(0,100,100))

           prf = case$profile$profile
           thres = ifelse(var > 1,private$thresholds[["sell"]],private$thresholds[["buy"]])
           action = applyThreshold(prf, var, thres)
           action
       }
    #    ,calculateOperation = function(portfolio, case, action) {
    #        reg = case$tickers$df[case$current,]
    #        cap = portfolio$saldo()
    #        pos = portfolio$getActive()$position
    #        sym = case$config$symbol
    #
    #        # Por temas de redondeo, el capital puede ser menor de 0
    #        if (action[1] > 0 && cap  > 1)  return (YATAOperation$new(sym, reg[1,DF_DATE], cap,      reg[1,DF_PRICE]))
    #        if (action[1] < 0 && pos  > 0)  return (YATAOperation$new(sym, reg[1,DF_DATE], pos * -1, reg[1,DF_PRICE]))
    #        NULL
    #    }
     )
    ,private = list(
          cycleBuy = 0
         ,cycleSell = 0
         ,calcPercentage = function(data) {
             var = ((data / private$dfVal[, 1]) - 1) * 100
             private$dfVar = as.data.table(var, keep.rownames = F)
             private$dfVar[, 1] = as.percentage(private$dfVar[, 1])
         }
         # Cuenta las veces que la variacion es positiva o negativa
         # acumulandola
         # Quita los ceros y obtiene la mediana
        ,calcCycle  = function(data) {
            # rollapply no vale
            # Ahi que recacular esto
            tmp = data
            tmp[is.na(tmp)] = 0
            res = rep(0,length(tmp))
            last = 0
            for (rec in 2:length(res)) {
                if (tmp[rec] == 0) vv = 0
                if (tmp[rec] >  0) {
                    vv = ifelse (tmp[rec - 1] >= 0, last + 1,  1)
                    tmp[rec - 1] = 0
                    tmp[rec]     = vv
                }
                if (tmp[rec] <  0) {
                    vv = ifelse (tmp[rec - 1] <= 0, last - 1, -1)
                    tmp[rec - 1] = 0
                    tmp[rec]     = vv
                }
                last = vv
                res[rec] = last
            }
            private$cycleSell = median(res[res > 0])
            private$cycleBuy  = median(res[res < 0])
        }

    )
)


