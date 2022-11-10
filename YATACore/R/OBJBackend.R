OBJBackend = R6::R6Class("YATA.OBJ.CORE.BACKEND"
    ,inherit    = OBJBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        print           = function() { message("Backend Object")}
       ,initialize      = function(factory) {
           super$initialize(factory)
       }
      ,latest = function (id) {
         parms = NULL
         if (!missing(id)) parms = list(id=id)
         makeGet("latest", parms)
      }
      ,names = function (...) {
          args = list(...)
          data = paste(unlist(args), collapse=";")
          makePost("names", data)
      }
      ,currencies = function (type=c("all", "currency", "token"), all=FALSE) {
         parms = NULL
         if (missing(type)) type = "all"
         type = match.arg(type)
         all = ifelse(all, "true", "false")
         makeGet("currencies", list(type=type, all=all))
      }
    )
    ,private = list(
        url = "http://127.0.0.1:5000"
       ,http = YATAHTTP$new()
       ,makeGet = function(endpoint, parms) {
           data = private$http$get(paste(url, endpoint, sep="/"), parms=parms)
           if (data$status_code != 200) {
               browser()
               stop("error en el get de backend")
           }
           RcppSimdJson::fparse(httr::content(data))
       }
       ,makePost = function(endpoint, data, type) {
           http = YATAHTTP$new()
           if (missing(type)) type = "text/plain"
           data = http$post(paste(url, endpoint, sep="/"), body=data, type=type)
           if (data$status_code != 200) {
               browser()
               stop("error en el get de backend")
           }
           RcppSimdJson::fparse(httr::content(data))
       }

    )
)
