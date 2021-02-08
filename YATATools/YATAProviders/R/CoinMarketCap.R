# Poloniex da datos cada
# 300  	    5	minutos
# 900	      15	minutos
# 1800	   30	minutos
# 7200	  120	   2  Horas
# 14400    240	   4  Horas
# 386400	 1440	   1  Dia
# La parte 1 hora la hacemos con 2 de 30
# La parte 8 horas con 2 de 4

# UDSC cotiza en USDT
# No Hay USD/USDT

PROVPoloniex = R6::R6Class("PROV.POLONIEX"
   ,inherit    = ProviderBase
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = FALSE
   ,public = list(
        initialize = function(eurusd, path, config) {
           super$initialize("Poloniex", eurusd, path, config)
           private$lastGet = as.POSIXct(1, origin="1970-01-01")
           loadTickers()
        }
       # ,ticker     = function(base, counter) {
       #     now = Sys.time()
       #     if (difftime(now, private$last, unit="mins") > private$interval) {
       #        private$last = now
       #        loadTickers()
       #     }
       #
       #     pTicker(base, counter, private$dft)
       # }
       ,currencies = function() {
          url = "%sreturnTicker"
          data = get(sprintf(url, urlbase))
          cols = unlist(strsplit(names(data), "_", fixed=TRUE))
          cols[seq(2, length(cols), by=2)]
       }
       ,session    = function(base, counter, interval, from, to, period) {
          # Aqui hay que buscar el par adecuado y luego ajustar cambios
          # Por ejemplo:
          # EUR/BTC - No existe
          #    -> USD/BTC - En Poloniex tampoco
          #    -> USDC/BTC - Este si existe
          # Hacemos el cambio USDC/USD Ya tenemos USD/BTC
          # Hacemos el cambio USD/EUR  Ya tenemos EUR/BTC
          url = "%sreturnChartData&currencyPair=%s&start=%d&end=%d&period=%d"
          start = as.numeric(from)
          end = as.numeric(ifelse(missing(to), Sys.time(), to))
          pair = paste(base, counter, sep="_")
          #interval = switch(period,)

          data = get(sprintf(url, urlbase, pair, start, end, period))
          # si recupera datos, devuelve el data frame
          if (!("data.frame" %in% class(data))) { # Cambiar el orden
              pair = paste(counter, base, "_")
              data = get(sprintf(url, pair, start, end, period))
          }
          else {
             # Poloniex da los datos al reves
             # Ej: USD/BTC da 23000 es decir deberia ser BTC/USD
             cols = c("high", "low", "open", "close")
             data[,cols] = 1/data[,cols]
          }
          data$date = as.POSIXct(data$date, origin="1970-01-01")
          data$quoteVolume = NULL
          names(data)[names(data) == "weightedAverage"] = "average"
          prov = rep("POL", nrow(data))
          base = rep(base, nrow(data))
          counter = rep(counter, nrow(data))
          df0 = data.frame(provider=prov, base=base, counter=counter)
          df = cbind(df0, data)
       }
       ,getCloseSession = function(base, counter, day) {
          if (is.character(day)) day = as.Date(day)
          # Cogemos los datos del dia y del dia anterior
          strTo   = sprintf("%s %d:00:00", day, config$closeTime)
          strFrom = sprintf("%s %d:00:00", day - days(1), config$closeTime)
          dtFrom  = as.integer(as.POSIXct(strFrom))
          dtTo    = as.integer(as.POSIXct(strTo))
          ctc = findPath(counter, base)
          # En Polonies va al reves
          if (is.null(ctc)) return (NULL)
          #Al menos  hay dos
          df = session(ctc[1], ctc[2], from=dtFrom, to=dtTo, period=86400)
          df = df = df[nrow(df),]
          for (idx in 2:(length(ctc) - 1)) {
              change = ifelse(ctc[idx] == "EUR", EUR$getCloseSession("EUR", "USD", day), df$close)
              df = session(ctc[idx], ctc[idx + 1], from=dtFrom, to=dtTo, period=86400)
              df = df[nrow(df),]
              df = df[,c("high", "low", "open", "close")] * change
          }
          df
       }
   )
   ,private = list(
        urlbase = "https://poloniex.com/public?command="
       ,loadTickers = function() {
           now = Sys.time()
           if (difftime(now, lastGet, unit="mins") < interval) return (invisible(self))
           private$lastGet = now
           resp = get("https://poloniex.com/public?command=returnTicker")
           dfv = as.data.frame(list.stack(resp))
           dfv = adjustTicker(dfv)
           max = ncol(dfv)
           dfv[,1:max] = sapply(dfv[,1:max], as.numeric)
           cols = strsplit(names(resp), "_", fixed=TRUE)
           dfc = data.frame(base=sapply(cols, function(x) x[[2]]), counter = sapply(cols, function(x) x[[1]]))
           private$dfTickers = cbind(dfc, dfv)
           addDefaults()
       }
       ,adjustTicker = function(df) {
           # Pone los nombres esperados a las columnas
          df = df[,-1]
           colnames(df) = c("last", "lowest", "highest", "change", "baseVolume", "quoteVolume", "active", "high", "low")
           df$active = ifelse(df$active == 0, 1, 0)
           df
       }
   )
)

# Permite unas 10 peticiones dia
# https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?CMC_PRO_API_KEY=68886e75-9fd7-4566-8942-587220e58538&start=1&limit=5000&convert=USD
