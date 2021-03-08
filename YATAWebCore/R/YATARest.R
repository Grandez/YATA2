restdf = function(endpoint, ...) {
   url = "http://127.0.0.1:9090/"
   url = paste0(url, endpoint)
   future({
      req = httr::GET(url, query = args2list(...))
      json = httr::content(req, type="application/json")
      as.data.frame(jsonlite::fromJSON(json))
   })
}
