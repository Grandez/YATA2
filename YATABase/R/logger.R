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
       ,type = list(PROCESS =  1,BATCH   =  5,LOG     = 10,SUMMARY = 11, ACT=20)
       ,print      = function() { message("Generic Logger class") }
       ,initialize = function(module=NULL, output = 1,log=1) {
           if (is.null(module)) module="general"
           private$modname   = module
           private$.logLevel = log
           private$.out      = output
           .setLogFile()
       }

       # Friendly function
       ,log = function(level, fmt,...) {
          # Mensaje de logging/depuracion de nivel level
          .println(self$type$LOG, level,.mountMessage(fmt, ...))
       }
       # Proceso en marcha, espera un done. Fichero se guarda
       ,doing = function(level, fmt, ...) {
          .print(self$type$ACT, level, .mountMessage(fmt, ...))
       }
       ,done = function(level, res=TRUE) {
          if (is.logical(res)) {
             if ( res) .flush(self$type$ACT, level,"\tOK", crayon::bold)
             if (!res) .flush(self$type$ACT, level,"\tKO", crayon::red)
          } else {
             .flush(self$type$ACT, level, paste0("\t", res),  crayon::blue)
          }
       }
       ,batch = function(fmt, ...) {
          .println(self$type$BATCH, 0, .mountMessage(fmt,...))
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
          .println(self$type$PROCESS, 0, .mountMessage(pattern, rc, diff, ...))
           if (.logLevel > 0) {
               .toConsole(self$type$SUMMARY, 1, paste("Elapsed time:", diff))
               .toConsole(self$type$SUMMARY, 1, paste("Return code :", rc))
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
       ,cache     = ""
       ,modname  = "YATA"
       ,logTimers = NULL
       ,logNames  = NULL
       ,.print = function(type, level, msg) {
          if (bitwAnd(.out, FILE)) private$cache = msg
          if (bitwAnd(.out, CON )) .toConsole(type, level, msg)
          invisible(self)
       }
       ,.println = function(type, level, msg, ansi=.void) {
          if (bitwAnd(.out, FILE)) .toFile   (type, level, msg)
          if (bitwAnd(.out, CON )) .toConsole(type, level, paste0(msg, "\n"), ansi)
          invisible(self)
       }
       ,.flush = function(type, level, msg, ansi=.void) {
           if (bitwAnd(.out, FILE)) {
               .toFile   (type, level, paste(private$cache, msg))
               private$cache = ""
           }
           if (bitwAnd(.out, CON )) cat(ansi(paste(msg, "\n")))
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
       ,.toConsole = function(type, level, txt, ansi=.void) {
           str  = format(Sys.time(), "%H:%M:%S")
#           prfx = NULL
#           if (type == self$type$LOG) prfx = sprintf("LOG%02d -", level)
           msg = paste(str, "-", txt)
           cat(ansi(msg))
       }

       ,.setLogFile = function() {
          logfile = paste0(Sys.getenv("YATA_SITE"), "/YATAData/log/yata.log")
          if (private$modname == "WEB")
              logfile = paste0(Sys.getenv("YATA_SITE"), "/YATAData/log/web.log")
          private$logFile = logfile
       }
       ,.mountMessage = function(fmt, ...) {
           sprintf(fmt, ...)
       }
       ,.void = function(txt) { txt }
    )
)

