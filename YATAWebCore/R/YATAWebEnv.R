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
         private$cookies = list()
         # A veces hay YATA al final
          data = parseQueryString(session$request$HTTP_COOKIE)
         # if (length(data) > 0) private$cookies = fromJSON(data[[1]])
      }
     ,getPanel = function(name)  { private$panels$get(name) }
     ,addPanel = function(panel) {
       private$panels$put(panel$name, panel)
       invisible(panel)
     }
    ,getMsg      = function(code, ...) { MSG$get(code, ...) }
    ,getCookies  = function(id) { private$cookies[[id]] }
    ,setCookies = function(id, data) {
       private$cookies[[id]] = data
       updateCookie(self$session, YATA=private$cookies)
    }
    ,getCTCLabels = function(codes, type="medium", invert = FALSE) {
        # Acepta: id, sym, name, long, medium, short
        # Devuelve una lista
        # Invert se usa para combos, en vez de la lista de etiquetas las da de codess
        if (is.numeric(codes)) data = lapply(codes, function(code) .getNameByID(code, type))
        else                   data = lapply(codes, function(code) .getNameBySym(code, type))
        names(data) = codes
        if (invert) {
           names(codes) = data
           data = codes
        }
        data
    }
    ,getCTCLabel = function(code, type="medium", invert = FALSE) {
        data = getCTCLabels(code,type,invert)
        data[[1]]
    }
    ,getCTCID = function(codes) {
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
     ,.getNameByID = function (id, type) {
         info = hID$get(id)
         if (is.null(info)) info = .addSymbol(id)
         .getName(info, type)
     }
     ,.getNameBySym = function (sym, type) {
         info = hSym$get(sym)
         if (is.null(info)) info = .addSymbol(sym)
         .getName(info, type)
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
    ,.getName = function(info, type) {
        if (type == "id")     return (info$id)
        if (type == "symbol") return (info$symbol)
        if (type == "name")   return (info$name)
        if (type == "full")   return (info$lbl)
        if (type == "long")   return (info$lbl24)
        if (type == "medium") return (info$lbl12)
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
