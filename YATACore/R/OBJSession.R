OBJSession = R6::R6Class("OBJ.SESSION"
    ,inherit    = OBJBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
# Viene a ser como un provider pero mas especifico
    ,public = list(
        print       = function() { message("Session Object")}
       ,initialize = function(factory) {
           super$initialize(factory)
           name = "session"
           #JGG Especial
           private$provider      = factory$getProvider("MKTCAP", "MarketCap")
           private$prtSession    = factory$getTable(codes$tables$session)
           private$tblCurrencies = factory$getTable(codes$tables$currencies)
           #private$lastGet       = as.integer(prtSession$getLastUpdate())
           private$interval      = 15
#           private$dfLast        = prtSession$getLatest()
       }
       ,setInterval   = function(interval) { private$interval = interval }
       ,getBest       = function(top=10, from=7, group=0) {
            session = prtSession$getLatest()
            if (nrow(session) == 0) session = updateLatest(TRUE)
            session = session[session$volume > 10,] # Solo los que se mueven
            getBestDF(session, top, from, group)
       }
       ,getPrice = function(currency) {
           if (!prtSession$select(symbol=currency,limit = 1)) return (0)
           prtSession$current$price
       }

       # ,getHistorical = function(base, idCurrency, from, to, period=24) {
       #     id = suppressWarnings(as.numeric(idCurrency))
       #     if (is.na(id)) id = tblCurrencies$getID(idCurrency)
       #     if (is.null(id)) return (NULL)
       #     provider$getHistorical(id,from,to)
       #  }
       #  ,updateCurrencies = function(max=3000) {
       #      df = provider$getLatest(max)
       #      df = df[,c("id", "name", "symbol", "slug", "rank",)]
       #      df
       #  }
       #  ,getLast   = function(currencies) {
       #      df = private$dfLast
       #      if (!missing(currencies)) df = df[df$symbol %in% currencies,]
       #      df
       #  }
       #  ,getLatest = function(currencies) {
       #      df = private$dfLast
       #      if (nrow(df) == 0) df = updateLatest(TRUE)
       #      if (!missing(currencies)) df = df[df$symbol %in% currencies,]
       #      df
       #  }
       # ,getPrices = function(currencies) {
       #     data = lapply(currencies, function(x) {
       #         if (x != "EUR") {
       #             df = prtSession$table(symbol=x)
       #             df = df[,c("tms", "price")]
       #             colnames(df) = c("tms", x)
       #             df
       #         }
       #     })
       #     if (length(data) == 0) return (NULL)
       #     dfp = data[[1]]
       #     if (length(data) > 1) {
       #         for (idx in 2:length(data)) {
       #             if (!is.null(data[[idx]])) dfp = full_join(dfp, data[[idx]], by="tms")
       #         }
       #     }
       #     dfp
       # }
       ,getSessionPrices = function(currencies) {
           df = getPrices(currencies)
           df[df$tms > as.POSIXct(Sys.Date()),]
       }

       ,updateLatest = function(isolated=FALSE) {
           last = format(as.POSIXct(Sys.time()), format = "%Y-%m-%d-%H:%M:%S")

           df = provider$getTickers()
           df[,c("name", "slug")] = NULL

           # Puede haber symbol repetidos (no por id)
           # Se han cambiado en la tabla de currencies
           df1 = df[,c("id", "symbol")]
           ctc = tblCurrencies$table()
           df2 = ctc[,c("id", "symbol")]
           dfs = inner_join(df1, df2, by="id")
           df2 = dfs[,c(1,3)]
           df  = inner_join(df, df2, by="id")
           df$symbol = df$symbol.y
           df        = df[,-ncol(df)]

           df$last = last
           prtSession$update(df,isolated)
       }
    )
    ,private = list(
        prtSession = NULL
       ,tblCurrencies = NULL
       ,provider   = NULL
       ,lastGet    = NULL
       ,interval   = NULL
       ,dfLast     = NULL
       ,getBestDF = function(df, top, from, group) {
           groups = c(25, 150)
           col = ""
           if (from ==  1) col = "hour"
           if (from == 24) col = "day"
           if (from ==  7) col = "day"
           if (from == 30) col = "month"
           if (col == "") return (NULL)
           if (group > 0) df = df[df$rank <= groups[group],]
           dft = df[order(df[col], decreasing = TRUE),]
           dft[1:top,]
       }
    )
)

