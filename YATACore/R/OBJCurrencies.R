# Tabla de MONEDAS
# Necesita la DB Base
OBJCurrencies = R6::R6Class("OBJ.CURRRENCIES"
    ,inherit    = OBJBase
    ,cloneable  = FALSE
    ,portable   = FALSE
    ,lock_class = TRUE
    ,public = list(valid = TRUE
        ,print = function() { message("Currencies Object")}
        ,initialize = function(factory) {
            super$initialize(factory)
            tbl = YATAFactory$getTable(YATACodes$tables$Currencies)
            private$tblCurrencies = YATAFactory$getTable(YATACodes$tables$Currencies)
            private$tblExchanges  = YATAFactory$getTable(YATACodes$tables$Exchanges)
            private$tblCameras    = YATAFactory$getTable(YATACodes$tables$Cameras)
            private$icons         = YATAFactory$getClass("Icons")
        }
        ,select = function(...) {
            tblCurrencies$select(...)
            self$current = tblCurrencies$current
        }
        ,getCurrencyName       = function(code, full = TRUE) {
            # if (code == "EUR") {
            #     if (full) return ("EUR - Euro")
            #     return ("EUR")
            # }
            data = select(id = code)
            ifelse (full, paste0(data$id, " - ", data$name), data$id)
        }
        ,getCurrencyNames      = function(subset, full = TRUE) {
            df = tblCurrencies$getTable()
            if (!missing(subset)) {
                df = df[df$currency %in% subset,]
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
        ,getNames = function(codes, full = FALSE) {
            df = tblCurrencies$table(inValues=list(id=codes))
            if (full) df$name = paste(df$id, df$name, sep = " - ")
            df
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

