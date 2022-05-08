# Factoria para Obtener diferentes objetos
# Los dejamos en lazy para no crear referencias circulares con los
# singletons YATABase.

YATAFACTORY = R6::R6Class("YATA.FACTORY"
   ,portable  = FALSE
   ,cloneable = FALSE
   ,lock_class = TRUE
   ,public = list(
       codes     = NULL
      ,parms     = NULL
      ,msg       = NULL
      ,logger    = NULL
      ,portfolio = NULL
      ,user = "YATA"
      ,fiat    = "__FIAT__"  # Codigo moneda FIAT
      ,print = function()     { message("Factoria de objetos YATA") }
      ,initialize = function(load=3) { # 1 - connect bbdd | 2 - connect to providers
          init(load)
          self$logger = YATALogger$new("yata")
       }
      ,finalize     = function() { clear() }
      ,hasPortfolio = function() { !is.null(getDB()) }
      ,clear     = function(){
          message("Clearing factory")
#         gc(verbose=FALSE)
      }
      ,setLogger = function(logger) {
          self$logger = logger
          invisible(self)
      }
      ,getID     = function() { base$getID() }
      ,changePortfolio  = function(id) {
          self$portfolio = parms$getPortfolioInfo(id, user)
          if (portfolio$target == 0) self$portfolio$target = 3
          private$objects = base$map()
          setDB(portfolio$db)
          parms$setLastPortfolio(id)
          invisible(self)
      }
      ######################################################################
      ### FACTORY GETTERS
      ######################################################################
      ,getTable    = function(name, force = FALSE) { DBFactory$get(name, force) }
      ,getProvider = function(code, object, force = FALSE) {
          setProvFactory() # Necesita tener Base creado
          ProvFactory$get(code, object, force)
      }
      ,getDefaultProvider = function() { ProvFactory$getDefaultProvider() }
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

      ,getDBID   = function() { DBFactory$getID()     }
      ,getDB     = function() { DBFactory$getDB()     }
      ,getDBBase = function() { DBFactory$getDBBase() }
      ,getDBName = function() {
          db = getDB()
          if (!is.null(db)) db$name
          else              NULL
      }

   )
   ,private = list(
       DBFactory   = NULL
      ,ProvFactory = NULL
      ,objects     = NULL
      ,classes     = NULL
      ,cfg         = NULL
      ,base        = NULL
      ,.valid      = TRUE
      ,setProvFactory = function() {
         # Le pasamos los datos de parametros a la factoria
         ProvFactory$setFactory        (self)
         ProvFactory$setOnlineInterval (parms$getOnlineInterval())
         ProvFactory$setCloseTime      (parms$getCloseTime())
         ProvFactory$setBaseCurrency   (parms$getBaseCurrency())
      }
      ,init      = function(load){
          sf = system.file("extdata", "yata.ini", package=packageName())
          private$cfg         = read.config(file=sf)

          self$codes          = YATACore:::YATACODES$new()
          private$base        = YATABase$new()
          private$objects     = YATABase::map()
          private$classes     = YATABase::map()
          private$DBFactory   = YATADB::YATADBFactory$new("YATA")

          self$msg    = OBJMessages$new(self$codes$tables$messages, private$DBFactory)
          self$parms  = OBJParms$new   (private$DBFactory, self$msg)

          if (bitwAnd(load,2) != 0) private$ProvFactory = YATAProviders::ProviderFactory$new()

          if (bitwAnd(load, 1) != 0) { # Load portfolio
              prefs = parms$getPreferences()
              if (prefs$autoOpen != 0) {
                  open = ifelse(prefs$autoOpen == 1, prefs$last, prefs$default)
                  self$portfolio = parms$getPortfolioInfo(open, user)
                  if (portfolio$target == 0) self$portfolio$target = 3 # Por si acaso
                  setDB(self$portfolio$db)
              }
          }
      }
      ,setDB     = function(connData)            {
         connInfo = jgg_list_merge(cfg$sgdb, connData)
         DBFactory$setDB(connInfo)
         invisible(self)
       }
   )
)

