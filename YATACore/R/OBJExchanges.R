# Tabla de MONEDAS
# Necesita la DB Base
OBJExchanges = R6::R6Class("OBJ.EXCHANGES"
    ,inherit    = OBJBase
    ,cloneable  = FALSE
    ,portable   = FALSE
    ,lock_class = TRUE
    ,public = list(valid = TRUE
        ,print = function() { message("Currencies")}
        ,initialize = function(Factory) {
            super$initialize(Factory)
            private$tblExchanges  = Factory$getTable(self$codes$tables$exchanges)
        }
        ,getExchanges = function(exchanges=NULL, active=TRUE) {
            if (is.null(exchanges)) {
                df = tblExchanges$table()
            } else {
                df = tblExchanges$table(inValues=list(id=exchanges))
            }
            if (active) df = df[df$active == 1,]
            df
        }
        ,getTablePairs = function() {
            if (is.null(tblExchangesPair)) {
                private$tblExchangesPair = Factory$getTable(self$codes$tables$exchanges_pair)
            }
            tblExchangesPair
        }
        ,deletePairs = function(idExch) {
            if (is.null(tblExchangesPair)) {
                private$tblExchangesPair = Factory$getTable(self$codes$tables$exchanges_pair)
            }
            tblExchangesPair$delete(idExch=idExch)
            inivisible(self)
        }
    )
    ,private = list(
        tblExchanges  = NULL
       ,tblExchangesPair = NULL
    )
)

