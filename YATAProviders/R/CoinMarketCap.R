PROVMarketCap = R6::R6Class("PROV.MARKETCAP"
   ,inherit    = ProviderBase
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = FALSE
   ,public = list(
       initialize = function(code, eurusd, path, config) {
          super$initialize(code, "CoinMarketCap", eurusd, path, config)
          private$lastGet = as.POSIXct(1, origin="1970-01-01")
          getPage()
       }
       ,loadTickers = function() {
           if (difftime(Sys.time(), lastGet, unit="mins") < interval) return (invisible(self))
           private$lastGet = Sys.time()
           getPage()
       }
       ,getLatest = function() { getPage() }
   )
   ,private = list(
       urlbase = "https://coinmarketcap.com"
      ,getPage = function() {

          page <- read_html(urlbase)

          tab = page %>% html_nodes("table")
          rows = tab %>% html_nodes("tr")
          data = lapply(rows, function(row) row %>% html_nodes("td"))

          # Coger las filas correctas
          cols = lapply(data, function(x) length(x))
          mask = (cols == 11)
          data = data[mask]

          # La columna 3 tiene nombre y simbolo en div o en span

         sims = lapply(data, function(item) extractName(item[[3]]))
         df = as.data.frame(sims, optional=T)
         df = data.table::transpose(df)

         # Las columnas 4,5, 6 tienen precio, var 1 dia y 1 sem
         # Pueden estar en un div (si hay link) o en un span
         values = unlist(lapply(data, function(x) extractValues(x[[4]])))
         df = cbind(df,values)
         values = unlist(lapply(data, function(x) extractValues(x[[5]])))
         df = cbind(df,values)
         values = unlist(lapply(data, function(x) extractValues(x[[6]])))
         df = cbind(df,values)
         colnames(df) = c("base", "counter", "last", "var1", "var7")
         df$base = "EUR"
         private$dfTickers = df
      }
     ,adjustTicker = function(df) {
           # Pone los nombres esperados a las columnas
          df = df[,-1]
           colnames(df) = c("last", "lowest", "highest", "change", "baseVolume", "quoteVolume", "active", "high", "low")
           df$active = ifelse(df$active == 0, 1, 0)
           df
       }
      ,extractName = function(nodeset) {
          txt = c("", "")
          res = nodeset %>% html_nodes("p")
          if (length(res) == 0) {
              res = nodeset %>% html_nodes("span")
          }
          if (length(res) > 0) {
              tmp = res %>% html_text()
              ll = length(tmp)
              txt = c(tmp[ll-1],  tmp[ll])
          }
          txt
      }
      ,extractValues = function(nodeset) {
          res = 0.0
          res = nodeset %>% html_nodes("span") %>% html_text()
          if (length(res) == 0) {
              res = nodeset %>% html_nodes("div") %>% html_text()
          }
          if (length(res) > 1) res = res[1]
          if (length(res) != 0) {
              res = gsub("$", "", res, fixed=TRUE)
              res = gsub(",", "", res, fixed=TRUE)
              res = gsub("%", "", res, fixed=TRUE)
              res = as.numeric(res)
          }
          res
       }

   )
)

# Permite unas 10 peticiones dia
# https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?CMC_PRO_API_KEY=68886e75-9fd7-4566-8942-587220e58538&start=1&limit=5000&convert=USD
