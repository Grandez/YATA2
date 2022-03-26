# En fichero usamos tms;tipo_mensaje
# Segun sea el tipo del mensaje, asi es el registro
# tipo:mensaje es:
#    1 - Process (Batch, Session, etc)
#    5 - Batch Process
#   10 - Logging/info:
#      tms;10;nivel;datos
#   99 - ERROR
# Salida (out) es
#   - 0 - Nada
#   - 1 - Fichero
#   - 2 - Consola
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
        valid   = TRUE
       ,lastErr = NULL
       ,PROCESS =  1
       ,BATCH   =  5
       ,LOG     = 10
       ,SUMMARY = 11
       ,print     = function() { message("Global environment for YATA")}
       ,initialize= function(module=NULL, output = 1,log=1) {
           .setLogFile(module)
           if (!is.null(module)) private$modname = module
           private$.logLevel   = log
           private$.out = output
       }
       # Friendly function
       ,log = function(level, fmt,...) {
          # Mensaje de logging/depuracion de nivel level
          .println(self$LOG, level,.mountMesage(fmt, ...))
       }
       ,doing = function(level, depth, fmt, ...) {
          # Proceso en marcha, no genera NL
          # Level nivel de info
          # Depth indentacion
          # Si va a fichero se guarda en cache hasta el done

       }
       ,done = function(level, ko = FALSE) {


       }
       ,batch = function(fmt, ...) {
          .println(self$BATCH, 0, .mountMessage(fmt,...))
       }
       ,process   = function(level, fmt, ...) {
          if (level > .logLevel) return (invisible(self))
          msg = .mountMessage(fmt,...)
          .println(2, level, msg)
          invisible(self)
       }
       ,info      = function(level, fmt, ...) {
          if (level > .logLevel) return (invisible(self))
          msg = .mountMessage(fmt,...)
          .println(3, level, msg)
          invisible(self)
       }
       ,executed  = function(rc, begin, fmt, ...) {
          diff = as.numeric(Sys.time()) - begin
          pattern = paste0("%d;%f;", fmt)
          .println(self$PROCESS, 0, .mountMessage(pattern, rc, diff, ...))
           if (.logLevel > 0) {
               .toConsole(self$SUMMARY, 1, paste("Elapsed time:", diff))
               .toConsole(self$SUMMARY, 1, paste("Return code :", rc))
          }
          invisible(self)
      }
       ,message   = function(fmt, ...) {
         .println(5, 3, .mountMessage(fmt, ...))
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
        FILE = 1
       ,CON  = 2
       ,logFile  = NULL
       ,.logLevel = 0
       ,.out      = 0
       ,modname  = "YATA"
       ,logTimers = NULL
       ,logNames  = NULL
       ,.println = function(type, level, msg) {
          if (bitwAnd(.out, FILE)) .toFile   (type, level, msg)
          if (bitwAnd(.out, CON )) .toConsole(type, level, paste0(msg, "\n"))
          invisible(self)
       }
       ,.toFile = function(type, level, txt, ...) {
           str = Sys.time()
           str = sub(" ", "-", str)
           line = paste(str,modname,type,level,txt, sep=";")
           rest = paste(list(...), collapse=";")
           if (nchar(rest) > 0) line = paste0(line, ";",rest)
           cat(line, file=logFile, append=TRUE)
       }
       ,.toConsole = function(type, level, txt) {
           str  = format(Sys.time(), "%H:%M:%S")
           prfx = NULL
           if (type == self$LOG) prfx = sprintf("LOG%02d -", level)
           cat(paste(str, "-", prfx, txt))
       }

       ,.setLogFile = function(module) {
          logfile = paste0(Sys.getenv("YATA_SITE"), "YATAData/log/yata.log")
          if (module == "WEB") paste0(Sys.getenv("YATA_SITE"), "YATAData/log/web.log")
       }

       ,.mountMessage = function(fmt, ...) {
           sprintf(fmt, ...)
       }
    )
)

