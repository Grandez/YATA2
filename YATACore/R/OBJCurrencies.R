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
        ,getCurrencyID = function(symbols, asList=TRUE) {
            data = tblCurrencies$table(inValues=list(symbol=symbols))
            if (asList) {
                res = as.list(c(data$id))
                names(res) = c(data$symbol)
            } else {
                res = data[,c("id", "symbol")]
                res$currency = res$symbol
            }
            res
        }
        ,getCurrencyNames      = function(subset, full = TRUE) {
            df = tblCurrencies$getCurrencyNames()
            if (!missing(subset)) {
                df = df[df$id %in% subset,]
            }
            if (full) df$name = paste(df$id, df$name, sep=" - ")
            df
        }
        ,getDF                 = function(...) { tblCurrencies$table(...)      }
        ,getActiveCurrencies   = function()    { tblCurrencies$table(active=1) }
        ,getInactiveCurrencies = function()    { tblCurrencies$table(active=0) }
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
        ,getCurrencies = function(currencies, active=TRUE) {
            if (missing(currencies)) {
                df = tblCurrencies$table(token=0)
            } else {
               df = tblCurrencies$table(token=0, inValues=list(symbol=currencies))
            }
            if (active) df = df[df$active == 1, ]
            df
        }
        ,getTokens = function(currencies, active=TRUE) {
            if (missing(currencies)) {
                df = tblCurrencies$table(token=1)
            } else {
               df = tblCurrencies$table(token=1, inValues=list(symbol=currencies))
            }
            if (active) df = df[df$active == 1, ]
            df
        }
        ,getID = function(symbols,as.df=TRUE) {
            df = tblCurrencies$table(inValues=list(symbol=symbols))
            if (as.df) {
                df[,c("id", "symbol")]
            } else {
                data = df$id
                names(data) = df$symbol
                data
            }
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

