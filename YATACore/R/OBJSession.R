OBJSession = R6::R6Class("OBJ.SESSION"
    ,inherit    = OBJBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
# Viene a ser como un provider pero mas especifico
    ,public = list(
        initialize = function(factory) {
           super$initialize(factory)
           #JGG Especial
           private$mktcap     = factory$getProvider("MKTCAP", "MarketCap")
           private$tblSession = factory$getTable(codes$tables$Session)
           private$tblExch    = factory$getTable(codes$tables$Exchanges)
           private$tblCMC     = factory$getTable(codes$tables$cmc)
           private$provider   = factory$getObject(codes$object$providers)
           updateLatest()
        }
        ,updateLatest = function() {
           df = mktcap$getLatest()
           last = tblSession$getLastUpdate()
           diff = ifelse(is.na(last), 10, difftime(Sys.time(), last[[1]], units="days"))

           tryCatch(tblSession$update(df, ifelse(diff > 0.75, FALSE, TRUE))
                    ,error = function(e) stop(paste("Fallo en el update", e))
           )
        }
        ,getBest = function(top=15, from=24) {
            col = sprintf("change%02d", from)
            dfexch = tblExch$getExchanges()
            colnames(dfexch) = "symbol"
            session = tblSession$getLatest()
            if (nrow(session) == 0) { # Se ha llamado sin coger la info
                updateLatest()
                session = tblSession$getLatest()
            }
            # Si no hay movimiento no me vale
            session = session[session$volume > 10,]
            df = inner_join(dfexch, session, by = "symbol")
            ncol = which(col == colnames(df))

            dft = df[order(df[ncol], decreasing = TRUE),]
            dft = dft[1:top,]
            dft = dft[,c("symbol", "price", col, "volume")]
            colnames(dft) = c("symbol", "price", "var", "volume")
            dft
        }
        ,getLatest = function() {
            ctc = c("BTC", "ETH", "ADA", "XRP", "LTC")
            ids = tblCMC$getID(ctc)
            lista = paste(unlist(ids), collapse=",")
            res = mktcap$getExchanges(lista)
        }
    )
    ,private = list(
        mktcap     = NULL
       ,tblSession = NULL
       ,tblExch    = NULL
       ,tblCMC     = NULL
       ,provider   = NULL
    )
)

