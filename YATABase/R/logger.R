# En fichero usamos tms;tipo_mensaje
# tipo:mensaje es:
#   1 - Ejecutado
#
YATALogger = R6::R6Class("YATA.LOGGER"
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,portable   = FALSE
    ,active = list(
      logLevel = function(value) {
          if (!missing(value)) private$.logLevel = value
          .logLevel
      }
    )
    ,public = list(
        valid = TRUE
       ,lastErr   = NULL
       ,print     = function() { message("Global environment for YATA")}
       ,initialize= function(module, console=FALSE,log=1) {
           .setLogFile()
           if (!missing(module)) private$modname = module
           private$.logLevel   = log
           private$console = console
       }
       ,process   = function(level, fmt, ...) {
          if (level > .logLevel) return (invisible(self))
          msg = .mountMessage(fmt,...)
          .println(2, msg)
          invisible(self)
       }
       ,info      = function(level, fmt, ...) {
          if (level > .logLevel) return (invisible(self))
          msg = .mountMessage(fmt,...)
          .println(3, msg)
          invisible(self)
       }
       ,executed  = function(rc, elapsed, fmt, ...) {
          if (.logLevel == 0) return(invisible(self))
          msg = .mountMessage(fmt,...)
          if (console) {
              .toConsole(msg)
              if (.logLevel > 0) {
                  .toConsole(paste("Elapsed time:", elapsed))
                  .toConsole(paste("Return code :", rc))
              }
          }
          if (!console) .toFile(1,msg,elapsed,rc)
          invisible(self)
      }
       ,message   = function(fmt, ...) {
         .println(5, .mountMessage(fmt, ...))
         invisible(self)
       }
       ,beg       = function(name, level = 0) {
           if (level > .logLevel) return (invisible(self))
           idx = length(logTimers)
           if (idx == 0) {
               private$logTimers = as.integer(Sys.time())
               private$logNames  = name
           } else {
               private$logTimers = c(logTimers, as.integer(Sys.time()))
               private$logNames  = c(logNames, name)
           }
           idx = length(logTimers)
           message("BEG - %d - %s", logTimers[idx], name)
           invisible(self)
       }
       ,end       = function(name) {
           idx = which.max(logNames)
           if (length(idx) == 0) return (invisible(self))
           idx = idx[1]
           from = length(longNames)
           while (from > idx ) {
              diff = as.integer(Sys.time()) - logTimers[from]
              message("END - %d - %d - %s", as.integer(Sys.time()), diff, logNames[from])
              from = from - 1
           }
           diff = as.integer(Sys.time()) - logTimers[idx]
           message("END - %d - %d - %s", as.integer(Sys.time()), diff, name)
           if (idx == 1) {
               private$logTimers = c()
               private$logNames  = c()
           } else {
               private$logTimers = logTimers[1:(idx - 1)]
               private$logNames  = logNames [1:(idx - 1)]
           }
           invisible(self)
       }

    )
    ,private = list(
        logFile  = NULL
       ,.logLevel = 0
       ,console  = FALSE
       ,modname  = "YATA"
       ,logTimers = NULL
       ,logNames  = NULL
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

