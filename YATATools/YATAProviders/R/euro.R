# Provider para la cotizacion del Euro
# No devulve cotizacion de fines de semana y no ordena
PROVEuro2 = R6::R6Class("PROV.EURO"
   ,inherit    = ProviderBase
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = FALSE
   ,public = list(
      initialize = function(code, eurusd, path, config) {
           super$initialize(code, "Euro", eurusd, path, config)
      }
      ,finalize = function() {
         browser()
      }
      ,exchanges = function(base, from, to) {
         url = urlbase
#         if (base == "EUR") {
            url = paste0(url, sprintf("/history?start_at=%s&end_at=%s", from, to))
#         }
         resp = get(url)
         data = resp[[1]]
         tms = names(data)
         names(data) = NULL
         df = ldply(data, data.frame)
         base = rep(base, nrow(df))
         df = cbind(tms, base, df)
         df$tms = as.POSIXct(df$tms)
         df = df[,c(1,2,which(colnames(df) == "USD"))]
         df$USD = 1 / df$USD
         df
      }
      ,getCloseSession = function(base, counter, day) {
          url = paste0(urlbase, "/", day)
          resp = get(url)
          resp$rates[[counter]]
      }
      ,getSessionDays = function(from, to) { exchanges("EUR", as.Date(from), as.Date(to)) }
      ,latest = function(base, counter) {
         if (base == "EUR") {
            url = paste0(urlbase, "/latest")
         }
         else {
            url = paste0(urlbase, sprintf("/latest?base=%s", base))
         }
         resp = get(url)
         resp$rates[[counter]]
      }
   )
   ,private = list(last=NULL
       ,urlbase = "https://api.exchangeratesapi.io"
   )
)
