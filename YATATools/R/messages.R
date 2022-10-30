# YATABaseMsg = R6::R6Class("YATA.BASE.MSG"
#    ,portable  = FALSE
#    ,cloneable = FALSE
#    ,lock_class = TRUE
#    ,public = list(
#        lbl = function(fmt, ...) { cat(line(fmt, ...)) ; invisible(self) }
#       ,lblGroup = function(fmt, ...) {
#          fmt = paste0(fmt, "\n")
#          crayon::bold(sprintf(fmt, ...))
#       }
#       ,lblProcess = function(level, fmt, ...) {
#          prfx = paste0(rep("\t", times=level), collapse="")
#          fmt  = paste0(prfx,fmt)
#          cat(line(fmt, ...)) ;
#          invisible(self)
#       }
#       ,lblProcess1 = function (fmt, ...) { lblProcess(1, fmt, ...)   }
#       ,lblProcess2 = function (fmt, ...) { lblProcess(2, fmt, ...)   }
#       ,lblProcess3 = function (fmt, ...) { lblProcess(3, fmt, ...)   }
#       ,out = function(fmt, ...) { cat(line(fmt, ...)) ; invisible(self) }
#       ,err = function(fmt, ...) {
#           sink(stderr())
#           cat(red(paste0(line(fmt, ...), "\n")))
#           sink()
#           invisible(self)
#       }
#       ,fatal  = function(rc, fmt, ...) {
#           self$err(fmt, ...)
#           quit(save="no", status = rc)
#       }
#       ,outfmt = function(attr, fmt, ...) { cat(attr(line(fmt, ...))) ; invisible(self) }
#       ,errfmt = function(attr, fmt, ...) {
#           sink(stderr())
#           cat(attr(line(fmt, ...)))
#           sink()
#           invisible(self)
#       }
#       ,ok = function() { outfmt(bold,"\tOK\n"); FALSE }
#       ,ko = function() { outfmt(bold $ red,"\tKO\n"); TRUE }
#       ,msgBlock = function(txt) {
#           cat(txt)
#           # write(txt, stdout())
#       }
#    )
#    ,private = list(
#       LENGTH = 30
#       ,line = function(fmt, ...) {
#           txt = sprintf(fmt, ...)
#           endl = (substr(txt,nchar(txt),nchar(txt)) == "\n")
#           size = LENGTH - nchar(txt)
#           if (size > 0 && endl == FALSE) {
#              # size = nchar(txt) - LENGTH
#              txt = paste(txt, sprintf("%*s", size, " "))
#           }
#           txt
#        }
#   )
# )
#
# .line = function(fmt, ...) {
#     txt = sprintf(fmt, ...)
#     endl = (substr(txt,nchar(txt),nchar(txt)) == "\n")
#     size = LENGTH - nchar(txt)
#     if (size > 0 && endl == FALSE) txt = paste(txt, sprintf("%*s", size, " "))
#     txt
# }

# lbl = function(fmt, ...) { cat(.line(fmt, ...))  }
# out = function(fmt, ...) { cat(.line(fmt, ...))  }
# err = function(fmt, ...) {
#     sink(stderr())
#     cat(red(paste0(.line(fmt, ...), "\n")))
#     sink()
# }
# fatal  = function(rc, fmt, ...) {
#    yataErr(fmt, ...)
#     quit(save="no", status = rc)
# }
