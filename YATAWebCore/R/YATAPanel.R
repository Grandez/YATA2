# Clase base para los paneles
YATAPanel = R6::R6Class("YATA.PANEL"
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,active = list(
    inEvent = function(value) {
      if (missing(value)) {
        private$.inEvent
      } else {
        private$.inEvent = value
      }
    }
  )
  ,public = list(
     name       = NULL
    ,parent     = NULL  # Puntero al padre
    ,loaded     = FALSE # Flag de carga
    ,factory    = NULL  # factory Singleton
    ,codes      = NULL  # short code to factory$codes
    ,parms      = NULL  # short code to factory$parms
    ,MSG        = NULL  # short code to factory$msgs
    ,DBID       = 0     # Check DB changed
    ,data       = list()  # Datos
    ,vars       = list()  # Variables temporales con memoria
    ,cookies    = list() # Variables con estado
    ,layout     = NULL
    ,visited    = 0
    ,print      = function() { message(paste("Panel object for", self$name)) }
    ,initialize = function(id, parent, session, ns = NULL) {
        self$name         = id
        self$parent       = parent
        web = tryCatch({ WEB }, error = function(cond) { YATAWebEnv$new()})
        self$DBID = web$DBID
        self$factory = web$factory
        #if (!is.null(private$definition)) private$definition$id = id
        # Typos
        self$codes   = self$factory$CODES
        self$parms   = self$factory$parms
        self$MSG     = self$factory$MSG
#        self$vars$first = 1 # Paneles que necesitan saber si es la primera vez
#JGG        private$loadCookies()
        private$root = self$getRoot()
        # if (!missing(ns) && !is.null(self$cookies$layout)) {
        #     self$layout = OBJLayout$new(ns)
        #     self$layout$update(session, self$cookies$layout)
        # }
    }
    ,isRoot      = function() { FALSE }
    ,getParent = function(name) {
        pp = self$parent
        while (!is.null(pp)) {
          if (pp$name == name) break
          pp = pp$parent
        }
        pp
    }
     ,getRoot = function() {
         root = self
         pp   = root$parent
         while (!is.null(pp)) {
                root = pp
                pp = pp$parent
         }
         root
      }
    ,makeCombo = function(df) {
        data = as.list(df$id)
        names(data) = df$name
        data
    }
    # ,setMsg = function(code, ...) {
    #    self$msg = self$MSG$get(code, ...)
    #    TRUE
    # }
    # ,getMsg = function() {
    #   self$msg
    # }
#    ,getCookie = function(key) { self$vars$cookies[[key]] }
    ,setCookies = function() {
#        WEB$setCookies(self$name, self$cookies)
        invisible(self)
    }
    #   browser()
    #    data = list(...)
    #    if (length(data) > 0) {
    #        if (length(self$vars$cookies) == 0) {
    #            self$vars$cookies = data
    #        } else {
    #            self$vars$cookies = list.merge(self$vars$cookies, data)
    #        }
    #        WEB$setCookies(self$name, self$vars$cookies)
    #    }
    # }
    ,invalidate = function(panel) {
       if (!is.null(self$parent)) self$parent$invalidate(panel)
       invisible(self)
    }
    ,isInvalid = function(panel) {
        if (!is.null(self$parent)) self$parent$isInvalid(panel)
     }
    ,reset     = function() {
        if (!is.null(self$parent)) self$parent$reset(self$name)
        invisible(self)
    }
    # ,getDef = function() {
    #    if (is.null(private$definition))
    #        return (list(id=self$name, left=-1, right=-1, son=NULL, submodule=FALSE))
    #     private$definition
    #  }
    ##########################################################
    ### Acceso a root
    ##########################################################
    ,getGlobalPosition = function(fiat=FALSE) { private$root$getGlobalPosition(fiat) }
    ,getOpenCurrencies = function()           { private$root$getOpenCurrencies()     }
    ,setCommarea       = function(...)        { private$root$setCommarea(...)        }
    ,getCommarea       = function(item=NULL, default=NULL) {
        private$root$getCommarea(item, default)
     }
  )
  ,private = list(
       invalid = c("")
      ,root   = NULL
      ,.inEvent = FALSE
      ,loadCookies = function() {
          # cookies = WEB$getCookies(self$name)
          # if (!is.null(cookies)) self$cookies = list.merge(self$cookies, cookies)
      }
  )
)
