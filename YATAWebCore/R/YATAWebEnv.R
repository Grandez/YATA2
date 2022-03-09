# Objeto global para guardar la configuracion
# Y los objetos
# Almacenamos tambien las monedas y sus nombres
YATAWebEnv = R6::R6Class("YATA.WEB.ENV"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,active = list(
      logLevel = function(value) {
         if (!missing(value)) {
             private$.logLevel = value
             log$setLevel(value)
         }
         .logLevel
      }
  )
  ,public = list(
      MSG      = NULL
     ,errorLevel = 0 # Nivel de error (9 - No rest)
     ,txtError = NULL
     ,factory  = NULL
     ,session  = NULL
     ,log      = NULL
     ,initialize = function() {
         tryCatch({
            self$factory = YATACore::YATAFACTORY$new()
            self$MSG     = factory$MSG
            logger = YATALogger$new("WEB",console=interactive())
            self$log     = YATALogger$new("WEB",console=interactive(), log=.logLevel)
            # private$tblCurrencies = factory$getTable("Currencies")
            # private$tblCameras    = factory$getTable("Cameras")
            private$hID   = YATABase$map
            private$hSym  = YATABase$map
            private$hCam  = YATABase$map
            self$errorLevel = restCheck()
#            loadFiats()
         }, error = function(e) {
            self$errorLevel = 98
            self$txtError = e
         })
     }
     ,finalize = function() {
         private$tblCurrencies = NULL
         private$tblCameras    = NULL
         private$hID    = NULL
         private$hSym   = NULL
         private$hCam   = NULL
         factory$clear()
     }
     # ,log = function(tpl, ...) {
     #   message(paste(as.integer(Sys.time()), "-", sprintf(tpl, ...)))
     # }
     ,setSession = function(session) {
         self$session = session
         private$cookies = list()
         data = parseQueryString(session$request$HTTP_COOKIE)
         if (length(data) > 0 && !is.null(data$YATA)) private$cookies = fromJSON(data$YATA)
         invisible(self)
      }
     ,getPanel = function(name, loading=FALSE)  {
         # Devuelve el objeto asociado al panel si existe
         # Actualiza javascript jggshiny con la pagina activa
         # if (loading) message(paste("Carga panel ", name))
         shinyjs::js$jgg_set_page(list(name=name))
         private$panels$get(name)
      }
     ,addPanel = function(panel) {
       private$panels$put(panel$name, panel)
       # Notificamos a js que cargue la pagina
       shinyjs::js$jgg_set_page(panel$getDef())
       self$getPanel(panel$name, loading=TRUE)
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
        # Invert se usa para combos, en vez de la lista de etiquetas las da de codes
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
        cdg = codes
        fiat = which(codes == "FIAT")
        if (length(fiat)) cdg = codes[-fiat]
        if (length(cdg) == 0) return(NULL)
        df = tblCurrencies$table(inValues=list(symbol=cdg))
        data = df$id
        names(data) = df$symbol
        if (length(fiat)) data = c(data,FIAT=0)
        data
    }
    ,getCameraNames = function(codes) {
        fun = function(code) {
            name = private$hCam$get(code)
            if (is.null(name)) {
                df = tblCameras$table(id=code)
                name = df[1,"name"]
                private$hCam$put(code, name)
            }
            name
        }
        lst = lapply(codes, function(code) fun(code) )
        names(lst) = codes
        lst
    }
  )
  ,private = list(
# Cada objeto representa una pagina
# De esta forma se gestiona la inicializacion de la pagina
# Y guardamos los datos temporales
      panels  = YATABase$map
     ,.logLevel = 0
     ,tblCurrencies = NULL
     ,tblCameras    = NULL
     ,hID     = NULL
     ,hSym    = NULL
     ,hCam    = NULL
     ,logsess = as.integer(Sys.time())
     # ,logs    = c(rep(0,10))
     # ,logn    = c(rep("", 10))
     # ,logi    = 1
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
           info$lbl32  = code
           info$lbl20  = code
         }
         else {
            info$id     = tblCurrencies$current$id
            info$symbol = tblCurrencies$current$symbol
            info$name   = tblCurrencies$current$name
            info$lbl    = paste0(info$symbol, " - ", info$name)
            info$lbl32  = ifelse(nchar(info$lbl) > 32, substr(info$lbl, 1, 20), info$lbl)
            info$lbl20  = ifelse(nchar(info$lbl) > 30, substr(info$lbl, 1, 32), info$lbl)
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
        if (type == "long")   return (info$lbl32)
        if (type == "medium") return (info$lbl20)
    }
    # ,loadFiats = function() {
    #      info = list()
    #      info$id     = 99999
    #      info$symbol = "EUR"
    #      info$name   = "Euro"
    #      info$lbl    = paste0(info$symbol, " - ", info$name)
    #      info$lbl32  = info$lbl
    #      info$lbl20  = info$lbl
    #      hSym$put(info$symbol, info)
    #      hID$put (info$id, info)
    #      info$id     = 99998
    #      info$symbol = "USD"
    #      info$name   = "US Dollar"
    #      info$lbl    = paste0(info$symbol, " - ", info$name)
    #      info$lbl32  = info$lbl
    #      info$lbl20  = info$lbl
    #      hSym$put(info$symbol, info)
    #      hID$put (info$id, info)
    # }

  )
)

yataSetCookie = function(key, value) {
  string = sprintf("Cookies.set(\'%s\', \'%s\');", key, value)
  runjs(string)
}
