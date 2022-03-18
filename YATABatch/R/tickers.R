getLatest = function(console=1, log=1) {
    count = 0
    begin = as.numeric(Sys.time())
    rc = tryCatch({
       logger = YATABase::YATALogger$new("Tickers", console, log)
       fact = YATACore::YATAFactory$new()
       session = fact$getObject(fact$CODES$object$session)
       while (count < 50) {
          logger$batch("Retrieving tickers")
          session$updateLatest()
          Sys.sleep(15 * 60)
          count = count + 1
       }
       0
    }, error = function(cond) {
        message(cond)
        16
    })
    logger$executed(rc, begin, "Retrieving tickers")
    invisible(rc)
}
