# Factoria para Obtener diferentes objetos
# Los dejamos en lazy para no crear referencias circulares con los
# singletons YATABase. Env, etc

YATAFACTORY = R6::R6Class("YATA.FACTORY"
   ,portable  = FALSE
   ,cloneable = FALSE
   ,lock_class = TRUE
   ,public = list(
       initialize = function(env) {
          message("Creando Factory")
          sf = system.file("extdata", "yata.ini", package=packageName())
          private$cfg         = read.config(file=sf)
          private$objects     = HashMap$new()
          private$classes     = HashMap$new()
          private$DBFactory   = YATADB::YATADBFactory$new(cfg$base)
          private$ProvFactory = YATAProviders::ProviderFactory$new(private$DBFactory)
          private$parms       = OBJParms$new   (private$DBFactory)
          private$msgs        = OBJMessages$new(private$DBFactory)
          if (parms$autoConnect()) {
              setDB(parms$lastOpen())
          } else {
              setDB(parms$defaultDB())
          }
          # Aqui hay que crear los parametros y conectar si es necesario
          message("Factory inicializada")
       }
      ,finalize  = function() {
         message("Limpiando DB")
         if (!is.null(DBFactory))   DBFactory$finalize()
         message("Limpiando Providers")
         if (!is.null(ProvFactory)) ProvFactory$finalize()
         message("Limpiando objetos")
         private$parms = NULL
         private$objects = NULL
         message("Limpiando memoria")
         gc()
         message("Fin limpieza")
      }
      ,getDBName = function() {
         db = getDB()
         if (!is.null(db)) {
            db$name
         }
         else {
            NULL
         }
      }
      ,getDBID   = function() { DBFactory$getID() }
      ,getMSG    = function() {
         if (is.null(private$msgs)) private$msgs = OBJMessages$new(private$DBFactory)
              private$msgs
      }
      ,getParms  = function()                    {
          if (is.null(private$parms)) private$parms = OBJParms$new(private$DBFactory)
              private$parms
       }
      ,getDB     = function()                    { DBFactory$getDB()         }
      ,setDB     = function(connData)            { DBFactory$setDB(connData) }
      ,changeDB  = function(id) {
          connInfo = parms$getDBInfo(id)
         private$objects = HashMap$new()
         parms$setLastOpen(id)
         setDB(connInfo)
      }
      ,getTable    = function(name, force = FALSE) { DBFactory$get(name, force) }
      ,getProvider = function(code, object, force = FALSE) {
          setProvFactory() # Necesita tener Base creado
          ProvFactory$get(code, object, force)
      }
      ,getObject   = function(name, force = FALSE) {
         if (force) return ( eval(parse(text=paste0("OBJ", name, "$new()"))))
         if (is.null(objects$get(name))) private$objects$put(name,
                                         eval(parse(text=paste0("OBJ", name, "$new()"))))
         objects$get(name)
      }
      ,getClass   = function(name, force = FALSE) {
         if (force) return ( eval(parse(text=paste0("R6", name, "$new()"))))
         if (is.null(classes$get(name))) private$classes$put(name,
                                         eval(parse(text=paste0("R6", name, "$new()"))))
         classes$get(name)
      }
      ,getEnvironment = function() {
           if (is.null(private$environ)) private$environ = YATAENV$new()
           private$environ
      }
      ,print = function()     { message("Factoria de objetos YATA") }
   )
   ,private = list(
       environ     = NULL
      ,DBFactory   = NULL
      ,ProvFactory = NULL
      ,objects     = NULL
      ,classes     = NULL
      ,cfg         = NULL
      ,parms       = NULL
      ,msgs        = NULL
      ,setProvFactory = function() {
         # Le pasamos los datos de parametros a la factoria
         ProvFactory$setOnlineInterval (parms$getOnlineInterval())
         ProvFactory$setCloseTime      (parms$getCloseTime())
         ProvFactory$setBaseCurrency   (parms$getBaseCurrency())
      }
   )
)

