unloadNamespace("YATAREST")
unloadNamespace("YATACore")
unloadNamespace("YATAProviders")
unloadNamespace("YATADB")
library(RestRserve)
library(YATAREST)

rest = YATAREST$new()
# id=2010&convert=EUR&time_start=1612137600&time_end=1615248000"

#request = Request$new(path = "/alive")
#request = Request$new(path = "/update")
#request = Request$new(path = "/latest")
request = Request$new(path = "/best", parameters_query = list(top = 10))
#request = Request$new(path = "/top", parameters_query = list(top = 10))
#request = Request$new(path = "/hist", parameters_query = list(id = 3137, from='2021/02/13', to='2021-03-15'))
response = rest$process_request(request)

cat("Response status:", response$status, "\n")
#> Response status: 200 OK
cat("Response body:", response$body, "\n")
#> Response body: 55
