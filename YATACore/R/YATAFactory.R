# Factoria para Obtener diferentes objetos
# Los dejamos en lazy para no crear referencias circulares con los
# singletons YATATools.

YATAFactory = R6::R6Class("YATA.FACTORY"
   ,portable  = FALSE
   ,cloneable = FALSE
   ,lock_class = TRUE
   ,public = list(
#       codes     = NULL
       parms     = NULL
      ,msg       = NULL
      ,backend   = NULL
#      ,logger    = NULL
      ,portfolio = NULL
      ,user = "YATA"
      ,fiat    = "__FIAT__"  # Codigo moneda FIAT
      ,print = function()     { message("Factoria de objetos YATA") }
      ,initialize = function(load=3) { # 1 - connect bbdd | 2 - connect to providers
          private$objects = YATATools::map()
          private$classes = YATATools::map()
          private$DBBase  = YATADBBase::DBFactory$new()
          private$DBUser  = YATADBUser::DBFactory$new()

          self$msg     = OBJMessages$new(DBBase)
          self$parms   = OBJParms$new   (DBBase, self$msg)
          self$backend = OBJBackend$new(self)
#JGG

#           if (bitwAnd(load, 1) != 0) { # Load portfolio
# #JGG              prefs = parms$getPreferences()
#               if (prefs$autoOpen != 0) {
#                   open = ifelse(prefs$autoOpen == 1, prefs$last, prefs$default)
#                   self$portfolio = parms$getPortfolioInfo(open, user)
#                   if (portfolio$target == 0) self$portfolio$target = 3 # Por si acaso
#                   setDB(self$portfolio$db)
#               }
#           }

       }
      ,finalize       = function() { clear() }
      ,destroy        = function() {
          private$DBBase$destroy()
          private$DBUser$destroy()
      }
      # ,hasPortfolio   = function() { !is.null(portfolio) }
      # ,getPortfolio   = function() { self$portfolio      }
      # ,getPortfolioID = function() { ifelse(is.null(self$portfolio), 0, self$portfolio$id)  }
      ,clear     = function(){
          gc(verbose=FALSE)
      }
      # ,setLogger = function(logger) {
      #     self$logger = logger
      #     invisible(self)
      # }
      ,getID     = function() {YATATools::uniqueID() }
      # ,changePortfolio  = function(id) {
      #     self$portfolio = parms$getPortfolioInfo(id, user)
      #     if (portfolio$target == 0) self$portfolio$target = 3
      #     private$objects = base$map()
      #     setDB(portfolio$db)
      #     parms$setLastPortfolio(id)
      #     invisible(self)
      # }
      ######################################################################
      ### FACTORY GETTERS
      ######################################################################
      ,getTable    = function(name, force = FALSE) {DBUser$getTable(name, force) }
      ,getObject   = function(name, force = FALSE) {
         # Pasamos la propia factoria como referencia
         if (force) return ( eval(parse(text=paste0("OBJ", name, "$new(self)"))))
         if (is.null(objects$get(name))) private$objects$put(name,
                                         eval(parse(text=paste0("OBJ", name, "$new(self)"))))
         objects$get(name)
      }
      ,getClass   = function(name, force = FALSE) {
         # Obtiene una clase general
         if (force) return ( eval(parse(text=paste0("R6", name, "$new()"))))
         if (is.null(classes$get(name))) private$classes$put(name,
                                         eval(parse(text=paste0("R6", name, "$new()"))))
         classes$get(name)
      }
      ######################################################################
      ### Database associated to an object
      ######################################################################

#      ,getDBID   = function() { DBFactory$getID()     }
      ,getDB     = function()     { DBUser$getDB()  }
      ,getDBBase = function()     { DBBase$getDB()  }
      ,getDBUser = function()     { DBUser$getDB()  }
      ,changeDB  = function(data) {
          DBUser$destroy()
          private$DBUser  = YATADBUser::DBFactory$new(data)
          invisible(self)
       }
      # ,getDBName = function() {
      #     db = getDB()
      #     if (!is.null(db)) db$name
      #     else              NULL
      # }
      #
   )
   ,private = list(
       DBBase      = NULL
      ,DBUser      = NULL
      ,objects     = NULL
      ,classes     = NULL
      #,cfg         = NULL
      # ,setDB     = function(connData)            {
      #    connInfo = jgg_list_merge(cfg$sgdb, connData)
      #    DBFactory$setDB(connInfo)
      #    invisible(self)
      #  }
   )
)

