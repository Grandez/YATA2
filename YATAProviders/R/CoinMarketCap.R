# Ahi que crear un conjunto de cuentas para poder hacer peticiones
# 300 creditos dia
# 10000 creditos mes
PROVMarketCap = R6::R6Class("PROV.MARKETCAP"
  ,inherit    = ProviderBase
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = FALSE
  ,public = list(
     initialize       = function(code, factory) { # }, dbf) {
       super$initialize  (code, "CoinMarketCap", factory) #, dbf)
       private$base    = YATABase$new()
       private$http    = private$base$http
       private$lastGet = as.POSIXct(1, origin="1970-01-01")
       private$hID     = base$map()
     }
    ,getIcons         = function(maximum, force=FALSE) {
        #JGG Revisar
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
             resp = http$get(paste0(urlbase, png), parms=NULL, headers=headers, accept=500)
             if (resp$status_code != 200) {
                 cat("\tKO\n")
             } else {
               writeBin(resp$content, png)
                 cat("\tOK\n")
             }
        }
        setwd(oldwd)
    }
      # cryptoType = all / coins / tokens
    ,getCurrencies    = function(from = 1, max = 0, type="all") {
        #JGG Revisar
        url     = "https://api.coinmarketcap.com/data-api/v3/cryptocurrency/listing"
        count   =   0
        until   = 501
        dfc     = NULL
        process = TRUE
        parms = list( start=from, limit=500, cryptoType=type, tagType="all")

        while (process) {
             if (count > 0) Sys.sleep(1) # Para no saturar
             data  = http$json(url, parms=parms, headers=headers)

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
                         ,mktcap=x$symbol
                         ,slug=x$slug
                         ,rank=as.integer(x$cmcRank)
                         ,since = since
                         ,active = as.integer(x$isActive)
                         ,token = ifelse(is.null(x$platform), 0, 1)
                     )
                   })
             df = do.call(rbind.data.frame,as.list(lst))
             dfc = rbind(dfc, df)
             # if (length(lst) > 0) {
             #     df = data.frame( matrix(unlist(lst), nrow=length(lst), byrow=TRUE)
             #                     ,stringsAsFactors=FALSE)
             #     colnames(df) = names(lst[[1]])
             #     dfc = rbind(dfc, df)
             # }
             count = count + length(data)
             if (count >= until || length(data) < 500) process = FALSE
        }
        dfc
    }
    ,getCurrenciesNumber = function(type=c("all", "coins", "tokens")) {
        url     = "https://api.coinmarketcap.com/data-api/v3/cryptocurrency/listing"
        parms = list( start=1, limit=2, cryptoType=match.arg(type))
        data  = http$json(url, parms=parms, headers=headers)
        as.integer(data$totalCount)
    }
    ,getTickers       = function(max = 0, from = 1) {
        toNum    = function(item) { ifelse(is.null(item), 0, item) }
        makeList = function(x)    {
          quote  = x$quotes[[1]]
          list( id        = x$id
               ,symbol    = x$symbol
               ,rank      = x$cmcRank
               ,price     = toNum(quote$price)
               ,volume    = toNum(quote$volume24)
               ,volday    = toNum(quote$volume24)
               ,volweek   = toNum(quote$volume7d)
               ,volmonth  = toNum(quote$volume30d)
               ,hour      = toNum(quote$percentChange1h)
               ,day       = toNum(quote$percentChange24h)
               ,week      = toNum(quote$percentChange7d)
               ,month     = toNum(quote$percentChange30d)
               ,bimonth   = toNum(quote$percentChange60d)
               ,quarter   = toNum(quote$percentChange90d)
               ,dominance = toNum(quote$dominance)
               ,turnover  = toNum(quote$turnover)
               ,tms       = quote$lastUpdated
          )
        }

        logfile = paste0(Sys.getenv("YATA_SITE"), "/data/log/mktcap.log")

        url =  "https://api.coinmarketcap.com/data-api/v3/cryptocurrency/listing"
        until = from + 500
        dfc   = NULL
        parms = list( start=from, limit=500, cryptoType="all", tagType="all")
        resp = list(total=0, from=0, count=0)
        while (parms$start < until) {
           if (parms$start > 1) Sys.sleep(1) # avoid DoS
           tryCatch({
             #logger$doing(3, "Getting tickers from %5d ", parms$start)
             data = http$json(url, parms=parms, headers=headers)

             #logger$done(3)

             if (is.null(data) || length(data) == 0) break

             resp$total  = as.integer(data$totalCount)
             resp$from   = parms$start
             resp$count  = length(data$cryptoCurrencyList)
             parms$start = parms$start + resp$count
             data        = data$cryptoCurrencyList
             until       = ifelse (max == 0, resp$total, max)

             if (length(data) > 0) {
                 items = lapply(data, function(x) makeList(x))
                  df    = do.call(rbind.data.frame,items)
                  df    = as_tms(df, c(17))
                  dfc   = rbind(dfc, df)
             }
           }, error = function (cond) {
               cat("ERROR GetTickers", cond$message)
              #logger$done(3, FALSE)
           })
        }
        resp$df = dfc
        resp
    }
    ,getTrend         = function() {
        table = http$html_table("https://coinmarketcap.com/trending-cryptocurrencies/", accept=500)
        if (is.null(table)) return (NULL)

        dfData  = table[,4:9]
        for (i in 1:ncol(dfData)) {
            dfData[,i] = gsub("[\\$\\%,-]", "", dfData[,i])
            dfData[,i] = as.numeric(dfData[,i])
        }
        # Partir nombre y simbolo (fallar si el simbolo tiene numeros)
        lbls = as.data.frame(table[,3])
        res = regexpr("[0-9]+[a-zA-Z]+$", lbls[,1])
        lbls$tmp = res
        lbls$len = attr(res,"match.length")
        lbls$name = substr(lbls[,1],1,nchar(lbls[,1]) - lbls[,3])
        lbls$symbol = substr(lbls[,1],lbls[,2],nchar(lbls[,1]))
        lbls$tmp     = regexpr("[a-zA-Z]+$", lbls$sym)
        lbls$symbol = substr(lbls$symbol,lbls$tmp,nchar(lbls$symbol))
        lbls = lbls[,c("symbol","name")]
        df = cbind(lbls, dfData)
        cols = c("symbol", "name", "price", "day", "week", "month", "marketcap", "volume")
        colnames(df) = cols
        df
    }
    ,getHistorical    = function(idCurrency, from, to ) {
        #JGG PARECE QUE AHORA SOLO DEVUELVE 180/1 DIAS EN LUGAR DE TODO EL RANGO
        #JGG ESTO NO ES PROBLEMA EN CONDICIONES NORMALES QUE SOLO PEDIMOS UNOS DIAS
        #JGG PERO SI PARA PROCESOS MAS MASIVOS, ASI QUE IREMOS POR BUCLES DE 90 DIAS
        logfile = paste0(Sys.getenv("YATA_SITE"), "/data/log/mktcap.log")

        if (is.null(idCurrency)) return(NULL)
        url = "https://api.coinmarketcap.com/data-api/v3/cryptocurrency/historical"

        # historical matches only 00:00:00
        from = as.POSIXlt(from, "GMT")
        hour(from) = 0
        minute(from) = 0
        second(from) = 0
        from = as.numeric(from)
        to = as.POSIXlt(to, "GMT")
        hour(to) = 0
        minute(to) = 0
        second(to) = 0
        to = as.numeric(to)
        parms = list(id = idCurrency, timeStart = from, timeEnd = to,convertId  = 2781) #JGG 2781 = USD 2790-EUR

        data  = http$json(url, parms=parms, headers=headers)
        data  = data$quotes
        items = lapply(data, function(item) {
            l1 = list(timeHigh=item$timeHigh, timeLow=item$timeLow)
            list.merge(item$quote, l1)
        })
        df = do.call(rbind.data.frame,items)
        if (nrow(df)> 0) df = as_tms(df, c(7,8,9))
        df
    }
    ,getExchanges     = function() {
        # Aparte de 1000 campos devuelve el campo 2
        # Nombre y acabado en un numero a veces (supongo que el id y solo los 10 primeros
        table = http$html_table("https://coinmarketcap.com/rankings/exchanges")
        df = table[,2]
        colnames(df) = "name"
        df$name = gsub("[0-9]+$","",df[,1])
        df
    }
    ,getExchangePairs = function(exchange) {
        colsJson  = c( "exchangeId",  "exchangeName"
                      ,"baseSymbol",  "baseCurrencyId"
                      ,"quoteSymbol", "quoteCurrencyId")
        colsTable = c( "idExch",      "name"
                      ,"base",        "idBase"
                      ,"counter",     "idCounter")

        url   = "https://api.coinmarketcap.com/data-api/v3/exchange/market-pairs/latest"
        parms = list( slug=exchange, category = "spot"
                     ,start=1, limit=500)

        data = http$json(url, parms=parms, headers=headers)

        maxPairs=data$numMarketPairs
        tbl = data$marketPairs
        df = do.call(rbind.data.frame,as.list(tbl))
        if (nrow(df) == 0) return (df)
        dfExch = df[,colsJson]
        colnames(dfExch) = colsTable
        count = nrow(dfExch)
        while(count < maxPairs) {
            parms$start = count + 1
            data = http$json(url, parms=parms, headers=headers)
            data = data$data
            tbl = data$marketPairs
            df = do.call(rbind.data.frame,as.list(tbl))
            dfTmp = df[,colsJson]
            colnames(dfTmp) = colsTable
            count = count + nrow(dfTmp)
            dfExch = rbind(dfExch, dfTmp)
        }
        dfExch
    }

   )
  ,private = list(
     urlbase = "https://coinmarketcap.com/"
    ,hID     = NULL
    ,base    = NULL
    ,http    = NULL
    ,headers = c( `User-Agent`      = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:86.0) Gecko/20100101 Firefox/86.0"
                 ,`Accept-Language` = "es-ES,es;q=0.8,en-US;q=0.5,en;q=0.3"
                 ,Accept          = "application/json, text/plain, */*"
                 ,Origin          = "https://coinmarketcap.com"
                 ,Referer         = "https://coinmarketcap.com/"
                 ,TE              = "Trailers"
    )
    ,getPage = function(page) {
        stop("MarketCap$getPage llamado")
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
    # ,request = function (url, parms, accept404 = TRUE) {
    #     if (missing(parms) || is.null(parms)) {
    #         page = httr::GET(url, add_headers(.headers=headers))
    #     } else {
    #        page = httr::GET(url, add_headers(.headers=headers), query=parms)
    #     }
    #    resp = httr::content(page, type="application/json")
    #    checkResponse(resp, url, parms, accept404 = FALSE)
    #    resp$data
    # }
  )
)
