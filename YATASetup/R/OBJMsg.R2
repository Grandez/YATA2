# Clase base para los mensajes
YATASTD = R6::R6Class("YATA.R6.STD.MSG"
   ,portable  = FALSE
   ,cloneable = FALSE
   ,lock_class = TRUE
   ,public = list(
       lbl = function(fmt, ...) { cat(line(fmt, ...)) ; invisible(self) }
      ,out = function(fmt, ...) { cat(line(fmt, ...)) ; invisible(self) }
      ,err = function(fmt, ...) {
          sink(stderr())
          cat(red(paste0(line(fmt, ...), "\n")))
          sink()
          invisible(self)
      }
      ,fatal  = function(rc, fmt, ...) {
          self$err(fmt, ...)
          quit(save="no", status = rc)
      }
      ,outfmt = function(attr, fmt, ...) { cat(attr(line(fmt, ...))) ; invisible(self) }
      ,errfmt = function(attr, fmt, ...) {
          sink(stderr())
          cat(attr(line(fmt, ...)))
          sink()
          invisible(self)
      }
      ,ok = function() { outfmt(bold,"\tOK\n"); FALSE }
      ,ko = function() { outfmt(bold $ red,"\tKO\n"); TRUE }
      ,msgBlock = function(txt) {
          cat(txt)
          # write(txt, stdout())
      }
   )
   ,private = list(
      length = 30
      ,line = function(fmt, ...) {
          txt = sprintf(fmt, ...)
          endl = (substr(txt,nchar(txt),nchar(txt)) == "\n")
          size = length - nchar(txt)
          if (size > 0 && endl == FALSE) {
             # size = nchar(txt) - length
             txt = paste(txt, sprintf("%*s", size, " "))
          }
          txt
       }
  )
)
