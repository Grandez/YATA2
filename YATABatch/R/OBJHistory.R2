# Tabla de MONEDAS
# Necesita la DB Base
OBJHistory = R6::R6Class("OBJ.HISTORY"
    ,cloneable  = FALSE
    ,portable   = FALSE
    ,lock_class = TRUE
    ,public = list(valid = TRUE
        ,print = function() { message("Class for Currencies History")}
        ,initialize = function(factory) {
            private$factory       = factory
            private$tblCurrencies = factory$getTable("Currencies")
            private$tblHistory    = factory$getTable("History")
        }
       #  ,getRanges = function(idList) {
       #      tblHistory$getRange(idList)
       #      # ctc = tblCurrencies$table()
       #      # #JGG No se qe pasa con los dos campos ultimos
       #      # ctc = ctc[,1:9]
       #      # left_join(ctc, rng, by="symbol")
       #  }
       #  ,getActiveCurrencies = function() {
       #      ctc = tblCurrencies$table()
       #      ctc[ctc$active == 1, c("id", "symbol")]
       #  }
       #  ,getSessionDays = function(symbol) {
       #      tblHistory$getDates(symbol)
       #  }
       #  ,getHistory = function(symbol, from=NULL, to=NULL, periods=0) {
       #      tblHistory$getHistory(symbol, from, to, periods)
       #  }
       #  ,getPrices = function(ids, periods) {
       #      # Cuidado con FIAT, es id = 0
       #      labels = as.character(periods)
       #      nrows = max(periods)
       #      from = Sys.Date() - nrows - 1
       #      to   = Sys.Date()
       #      data = lapply(ids, function(id) {
       #          if (id == 0) { # FIAT
       #              data = as.list(rep(1, length(periods)))
       #              data$id = id
       #          } else {
       #              df = getHistory(id, from, to, nrows + 1)
       #              data = as.list(rep(0, length(periods)))
       #              data$id = id
       #          }
       #          names(data) = c(labels, "id")
       #          data$id = id
       #          if (id != 0) {
       #              for (idx in 1:length(periods)) {
       #                  if (nrow(df) >= periods[idx]) data[[labels[idx]]] = df[periods[idx], "close"]
       #              }
       #          }
       #          data
       #      })
       #      df = data.frame(matrix(unlist(data), nrow=length(data), byrow=TRUE))
       #      colnames(df) = c(labels, "id")
       #      df
       #  }
       # ,getTableHistory = function() { private$tblHistory }
       # ,add = function(df, isolated=TRUE) {
       #     tblHistory$bulkAdd(df, isolated)
       #     invisible(self)
       #  }
    )
    ,private = list(
        factory       = NULL
       ,tblCurrencies = NULL
       ,tblHistory    = NULL
    )
)

