YATAREST = R6::R6Class("YATA.REST"
    ,inherit    = RestRserve::Application
    ,lock_class = TRUE
    ,public = list(
        initialize = function() {
            super$initialize()
            private$factory = YATACore::YATAFACTORY$new()
            private$initREST()
        }
        ,getPort = function() { factory$getParms()$getRESTPort() }
    )
   ,private = list(
        factory = NULL
       ,initREST = function() {
         super$add_get("/alive", FUN = function(.req, .res) { .res$set_body("OK") })
         super$add_get("/best"  , best_handler)
         super$add_get("/latest", latest_handler)

# super$add_post(
#   path = "/addone",
#   FUN = function(.req, .res) {
#     result = list(x = .req$body$x + 1L)
#     .res$set_content_type("application/json")
#     .res$set_body(result)
#   })
#
#
       }
   )
)
