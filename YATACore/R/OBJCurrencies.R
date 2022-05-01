# Tabla de MONEDAS
# Necesita la DB Base
# Si hay selective entonces cacheamos los datos
# Si no lo hay accedemos a la base de datos para no usar memoria
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
            if (!is.null(Factory$camera)) {
                if (Factory$camera$selective_ctc > 0 ||
                    Factory$camera$selective_tok > 0) {
                    cacheCurrencies(Factory$camera)
                }
            }
            #private$icons         = Factory$getClass("Icons")
        }
        ,select = function(...) {
            # if (!is.null(target)) {
            #     selectFromTarget(...)
            # } else {
              df = getData(...)
              if (nrow < 2) self$current = as.list(df)
               # tblCurrencies$select(...)
               # self$current = tblCurrencies$current
#            }
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
            if (!is.null(target)) {
                df = target[,c("symbol", "name", "rank")]
                colnames(df) = c("id", "name", "rank")
            } else {
               df = tblCurrencies$getCurrencyNames()
            }
            if (!missing(subset)) {
                df = df[df$id %in% subset,]
            }
            if (full) df$name = paste(df$id, df$name, sep=" - ")
            df
        }
        #JGG PASARLO A FUNCION getData (si target .... si no ....)
        # Todas las funciones deben pasar por ahi
        ,getDF                 = function(...) {
            getData(...)
            #tblCurrencies$table(...)
         }
        ,getActiveCurrencies   = function()    {
            getData(active=1)
            #tblCurrencies$table(active=1)
         }
        ,getInactiveCurrencies = function()    {
            getData(active=0)
            #tblCurrencies$table(active=0)
         }
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
        ,getAllCurrencies = function() { tblCurrencies$table() }
        ,getCurrencies    = function(currencies, active=TRUE) {
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
       ,target = NULL
       ,updIcons = function(df) {
           df$icon = mapply( function(sym,ic) { if (is.na(ic)) ic=paste0(sym, ".png")
                                                icons$getIcon(ic)
                                              }, sym=df$id, ic=df$icon)
           df
       }
      ,cacheCurrencies = function(camera) {
          df = tblCurrencies$table()
          if (bitwAnd(camera$target, 1) != 0) { # Monedas
              dft = df %>% filter(active == 1 & token == 0)
              if (camera$selective_ctc > 0) {
                  dft = dft[order(rank),]
                  dft = dft[1:camera$selective_ctc,]
              }
              private$target = dft
          }
          if (bitwAnd(camera$target, 2) != 0) { # tokens
              dft = df %>% filter(active == 1 & token == 1)
              if (camera$selective_tok > 0) {
                  dft = dft[order(rank),]
                  dft = dft[1:camera$selective_tok,]
              }
              if (!is.null(target)) {
                  dft = rbind(target, dft)
                  private$target = dft[order(rank),]
              } else {
                private$target = dft
              }
          }
      }
     ,selectFromTarget = function (...) {

     }
     ,getData = function(...) {
         browser()
         if (is.null(target)) return (tblCurrencies(...))
         args = args2list(...)
         if (length(args) == 0) return (target)
         df = target
         fields = names(args)
         for (fied in names(args)) {
             df = df %>% filter(field == args[[field]])
         }
         df
     }
    )
)

