startDaemons = function() {
   work = paste0(Sys.getenv("YATA_SITE"), "/data/wrk/")

   exec = YATAExec$new()
   daemons = c("start_tickers", "start_history")
   lapply(daemons, function (daemon) {
       cat("Daemon ", daemon, " ")
       resp = exec$R(daemon)
       nfo = ifelse (resp$is_alive(), resp$get_pid(), "KO")
       cat(nfo, "\n")
   })
   # if (.launchRest()) {
   #     cat("Daemon start_rest ")
   #     resp = exec$R("start_rest")
   #     nfo = ifelse (resp$is_alive(), resp$get_pid(), "KO")
   #     cat(nfo, "\n")
   # } else {
   #     cat("Daemon start_rest active\n")
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
