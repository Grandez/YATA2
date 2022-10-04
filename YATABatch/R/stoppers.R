# Chequea el estado de un proceso o demonio en base a su pid file
# 0 - Ejecutando
# 1 - No activo
# 4 - Activo pero pendiente de detenerse
check_process = function (process = "yata") {
   rc = 0
   pidfile = paste0(Sys.getenv("YATA_SITE"), "/data/wrk/", process, ".pid")
   if (!file.exists(pidfile)) {
      rc = 1
      message(paste("Process", process, "is NOT active"))
   } else {
      data = readLines(pidfile)
      res  = grep("stop", data, ignore.case = TRUE)
      if (length(res) == 0) {
         message(paste("Process", process, "is ACTIVE"))
      } else {
         message(paste("Process", process, "is PENDING to be stopped"))
         rc = 4
      }

   }
   return (invisible(rc))
}
stop_batch = function (process = "yata", clean = FALSE) {
   rc = 0
   pidfile = paste0(Sys.getenv("YATA_SITE"), "/data/wrk/", process, ".pid")
   if (file.exists(pidfile)) {
      message(paste("Sending kill message to", process))
      cat("stop", file=pidfile)
   } else {
      message(paste("Process", process, "is not active"))
      rc = 4
   }
   if (clean) unlink(pidfile, force = TRUE)
   invisible(rc)
}
stop_process = function(process = "yata", clean = FALSE) {
   stop_batch(process, clean)
}
