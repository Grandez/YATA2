# Ahi que crear un conjunto de cuentas para poder hacer peticiones
# 300 creditos dia
# 10000 creditos mes
PROVMarketCap = R6::R6Class("PROV.MARKETCAP"
   ,inherit    = ProviderBase
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = FALSE
   ,public = list(
       initialize = function(code, eurusd, dbf) {
          super$initialize  (code, "CoinMarketCap", eurusd, dbf)
          private$lastGet = as.POSIXct(1, origin="1970-01-01")
          private$hID     = HashMap$new()
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
      ,getLatest = function(start=1, max=1000) {
         browser()
          limit = 1000 # Max items per connection
          max = start + max
          dfl = NULL

          while(start < max) {
             lst = requestLatest(start, 1000)
             if (is.null(lst)) break;
             df = as.data.frame(matrix(unlist(lst), nrow=length(lst), byrow=TRUE))
             if (nrow(df) == 0) {
                 status=list(code=400,message="No data received")
                 break;
             }
             colnames(df) = names(lst[[1]])
             if (is.null(dfl)) {
                 dfl = df
             } else {
                dfl = rbind(dfl, df)
             }
             start = start + limit
          }
          # Puede haber avisos de NULL o NA
          dfl[] = suppressWarnings(lapply(dfl, function(x) ifelse(is.na(as.numeric(x)),x,as.numeric(x))))
          if (nrow(dfl) > 0) {
              tms = rep(Sys.time(), nrow(dfl))
              dfl$tms = tms
          }
          # CAmbiamos los nombres de las columnas
          colnames(dfl) = c( "id", "name", "symbol", "slug", "rank", "price"
                            ,"volume", "volday", "volweek", "volmonth"
                            ,"hour", "day", "week", "month", "bimonth", "quarter"
                            ,"dominance", "turnover", "tms")
          dfl
      }
      ,unloadCurrencies = function(from, limit) {
         getLatest(from, limit)
      }
       # Esta version se come los creditos
       # ,getLatest = function() {
       #     makeList = function(item) {
       #
       #        id=item$id
       #        name=item$name
       #        symbol=item$symbol
       #        eur = item$quote$EUR
       #        price      = ifelse(is.null(eur$price), 0, eur$price)
       #        change_1h  = ifelse(is.null(eur$percent_change_1h) , 0, eur$percent_change_1h)
       #        change_24h = ifelse(is.null(eur$percent_change_24h), 0, eur$percent_change_24h)
       #        change_7d  = ifelse(is.null(eur$percent_change_7d) , 0, eur$percent_change_7d)
       #        change_30d = ifelse(is.null(eur$percent_change_30d), 0, eur$percent_change_30d)
       #        change_60d = ifelse(is.null(eur$percent_change_60d), 0, eur$percent_change_60d)
       #        change_90d = ifelse(is.null(eur$percent_change_90d), 0, eur$percent_change_90d)
       #        volume     = ifelse(is.null(eur$volume_24h),         0, eur$volume_24h)
       #        list( id       = id
       #             ,name     = name
       #             ,symbol   = symbol
       #             ,price    = price
       #             ,change01 = change_1h
       #             ,change24 = change_24h
       #             ,change07 = change_7d
       #             ,change30 = change_30d
       #             ,change60 = change_60d
       #             ,change90 = change_90d
       #             ,volume   = volume
       #        )
       #     }
       #     return(NULL)
       #     # Se come los creditos
       #     url = mountURL("cryptocurrency/listings/latest")
       #     page = GET(url,add_headers("X-CMC_PRO_API_KEY" = info$token)
       #                   ,add_headers(Accept = "application/json")
       #                   ,query = list(start = 1, limit = 5000, convert = "EUR")
       #               )
       #
       #     json = content(page, type = "application/json")
       #     resp = json[[1]]
       #     data = json[[2]]
       #     l = lapply(data, function(item) makeList(item))
       #     df = data.frame(matrix(unlist(l), nrow=length(l), byrow=TRUE))
       #     df$X1 = as.integer(df$X1)
       #     for (col in 4:ncol(df)) df[,col] = as.numeric(df[,col])
       #
       #     tms = Sys.time()
       #     dft = data.frame(tms=rep(tms, nrow(df)))
       #     df = cbind(dft, df)
       #
       #     colnames(df) = c( "tms", "id", "name", "symbol", "price"
       #                      ,"change01", "change24", "change07"
       #                      ,"change30", "change60", "change90"
       #                      ,"volume")
       #
       #     df[df$volume < 10, "volume"] = 0
       #     private$dfTickers = df
       #     df
       #  }
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
            ,time_start = asUnix(from)
            ,time_end   = asUnix(to)
         )

         page = GET(url, add_headers(.headers=headers), query=parms)

         # 1 - Header response / 2 - Data
         resp = httr::content(page, type="application/json")
         if (http_error(page)) {
            msg = paste("ERROR EN EL GET: ", resp[[1]]$error_code, "message: ", resp[[1]]$error_message)
            message(msg)
            return (NULL)
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
         df1 = df[,1:ncol(df) - 1]
         # sapply falla cuando es uno
         # df1 = as.data.frame(sapply(df1,as.numeric))
         for (col in 1:ncol(df1)) df1[,col] = as.numeric(df1[,col])
         tms = anytime::anytime(df[,ncol(df)])
         cbind(tms=tms,df1)
      }
   )
   ,private = list(
       urlbase = "https://coinmarketcap.com/"
      ,hID     = NULL
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
      ,requestLatest = function(beg, end) {
         url =  "https://api.coinmarketcap.com/data-api/v3/cryptocurrency/listing"
         # Sin sor ordena por defecto por rank
         makeRow = function(x) {
            quote = x$quotes[[1]]
            list( id=as.integer(x$id)
                 ,name=x$name
                 ,symbol=x$symbol
                 ,slug=x$slug
                 ,rank=as.integer(x$cmcRank)
                 ,price  = ifelse(is.null(quote$price),            0, as.numeric(quote$price))
                 ,volume = ifelse(is.null(quote$volume24),         0, as.numeric(quote$volume24))
                 ,vol24  = ifelse(is.null(quote$volume24),         0, as.numeric(quote$volume24))
                 ,vol07  = ifelse(is.null(quote$volume7d),         0, as.numeric(quote$volume7d))
                 ,vol30  = ifelse(is.null(quote$volume30d),        0, as.numeric(quote$volume30d))
                 ,var01  = ifelse(is.null(quote$percentChange1h),  0, as.numeric(quote$percentChange1h))
                 ,var24  = ifelse(is.null(quote$percentChange24h), 0, as.numeric(quote$percentChange24h))
                 ,var07  = ifelse(is.null(quote$percentChange7d),  0, as.numeric(quote$percentChange7d))
                 ,var30  = ifelse(is.null(quote$percentChange30d), 0, as.numeric(quote$percentChange30d))
                 ,var60  = ifelse(is.null(quote$percentChange60d), 0, as.numeric(quote$percentChange60d))
                 ,var90  = ifelse(is.null(quote$percentChange90d), 0, as.numeric(quote$percentChange90d))
                 ,dominance = ifelse(is.null(quote$dominance),     0, as.numeric(quote$dominance))
                 ,turnover  = ifelse(is.null(quote$turnover),      0, as.numeric(quote$turnover))
            )
         }
         # Campos a recuperar
         aux = c( "ath"    , "atl"  # Hgh/Low
                 ,"high24h", "low24h"
                 ,"num_market_pairs"
                 ,"cmc_rank"
                #,"date_added"
                #,"tags"
                #,"platform"
                #,"max_supply"
                # ,"circulating_supply"
                # ,"total_supply"
                  ,"volume_7d"
                  ,"volume_30d"
         )
         parms = list( start=beg, limit=end, convert = "EUR"
                      ,cryptoType="all", tagType="all", aux = paste(aux, collapse=","))
   # ,sortBy="market_cap"
   # ,sortType="desc"

         data = request(url, parms)
         if (is.null(data)) return (NULL)
         # Debe devolver 2 listas
         data[which(names(data) == "totalCount")] = NULL
         data = data[[1]]
         lapply(data, function(x) makeRow(x))
      }
      ,request = function (url, parms) {
          if (missing(parms) || is.null(parms)) {
              page = httr::GET(url, add_headers(.headers=headers))
          } else {
             page = httr::GET(url, add_headers(.headers=headers), query=parms)
          }
         resp = httr::content(page, type="application/json")
         if (http_error(page)) {
             data = resp$status
             status=list(code=data$error_code,message=data$error_message)
             return (NULL)
         }
         resp$status = NULL
         #JGG  Depurar la lista a devolver
         resp[[1]]
      }
   )
)

# Permite unas 10 peticiones dia
# https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?CMC_PRO_API_KEY=68886e75-9fd7-4566-8942-587220e58538&start=1&limit=5000&convert=USD

