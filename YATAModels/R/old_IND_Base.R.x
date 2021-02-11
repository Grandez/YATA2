
IND_Base <- R6Class("IND_Base",
                   public = list(
                        name="Modelo abstracto"
                       ,symbolBase="NONE"
                       ,symbol="NONE"
                       ,colPrice="Close"
                       ,indicators=NULL
                       ,setParameters             = function(parms)   { private$.parameters = private$.replaceList(private$.parameters, parms) }
                       ,getParameters             = function()        { private$.parameters }
                       ,getIndicators             = function()        { list() }
                       ,setThresholds             = function(parms)   { private$.replaceList(private$.thresholds, parms) }
                       ,createPrimaryIndicators   = function(data)    {stop("This class is virtual") }
                       ,createSecondaryIndicators = function(data)    {stop("This class is virtual") }
                       ,calculateAction           = function(cartera, caso, reg) { stop("This class is virtual") }
                       ,calculateOperation        = function(cartera, caso, reg, action) { stop("This class is virtual") }
                       ,createIndicatorsSecondary = function(data)  { data }
                       ,createIndicatorsTerciary  = function(data)  { data }
                       ,plotIndicatorsSecondary   = function(plots) { plots }
                       ,plotIndicatorsTerciary    = function(plots) { plots }
                       ,getRmdDoc                 = function()      { stop("This class is virtual") }
                       ,print = function() {
                           cat(self$name)
                       }
                       ,createIndicatorsPrimary = function(data) {
                           d = data[,c("Date", self$colPrice, "Volume")]
                           colnames(d) <- c("date", "price", "volume")
                           d$date = as.Date(d$date)
                           d$pmm = 0
                           d$oper = 0
                           v0 <- rollapply(d$price, 2
                                           , function(x) return (((x[2] / x[1]) - 1) * 100)
                                           , fill=NA, align="right")

                           cbind(d, v0)
                       }
                       ,plotIndicatorsPrimary     = function(plots, names) {
                           if ("lm" %in% names) plots[1][[1]] = plots[1][[1]] +
                                                                geom_smooth(method="lm", na.rm=T)
                           return (plots)
                       }
                       ,plotNamesPrimary   = function() { "lm" }
                       ,plotNamesSecondary = function() {      }
                       ,plotNamesTerciary  = function() {      }

                   )

                  ,private = list(
                        .parameters = list()
                       ,.thresholds = list()
                       ,.replaceList = function(lista, data) {
                         idx = 1
                         while (idx <= length(data)) {
                             lista[[idx]] = data[idx]
                             idx = idx + 1
                         }
                         lista
                       }
                      # Function used by children objects
                      ,.getParameters = function(reg) {
                          parms = list()
                          names = c()
                          idx=5 # Los parametros empiezan en la 5
                          while (idx <= ncol(reg)) {
                              if (!is.na(reg[1,idx])) {
                                  parms[length(parms) + 1] = reg[1,idx]
                                  names=c(names, reg[1,idx-1])
                                  idx  = idx + 2  # Nombre/valor
                              }
                              else {
                                  names(parms) = names
                                  return (parms)
                              }
                          }
                          NULL
                      }

                  )
)

