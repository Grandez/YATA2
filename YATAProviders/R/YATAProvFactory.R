# Devuelve una instancia de un proveedor de datos
ProviderFactory = R6::R6Class("FACTORY.PROVIDER"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = FALSE
   ,public = list(
       initialize = function(dbf) {
          # le pasamos la factoria
          # de hay saca la tabla de cadenas
#           if (!missing(external)) private$provNames = c(private$provNames, external)
            if (missing(dbf)) dbf = YATADB::YATADBFactory$new()
            private$path = dbf$getTable("Path")
            private$EUR = get("EUR", "Euro")
       }
            ,finalize = function() {
      }

       ,get = function(code, provider, force=FALSE) {
           if (force) {
               createProvider(code, provider)
           } else {
             if (is.null(private$providers$get(provider)))
                 providers$put(provider, createProvider(code, provider))
             private$providers$get(provider)
           }
       }
      ,setOnlineInterval = function(value) { private$config$interval     = value }
      ,setCloseTime      = function(value) { private$config$closeTime    = value }
      ,setBaseCurrency   = function(value) { private$config$baseCurrency = value }

   )
   ,private = list(
       providers = HashMap$new()
      ,EUR    =  NULL
      ,path   = NULL
      ,config = list(interval=100, closeTime=22, baseCurrency="EUR")
      ,createProvider = function (code, provider) {
         eval(parse(text=paste0("PROV", provider, "$new(code, EUR, path, config)")))
      }
   )

)
