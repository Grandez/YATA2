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
           private$tblSession    = factory$getTable(codes$tables$Session)
           private$tblCurrencies = factory$getTable(codes$tables$Currencies)
           private$tblExch       = factory$getTable(codes$tables$Exchanges)
           private$lastGet       = as.integer(tblSession$getLastUpdate())
           private$interval      = 15
           private$dfLast        = tblSession$getLatest()
       }
       ,setInterval   = function(interval) { private$interval = interval }
       ,getBest       = function(top=10, from=7, group=0) {
            session = tblSession$getLatest()
            if (nrow(session) == 0) session = updateLatest(TRUE)
            session = session[session$volume > 10,] # Solo los que se mueven
            getBestDF(session, top, from, group)
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
        ,getLast   = function(currencies) {
            df = private$dfLast
            if (!missing(currencies)) df = df[df$symbol %in% currencies,]
            df
        }
        ,getLatest = function(currencies) {
            df = private$dfLast
#            df = tblSession$getLatest()
            if (nrow(df) == 0) df = updateLatest(TRUE)
            if (!missing(currencies)) df = df[df$symbol %in% currencies,]
            df
        }
       ,getPrices = function(currencies) {
           data = lapply(currencies, function(x) {
               if (x != "EUR") {
                   df = tblSession$table(symbol=x)
                   df = df[,c("tms", "price")]
                   colnames(df) = c("tms", x)
                   df
               }
           })
           if (length(data) == 0) return (NULL)
           dfp = data[[1]]
           if (length(data) > 1) {
               for (idx in 2:length(data)) {
                   if (!is.null(data[[idx]])) dfp = full_join(dfp, data[[idx]], by="tms")
               }
           }
           dfp
       }
       ,updateLatest = function(force=FALSE) {
           res = NULL
           if (force || (as.integer(Sys.time()) - lastGet) > 900) {
               # Puede haber nombre duplicados
               df = provider$getLatest()
               df[,c("name", "slug")] = NULL
               private$dfLast = df
               df1 = df[,c("id", "symbol")]
               ctc = tblCurrencies$table()
               df2 = ctc[,c("id", "symbol")]
               dfs = inner_join(df1, df2, by="id")
               df2 = dfs[,c(1,3)]
               df = inner_join(df, df2, by="id")
               df$symbol = df$symbol.y
               df = df[,-ncol(df)]
               tryCatch({tblSession$update(df) ; res = df }
                       ,error = function(e) { stop(paste("Fallo en el update", e)) })
          }
           res
        }
    )
    ,private = list(
        tblSession = NULL
       ,tblExch    = NULL
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

