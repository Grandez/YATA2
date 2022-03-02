# Factoria para Obtener diferentes objetos
# Los dejamos en lazy para no crear referencias circulares con los
# singletons YATABase.

YATAFACTORY = R6::R6Class("YATA.FACTORY"
   ,portable  = FALSE
   ,cloneable = FALSE
   ,lock_class = TRUE
   ,public = list(
       codes  = NULL
      ,parms  = NULL
      ,MSG    = NULL  # Like WEB
      # Ponemos init y clear para manejar fuera de initialize y finalize
      # auto se usa para el CI
      ,initialize = function(auto=TRUE) { init(auto, FALSE) }
      ,finalize   = function() { clear()     }
      ,clear     = function(){
         if (!is.null(DBFactory))   DBFactory$finalize()
         if (!is.null(ProvFactory)) ProvFactory$finalize()
         self$parms = NULL
         self$MSG  = NULL
         private$objects = NULL
#         gc(verbose=FALSE)
      }
      ,getDBName = function() {
          db = getDB()
          if (!is.null(db)) db$name
          else              NULL
      }
      ,getDBID   = function() { DBFactory$getID() }
      ,getDB     = function()                    { DBFactory$getDB()       }
      ,getDBBase = function()                    { DBFactory$getDBBase()   }
      ,setDB     = function(connData)            {
         connInfo = list.merge(cfg$sgdb, connData)
         DBFactory$setDB(connInfo)
         invisible(self)
       }
      ,changeDB  = function(id) {
          connInfo = parms$getDBInfo(id)
         private$objects = YATABase$map
         parms$setLastOpen(id)
         setDB(connInfo)
      }
      ,getTable    = function(name, force = FALSE) { DBFactory$get(name, force) }
      ,getProvider = function(code, object, force = FALSE) {
          setProvFactory() # Necesita tener Base creado
          ProvFactory$get(code, object, force)
      }
      ,getObject   = function(name, force = FALSE) {
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
      # ,getEnvironment = function() {
      #      if (is.null(private$environ)) private$environ = YATAENV$new()
      #      private$environ
      # }
      ,print = function()     { message("Factoria de objetos YATA") }
   )
   ,private = list(
       DBFactory   = NULL
      ,ProvFactory = NULL
      ,objects     = NULL
      ,classes     = NULL
      ,cfg         = NULL
      ,setProvFactory = function() {
         # Le pasamos los datos de parametros a la factoria
         ProvFactory$setOnlineInterval (parms$getOnlineInterval())
         ProvFactory$setCloseTime      (parms$getCloseTime())
         ProvFactory$setBaseCurrency   (parms$getBaseCurrency())
      }
      ,init      = function(auto, clean=TRUE){
          if (clean) clear()
          sf = system.file("extdata", "yata.ini", package=packageName())
          private$cfg         = read.config(file=sf)

          self$codes  = YATACore::YATACODES$new()

          private$objects     = YATABase$map
          private$classes     = YATABase$map
          private$DBFactory   = YATADB::YATADBFactory$new(cfg$base)
          private$ProvFactory = YATAProviders::ProviderFactory$new(private$DBFactory)

          self$parms  = OBJParms$new   (private$DBFactory)
          self$MSG    = OBJMessages$new(self$codes, private$DBFactory)

          if (auto) {
              if (parms$autoConnect()) {
                  setDB(parms$lastOpen())
              } else {
                  setDB(parms$defaultDB())
              }
          }
      }

   )
)

