# Objeto global para guardar la configuracion
# Y los objetos
# Almacenamos tambien las monedas y sus nombres
YATAWebEnv = R6::R6Class("YATA.WEB.ENV"
  ,portable   = TRUE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,inherit    = JGGWEB
  ,public = list(
      msg      = NULL
     ,factory  = NULL
     # ,REST   = NULL
     # ,errorLevel = 0 # Nivel de error (99 - unhandled, 98 - init, 97 - No servers, 97)
     # ,txtError = NULL

     # ,session  = NULL
     # ,log      = NULL
#     ,window  = list(width = 0, height = 0)
     ,combo    = NULL
     ,print    = function() { message("Singleton for APP WEB")}
     ,initialize = function() {

         super$initialize()

         tryCatch({
         self$factory = YATACore::YATAFactory$new()
         self$msg        = self$factory$msg
            # self$log        = YATALogger$new("WEB")
            # private$hID     = private$base$map()
            # private$hSym    = private$base$map()
            # private$hCam    = private$base$map()
            # private$idPortfolio = self$factory$getPortfolioID()
         self$combo      = YATAWebCombos$new(self$factory)
            # private$tblCurrencies = self$factory$getTable(self$factory$codes$tables$currencies)
            # self$REST       = YATAServer$new(self$factory)
            # self$errorLevel = self$REST$check()
            # if (self$errorLevel > 0) self$txtError = "REST Services"

             message("Iniciado YATAWebEnv")
         }, YATAERROR = function (cond) {
             browser()
             self$errorLevel = 98
             self$txtError = cond$message
         }, error = function(cond) {
             browser()
            self$errorLevel = 99
            self$txtError = cond$message
         })
     }
     ,finalize = function() {
         # private$tblCurrencies = NULL
         # private$tblCameras    = NULL
         # private$hID    = NULL
         # private$hSym   = NULL
         # private$hCam   = NULL
      #   self$factory$clear()
     }
     # ,setWindow = function(data) {
     #     # self$window$width  = data$window_width
     #     # self$window$height = data$window_height
     # }
     # ,setSession = function(session) {
     #     #JGG Revisr
     #     self$session = session
     #     data = parseQueryString(session$request$HTTP_COOKIE)
     #     if (length(data) > 0 && !is.null(data$YATA)) private$cookies = fromJSON(data$YATA)
     #     invisible(self)
     #  }
     # ,getPanel = function(name, loading=FALSE)  {
     #     panel = private$panels$get(name)
     #     if (!is.null(panel)) shinyjs::js$yata_set_page(name)
     #     panel
     # }
     # ,addPanel = function(panel) {
     #     private$panels$put(panel$name, panel)
     #     shinyjs::js$yata_add_page(panel$name)
     #     self$getPanel(panel$name, loading=TRUE)
     # }


    #  ,tooltip            = function(id)  { self$msg$tooltip(id)   }
     ,getLabelsPanel     = function(cached=TRUE)    {
         if (!is.null(private$cache$lblPanels)) return (private$cache$lblPanels)
         lst = self$getLabelsMenu( 0)
         if (cached) private$cache$lblPanels = lst
         lst
      }
     ,getLabelsMenuMain  = function()    {
         self$getLabelsMenu( 1) }
     ,getLabelsMenuOper  = function(cached=TRUE)    {
         if (!is.null(private$cache$menuOper)) return (private$cache$menuOper)
         lst = self$getLabelsMenu( 2)
         if (cached) private$cache$menuOper = lst
         lst
      }
    #  ,getLabelsMenuAdmin = function()    { self$getLabelsMenu( 5) }
    #  ,getLabelsPanelErr  = function()    { self$getLabelsMenu( 9) }
     ,getLabelsMenu      = function(idx) {
         key = YATACODE$labels$lblPanels + idx
         self$msg$getBlock(key)
     }
    #  ,getLabelsAdmin     = function() { self$msg$getBlock(40) }
    #  ,getMsg    = function(code, ...) { self$msg$get(code, ...) }
    #  ,loadCookies = function(data)    { private$cookies = jsonlite::fromJSON(data) }
    #  ,setCookies  = function(name, values) {
    #     private$cookies[[name]] = values
    #     updateCookie(self$session, yata=private$cookies)
    #     invisible(self)
    # }
    #  ,getCookies = function(block)    {
    #     if (missing(block))
    #         private$cookies
    #     else
    #         private$cookies[[block]]
    #  }
    #  ,getCookie = function(id) { private$cookies[[id]] }
    #  ,setCookie = function(id, data) {
    #    private$cookies[[id]] = data
    #    updateCookie(self$session, YATA=private$cookies)
    # }

    #  ,getCTCLabels = function(codes, type="medium", invert = FALSE) {
    #     # Acepta: id, sym, name, long, medium, short
    #     # Devuelve una lista
    #     # Invert se usa para combos, en vez de la lista de etiquetas las da de codes
    #     if (is.numeric(codes)) data = lapply(codes, function(code) .getNameByID(code, type))
    #     else                   data = lapply(codes, function(code) .getNameBySym(code, type))
    #     names(data) = codes
    #     if (invert) {
    #        names(codes) = data
    #        data = codes
    #     }
    #     data
    # }
    #  ,getCTCLabel = function(code, type="medium", invert = FALSE) {
    #     data = getCTCLabels(code,type,invert)
    #     data[[1]]
    # }
    #  ,getCTCID = function(codes) {
    #     cdg = codes
    #     fiat = which(codes == "FIAT")
    #     if (length(fiat)) cdg = codes[-fiat]
    #     if (length(cdg) == 0) return(NULL)
    #     df = tblCurrencies$table(inValues=list(symbol=cdg))
    #     data = df$id
    #     names(data) = df$symbol
    #     if (length(fiat)) data = c(data,FIAT=0)
    #     data
    # }


    #  ,getCameraNames = function(codes) {
    #     fun = function(code) {
    #         name = private$hCam$get(code)
    #         if (is.null(name)) {
    #             df = tblCameras$table(id=code)
    #             name = df[1,"name"]
    #             private$hCam$put(code, name)
    #         }
    #         name
    #     }
    #     lst = lapply(codes, function(code) fun(code) )
    #     names(lst) = codes
    #     lst
    # }
    #  ,startDaemons = function() {
    #      YATABatch::startDaemons()
    #      invisible(self)
    #  }
  )
  ,private = list(
# Cada objeto representa una pagina
# De esta forma se gestiona la inicializacion de la pagina
# Y guardamos los datos temporales
     #  panels  = NULL
     # ,base = NULL
     # ,.logLevel = 0
     # ,tblCurrencies = NULL
     # ,tblCameras    = NULL
     # ,hID     = NULL
     # ,hSym    = NULL
     # ,hCam    = NULL
     # ,cookies = NULL
       cache   = list() # Cache mensajes
     # ,logsess = as.integer(Sys.time())
     # ,logs    = c(rep(0,10))
     # ,logn    = c(rep("", 10))
     # ,logi    = 1
    #  ,.getNameByID = function (id, type) {
    #      info = hID$get(id)
    #      if (is.null(info)) info = .addSymbol(id)
    #      .getName(info, type)
    #  }
    #  ,.getNameBySym = function (sym, type) {
    #      info = hSym$get(sym)
    #      if (is.null(info)) info = .addSymbol(sym)
    #      .getName(info, type)
    #  }
    # ,.addSymbol = function(code) {
    #      if (is.numeric(code)) tblCurrencies$select(id=code)
    #      else                  tblCurrencies$select(symbol=code)
    #
    #      info = list()
    #      if (is.null(tblCurrencies$current)) {
    #        info$id     = code
    #        info$symbol = code
    #        info$name   = code
    #        info$lbl    = code
    #        info$lbl32  = code
    #        info$lbl20  = code
    #      }
    #      else {
    #         info$id     = tblCurrencies$current$id
    #         info$symbol = tblCurrencies$current$symbol
    #         info$name   = tblCurrencies$current$name
    #         info$lbl    = paste0(info$symbol, " - ", info$name)
    #         info$lbl32  = ifelse(nchar(info$lbl) > 32, substr(info$lbl, 1, 20), info$lbl)
    #         info$lbl20  = ifelse(nchar(info$lbl) > 30, substr(info$lbl, 1, 32), info$lbl)
    #      }
    #      hID$put (info$id,     info)
    #      hSym$put(info$symbol, info)
    #      info
    # }
    # ,.getName = function(info, type) {
    #     if (type == "id")     return (info$id)
    #     if (type == "symbol") return (info$symbol)
    #     if (type == "name")   return (info$name)
    #     if (type == "full")   return (info$lbl)
    #     if (type == "long")   return (info$lbl32)
    #     if (type == "medium") return (info$lbl20)
    # }
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

# yataSetCookie = function(key, value) {
#     browser()
#   string = sprintf("Cookies.set(\'%s\', \'%s\');", key, value)
#   runjs(string)
# }
