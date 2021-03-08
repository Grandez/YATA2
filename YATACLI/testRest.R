unloadNamespace("YATAREST")
unloadNamespace("YATABatch")
unloadNamespace("YATACore")
unloadNamespace("YATAProviders")
unloadNamespace("YATADB")
unloadNamespace("YATATools")
library(RestRserve)
library(YATAREST)

rest = YATAREST$new()

# request = Request$new(path = "/best", parameters_query = list(top=15,from=7))
request = Request$new(path = "/latest")
response = rest$process_request(request)

browser()
cat("Response status:", response$status)
#> Response status: 200 OK
cat("Response body:", response$body)
#> Response body: 55