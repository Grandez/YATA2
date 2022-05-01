# Lo hacemos clase para configurarlo
YATAServer = R6::R6Class("YATA.SERVER"
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,portable   = FALSE
  ,public = list(
     initialize = function(type) {
         tryCatch({
            private$fact  = WEB$factory # YATACore::getFactory()
            servers = fact$parms$getServers()
            if (missing(type)) type = "REST"
            private$parms = servers[[type]]
            private$.url = paste0(parms$url, ":", parms$port, "/")
            private$http = YATAHTTP$new()
         }, error = function(cond) {
            YATABase:::error( "Error initializing object"
                            ,subclass=NULL, origin=cond, action="YATARest")
         })
     }
     ,GET   = function(endpoint, ...) {
         .restDfBody(endpoint, ...)
         # future({ .restDfBody(endpoint, ...)})
      }
     ,PUT   = function(endpoint, ...) {
        future({ .restDfBody(endpoint, ...)})
        invisible(self)
      }
     ,GETSync    = function(endpoint, ...) {          .restDfBody(endpoint, ...)   }
     ,GETDF      = function(endpoint, ...) { future({ .restDfBody(endpoint, ...)}) }
     ,DF         = function(endpoint, ...) { future({ .restDfBody(endpoint, ...)}) }
     ,trending   = function(sync=FALSE) {
         if (sync) {
             return (tryCatch({
                prov = fact$getProvider() #JGG OJO por ahora siempre devuelve el mismo
                prov$getTrend()
             }, error = function(cond) {
                NULL
             }))
         }

         future_promise ({
            browser()
            prov = fact$getProvider() #JGG OJO por ahora siempre devuelve el mismo
            df = prov$getTrend()
         }) %>% then (
            onFulfilled = function(df) {
               browser()
               df
            }
           ,onRejected = function(err) {
             browser()
             NULL
        })
     }
  )
  ,private = list(
      parms = NULL
     ,http = NULL
    ,.url  = NULL
    ,fact  = NULL
    ,.restDfBody = function(endpoint, ...) {
        browser()
        url = paste0(.url, endpoint)
        req = http$get(url, parms = args2list(...))

        if (req$status_code == 200) {
            json = httr::content(req, type="application/json", encoding="UTF-8")
            as.data.frame(jsonlite::fromJSON(json))
        } else {
            httr::content(req, type="text/html", encoding="UTF-8")
        }
    }
  )
)
