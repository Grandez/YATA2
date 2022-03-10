# Lo hacemos clase para configurarlo
YATARest = R6::R6Class("YATA.REST"
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,portable   = FALSE
  ,public = list(
     initialize = function(type) {
        fact  = YATACore::YATAFACTORY$new()
        servers = fact$parms$getServers()
        if (missing(type)) type = "REST"
        private$parms = servers[[type]]
        private$.url = paste0(parms$url, ":", parms$port, "/")
     }
     ,restCheck = function() {
         tryCatch({
             httr::GET(paste0(.url,"alive"))
             0
            },error = function(e) {
             99
            })
      }
     ,PUT   = function(endpoint, ...) { # PUT No devuelve datos
         url = paste0(.url, endpoint)
         future({ httr::GET(url, query = args2list(...)) })
      }
     ,POST   = function(endpoint, ...) { # PUT No devuelve datos
         url = paste0(.url, endpoint)
         future({ httr::GET(url, query = args2list(...)) })
      }
     ,PUTSync = function(endpoint, ...) {
         url = paste0(.url, endpoint)
         httr::GET(url, query = args2list(...))
      }
     ,GETDF      = function(endpoint, ...) { future({ .restDfBody(endpoint, ...)}) }
     ,DF         = function(endpoint, ...) { future({ .restDfBody(endpoint, ...)}) }
     ,restdfSync = function(endpoint, ...) {          .restDfBody(endpoint, ...)   }
  )
  ,private = list(
      parms = NULL
    ,.url = NULL
    ,.restDfBody = function(endpoint, ...) {
        url = paste0(.url, endpoint)

        req = httr::GET(url, query = args2list(...))
        if (req$status_code == 200) {
            json = httr::content(req, type="application/json", encoding="UTF-8")
            as.data.frame(jsonlite::fromJSON(json))
        } else {
            httr::content(req, type="text/html", encoding="UTF-8")
        }
    }
  )
)
