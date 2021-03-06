# Devuelve una instancia de un proveedor de datos
ProviderFactory = R6::R6Class("FACTORY.PROVIDER"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = FALSE
   ,public = list(
       initialize = function(dbf) {
          # le pasamos la factoria para que obtenga sus datos
#           if (!missing(external)) private$provNames = c(private$provNames, external)
            if (missing(dbf)) dbf = YATADB::YATADBFactory$new()
            private$dbf  = dbf
#            private$EUR = get("EUR", "Euro")
            # Por ahora vamos a tirar de MarketCap
            private$mktcap = PROVMarketCap$new("MKTCAP", NULL, dbf)
        }
       ,finalize = function() {
          private$providers = NULL
          private$dbf = NULL
          private$config = NULL
        }
       ,get = function(code, provider, force=FALSE) {
          private$mktcap
           # if (force) {
           #     createProvider(code, provider)
           # } else {
           #   if (is.null(private$providers$get(provider)))
           #       providers$put(provider, createProvider(code, provider))
           #   private$providers$get(provider)
           # }
       }
      ,setOnlineInterval = function(value) { private$config$interval     = value }
      ,setCloseTime      = function(value) { private$config$closeTime    = value }
      ,setBaseCurrency   = function(value) { private$config$baseCurrency = value }

   )
   ,private = list(
       providers = HashMap$new()
      ,dbf    = NULL
      ,EUR    = NULL
      ,mktcap = NULL
      ,config = list()
      ,createProvider = function (code, provider) {
         eval(parse(text=paste0("PROV", provider, "$new(code, EUR, dbf=dbf)")))
      }
   )

)
