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
           private$provider        = factory$getProvider("MKTCAP", "MarketCap")
           private$tblSession    = factory$getTable(codes$tables$Session)
           private$tblCurrencies = factory$getTable(codes$tables$Currencies)
           private$tblExch    = factory$getTable(codes$tables$Exchanges)
           private$lastGet    = as.Date.POSIXct(1)
           private$interval   = 15

       }
       ,setInterval   = function(interval) { private$interval = interval }
       ,getBest       = function(top=10, from=7) {
            session = tblSession$getLatest()
            if (nrow(session) == 0) session = updateLatest()
            session = session[session$volume > 10,] # Solo los que se mueven
            getBestDF(session, top, from)
       }
       ,getTop       = function(top=10, from=7) {
            session = tblSession$getLatest()
            if (nrow(session) == 0) session = updateLatest()
            session = session[session$volume > 10,] # Solo los que se mueven
            getBestDF(session[session$rank <= 150,], top, from)
        }
       ,getHistorical = function(base, idCurrency, from, to, period=24) {
           id = suppressWarnings(as.numeric(idCurrency))
           if (is.na(id)) id = tblCurrencies$getID(idCurrency)
           if (is.null(id)) return (NULL)
           provider$getHistorical(id,from,to)
        }
        ,updateCurrencies = function(max=3000) {
            df = provider$getLatest(max)
            df = df[,c("id", "name", "symbol", "slug", "rank",)]
            df
        }
        ,getLatest = function(currencies) {
            dt = Sys.time()
            if (difftime(dt, lastGet, units="mins")  > interval) {
                private$lastGet = dt
                df = updateLatest()
            } else {
                df = tblSession$getLatest()
            }
            if (!missing(currencies)) df[df$symbol %in% currencies,]
        }
       ,updateLatest = function() {
           # Es publico para que se pueda lanzar asincronamente
           df = provider$getLatest()
           last = tblSession$getLastUpdate()
           diff = ifelse(is.na(last), 10, difftime(Sys.time(), last[[1]], units="days"))

           tryCatch(tblSession$update(df, ifelse(diff > 0.75, FALSE, TRUE))
                    ,error = function(e) stop(paste("Fallo en el update", e))
           )
           df
        }
    )
    ,private = list(
        tblSession = NULL
       ,tblExch    = NULL
       ,tblCurrencies = NULL
       ,provider   = NULL
       ,lastGet    = NULL
       ,interval   = NULL
       ,getBestDF = function(df, top, from) {
           col = ""
           if (from ==  1) col = "hour"
           if (from == 24) col = "day"
           if (from ==  7) col = "day"
           if (from == 30) col = "month"
           if (col == "") return (NULL)
           dft = df[order(df[col], decreasing = TRUE),]
           dft[1:top,]
       }
    )
)

