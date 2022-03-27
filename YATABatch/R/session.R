.getSessionData = function(batch, last, max) {
    dft = NULL
    provider      = batch$fact$getObject(batch$fact$CODES$object$providers)
    tblCurrencies = batch$fact$getTable(batch$fact$CODES$tables$currencies)

    tryCatch({
       data = provider$getTickers(500, 1)
       if (max == 0) max = data$total

       repeat {
          df = data$df
          df[,c("name", "slug")] = NULL

          # Puede haber symbol repetidos (no por id)
          # Se han cambiado en la tabla de currencies
          df1 = df[,c("id", "symbol")]
          ctc = tblCurrencies$table()
          df2 = ctc[,c("id", "symbol")]
          dfs = inner_join(df1, df2, by="id")
          df2 = dfs[,c(1,3)]
          df  = left_join(df, df2, by="id")
          df$symbol = df$symbol.y
          df        = df[,-ncol(df)]

          df$last = last
          dft = rbind(dft, df)
          start = data$from + data$count
          if (start >= max) break;
          data = provider$getTickers(500, start)
        }
     }, error = function (cond) {
         cat("ERROR EN GETSESSION DATA - Continua\n")
     })

   #  repeat {
   #     df = data$df
   #     df[,c("name", "slug")] = NULL
   #
   #     # Puede haber symbol repetidos (no por id)
   #     # Se han cambiado en la tabla de currencies
   #     df1 = df[,c("id", "symbol")]
   #     ctc = tblCurrencies$table()
   #     df2 = ctc[,c("id", "symbol")]
   #     dfs = inner_join(df1, df2, by="id")
   #     df2 = dfs[,c(1,3)]
   #     df  = inner_join(df, df2, by="id")
   #     df$symbol = df$symbol.y
   #     df        = df[,-ncol(df)]
   #
   #     df$last = last
   #     dft = rbind(dft, df)
   #     start = data$from + data$count
   #     if (start >= max) break;
   #     data = provider$getTickers(500, start)
   # }
   dft
}

#JGG NOTE
# De vez en cuando da duplicados al insertar
# El motivo no lo tengo claro, puede ser que repita datos la WEB
# Para evitar esos errores cargamos la tabla con mysql que los errores no bloquean
#
.appendLatest = function(batch, session, last, max) {
    browser()
    count = 0

    df = .getSessionData(batch, last, max)
    if (nrow(df) == 0) return (count)
    count = nrow(df)

    colnames = session$getColumnNames(colnames(df))
    datafile = file.path(Sys.getenv("YATA_SITE"), "YATAData/tmp", session$getDBTableName())
    datafile = gsub("\\\\", "/", datafile) # Lo de win/unix
    datafile = paste0(datafile, ".dat")

    write.table(df, datafile, dec=".", sep=";", quote=FALSE, row.names = FALSE, col.names=FALSE)
    res = YATAExec$new()$import(basename(datafile), "YATAData", colnames)
    file.remove(datafile)
    count
}
updateSession = function(max=0, output=1, log=1) {
    count = 0
    begin = as.numeric(Sys.time())
    batch = YATABatch$new("Tickers", output, log)

    rc = tryCatch({
       session = batch$fact$getObject(batch$fact$CODES$object$session)

       while (count < 50) { # Para que se pare automaticamente
          batch$log$batch("Retrieving tickers")
          last = as.POSIXct(Sys.time())
          session$updateLastUpdate(last, 0)
          total = .appendLatest(batch, session, last, max)
          session$updateLastUpdate(last, total)
          batch$log$batch("OK")
          Sys.sleep(15 * 60)
          count = count + 1
       }
       0
    }, YATAERROR = function (cond) {
        browser()
    }, error = function(cond) {
        browser()
        message(cond)
        16
    })
    batch$log$executed(rc, begin, "Retrieving tickers")
    invisible(rc)
}
