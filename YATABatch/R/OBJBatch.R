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
       ,process = "YATA"
        # Return codes (Correct are even, failed are odd)
       ,rc = list(OK=0, RUNNING=2, NODATA=4, KILLED=8, INVALID=12, FLOOD=17, ERRORS=33, SEVERE=41, FATAL=129)
       ,initialize = function (process="YATA", logLevel = 0, logOutput = 0) {
           self$process = process
           site = Sys.getenv("YATA_SITE")
           if (nchar(site) == 0) {
              site = "/tmp"
              os   = Sys.info()
              if (os["sysname"] == "windows") site = Sys.getenv("temp")
              site = normalizePath(file.path(site, "YATA"))
           }
           dir.create(site, showWarnings = FALSE)
           dirWrk = normalizePath(file.path(site, "data/wrk"))
           dir.create(dirWrk, showWarnings = FALSE)

           dirLog = normalizePath(file.path(site, "data/log"))
           dir.create(dirLog, showWarnings = FALSE)

           private$pidfile = file.path(dirWrk, paste0(process, ".pid"))
           private$logfile = file.path(dirLog, paste0(process, ".log"))

           if (file.exists(pidfile)) {
              self$running = TRUE
           } else {
              cat(paste0(Sys.getpid(),"\n"), file=pidfile)
           }
           self$logger = YATALogger$new(process, logLevel, logOutput)
       }
       ,destroy = function(rc = 0) {
          if (!is.null(pidfile) && file.exists(pidfile)) unlink(pidfile, force = TRUE)
          invisible(rc)
       }
       ,stop_process = function(expception = FALSE) {
           # fichero de control borrado
           if (!file.exists(pidfile)) {
               if (!exception) return (TRUE)
               YATABase:::KILLED(paste(process, "killed by user"))
           }
           # Existe la palabra stop en el fichero de control
           data = readLines(pidfile)
           if (length(grep("stop", data, ignore.case = TRUE)) > 0) {
               if (!exception) return (TRUE)
               YATABase:::KILLED(paste(process, "killed by user"))
           }
           FALSE
       }
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



