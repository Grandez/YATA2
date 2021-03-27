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
#    ,msg        = NULL
    ,layout     = NULL   # Matriz de layout del panel
#    ,nextAction = NULL  Esto no es generico
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
        self$MSG     = self$factory$msgs
        self$vars$first = 1 # Paneles que necesitan saber si es la primera vez
        private$loadCookies()
    }
    ,layoutInit = function(layout) {
        self$layout = layout
        private$layoutOld = matrix("", nrow = nrow(layout), ncol=ncol(layout))
        invisible(self)
    }
    ,layoutSet = function(layout) {
       private$layoutOld = self$layout
       self$layout = layout
       invisible(self)
    }
    ,layoutChanges = function() { self$layout != private$layoutOld }
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
    ,getCookies = function(key) {
        self$vars$cookies[[key]]
    }
    ,setCookies = function(...) {
       data = list(...)
       self$vars$cookies[names(data)] = data
       YATAWEB$setCookies(self$name, self$vars$cookies)
    }
    ,invalidate = function(panel) {
       self$getRoot()$invalidate(self$name)
       invisible(self)
    }
    ,isInvalid = function() { self$getRoot()$isInvalid(self$name) }
    ,reset     = function() {
        self$getRoot()$reset(self$name)
        invisible(self)
    }
  )
  ,private = list(
       invalid = c("")
      ,layoutOld = NULL
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
