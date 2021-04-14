restCheck = function() {
   url = "http://127.0.0.1:9090/"
   url = paste0(url,"alive")
   tryCatch({httr::http_error(httr::GET(url))}, error = function(e) TRUE)
}
PUT   = function(endpoint, ...) {
   url = "http://127.0.0.1:9090/"
   url = paste0(url, endpoint)
   message("GET: ", url)
   future({ httr::GET(url, query = args2list(...)) })
}
restdf = function(endpoint, ...) {
   url = "http://127.0.0.1:9090/"
   url = paste0(url, endpoint)
#   message("GET: ", url)
   future({
      req = httr::GET(url, query = args2list(...))
      if (req$status_code == 200) {
          json = httr::content(req, type="application/json")
          as.data.frame(jsonlite::fromJSON(json))
      }
      else {
          httr::content(req)
      }

   })
}
# Para debug
restdfsync = function(endpoint, ...) {
   url = "http://127.0.0.1:9090/"
   url = paste0(url, endpoint)
   req = httr::GET(url, query = args2list(...))
   if (req$status_code == 200) {
       json = httr::content(req, type="application/json")
       as.data.frame(jsonlite::fromJSON(json))
   }
   else {
       httr::content(req)
   }
}
