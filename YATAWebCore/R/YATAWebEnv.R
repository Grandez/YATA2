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
     ,REST   = NULL
     ,errorLevel = 0 # Nivel de error (9 - No rest)
     ,txtError = NULL
     ,factory  = NULL
     ,session  = NULL
     ,log      = NULL
     ,window  = list(width = 0, height = 0)
     ,cookies = NULL
     ,combo    = NULL
     ,DBID     = 0     # Flag DB Changed
     ,initialize = function() {
         tryCatch({
            private$base   = YATABase$new()
            private$panels = base$map()
            self$factory   = YATACore::getFactory(TRUE)
            self$MSG       = factory$MSG
            self$log       = YATALogger$new("WEB")
            private$hID    = base$map()
            private$hSym   = base$map()
            private$hCam   = base$map()
            self$REST      = YATARest$new()
            self$combo     = YATAWebCombos$new(self$factory)
#            self$errorLevel = REST$check()
            private$tblCurrencies = factory$getTable(factory$CODES$tables$currencies)
         }, YATAERROR = function (cond) {
             browser()
             self$errorLevel = 97
             self$txtError = cond
         }, error = function(cond) {
            self$errorLevel = 98
            self$txtError = cond
         })
     }
     ,finalize = function() {
         private$tblCurrencies = NULL
         private$tblCameras    = NULL
         private$hID    = NULL
         private$hSym   = NULL
         private$hCam   = NULL
      #   factory$clear()
     }
     ,setWindow = function(data) {
         # self$window$width  = data$window_width
         # self$window$height = data$window_height
     }
     ,setSession = function(session) {
         #JGG Revisr
         self$session = session
         data = parseQueryString(session$request$HTTP_COOKIE)
         if (length(data) > 0 && !is.null(data$YATA)) self$cookies = fromJSON(data$YATA)
         invisible(self)
      }
     ,getPanel = function(name, loading=FALSE)  {
         panel = private$panels$get(name)
         if (!is.null(panel)) shinyjs::js$yata_set_page(name)
         panel
      }
     ,addPanel = function(panel) {
         private$panels$put(panel$name, panel)
         shinyjs::js$yata_add_page(panel$name)
         self$getPanel(panel$name, loading=TRUE)
     }
    ,getMsg    = function(code, ...) { MSG$get(code, ...) }
    ,getCookie = function(id) { self$cookies[[id]] }
    ,setCookie = function(id, data) {
        browser()
       self$cookies[[id]] = data
       updateCookie(self$session, YATA=self$cookies)
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
     ,startDaemons = function() {
         exec = private$base$exec()
         resp = exec$R("start_daemons")
         invisible(self)
     }
  )
  ,private = list(
# Cada objeto representa una pagina
# De esta forma se gestiona la inicializacion de la pagina
# Y guardamos los datos temporales
      panels  = NULL
     ,base = NULL
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
         if (is.null(tblCurrencies$current)) {
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
    browser()
  string = sprintf("Cookies.set(\'%s\', \'%s\');", key, value)
  runjs(string)
}
