YATAENV = R6::R6Class("YATA.ENV"
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,portable   = FALSE
    ,public = list(
        valid = TRUE
       ,lastErr   = NULL
       ,print      = function() { message("Global environment for YATA")}
       ,initialize = function() {
           stop("Que es esta clase??????")
           message("Creando Entorno")
            # tryCatch({ private$base = YATABASE$new()
            #            initEnv()
            # }, error = function(cond) {
            #     browser()
            #    self$valid = FALSE
            #    err   = cond
            #    stop(errorCondition("Error de inicializacion",
            #                           class=c("YATAErr", "error")))
            # })
           message("ENV creado")
       }
       ,setErr = function(errobj) {
           self$lastErr = errobj
           inivisible(self)
       }
        ,err = function(errobj) {
            setErr(errobj)
            stop(errorCondition(err$text, class=c("YATAErr", "error")))
        }
        ,getBase   = function() { private$base  }
        ,currencies       = function(codes) { base$currencies(codes)       }
        ,getCurrencyNames = function(codes, full) { base$getCurrencyNames(codes, full) }
        ,icon             = function(name) {
            name = toupper(name)
            system.file(paste0("extdata/icons/icons/", name, ".png"), package=packageName(), mustWork = TRUE)
        }
    )
    ,private = list(
        base    = NULL
       ,initEnv = function() {
           if (base$autoConnect()) YATAFactory$getDB(base$lastOpen())
       }
    )
)

