startDaemons = function() {
    browser()
   work = paste0(Sys.getenv("YATA_SITE"), "/YATAData/wrk/")

   exec = YATAExec$new()
   resp = exec$R("start_tickers.R")
   if (resp$is_alive()) cat(paste(resp$get_pid(), "\n"),file=paste(work,"start_tickers.pid"))
   resp = exec$R("start_history.R")
   if (resp$is_alive()) cat(paste(resp$get_pid(), "\n"),file=paste(work,"start_history.pid"))
   if (.launchRest()) {
       resp = exec$R("start_rest.R")
       if (resp$is_alive()) cat(paste(resp$get_pid(), "\n"),file=paste(work,"start_rest.pid"))
   }
}
.launchRest = function(exec) {
    resp = tryCatch({
       httr::GET("http://127.0.0.1:4005/alive")
    }, error = function(cond) {
        list(status_code = 500)
    })
    ifelse (resp$status_code == 200, FALSE, TRUE)
}
