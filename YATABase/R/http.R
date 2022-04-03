YATAHTTP = R6::R6Class("YATA.R6.HTTP"
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,portable   = FALSE
   ,public = list(
      get = function (url, parms=NULL, headers=NULL, accept = 0) {
         # accept indica el bloque de errores a aceptar
         # 0 - 200: Solo OK
         heads = character()
         prms=NULL
         if (!is.null(headers)) heads=headers
         if (!is.null(parms))   prms = parms

         page = httr::GET(url, add_headers(.headers=headers), query=prms)
         private$rc = checkResponse("get", page, url, parms, accept)
         page
      }
     ,json = function (url, parms=NULL, headers=NULL, accept = 400) {
         page = get(url, parms, headers, accept)
         resp = httr::content(page, type="application/json")
         resp$data
      }
     ,html = function(url, parms=NULL, headers=NULL, accept = 400) {
         page = get(url, parms=NULL, headers=NULL, accept = 400)
         httr::content(page, as="parsed")
     }
     ,html_table = function(url, parms=NULL, headers=NULL, accept = 500) {
         resp = html(url)
         if (rc != 0) return (NULL)

         tables = resp %>% rvest::html_elements("table")
         tables = tables %>% rvest::html_table()
         tables[[1]] %>% data.frame()
      }
   )
   ,private = list(
       resp = NULL
      ,rc = 0
      ,checkResponse = function(method, page, url, parms, accept) {
         rc = (page$status_code %/% 100) * 100
         if (rc == 0 || rc == 200) return (0)
         # Hacemos el trycatch para grabar siempre el error
         tryCatch({
            YATABase:::HTTP( paste("HTTP ERROR:", resp$status$error_message)
                            ,action=method, code=page$status_code
                            ,origin=page$url, message=resp$status$error_message
                            ,parameters = parms
                           )
         }, error = function(cond){
            if (rc == accept || rc == 500) return (rc)
            YATABase:::propagateError(cond)
         })
      }

   )
)
