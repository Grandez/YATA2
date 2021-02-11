# Media Móvil Ponderada con retraso regulado usando una curva de distribución normal (o Gaussiana)
# como función de ponderación de coeficientes.

# Esta Media Móvil utiliza una curva de distribución Normal (Gaussiana) que puede ser puesta
# por el parámetro Offset de 0 a 1.
# Este parámetro permite regular la suavidad y la alta sensibilidad de la Media Móvil.
# Sigma es otro parámetro que es responsable de la forma de los coeficientes de la curva.

# Una descripción más detallada de ALMA se puede encontrar en el sitio web del autor.
# https://www.mql5.com/go?link=http://www.arnaudlegoux.com/

# Window size:
#    The Window Size is nothing but the look back period and this forms the basis of your ALMA settings.
#    You can use the ALMA window size to any value that you like,
#    although it is best to stick with the well followed parameters
#    such as 200, 100, 50, 20, 30 and so on based on the time frame of your choosing.

# Offset:
#    The offset value is used to tweak the ALMA to be more inclined towards responsiveness or smoothness.
#    The offset can be set in decimals between 0 and 1.
#    A setting of 0.99 makes the ALMA extremely responsive, while a value of 0.01 makes it very smooth.

#Sigma:
#    The sigma setting is a parameter used for the filter.
#    A setting of 6 makes the filter rather large while a smaller sigma setting makes it more focused.
#    According to Mr. Legoux, a sigma value of 6 is said to offer good performance.


# Formula
#   1/NORM SUM(i=1 hasta window) p(i)e elevado (i-offset)2 / sigma 2
#source(paste(YATAENV$modelsDir,"Model_MA.R",sep="/"))
source("R/IND_MA.R")

IND_ALMA <- R6Class("IND_ALMA", inherit=IND_MA,
   public = list(
         name="Arnaud Legoux moving average"
        ,symbol="ALMA"
        ,initialize = function() {
           super$initialize(list(window=7,offset=0.5,sigma=6))
           ind1 = YATAIndicator$new( self$name, self$symbol, type=IND_LINE, blocks=3
                                    ,parms=list(window=7,  offset=0.5,  sigma=6))
           private$addIndicators(ind1)
        }
       # ,calculate <- function(data, ind, columns, n, offset, sigma) {
       ,calculate = function(data, ind) {
           if (ind$name != self$symbol) return (super$calculate(data, ind))
           xt=private$getXTS(data)
           n      = private$parameters[["window"]]
           offset = private$parameters[["offset"]]
           sigma  = private$parameters[["sigma" ]]
           res1 = TTR::ALMA(xt[,data$PRICE] ,n,offset,sigma)
           res2 = TTR::ALMA(xt[,data$VOLUME],n,offset,sigma)

           list(list(private$setDF(res1, ind$columns)), list(private$setDF(res2, paste0(ind$columns, "_v"))))
        }
   )
)


