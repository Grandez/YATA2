startDaemons = function() {
   work = paste0(Sys.getenv("YATA_SITE"), "/data/wrk/")

   exec = YATAExec$new()
   daemons = c("start_tickers", "start_history")
   lapply(daemons, function (daemon) {
      pidfile = paste0(work, daemon, ".pid")
      if (!file.exists(pidfile)) {
          resp = exec$R(paste0(daemon, ".R"))
          if (resp$is_alive()) {
              cat(paste(resp$get_pid(), "\n"), file=pidfile)
          }
      }
   })
   # if (.launchRest()) {
   #     resp = exec$R("start_rest.R")
   #     if (resp$is_alive()) cat(paste(resp$get_pid(), "\n"),file=paste(work,"rest.pid"))
   # }
   0
}
.launchRest = function(exec) {
    resp = tryCatch({
       httr::GET("http://127.0.0.1:4005/alive")
    }, error = function(cond) {
        list(status_code = 500)
    })
    ifelse (resp$status_code == 200, FALSE, TRUE)
}
