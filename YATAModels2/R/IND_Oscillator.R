library(R6)
IND_Oscillator <- R6Class("IND_Oscillator", inherit=IND__BASE,
                  public = list(
                      name="Mobile Average"
                      ,symbolBase="MA"
                      ,symbol="MA"
                      ,initialize         = function() { super$initialize() }
                      ,calculateAction    = function(case, portfolio) {
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
                      ,calculateOperation = function(portfolio, case, action) {
                          reg = case$tickers$df[case$current,]
                          cap = portfolio$saldo()
                          pos = portfolio$getActive()$position
                          sym = case$config$symbol

                          # Por temas de redondeo, el capital puede ser menor de 0
                          if (action[1] > 0 && cap  > 1)  return (YATAOperation$new(sym, reg[1,DF_DATE], cap,      reg[1,DF_PRICE]))
                          if (action[1] < 0 && pos  > 0)  return (YATAOperation$new(sym, reg[1,DF_DATE], pos * -1, reg[1,DF_PRICE]))
                          NULL
                      }
                  )
                  ,private = list(
                  )
)


