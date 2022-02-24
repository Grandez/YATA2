restCheck = function() {
   url = "http://127.0.0.1:4001/"
   url = paste0(url,"alive")
   tryCatch({httr::http_error(httr::GET(url))}, error = function(e) TRUE)
}
PUT   = function(endpoint, ...) { # PUT No devuelve datos
   url = "http://127.0.0.1:4001/"
   url = paste0(url, endpoint)
   future({ httr::GET(url, query = args2list(...)) })
}
PUTSync = function(endpoint, ...) {
   url = "http://127.0.0.1:4001/"
   url = paste0(url, endpoint)
   httr::GET(url, query = args2list(...))
}
GETDF = function (endpoint, ...) { future({ .restDfBody(endpoint, ...)}) }

restdf      = function(endpoint, ...) { future({ .restDfBody(endpoint, ...)}) }
restdfSync  = function(endpoint, ...) {          .restDfBody(endpoint, ...)   }
.restDfBody = function(endpoint, ...) {
    url = "http://127.0.0.1:4001/"
    url = paste0(url, endpoint)

    req = httr::GET(url, query = args2list(...))
    if (req$status_code == 200) {
        json = httr::content(req, type="application/json", encoding="UTF-8")
        as.data.frame(jsonlite::fromJSON(json))
    }
    else {
       httr::content(req, type="text/html", encoding="UTF-8")
    }
}
