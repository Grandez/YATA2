# Objeto global para guardar la configuracion
# Y los objetos
# YATANS = function (namespace, id = NULL) {
#   # NS code
#     if (length(namespace) == 0)
#         ns_prefix <- character(0)
#     else ns_prefix <- paste(namespace, collapse = ns.sep)
#     f <- function(id) {
#         if (length(id) == 0)
#             return(ns_prefix)
#         if (length(ns_prefix) == 0)
#             return(id)
#         paste(ns_prefix, id, sep = ns.sep)
#     }
#     if (missing(id)) {
#         f
#     }
#     else {
#         f(id)
#     }
# }
YATAWebEnv = R6::R6Class("YATA.WEB.ENV"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,public = list(
      MSG = NULL
     ,initialize = function() {
        private$env = YATAFactory$getEnvironment()
        self$MSG = YATAFactory$getMSG()
        private$ctc = HashMap$new()
        private$tblCurrencies = YATAFactory$getTable(YATACodes$tables$Currencies)
     }
     ,getPanel = function(name)  { private$panels$get(name) }
     ,addPanel = function(panel) {
       private$panels$put(panel$name, panel)
       invisible(panel)
     }
    ,getCurrencyNames = function(codes, full = FALSE) {
        if (full) tblCurrencies$getFullNames(codes)
        else      tblCurrencies$getNames(codes)
    }
    ,currencyIcon = function(code) {
      env$currencies(code)
    }
  )
  ,private = list(
# Cada objeto representa una pagina
# De esta forma se gestiona la inicializacion de la pagina
# Y guardamos los datos temporales
      panels = HashMap$new()
     ,db = NULL
     ,env = NULL
     ,ctc = NULL
     ,tblCurrencies = NULL
  )
)
