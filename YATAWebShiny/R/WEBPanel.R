# Clase base para los paneles
WEBPanel = R6::R6Class("JGG.INFO.UI"
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,active = list(
  )
  ,public = list(
     name       = NULL
    ,parent     = NULL  # Puntero al padre
    ,root       = NULL  # Puntero a raiz
    ,session    = NULL
    ,factory    = NULL
    ,loaded     = FALSE # Flag de carga
    ,data       = list()  # Datos
    ,vars       = list()  # Variables temporales con memoria
    ,cookies    = list()  # Variables con estado
    ,events     = list(listen = c(""), events=c(""))
    ,DBID       = 0     # Check DB changed
    ,codes      = NULL
    ,parms      = NULL
    ,MSG        = NULL
    ,print      = function() { message(paste("Panel object for", self$name)) }
    ,initialize = function(id, parent, session) {
        web = tryCatch({ WEB }, error = function(cond) { YATAWebEnv$new()})

        self$name      = id
        self$parent    = parent
        self$session   = session
        self$root      = private$getRoot()

        self$DBID    = web$DBID
        self$factory = web$factory
        self$cookies = web$getCookies(id)

        self$codes   = self$factory$codes
        self$parms   = self$factory$parms
        self$MSG     = self$factory$MSG

    }
    ,getParent = function(name) {
        pp = self$parent
        while (!is.null(pp)) {
          if (pp$name == name) break
          pp = pp$parent
        }
        pp
    }
#    ,getCookie = function(key) { self$vars$cookies[[key]] }
    # ,setCookies = function() {
    #      WEB$setCookies(self$name, self$cookies)
    #     invisible(self)
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
    ,setCommarea       = function(...)            { WEB$setCommarea(...)        }
    ,getCommarea       = function(item=NULL, default=NULL) {
        WEB$getCommarea(item, default)
    }
    ,setCommareaBlock       = function(block, ...) {
        WEB$setCommareaBlock(block=block, ...)
     }
    ,getCommareaBlock       = function(block, item=NULL, default=NULL) {
        WEB$getCommareaBlock(block, item, default)
     }

  )
  ,private = list(
      getRoot   = function() {
         tmp = self$parent
         while (!is.null(tmp)) tmp = tmp$parent
         tmp
      }


  )
)
