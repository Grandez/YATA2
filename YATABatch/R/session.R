# En lugar de esperar a tener todas las monedas vamos cargando bloque por bloque
.getSessionData = function(batch, last, max, session, currencies) {
    count = 0
    dft   = NULL
    provider      = batch$fact$getObject(batch$fact$codes$object$providers)

    tryCatch({
       data = provider$getTickers(500, 1)
       if (max == 0) max = data$total

       repeat {
          if (nrow(data$df) > 0) {
              df = data$df
              df[,c("name", "slug")] = NULL

              df1 = df[,c("id", "symbol")]
              dfs = inner_join(df1, currencies, by="id")

              df2 = dfs[,c(1,3)]
              df  = left_join(df, df2, by="id")

              df$symbol = df$symbol.y
              df        = df[,-ncol(df)]

              df$last = last
              df = df %>% filter (price > 0 & volume > 0)
              dft = rbind(dft, df)
              count = count + nrow(dft)
              .add2database(dft, session)
          }
          start = data$from + data$count

          if (start >= max) break;
          data = provider$getTickers(500, start)
        }
     }, error = function (cond) {
         cat ("getSessionData", cond$message)
         # Nada, igonoramos errores de red
     })
     count
}
updateSession = function(max = 0) {
   pidfile = paste0(Sys.getenv("YATA_SITE"), "/data/wrk/tickers.pid")
   logfile = paste0(Sys.getenv("YATA_SITE"), "/data/log/tickers.log")

   count   = 0
   begin   = as.numeric(Sys.time())
   batch   = YATABatch$new("Tickers")
   rc      = batch$rc$OK

   batch$fact$setLogger(batch$logger)
   if (file.exists(pidfile)) return (batch$rc$RUNNING)
   cat(paste0(Sys.getpid(),"\n"), file=pidfile)

   session    = batch$fact$getObject(batch$fact$codes$object$session)
   currencies = batch$fact$getObject(batch$fact$codes$object$currencies)
   dfCTC      = currencies$getAllCurrencies()
   dfCTC      = dfTokens[,c("id", "symbol", "token")]
   info       = batch$fact$parms$getSessionData()
   oldData    = Sys.time() - (info$history * 60 * 60)

   session$removeData(oldData)

   while (count < info$alive) { # Para que se pare automaticamente
      rc0 = tryCatch({
               batch$logger$batch("Retrieving tickers")
               last = as.POSIXct(Sys.time())
               session$updateLastUpdate(last, 0)
               total = .getSessionData(batch, last, max, session, dfCTC)
               session$updateLastUpdate(last, total)
               batch$logger$batch("OK")
               batch$rc$OK
            }, YATAERROR = function (cond) {
               batch$rc$FATAL
            }, error = function(cond) {
               batch$rc$SEVERE
            })
      if (rc0 > rc) rc = rc0
      Sys.sleep(info$interval * 60)
      count = count + 1
   }

  if (file.exists(pidfile)) file.remove(pidfile)
  batch$logger$executed(rc, begin, "Retrieving tickers")
  invisible(rc)
}
