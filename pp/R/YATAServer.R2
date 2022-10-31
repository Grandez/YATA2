# Lo hacemos clase para configurarlo
YATAServer = R6::R6Class("YATA.SERVER"
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,portable   = FALSE
  ,public = list(
     initialize = function(factory, type) {
         tryCatch({
            private$factory  = factory
            servers = factory$parms$getServers()
            if (missing(type)) type = "REST"
            private$parms = servers[[type]]
            private$.url = paste0(parms$url, ":", parms$port, "/")
            private$http = YATAHTTP$new()
         }, error = function(cond) {
            message("ERROR CREATING YATAServer")
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
                prov = factory$getProvider() #JGG OJO por ahora siempre devuelve el mismo
                prov$getTrend()
             }, error = function(cond) {
                NULL
             }))
         }

         future_promise ({
            browser()
            prov = factory$getProvider() #JGG OJO por ahora siempre devuelve el mismo
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
     ,check      = function() {
        url = paste0(.url, "alive")
        req = http$get(url)
        ifelse(is.null(req), 97, 0) # 99 - ERROR NO Server
     }
  )
  ,private = list(
      parms = NULL
     ,http = NULL
    ,.url  = NULL
    ,factory  = NULL
    ,.restDfBody = function(endpoint, ...) {
        url = paste0(.url, endpoint)
        req = http$get(url, parms = args2list(...))
        if (is.null(req)) return (NULL)
        if (req$status_code == 200) {
            json = httr::content(req, type="application/json", encoding="UTF-8")
            as.data.frame(jsonlite::fromJSON(json))
        } else {
            httr::content(req, type="text/html", encoding="UTF-8")
        }
    }
  )
)
