IND_Slope <- R6Class("IND_Slope", inherit=IND__Base,
    public = list(
       name="Slope"
      ,symbol="SLOPE"
      ,initialize = function() { super$initialize() }
      ,calculate = function(TTickers, date) {
          ##JGG Falta ajustar los periodos si no es un dia
          ######################################################################
          # 1.- Obtener el valor de i para los datos
          #     (Cf / Ci) = (1 + i) ^ n
          # 2.- Si (Cf / ci ) < 1 Es un interes negativo, hacemos el inverso
          # 3.- Calculamos la variacion para el caso n = 180 (v)
          # 4.- La tangente es el log en base 2 de v
          # 5.- Si el interes era negativo, la pendiente es negativa
          ######################################################################
          xt = private$getXTS(TTickers, pref=0)
          n  = nrow(xt)
          Ci = xt[1,TTickers$PRICE]
          v0 = (xt[n,TTickers$PRICE] / Ci)
          v  = v0 - 1

          if (v0 < 1) v = (1 / v0) - 1

          i = (2 ^ (v / n)) - 1 # interes original
          v = (1 + i) ^ 180     # 180 (PI) es un valor fijo

          slope = log2(v)
          rad   = atan(slope)
          alpha = 180 * rad / pi

          if (v0 < 1) alpha = alpha * -1
          alpha
      }
   )
)
