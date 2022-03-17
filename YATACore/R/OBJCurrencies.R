# Tabla de MONEDAS
# Necesita la DB Base
OBJCurrencies = R6::R6Class("OBJ.CURRRENCIES"
    ,inherit    = OBJBase
    ,cloneable  = FALSE
    ,portable   = FALSE
    ,lock_class = TRUE
    ,public = list(valid = TRUE
        ,print = function() { message("Currencies")}
        ,initialize = function(Factory) {
            super$initialize(Factory)
            private$tblCurrencies = Factory$getTable(self$codes$tables$currencies)
            private$tblExchanges  = Factory$getTable(self$codes$tables$exchanges)
            private$tblCameras    = Factory$getTable(self$codes$tables$cameras)
            #private$icons         = Factory$getClass("Icons")
        }
        ,select = function(...) {
            tblCurrencies$select(...)
            self$current = tblCurrencies$current
            invisible(self)
        }
        ,getCurrencyName       = function(code, full = TRUE) {
            data = select(id = code)
            ifelse (full, paste0(data$id, " - ", data$name), data$id)
        }
        ,getCurrencyNames      = function(subset, full = TRUE) {
            df = tblCurrencies$getCurrencyNames()
            if (!missing(subset)) {
                df = df[df$id %in% subset,]
            }
            if (full) df$name = paste(df$id, df$name, sep=" - ")
            df
        }
        ,getDF                 = function(...) { tblCurrencies$table(...) }
        ,getActiveCurrencies   = function() { updIcons(tblCurrencies$getTable()) }
        ,getInactiveCurrencies = function() { updIcons(tblCurrencies$table(active=YATACodes$flag$inactive)) }
        ,getAllCurrencies      = function() { updIcons(tblCurrencies$table())                               }
        ,getCameras   = function(counter) {
            df = tblExchanges$getCameras(counter)
            if (nrow(df) == 0) return (NULL)
            tblCameras$getCameraNames(df$camera)
        }
        ,getCameraCurrencies   = function(camera) {
            dfAll = getAllCurrencies()
            dfCam = tblExchanges$getCurrencies(camera)
        }
        ,getCurrencyCameras    = function(currency) {
            df  = tblExchanges$uniques(c("camera"), symbol=currency)
            tblCameras$table(inValues=list(id=df$camera))
        }
        ,addBulk = function(data) { tblCurrencies$bulkAdd(data)}
    )
    ,private = list(
        tblCurrencies = NULL
       ,tblCameras    = NULL
       ,tblExchanges  = NULL
       ,icons = NULL
       ,updIcons = function(df) {
           df$icon = mapply( function(sym,ic) { if (is.na(ic)) ic=paste0(sym, ".png")
                                                icons$getIcon(ic)
                                              }, sym=df$id, ic=df$icon)
           df
        }
    )
)

