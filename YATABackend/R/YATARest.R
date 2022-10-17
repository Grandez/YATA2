YATARest = R6::R6Class("YATA.BACKEND.REST"
    ,inherit    = RestRserve::Application
    ,lock_class = TRUE
    ,public = list(
        initialize = function(port, logLevel, logOuput) {
            cat("Initializing YATAREST\n")
            super$initialize()
            self$logger$set_log_level("all")
            private$initREST()
            private$setMiddleware()
            cat("Init hecho")
            # private$setDoc()
        }
        ,getPort = function() {
            servers = factory$parms$getServers()
            servers$REST$port
         }
    )
   ,private = list(
        factory = NULL
       ,initREST = function() {
         super$add_get ("/alive"    , handler_alive)
         super$add_get ("/best"     , get_best)
         super$add_get ("/history"  , get_history)
         super$add_get ("/latest"   , latest_handler)
         super$add_get ("/trending" , latest_handler)

       }
      ,setMiddleware = function() {
         json_middleware = Middleware$new( process_response = function(.req, .res) {
             .res$content_type = "application/json"}
        )
        self$append_middleware(json_middleware)
      }
       # ,setDoc = function() {
       #     doc_file = system.file("doc/yatarest.yaml", package = packageName())
       #     super$add_openapi(path = "/yatarest.yaml", file_path = doc_file)
       #     super$add_swagger_ui(path = "/doc", path_openapi = "/yatarest.yaml", use_cdn = TRUE)
       # }
   )
)
