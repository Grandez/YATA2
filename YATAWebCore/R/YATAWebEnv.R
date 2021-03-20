# Objeto global para guardar la configuracion
# Y los objetos
# Almacenamos tambien las monedas y sus nombres
YATAWebEnv = R6::R6Class("YATA.WEB.ENV"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,public = list(
      MSG      = NULL
     ,inError  = FALSE
     ,txtError = NULL
     ,factory  = NULL
     ,session  = NULL
     ,initialize = function() {
         tryCatch({
            self$factory = YATACore::YATAFACTORY$new()
            self$MSG     = self$factory$MSG

            private$tblCurrencies = factory$getTable("Currencies")
            private$hID  = HashMap$new()
            private$hSym = HashMap$new()
            loadFiats()
         }, error = function(e) {
           browser()
            self$inError = TRUE
            self$txtError = e
         })
     }
     ,finalize = function() {
         private$tblCurrencies = NULL
         private$hID    = NULL
         private$hSym   = NULL
         factory$clear()
     }
     ,setSession = function(session) {
         self$session = session
         # A veces hay YATA al final
         data = parseQueryString(session$request$HTTP_COOKIE)
         private$cookies = fromJSON(data[[1]])
      }
     ,getPanel = function(name)  { private$panels$get(name) }
     ,addPanel = function(panel) {
       private$panels$put(panel$name, panel)
       invisible(panel)
     }
    ,getMsg      = function(code, ...) { MSG$get(code, ...) }
    ,getCookies  = function(id) { private$cookies[[id]] }
    ,setCookies = function(id, data) {
      browser()
       private$cookies[[id]] = data
       updateCookie(self$session, YATA=private$cookies)
    }
    ,getCurrencyLabel = function(codes, style = 10) {
        if (is.numeric(codes)) data = lapply(codes, function(code) .getNameByID(code, style))
        else                   data = lapply(codes, function(code) .getNameBySym(code, style))
        names(data) = codes
        data
    }
    ,getCurrenciesID = function(codes) {
        df = tblCurrencies$table(inValues=list(symbol=codes))
        data = df$id
        names(data) = df$symbol
        data
    }
  )
  ,private = list(
# Cada objeto representa una pagina
# De esta forma se gestiona la inicializacion de la pagina
# Y guardamos los datos temporales
      panels  = HashMap$new()
     ,tblCurrencies  = NULL
     ,hID     = NULL
     ,hSym    = NULL
     ,cookies = list()
     ,.getNameByID = function (id, style) {
         info = hID$get(id)
         if (is.null(info)) info = .addSymbol(id)
         .getName(info, style)
     }
     ,.getNameBySym = function (sym, style) {
         info = hSym$get(sym)
         if (is.null(info)) info = .addSymbol(sym)
         .getName(info, style)
     }
    ,.addSymbol = function(code) {
         if (is.numeric(code)) tblCurrencies$select(id=code)
         else                  tblCurrencies$select(symbol=code)

         info = list()
         if (!tblCurrencies$selected()) {
           info$id     = code
           info$symbol = code
           info$name   = code
           info$lbl    = code
           info$lbl24  = code
           info$lbl12  = code
         }
         else {
            info$id     = tblCurrencies$current$id
            info$symbol = tblCurrencies$current$symbol
            info$name   = tblCurrencies$current$name
            info$lbl    = paste0(info$symbol, " - ", info$name)
            info$lbl24  = ifelse(nchar(info$lbl) > 24, substr(info$lbl, 1, 24), info$lbl)
            info$lbl12  = ifelse(nchar(info$lbl) > 12, substr(info$lbl, 1, 12), info$lbl)
         }
         hID$put (info$id,     info)
         hSym$put(info$symbol, info)
         info
    }
    ,.getName = function(info, style) {
        if (style ==  0) return (info$id)
        if (style ==  1) return (info$symbol)
        if (style ==  2) return (info$name)
        if (style == 10) return (info$lbl)
        if (style == 24) return (info$lbl24)
        if (style == 12) return (info$lbl12)
    }
    ,loadFiats = function() {
         info = list()
         info$id     = 99999
         info$symbol = "EUR"
         info$name   = "Euro"
         info$lbl    = paste0(info$symbol, " - ", info$name)
         info$lbl24  = info$lbl
         info$lbl12  = info$lbl
         hSym$put(info$symbol, info)
         hID$put (info$id, info)
         info$id     = 99998
         info$symbol = "USD"
         info$name   = "US Dollar"
         info$lbl    = paste0(info$symbol, " - ", info$name)
         info$lbl24  = info$lbl
         info$lbl12  = info$lbl
         hSym$put(info$symbol, info)
         hID$put (info$id, info)
    }

  )
)

yataSetCookie = function(key, value) {
  string = sprintf("Cookies.set(\'%s\', \'%s\');", key, value)
  runjs(string)
}
