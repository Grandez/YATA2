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
updateHistory = function(console=1, log=1) {
    count = 0
    begin = as.numeric(Sys.time())
    rc = tryCatch({
       logger = YATABase::YATALogger$new("History", console, log)
       fact = YATACore::YATAFactory$new()
       octc = fact$getObject(fact$CODES$object$currencies)
       hist = fact$getObject(fact$CODES$object$history)
       prov = fact$getObject(fact$CODES$object$providers)
       ctc  = octc$getCurrencies()
       rng  = hist$getRanges()
       df   = left_join(ctc, rng, by=c("id", "symbol"))
       #JGG OJO AL 2021-01-01 COMO FECHA FIJA
       df[is.na(df$min), "min"] = as.Date.character("2021-01-01")
       df[is.na(df$max), "max"] = as.Date.character("2021-01-01")
       for (row in 1:nrow(ctc)) {
           logger$batch("%5d - Retrieving history for %s", row, df[row,"name"])
           data = prov$getHistory(df[row, "id"], df[row,"max"])
           if (!is.null(data)) {
               if (difftime(Sys.time(), df[1,"max"], unit="days") >= 2) {
                   data$id = df[row, "id"]
                   data$symbol = df[row, "symbol"]
                   hist$add(data)
                   Sys.sleep(1)
               }
           }
       }
       0
    }, error = function(cond) {
        message(cond)
        16
    })
    logger$executed(rc, begin, "Retrieving history")
    invisible(rc)
}
