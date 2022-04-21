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
      ,logger = NULL
      ,delete_flag = FALSE
      ,created = NULL
      ,fiat    = "$FIAT"  # Codigo moneda FIAT
      ,camera  = "CASH"   # Codigo camara FIAT
      ,id = 0
      ,user = "YATA"
      ,print = function()     { message("Factoria de objetos YATA") }
      ,initialize = function(load=3) {
          # level: Cosas a conectarpara hacer la carga rapida
          #    0 - Nada
          #    1 - BBDD de usuario (la de sistema siempre se conecta)
          #    2 - Providers
          init(load)
          self$logger = YATALogger$new("yata")
       }
      ,finalize   = function() { clear() }
      ,valid = function() {
          if (.valid) {
              tryCatch({
                  MSG$get("TEST")
              }, error = function(e) {
                  private$.valid = FALSE
              })
          }
          .valid
      }
      ,remove = function() {
          message("Removing")
      }
      ,hasPortfolio = function() { !is.null(getDB()) }
      ,delete     = function(){
          # message("Deleting Factory")
          # pf = parent.frame()
          # self$delete_flag = TRUE
          # insts = sapply(ls(pf), function(i) {class(get(i, envir = pf))[1] == "YATA.FACTORY"})
          #
          # this = ls(pf)[insts][sapply(mget(ls(pf)[insts], envir = pf),
          #               function(x) x$delete_flag)]
          # rm(list = this, envir = pf)
          #      message("demo object deleted!")
       }
      ,clear     = function(){
          message("Clearing factory")
         # if (!is.null(YATADBFactory))   YATADBFactory$finalize()
         # if (!is.null(ProvFactory)) ProvFactory$finalize()
         # self$parms = NULL
         # self$MSG  = NULL
         # private$objects = NULL
#         gc(verbose=FALSE)
      }
      ,setLogger = function(logger) {
          self$logger = logger
          invisible(self)
      }
      ,getID     = function() { base$getID() }
      ,getDBName = function() {
          db = getDB()
          if (!is.null(db)) db$name
          else              NULL
      }
      ,getDBID   = function() { YATADBFactory$getID() }
      ,getDB     = function()                    { YATADBFactory$getDB()       }
      ,getDBBase = function()                    { YATADBFactory$getDBBase()   }
      ,setDB     = function(connData)            {
         connInfo = list.merge(cfg$sgdb, connData)
         YATADBFactory$setDB(connInfo)
         invisible(self)
       }
      ,changeDB  = function(id) {
          connInfo = parms$getDBInfo(id)
          private$objects = base$map()
          setDB(connInfo)
          parms$setLastOpen(id)
          invisible(self)
       }
      ,getTable    = function(name, force = FALSE) { YATADBFactory$get(name, force) }
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
      # ,getEnvironment = function() {
      #      if (is.null(private$environ)) private$environ = YATAENV$new()
      #      private$environ
      # }
   )
   ,private = list(
       YATADBFactory   = NULL
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
          private$YATADBFactory   = YATADB::YATADBFactory$new("YATA")

          self$MSG    = OBJMessages$new(self$codes$tables$messages, private$YATADBFactory)
          self$parms  = OBJParms$new   (private$YATADBFactory, self$MSG)

          if (bitwAnd(load,2) != 0) private$ProvFactory = YATAProviders::ProviderFactory$new()

          if (bitwAnd(load, 1) != 0) { # Load portfolio
              prefs = parms$getPreferences()
              if (prefs$autoOpen != 0) {
                  camera = ifelse(prefs$autoOpen == 1, prefs$last, prefs$default)
                  data = parms$getCameraInfo(camera)
                  setDB(data$db)
              }
          }
      }
   )
)

