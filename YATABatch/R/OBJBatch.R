# Objeto comun para los procesos Batch
# Carga la factoria, el objeto base, logger,etc.
# Para los Logs usaremos un numero de dos digitos
# el primero, para el detalle
# el segundo parael sumario
# Ejemplo:  1 - Imprmir sumario simple
#          32 - Imprimir mensajes de detalle de nievl 3 y resumen de nivel 2
YATABatch = R6::R6Class("YATA.OBJ.BATCH"
    ,cloneable  = FALSE
    ,portable   = FALSE
    ,lock_class = TRUE
    ,public = list(
        running  = FALSE
       ,fact   = NULL
       ,logger = NULL
       ,base   = NULL
        # Return codes
       ,rc = list(OK=0, RUNNING=2, NODATA=4, ERRORS=12, FATAL=16, SEVERE=32)
       ,initialize = function (process="YATA") {
           private$pidfile = paste0(Sys.getenv("YATA_SITE"), "/data/wrk/", process, ".pid")
           private$logfile  = paste0(Sys.getenv("YATA_SITE"), "/data/log/", process, ".log")

           if (file.exists(pidfile)) {
              message(paste("Process", process, "already running"))
              self$running = TRUE
           } else {
              cat(paste0(Sys.getpid(),"\n"), file=pidfile)
           }
           self$logger = YATALogger$new(process)
           # self$codes  = YATACore::YATACODES$new()

           # self$fact   = YATACore::YATAFACTORY$new()
           # self$logger = YATALogger$new(process)
           # self$fact$setLogger(self$logger)
           # self$base   = YATABase$new()
       }
       ,finalice = function() {

       }
       ,destroy = function(rc = 0) {
          if (!is.null(pidfile) && file.exists(pidfile)) unlink(pidfile, force = TRUE)
          invisible(rc)
       }
       ,stop_process = function() {
           # fichero de control borrado
           if (!file.exists(pidfile)) return (TRUE)
           # Existe la palabra stop en el fichero de control
           data = readLines(pidfile)
           if (length(grep("stop", data, ignore.case = TRUE)) > 0) return (TRUE)
           FALSE
       }
       ,setVerbose = function(verbose) {
           # if (!missing(verbose)) {
           #     det = verbose %% 10
           #     private$msgDet = verbose %% 10
           #     private$msgSum = floor( verbose / 10)
           # }
           # invisible(self)
       }
       # ,log = function(level, txt, ...) {
       #     if (level > 0 && level <= msgDet) {
       #         prfx = paste0(rep("   ",level), collapse="")
       #         txt = paste0(prfx,txt, collapse="")
       #         msg(sprintf(txt, ...))
       #     }
       #     invisible(self)
       #  }
       ,warn = function(txt, ...) { msg(.msg("wARNING:", txt, ...), out=stderr()) }
       ,info = function(txt, ...) { msg(.msg("INFO   :", txt, ...), out=stdout()) }
       ,err  = function(txt, ...) { msg(.msg("ERROR  :", txt, ...), out=stderr()) }
       ,cont = function(txt, ...) { msg(sprintf(paste0("        ",txt), ...), out=stderr()) }
       ,summary = function(level, txt, ...) {
          if (level <= msgSum) msg(.msg("", txt, ...))
        }
       ,begin = function()   { private$tmsBeg = Sys.time() }
       ,end   = function(rc) { rc }
    )
    ,private = list(
         tmsBeg = 0
        ,tmsEnd = 0
        ,msgDet = 0
        ,msgSum = 0
        ,pidfile = NULL
        ,logfile = NULL
        ,.msg = function(head="", txt, ...) {
           lbl = trimws(paste(head, txt))
           sprintf(lbl, ...)
        }
    )
)



