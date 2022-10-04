#' Recupera los datos historicos de las sesiones
#' Proceso Diario
#'
# NOTAS
# Parando 3 segundos cada vez casca a los 262
# Si lo pongo como demonio, puedo ir ejecutando trozos a lo largo del dia
# Y de esta forma tendriamos un desfase posible de dos dias
update_history = function(reverse = FALSE, backward = FALSE, logLevel = 0, logOutput = 0) {
   browser()
   factory = NULL
   batch   = YATABatch$new("history", logLevel, logOutput)
   logger  = batch$logger

   if (batch$running) {
      logger$running()
      return (invisible(batch$rc$RUNNING))
   }

   rc = tryCatch({
      browser()
      factory = Factory$new()

      tblctc = factory$getTable("Currencies")
      dfctc  = tblctc$table(active = 1)
      if (nrow(dfctc) == 0) stop(structure( list(message="No data"), class = c("NODATA", "condition")))

      process = TRUE
      while (process) {
         .updateHistory(factory, logger, dfctc, reverse)
         process = batch$stop_process()
         if (process) {
            # Calcular el dia siguiente y poner a la espera
            message("Waiting")
            Sys.sleep(interval * 60)
         }
      }
      batch$rc$OK
   }, NODATA = function (cond) {
      if (!is.null(factory)) factory$detroy()
      batch$rc$NODATA
   }, error  = function (cond) {
       browser()
      if (!is.null(factory)) factory$detroy()
       batch$rc$FATAL
   })
   batch$destroy()
   invisible(rc)
}

.updateHistory = function (factory, logger, dfCTC, reverse) {
   prov    = factory$getDefaultProvider()
   tblCTC  = factory$getTable("Currencies")
   tblHist = factory$getTable("History")
   tables  = list(hist=tblHist, ctc=tblCTC)
   today   = Sys.Date()

   rows = 1:nrow(dfCTC)
   if (reverse) rows = nrow(dfCTC):1
   count = 0
   for (row in rows) {
        last = dfCTC[row,"last"]
        if (is.na(last)) last = dfCTC[row,"since"] # Sys.Date() - 20
        logger$doing(5, "%5d - Retrieving %-15s", row, dfCTC[row,"symbol"])
        if (as.integer(today - last) < 2) {
           logger$done(5, "- skip")
           next
        }
        count = count + 1
        to = today
        if (logger$level < 5)logger$doing(1, "%5d - Retrieving %-15s", row, dfCTC[row,"symbol"])
        if (to - last > 25) to = last + 25
        data = .retrieveData(prov, as.integer(dfCTC[row,"id"]), last + 1, to )
        txt = ifelse(is.null(data), "No info", "OK")
        logger$done(1, "- %s", txt)
#        message(sprintf("%5d - Solicitado %s (%05d) %s datos", count, dfCTC[row,"symbol"], dfCTC[row, "id"], txt))
        if (!is.null(data)) .updateData(data, as.list(dfCTC[row,]), tables)
        if ( is.null(data)) .updateLastDate(to, as.list(dfCTC[row,]), tables)

        .wait(row)
   }
}

.updateData = function(data, ctc, tables) {
    message(paste("Procesando", ctc$symbol, "(", ctc$id, ")"))

    data$id     = ctc$id
    data$symbol = ctc$symbol
    tblhist = tables$hist
    tblctc  = tables$ctc
    tryCatch({
       tblhist$db$begin()
       tblhist$bulkAdd(data)
       tblctc$select(id = ctc$id)
       tblctc$set(last= substr(data[nrow(data), "timestamp"], 1,10))
       tblctc$apply()
       tblhist$db$commit()
    }, error = function (cond) {
       tblhist$db$rollback()
       YATABase:::propagateError(cond)
    })

}
.updateLastDate = function(to, ctc, tables) {
    tblctc  = tables$ctc
    tryCatch({
       tblctc$db$begin()
       tblctc$select(id = ctc$id)
       tblctc$set(last = to)
       tblctc$apply()
       tblctc$db$commit()
    }, error = function (cond) {
       tblhist$db$rollback()
       YATABase:::propagateError(cond)
    })
}
.retrieveData = function (prov, id, from, to) {
   waits = c(60, 120, 240) # Minutos a esperar
   count = 0
   process = TRUE
   data    = NULL

   while (process) {
      process = tryCatch({
          data = prov$getHistorical(id, from, to)
          FALSE
       }, HTTP_FLOOD = function(cond) {
          #JGG OJO, ahora no espera
          count = ifelse(count == 3, 3, count + 1)
          message(paste("Waiting by flood", waits[count], "minutes"))
          YATABase:::propagateError(cond)
          Sys.sleep(waits[count] * 60)
          TRUE
       }, error = function(cond) {
          YATABase:::propagateError(cond)
       })
   }
   data
}
.wait = function (row) {
   wait = 4
   if      ((row %% 200) == 0)  wait = 59
   else if ((row %% 100) == 0)  wait = 29
   else if ((row %%  10) == 0)  wait = 09
   message(paste("Waiting", wait, "seconds at item", row))
   Sys.sleep(wait + 1)
}
