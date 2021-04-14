YATAREST = R6::R6Class("YATA.REST"
    ,inherit    = RestRserve::Application
    ,lock_class = TRUE
    ,public = list(
        initialize = function() {
            cat("Initializing YATAREST\n")
            super$initialize()
            private$factory = YATACore::YATAFACTORY$new()
            private$initREST()
            private$setDoc()
        }
        ,getPort = function() { private$factory$parms$getRESTPort() }
    )
   ,private = list(
        factory = NULL
       ,initREST = function() {
         super$add_get("/alive", FUN = function(.req, .res) { .res$set_body("OK") })
         super$add_get("/best"   , best_handler)
         super$add_get("/hist"   , hist_handler)
         super$add_get("/latest" , latest_handler)
         super$add_get("/update" , update_handler)
       }
       ,setDoc = function() {
           doc_file = system.file("doc/yatarest.yaml", package = packageName())
           super$add_openapi(path = "/yatarest.yaml", file_path = doc_file)
           super$add_swagger_ui(path = "/doc", path_openapi = "/yatarest.yaml", use_cdn = TRUE)
       }
   )
)
