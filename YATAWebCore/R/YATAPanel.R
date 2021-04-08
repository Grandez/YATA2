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
    ,initialize = function(id, parent, session) {
        self$name         = id
        self$parent       = parent
        private$pnlDef$id = id

        session$sendCustomMessage("setPanel", private$pnlDef)

        self$factory = YATAWEB$factory
        self$codes   = self$factory$codes
        self$parms   = self$factory$parms
        self$MSG     = self$factory$MSG
        self$vars$first = 1 # Paneles que necesitan saber si es la primera vez
        private$loadCookies()
    }
    ,root      = function() { FALSE }
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
    ,getCookie = function(key) { self$vars$cookies[[key]] }
    ,setCookies = function(...) {
      browser()
       data = list(...)
       if (length(data) > 0) self$vars$cookies = list.merge(self$vars$cookies, data)
       YATAWEB$setCookies(self$name, self$vars$cookies)
    }
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
  )
  ,private = list(
       invalid = c("")
      ,pnlDef = list(
         name="name"
         ,id=NULL
         ,leftSide=FALSE
         ,rightSide=FALSE
      )
      ,loadCookies = function() {
          self$vars$cookies = list()
          cookies = YATAWEB$getCookies(self$name)
          if (!is.null(cookies)) self$vars$cookies = cookies
      }
  )
)
