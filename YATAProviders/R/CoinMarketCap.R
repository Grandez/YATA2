# Ahi que crear un conjunto de cuentas para poder hacer peticiones
# 300 creditos dia
# 10000 creditos mes
PROVMarketCap = R6::R6Class("PROV.MARKETCAP"
   ,inherit    = ProviderBase
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = FALSE
   ,public = list(
       initialize = function(code, eurusd, path, config) {
          super$initialize(code, "CoinMarketCap", eurusd, path, config)
          private$lastGet = as.POSIXct(1, origin="1970-01-01")
          #getLatest()
       }
       ,loadTickers = function() {
           if (difftime(Sys.time(), lastGet, unit="mins") < interval) return (invisible(self))
           private$lastGet = Sys.time()
           getLatest()
       }
       ,getExchanges = function(txtID) {
          # Necesitamos una clave profesional
           stop("NO tenemos permiso")
           url = mountURL("exchange/quotes/latest")
           page = GET(url,add_headers("X-CMC_PRO_API_KEY" = info$token)
                         ,add_headers(Accept = "application/json")
                         ,query = list(id = txtID, convert = "EUR")
                     )

           json = content(page, type = "application/json")


       }
       ,getLatest = function() {
           makeList = function(item) {

              id=item$id
              name=item$name
              symbol=item$symbol
              eur = item$quote$EUR
              price      = ifelse(is.null(eur$price), 0, eur$price)
              change_1h  = ifelse(is.null(eur$percent_change_1h) , 0, eur$percent_change_1h)
              change_24h = ifelse(is.null(eur$percent_change_24h), 0, eur$percent_change_24h)
              change_7d  = ifelse(is.null(eur$percent_change_7d) , 0, eur$percent_change_7d)
              change_30d = ifelse(is.null(eur$percent_change_30d), 0, eur$percent_change_30d)
              change_60d = ifelse(is.null(eur$percent_change_60d), 0, eur$percent_change_60d)
              change_90d = ifelse(is.null(eur$percent_change_90d), 0, eur$percent_change_90d)
              volume     = ifelse(is.null(eur$volume_24h),         0, eur$volume_24h)
              list( id       = id
                   ,name     = name
                   ,symbol   = symbol
                   ,price    = price
                   ,change01 = change_1h
                   ,change24 = change_24h
                   ,change07 = change_7d
                   ,change30 = change_30d
                   ,change60 = change_60d
                   ,change90 = change_90d
                   ,volume   = volume
              )
           }
           url = mountURL("cryptocurrency/listings/latest")
           page = GET(url,add_headers("X-CMC_PRO_API_KEY" = info$token)
                         ,add_headers(Accept = "application/json")
                         ,query = list(start = 1, limit = 5000, convert = "EUR")
                     )

           json = content(page, type = "application/json")
           resp = json[[1]]
           data = json[[2]]
           l = lapply(data, function(item) makeList(item))
           df = data.frame(matrix(unlist(l), nrow=length(l), byrow=TRUE))
           df$X1 = as.integer(df$X1)
           for (col in 4:ncol(df)) df[,col] = as.numeric(df[,col])

           tms = Sys.time()
           dft = data.frame(tms=rep(tms, nrow(df)))
           df = cbind(dft, df)

           colnames(df) = c( "tms", "id", "name", "symbol", "price"
                            ,"change01", "change24", "change07"
                            ,"change30", "change60", "change90"
                            ,"volume")

           df[df$volume < 10, "volume"] = 0
           private$dfTickers = df
           df
        }
       ,getCurrencies = function(page) {
          url = urlbase
          if (!missing(page)) url = paste0(url, "?page=", page)
          page = tryCatch(read_html(url), error = function(cond) NULL )
          if (is.null(page)) return (NULL)
          tab = page %>% html_nodes("table")
          rows = tab %>% html_nodes("tr")
          data = lapply(rows, function(row) row %>% html_nodes("td"))

          # Coger las filas correctas
          cols = lapply(data, function(x) length(x))
          mask = (cols == 11)
          data = data[mask]

          # col 1 - Estrella
          # col 2 - orden
          # col 3 - Icono, nombre y simbolo
          # La columna 3 tiene nombre y simbolo en div o en span

          # Si busco img me da los 100 elementos
         sims = lapply(data, function(item) extractName(item[[3]]))
         df = as.data.frame(sims, optional=T)
         df = data.table::transpose(df)
         colnames(df) = c("name", "id")
         df
      }
   )
   ,private = list(
       urlbase = "https://coinmarketcap.com/"
      ,getPage = function(page) {

         # el paquete rvest hace cosas muy raras
         # Hacemos scrapping a pelo
         # La columna 3 tiene icono, nombre y simbolo
         # La 4 el precio
         # La 5 variacion diaria
         # La 6 variacion semanal
          url = urlbase
          if (!missing(page)) url = paste0(url, "?page=", page)
          page = httr::GET(url)
          page = content(page, "text")
          beg = str_locate(page, "<tbody")
          end = str_locate(page, "</tbody>")
          table = substr(page, beg[2]+1, end[1])
          rows = strsplit(table, "<tr", fixed=TRUE)
          rows = lapply(rows[[1]], function(x) strsplit(x, "<td", fixed=TRUE))
#           mask =
# lines = unlist(lapply(table, function(x) strsplit(table, "<tr", fixed=TRUE)))
#     datos = lines[grepl("coin-logo", lines, fixed=TRUE)]

          tab = page %>% html_nodes("table")
          rows = tab %>% html_nodes("tr")
          data = lapply(rows, function(row) row %>% html_nodes("td"))

          # Coger las filas correctas
          cols = lapply(data, function(x) length(x))
          mask = (cols == 11)
          data = data[mask]

          # col 1 - Estrella
          # col 2 - orden
          # col 3 - Icono, nombre y simbolo
          # La columna 3 tiene nombre y simbolo en div o en span

          # Si busco img me da los 100 elementos
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
         df
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
