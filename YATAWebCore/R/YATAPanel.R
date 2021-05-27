# Clase base para los paneles
YATAPanel = R6::R6Class("YATA.PANEL"
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,public = list(
     name       = NULL
    ,parent     = NULL  # Puntero al padre
    ,loaded     = FALSE # Flag de carga
    ,factory    = NULL  # Puntero a Factory
    ,codes      = NULL  # short code to factory$codes
    ,parms      = NULL  # short code to factory$parms
    ,MSG        = NULL  # short code to factory$msgs
    ,data       = list()  # Datos
    ,vars       = list()  # Variables temporales con memoria
    ,cookies    = list() # Variables con estado
    ,layout     = NULL
    ,print      = function() { message(paste("Panel object for", self$name)) }
    ,initialize = function(id, parent, session, ns) {
        self$name         = id
        self$parent       = parent

        # Typos
        self$factory = YATAWEB$factory
        self$codes   = self$factory$codes
        self$parms   = self$factory$parms
        self$MSG     = self$factory$MSG
#        self$vars$first = 1 # Paneles que necesitan saber si es la primera vez
        private$loadCookies()
        private$root = private$getRoot()
        if (!missing(ns) && !is.null(self$cookies$layout)) {
            self$layout = OBJLayout$new(ns)
            self$layout$update(session, self$cookies$layout)
        }
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
        YATAWEB$setCookies(self$name, self$cookies)
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
    #        YATAWEB$setCookies(self$name, self$vars$cookies)
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
    ,getDef = function() {
        def = private$definition
        if (is.null(def)) def = list(id=self$name, left=-1, right=-1)
        def
     }
    ##########################################################
    ### Acceso a root
    ##########################################################
    ,getGlobalPosition = function(fiat=FALSE) { private$root$getGlobalPosition(fiat) }
    ,getOpenCurrencies = function()           { private$root$getOpenCurrencies()     }
    ,getCommarea       = function()           { private$root$getCommarea()           }
    ,setCommarea       = function(data)       {
        private$root$setCommarea(data)
        invisible(self)
    }
    ,setCommareaItem   = function(name, value) {
        private$root$setCommareaItem(name, value)
        invisible (self)
     }
    ,setCommareaItems  = function(...)        {
        private$root$setCommareaItems(...)
        invisible (self)
     }
    ,getCommareaItem  = function(item, default=NULL)  {
        private$root$getCommareaItem(item, default)
      }
  )
  ,private = list(
       invalid = c("")
      ,root   = NULL
     ,getRoot = function() {
         root = self
         pp   = root$parent
         while (!is.null(pp)) {
                root = pp
                pp = pp$parent
         }
         root
      }
      ,loadCookies = function() {
          cookies = YATAWEB$getCookies(self$name)
          if (!is.null(cookies)) self$cookies = list.merge(self$cookies, cookies)
      }
  )
)
