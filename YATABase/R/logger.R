# En fichero usamos tms;tipo_mensaje
# tipo:mensaje es:
#   1 - Ejecutado
#
YATALogger = R6::R6Class("YATA.LOGGER"
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,portable   = FALSE
    ,public = list(
        valid = TRUE
       ,lastErr   = NULL
       ,print      = function() { message("Global environment for YATA")}
       ,initialize = function(module, console=FALSE,log=1) {
           .setLogFile()
           if (!missing(module)) private$modname = module
           private$logLevel   = log
           private$console = console
       }
       ,process = function(level, fmt, ...) {
          if (level > logLevel) return (invisible(self))
          msg = .mountMessage(fmt,...)
          .println(2, msg)
          invisible(self)
       }
       ,info = function(level, fmt, ...) {
          if (level > logLevel) return (invisible(self))
          msg = .mountMessage(fmt,...)
          .println(3, msg)
          invisible(self)
       }
      ,executed = function(rc, elapsed, fmt, ...) {
          if (logLevel == 0) return()
          msg = .mountMessage(fmt,...)
          if (console) {
              .toConsole(msg)
              if (logLevel > 1) {
                  .toConsole(paste("Elapsed time:", elapsed))
                  .toConsole(paste("Return code :", rc))
              }
          }
          if (!console) .toFile(1,msg,elapsed,rc)
      }
    )
    ,private = list(
        logFile  = NULL
       ,logLevel = 0
       ,console  = FALSE
       ,modname  = "YATA"
       ,.println = function(type, msg) {
          if (!console) return (.toFile(type, msg))
          .toConsole(msg)
           cat("\n")
       }
       ,.setLogFile = function() {
           if (.Platform$OS.type != "windows") {
               private$logFile = "/tmp/yata.log"
               return()
           }
           root = Sys.getenv("TMP")
           if (nchar(root) == 0) root = Sys.getenv("TEMP")
           if (nchar(root) != 0) root = paste0(root, "/")
           private$logFile = paste0(root, "yata.log")
       }
       ,.toFile = function(type, ...) {
           str = Sys.time()
           str = sub(" ", "-", str)
           line = paste(str,type,modname,..., sep=";")
           cat(line, file=logFile, append=TRUE)
       }
       ,.toConsole = function(msg) {
           str = format(Sys.time(), "%H:%M:%S")
           cat(paste0(str, " - ", msg))
       }

       ,.mountMessage = function(fmt, ...) {
           sprintf(fmt, ...)
       }
    )
)

