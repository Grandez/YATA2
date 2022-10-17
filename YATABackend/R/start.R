start = function(port=4000, logLevel = 9, logOutput = 2) {
   batch  = YATABatch$new("backend", logLevel, logOutput)
   logger = batch$logger

   if (batch$running) {
      logger$running()
      return (invisible(batch$rc$RUNNING))
   }


    rc = tryCatch({
        app = YATARest$new(port, logLevel, logOuput)
        backend = BackendRserve$new()
        resp = backend$start(YATARest, http_port = port, background = TRUE)
        #resp = RestRserve:::ApplicationProcess$new(12345)
        if ("ApplicationProcess" %in% class(resp))  {
            browser()
            batch$addDataToControlFile(resp$pid)
        } else {
            browser()
            batch$addDataToControlFile(resp)
        }
        batch$rc$OK
    }, error = function(cond){
        browser()
        batch$rc$FATAL
    })
}

stop = function (logLevel = 1, logOutput = 1) {
   batch = YATABatch$new("backend", logLevel, logOutput)

   if (!batch$running) {
       batch$logger$warning("YATA Backend is NOT running")
       return (invisible(batch$rc$NOT_RUNNIG))
   }
   # Debe haber dos lineas pid padre y el server
   data = batch$getControlFile()
   if (length(data) > 1) {
       pid = suppressWarnings(as.integer(data[2]))
       if (!is.na(pid)) tools::pskill(pid)
   }

   if (length(data) > 0) {
       pid = suppressWarnings(as.integer(data[1]))
       if (!is.na(pid)) tools::pskill(pid)
   }

   YATABatch::stop_process("backend", TRUE)
   invisible(batch$destroy(batch$rc$OK))
}
