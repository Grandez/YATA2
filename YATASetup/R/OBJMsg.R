# Clase base para los mensajes
YATASTD = R6::R6Class("YATA.R6.STD.MSG"
   ,portable  = FALSE
   ,cloneable = FALSE
   ,lock_class = TRUE
   ,public = list(
       lbl = function(fmt, ...)  { cat(line(fmt, ...)) }
      ,out  = function(fmt, ...) { cat(line(fmt, ...)) }
      ,err  = function(fmt, ...) {
          sink(stderr())
          cat(red(line(fmt, ...)))
          sink()
      }
      ,fatal  = function(rc, fmt, ...) {
          self$err(fmt, ...)
          quit(save="no", status = rc)
      }
      ,outfmt = function(attr, fmt, ...) { cat(attr(line(fmt, ...))) }
      ,errfmt = function(attr, fmt, ...) {
          sink(stderr())
          cat(attr(line(fmt, ...)))
          sink()
      }
      ,logical = function(object, expected, result) {
         txt = paste0("ERROR in ", object, ". Expected: ", expected, "- Found: ", result)
         err(txt)
      }
      ,ok = function() { outfmt(bold,"\tOK\n") }
      ,ko = function() { outfmt(bold $ red,"\tKO\n") }
      ,msgBlock = function(txt) {
          cat(txt)
          # write(txt, stdout())
      }
   )
   ,private = list(
      length = 50
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
