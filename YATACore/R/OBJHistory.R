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
            tbl = Factory$getTable(YATACodes$tables$Currencies)
            private$tblCurrencies = Factory$getTable(YATACodes$tables$Currencies)
            private$tblHistory    = Factory$getTable(YATACodes$tables$History)
        }
        ,getRanges = function() {
            browser()
            rng = tblHistory$getRange()
            ctc = tblCurrencies$table()
            #JGG No se qe pasa con los dos campos ultimos
            ctc = ctc[,1:9]
            left_join(ctc, rng, by="symbol")
        }
        ,getActiveCurrencies = function() {
            ctc = tblCurrencies$table()
            ctc[ctc$active == 1, c("id", "symbol")]
        }
        ,getSessionDays = function(symbol) {
            tblHistory$getDates(symbol)
        }
        ,addBulk = function(df) {
            tblHistory$bulkAdd(df, isolated=TRUE)
        }
    )
    ,private = list(
        tblCurrencies = NULL
       ,tblHistory    = NULL
    )
)

