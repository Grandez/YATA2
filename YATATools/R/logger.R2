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
          if (!missing(value)) private$.level = value
          .level
      }
   )
  ,public = list(
      valid   = TRUE
     ,lastErr = NULL
     ,type = list(PROCESS =  1,BATCH   =  5,LOG     = 10,SUMMARY = 11, ACT=20, ERROR=99)
     ,print        = function() { message("Generic Logger class") }
     ,initialize   = function(module="general", level, output) {
         private$modname   = module
         loglevel    = Sys.getenv("YATA_LOG_LEVEL")
         logoutput   = Sys.getenv("YATA_LOG_OUTPUT")

         if (missing(output)) {
             private$.output   = ifelse(nchar(loglevel) == 0, 0, as.integer(loglevel))
         } else {
            private$.output = output
         }

         if (missing(level)) {
             logLevel = ifelse(nchar(loglevel) == 0, 0, as.integer(loglevel))
         } else {
             logLevel = level
         }
         if (logLevel < 10) {
            private$levelCon  = logLevel
            private$levelFile = logLevel
         } else {
            private$levelFile = logLevel %%  10
            private$levelCon  = logLevel %/% 10
         }
         private$.level = min(private$levelFile, private$levelCon)
         .setLogFile()
       }
     ,setLogLevel  = function(level) {
          if (level < 10) {
             ll = level * 10
             ll = ll + level
             level = ll
          }
          private$levelFile = logLevel %%  10
          private$levelCon  = logLevel %/% 10
          private$.level = min(private$levelFile, private$levelCon)
          invisible(self)
       }
     ,setLogOutput = function(output) {
          private$.output = output
          invisible(self)
       }
     ,log          = function(level, fmt,...) {
          # Mensaje de logging/depuracion de nivel level
          .println(self$type$LOG, level,.mountMessage(fmt, ...))
       }
     ,doing        = function(level, fmt, ...) {
                 # Proceso en marcha, espera un done. Fichero se guarda
          .print(self$type$ACT, level, .mountMessage(fmt, ...))
       }
     ,done         = function(level, res=TRUE) {
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
          if (level > .level) return (invisible(self))
          msg = .mountMessage(fmt,...)
          .println(2, level, msg)
          invisible(self)
       }
       ,info      = function(level, fmt, ...) {
          if (level > .level) return (invisible(self))
          msg = .mountMessage(fmt,...)
          .println(3, level, msg)
          invisible(self)
       }
       ,executed  = function(rc, begin, fmt, ...) {
          diff = as.numeric(Sys.time()) - begin
          diff = round(diff, 0)
          pattern = paste0("%d;%d;", fmt)
          .println(self$type$PROCESS, 0, .mountMessage(pattern, rc, diff, ...))
           if (.level > 0) {
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
           if (level > .level) return (invisible(self))
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
       ,fail = function(cond) {
          data=""
          tags = names(cond)
          for (idx in 1:length(tags)) {
             data=paste0(data,";",tags[idx],": ", cond[[idx]])
          }
          # .toFile(self$type$ERROR, 0, sprintf( "Class: %s;Message: %s;Fields: %d;%s"
          #                                     ,class(cond)[2], cond, length(tags),data))
       }

    )
    ,private = list(
        FILE = 1
       ,CON  = 2
       ,logFile  = NULL
       ,levelFile = 0
       ,levelCon  = 0
       ,.output   = 0
       ,.level    = 0
       ,cache     = ""
       ,modname  = "YATA"
       ,logTimers = NULL
       ,logNames  = NULL
       ,.print = function(type, level, msg) {
          if (bitwAnd(.output, FILE)) private$cache = msg
          if (bitwAnd(.output, CON )) .toConsole(type, level, msg)
          invisible(self)
       }
       ,.println = function(type, level, msg, ansi=.void) {
          if (bitwAnd(.output, FILE)) .toFile   (type, level, msg)
          if (bitwAnd(.output, CON )) .toConsole(type, level, paste0(msg, "\n"), ansi)
          invisible(self)
       }
       ,.flush = function(type, level, msg, ansi=.void) {
           if (bitwAnd(.output, FILE)) {
               .toFile   (type, level, paste(private$cache, msg))
               private$cache = ""
           }
           if (bitwAnd(.output, CON )) cat(ansi(paste(msg, "\n")))
           invisible(self)
       }
       ,.toFile = function(type, level, txt, ...) {
          if (level > levelFile) return()
           str = Sys.time()
           str = sub(" ", "-", str)
           line = paste(str,modname,type,level,txt, sep=";")
           rest = paste(list(...), collapse=";")
           if (nchar(rest) > 0) line = paste0(line, ";",rest)
           cat(paste0(line, "\n"), file=logFile, append=TRUE)
       }
       ,.toConsole = function(type, level, txt, ansi=.void) {
          if (level > levelCon) return()
           str  = format(Sys.time(), "%H:%M:%S")
#           prfx = NULL
#           if (type == self$type$LOG) prfx = sprintf("LOG%02d -", level)
           msg = paste(str, "-", txt)
           cat(ansi(msg))
       }

       ,.setLogFile = function() {
          logfile = paste0(Sys.getenv("YATA_SITE"), "/data/log/yata.log")
          if (private$modname == "WEB")
              logfile = paste0(Sys.getenv("YATA_SITE"), "/data/log/web.log")
          private$logFile = logfile
       }
       ,.mountMessage = function(fmt, ...) {
           sprintf(fmt, ...)
       }
       ,.void = function(txt) { txt }
    )
)

