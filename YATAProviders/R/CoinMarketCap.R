# Ahi que crear un conjunto de cuentas para poder hacer peticiones
# 300 creditos dia
# 10000 creditos mes
PROVMarketCap = R6::R6Class("PROV.MARKETCAP"
   ,inherit    = ProviderBase
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = FALSE
   ,public = list(
       initialize = function(code, eurusd) { # }, dbf) {
          super$initialize  (code, "CoinMarketCap", eurusd) #, dbf)
          private$base    = YATABase$new()
          private$lastGet = as.POSIXct(1, origin="1970-01-01")
          private$hID     = base$map()
       }
      ,getIcons = function(maximum, force=FALSE) {
          urlbase = "https://s2.coinmarketcap.com/static/img/coins/200x200/"
          urlbase2 = "https://s2.coinmarketcap.com/static/img/coins/64x64/"
          if (missing(maximum)) maximum=9999
          oldwd = getwd()
          site = Sys.getenv("YATA_SITE")
          site = "P:/R/YATA2/"
          wd = file.path(site, "YATAExternal", "icons")
          setwd(wd)
          files = list.files()
          for (idx in 1:maximum) {
               png = paste0(idx, ".png")
               cat(png)
               if (length(which(files == png)) != 0 && !force) {
                   cat("\tExist\n")
                   next
               }
               resp = GET(paste0(urlbase, png), add_headers(.headers=headers), query=NULL)
               if (resp$status_code != 200) {
                   cat("\tKO\n")
               } else {
                 writeBin(resp$content, png)
                   cat("\tOK\n")
               }
          }
          setwd(oldwd)
      }
      ,getCurrencies = function(from = 1, max = 0) {
          url     = "https://api.coinmarketcap.com/data-api/v3/cryptocurrency/listing"
          count   =   0
          until   = 501
          dfc     = NULL
          process = TRUE
          parms = list( start=from, limit=500, convert = "EUR"
                       ,cryptoType="all", tagType="all")

          while (process) {
               if (count > 0) Sys.sleep(1) # Para no saturar
               data  = request(url, parms)
               until = ifelse (max == 0, data$totalCount, max)
               data  = data[[1]]
               parms$start = parms$start + length(data)

               lst = lapply(data, function(x) {
                      since = ifelse(is.null(x$dateAdded), x$lastUpdated, x$dateAdded)
                      since = paste(substr(since,1,10),substr(since,12,19), sep="-")
                      if (nchar(x$symbol) > 64) x$symbol = substr(x$symbol,1,64)
                      list( id=as.integer(x$id)
                           ,name=x$name
                           ,symbol=x$symbol
                           ,slug=x$slug
                           ,rank=as.integer(x$cmcRank)
                           ,since = since
                           ,icon = paste0(x$id, ".png")
                           ,active = as.integer(x$isActive)
                       )
                     })
               if (length(lst) > 0) {
                   df = data.frame( matrix(unlist(lst), nrow=length(lst), byrow=TRUE)
                                   ,stringsAsFactors=FALSE)
                   colnames(df) = names(lst[[1]])
                   dfc = rbind(dfc, df)
               }
               count = count + length(data)
               if (count >= until || length(data) < 500) process = FALSE
          }
          dfc
      }
      ,getTickers    = function(max = 0, from = 1) {
          url =  "https://api.coinmarketcap.com/data-api/v3/cryptocurrency/listing"
          until = from + 500
          dfc   = NULL
          parms = list( start=from, limit=500, convert = "EUR"
                       ,cryptoType="all", tagType="all")
          resp = list(total=0, from=0, count=0)
          while (parms$start < until) {
               if (parms$start > 1) Sys.sleep(1)
               data = request(url, parms)
               if (is.null(data) || length(data) == 0) break
               data2 = data[[1]]
               resp$total = data$totalCount
               resp$from  = parms$start
               resp$count = length(data2)
               until = ifelse (max == 0, data$totalCount, max)
               parms$start = parms$start + length(data2)

               lst = lapply(data2, function(x) {
                      quote = x$quotes[[1]]
                      list( id     = x$id
                           ,symbol = x$symbol
                           ,rank   = x$cmcRank
                           ,price  = ifelse(is.null(quote$price),            0, quote$price)
                           ,volume = ifelse(is.null(quote$volume24),         0, quote$volume24)
                           ,vol24  = ifelse(is.null(quote$volume24),         0, quote$volume24)
                           ,vol07  = ifelse(is.null(quote$volume7d),         0, quote$volume7d)
                           ,vol30  = ifelse(is.null(quote$volume30d),        0, quote$volume30d)
                           ,var01  = ifelse(is.null(quote$percentChange1h),  0, quote$percentChange1h)
                           ,var24  = ifelse(is.null(quote$percentChange24h), 0, quote$percentChange24h)
                           ,var07  = ifelse(is.null(quote$percentChange7d),  0, quote$percentChange7d)
                           ,var30  = ifelse(is.null(quote$percentChange30d), 0, quote$percentChange30d)
                           ,var60  = ifelse(is.null(quote$percentChange60d), 0, quote$percentChange60d)
                           ,var90  = ifelse(is.null(quote$percentChange90d), 0, quote$percentChange90d)
                           ,dominance = ifelse(is.null(quote$dominance),     0, quote$dominance)
                           ,turnover  = ifelse(is.null(quote$turnover),      0, quote$turnover)
                           ,tms = paste(substr(quote$lastUpdated,1,10),substr(quote$lastUpdated,12,19), sep="-")
                      )
                     })
               df = data.frame( matrix(unlist(lst), nrow=length(lst), byrow=TRUE)
                               ,stringsAsFactors=FALSE)
               colnames(df) = c( "id",        "symbol",  "rank", "price"
                                ,"volume",    "volday",   "volweek", "volmonth"
                                ,"hour",      "day",      "week",    "month"
                                ,"bimonth",   "quarter"
                                ,"dominance", "turnover", "tms")

               names = colnames(df)
               for (idx in 1:ncol(df)) {
                   if (names[idx] == "id")     { df[,idx] = as.numeric(df[,idx]); next }
                   if (names[idx] == "rank")   { df[,idx] = as.numeric(df[,idx]); next }
                   if (names[idx] == "symbol") { next }
                   if (names[idx] == "tms")    { df[,idx] = as.POSIXct(df[,idx]); next }
                   df[,idx] = as.numeric(df[,idx])
               }
               dfc = rbind(dfc, df)

          }
          resp$df = dfc
          resp
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
      ,unloadCurrencies = function(from, limit) {
         getLatest(from, limit)
      }
      ,getHistorical = function(idCurrency, from, to ) {
          if (is.null(idCurrency)) return(NULL)
          url = "https://web-api.coinmarketcap.com/v1/cryptocurrency/ohlcv/historical"

          headers = c(
             `User-Agent`      = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:86.0) Gecko/20100101 Firefox/86.0"
            ,`Accept-Language` = "es-ES,es;q=0.8,en-US;q=0.5,en;q=0.3"
            ,Accept          = "application/json, text/plain, */*"
            ,Origin          = "https://coinmarketcap.com"
            ,Referer         = "https://coinmarketcap.com/"
            ,TE              = "Trailers"
         )
         parms = list(
             convert    = "EUR"
            ,id         = idCurrency
            ,time_start = as.numeric(as.POSIXct(from))
            ,time_end   = as.numeric(as.POSIXct(to))
         )

         page = GET(url, add_headers(.headers=headers), query=parms)

         # 1 - Header response / 2 - Data
         resp = httr::content(page, type="application/json")
         if (http_error(page)) {
             base:::HTTP( "ERROR GET HISTORICAL", action="GET"
                         ,origin=resp$error_code, message=resp[[1]]$error_message)
         }

         body = resp[[2]]
         data = body[[4]] # 1 - id / 2 - name / 3 - symbol / 4 - data


         data2 = lapply(data, function(x) x[[5]])
         data3 = lapply(data2, function(x) x[[1]])
         df1 = as.data.frame(sapply(data3, unlist))
         df = t(df1)
         row.names(df) = NULL
         df = as.data.frame(df)
         if (nrow(df) == 0) return (NULL)
         # La ultima columna es el timestamp
         df[,"timestamp"] = paste(substr(df[,"timestamp"],1,10),substr(df[,"timestamp"],12,19), sep="-")
         df
      }
   )
   ,private = list(
       urlbase = "https://coinmarketcap.com/"
      ,hID     = NULL
      ,base    = NULL
      ,headers = c( `User-Agent`      = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:86.0) Gecko/20100101 Firefox/86.0"
                   ,`Accept-Language` = "es-ES,es;q=0.8,en-US;q=0.5,en;q=0.3"
                   ,Accept          = "application/json, text/plain, */*"
                   ,Origin          = "https://coinmarketcap.com"
                   ,Referer         = "https://coinmarketcap.com/"
                   ,TE              = "Trailers"
      )

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
      ,request = function (url, parms) {
          if (missing(parms) || is.null(parms)) {
              page = httr::GET(url, add_headers(.headers=headers))
          } else {
             page = httr::GET(url, add_headers(.headers=headers), query=parms)
          }
         resp = httr::content(page, type="application/json")

         if (http_error(page) || resp$status$error_code != 0) {
             data = resp$status
             status=list(code=data$error_code,message=data$error_message)
             YATABase$cond$HTTP( "HTTP Error", origin=page, action="get"
                                ,rc=resp$status$error_code
                                ,message = resp$status$error_message)
         }
         resp$status = NULL
         #JGG  Depurar la lista a devolver
         resp[[1]]
      }
   )
)

# Permite unas 10 peticiones dia
# https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?CMC_PRO_API_KEY=68886e75-9fd7-4566-8942-587220e58538&start=1&limit=5000&convert=USD

