# Tabla de MONEDAS
# Necesita la DB Base
OBJHistory = R6::R6Class("OBJ.HISTORY"
    ,inherit    = OBJBase
    ,cloneable  = FALSE
    ,portable   = FALSE
    ,lock_class = TRUE
    ,public = list(valid = TRUE
        ,print = function() { message("Currencies")}
        ,initialize = function(Factory) {
            super$initialize(Factory)
            private$tblCurrencies = Factory$getTable(self$codes$tables$currencies)
            private$tblHistory    = Factory$getTable(self$codes$tables$history)
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
        ,add = function(df, isolated=TRUE) {
            tblHistory$bulkAdd(df, isolated)
        }
    )
    ,private = list(
        tblCurrencies = NULL
       ,tblHistory    = NULL
    )
)

