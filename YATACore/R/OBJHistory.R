# Tabla de MONEDAS
# Necesita la DB Base
OBJHistory = R6::R6Class("OBJ.HISTORY"
    ,inherit    = OBJBase
    ,cloneable  = FALSE
    ,portable   = FALSE
    ,lock_class = TRUE
    ,public = list(valid = TRUE
        ,print = function() { message("Currencies History")}
        ,initialize = function(Factory) {
            super$initialize(Factory)
            private$tblCurrencies = Factory$getTable(self$codes$tables$currencies)
            private$tblHistory    = Factory$getTable(self$codes$tables$history)
            private$tblBase       = private$tblHistory
        }
        ,getRanges = function(idList) {
            tblHistory$getRange(idList)
            # ctc = tblCurrencies$table()
            # #JGG No se qe pasa con los dos campos ultimos
            # ctc = ctc[,1:9]
            # left_join(ctc, rng, by="symbol")
        }
        ,getActiveCurrencies = function() {
            ctc = tblCurrencies$table()
            ctc[ctc$active == 1, c("id", "symbol")]
        }
        ,getSessionDays = function(symbol) {
            tblHistory$getDates(symbol)
        }
        ,getHistory = function(symbol, from, to) {
            df = tblHistory$getHistory(symbol, from, to)
            nm = colnames(df)
            nm[length(nm)] = "tms"
            colnames(df) = nm
            df[order(df$tms, decreasing = TRUE),]
        }
        ,getPrices = function(ids, periods) {
            # Cuidado con FIAT, es id = 0
            labels = as.character(periods)
            from = Sys.Date() - max(periods) - 1
            to   = Sys.Date()
            data = lapply(ids, function(id) {
                if (id == 0) { # FIAT
                    data = as.list(rep(1, length(periods)))
                    data$id = id
                } else {
                    df = getHistory(id, from,to)
                    data = as.list(rep(0, length(periods)))
                    data$id = id
                }
                names(data) = c(labels, "id")
                data$id = id
                if (id != 0) {
                    for (idx in 1:length(periods)) {
                        if (nrow(df) >= periods[idx]) data[[labels[idx]]] = df[periods[idx], "close"]
                    }
                }
                data
            })
            df = data.frame(matrix(unlist(data), nrow=length(data), byrow=TRUE))
            colnames(df) = c(labels, "id")
            df
        }
       ,getTableHistory = function() { private$tblHistory }
       ,add = function(df, isolated=TRUE) {
           tblHistory$bulkAdd(df, isolated)
           invisible(self)
        }
    )
    ,private = list(
        tblCurrencies = NULL
       ,tblHistory    = NULL
    )
)

