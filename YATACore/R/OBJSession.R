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
#           private$provider   = factory$getObject(codes$object$providers)
           private$lastGet    = as.Date.POSIXct(1)
           private$interval   = 15

       }
       ,setInterval   = function(interval) { private$interval = interval }
       ,getBest       = function(top=15, from=24, best=FALSE) {
            col = sprintf("var%02d", from)
            session = tblSession$getLatest()

            # Se ha llamado sin coger la info
            if (nrow(session) == 0) session = updateLatest()

            # Si no hay movimiento no me vale
            session = session[session$volume > 10,]

            ncol = which(col == colnames(session))

            if (!missing(best) && best) session = session[session$rank < 150, ]

            dft = session[order(session[ncol], decreasing = TRUE),]
            dft = dft[1:top,]
            dft = dft[,c("id", "symbol", "name", "price", col, "volume")]
            colnames(dft) = c("id", "symbol", "name", "price", "var", "volume")
            dft
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
        ,getLatest = function() {
            dt = Sys.time()
            if (difftime(dt, lastGet, units="mins")  > interval) {
                private$lastGet = dt
                df = updateLatest()
            } else {
                df = tblSession$getLatest()
            }
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
    )
)

