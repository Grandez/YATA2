banner = function(title) {
   len = 60
   guiones = paste0(rep("-", len),sep="", collapse="")
   cat(paste0("+", guiones, "+", collapse=""), sep="\n")
   sp =
   sp = rep(" ", (len - nchar(title) - 2))
   cat("|", title)
   cat(paste0(sp, collapse=""), "|")
   cat("\n")
   cat(paste0("+", guiones, "+", collapse=""), sep="\n")
}
