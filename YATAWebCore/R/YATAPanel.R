# Clase base para los paneles
YATAPanel = R6::R6Class("YATA.PANEL"
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,public = list(
     name       = NULL
    ,parent     = NULL
    ,loaded     = FALSE
    ,valid      = FALSE
    ,factory    = NULL
    ,codes      = NULL
    ,parms      = NULL
    ,MSG        = NULL
    ,msg        = NULL
    ,nextAction = NULL
    ,data       = list()  # Datos
    ,vars       = list()  # Variables temporales con memoria
    ,initialize = function(id, parent, session) {
        self$name    = id
        self$parent  = parent
        self$factory = YATAWEB$factory
        self$codes   = self$factory$codes
        self$parms   = self$factory$parms
        self$MSG     = self$factory$msgs

        private$pnlDef$id = id
        if (!missing(session)) session$sendCustomMessage("setPanel", private$pnlDef)
        private$loadCookies()
    }
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
    ,setMsg = function(code, ...) {
       self$msg = self$MSG$get(code, ...)
       TRUE
    }
    ,getMsg = function() {
      self$msg
    }
    ,getCookies = function(key) {
        self$vars$cookies[[key]]
    }
    ,setCookies = function(...) {
       data = list(...)
       self$vars$cookies[names(data)] = data
       YATAWEB$setCookies(self$name, self$vars$cookies)
    }
  )
  ,private = list(
      pnlDef = list(
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
