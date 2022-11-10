# Tabla de MONEDAS
# Necesita la DB Base
OBJExchanges = R6::R6Class("OBJ.EXCHANGES"
    ,inherit    = OBJBase
    ,cloneable  = FALSE
    ,portable   = FALSE
    ,lock_class = TRUE
    ,public = list(valid = TRUE
        ,print = function() { message("Currencies")}
        ,initialize = function(factory) {
            super$initialize(factory)
            private$tblExchanges  = factory$getTable(self$codes$tables$exchanges)
            private$nameTblPair = self$codes$tables$exchanges_pair
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
        # ,getPortfolioExchanges = function() {
        #     browser()
        #     if (is.null(tblCameras))
        #         private$tblCameras = factory$getTable(self$codes$tables$cameras)
        #     tblCameras$table()
        # }
        ,getTablePairs = function() {
            if (is.null(tblExchangesPair)) {
                private$tblExchangesPair = factory$getTable(nameTblPair)
            }
            private$tblExchangesPair
        }
        ,deletePairs = function(idExch) {
            if (is.null(tblExchangesPair)) {
                private$tblExchangesPair = factory$getTable(nameTblPair)
            }
            tblExchangesPair$delete(idExch=idExch)
            invisible(self)
        }
    )
    ,private = list(
        tblExchanges     = NULL
       ,tblExchangesPair = NULL
       ,tblCameras       = NULL
       ,nameTblPair = NULL
    )
)

