# Maneja los cambios EUR, USD, USDC, USDT
OBJEuro = R6::R6Class("OBJ.EURO"
    ,inherit    = OBJBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        print           = function() { message("Clearings Object")}
       ,initialize      = function(factory) {
           super$initialize(factory)
           private$tblEuro = YATAFactory$getTable(YATACodes$tables$Sessions)
       }
       ,lastExchange  = function(base, counter) {
           # Caso especial de USDC y USDT
           if (counter == "USDC" || counter == "USDT") {
               if (base == "USD") return (1)
               if (base == "EUR") return (lastExchange("EUR", "USD"))
           }
           tblEuro$last(base, counter)
        }
       ,lastExchanges = function()              { tblEuro$lastExchangeS()      }
       ,updateExchanges = function(data) {
            counters = tblEuro$counters(data[1, "base"])
            tryCatch({
               db$begin()
               for (id in counters) {
                 df = data[,c("base", id, "tms")]
                 counter = rep(id, nrow(data))
                 df = cbind(counter, df)
                 colnames(df) = c("counter", "base", "close", "tms")
                 # Usamos A/B como cuanto de A necesitamos para 1 B
                 df$close = 1 / df$close
                 tblEuro$bulkAdd(df)
               }
               db$commit()
           },error = function(cond) {
               browser()
                env$setErr(YATAError$new("Error en update", cond, ext=db$lastErr))
                db$rollback()
                stop(errorCondition("YATA ERROR", class=c("YATAErr", "error")))
           })
       }
    )
    ,private = list(
       tblEuro  = NULL
    )
)
