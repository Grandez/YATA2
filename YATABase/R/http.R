YATAHTTP = R6::R6Class("YATA.R6.HTTP"
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,portable   = FALSE
   ,public = list(
      get = function(url) {
         private$resp = httr::GET(url)
         resp
      }
      ,text    = function(resp) { httr::content(resp, as="text") }
      ,content = function(resp) { httr::content(resp)            }
   )
   ,private = list(
      resp = NULL
   )
)
