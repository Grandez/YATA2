#' Recupera los datos historicos de las sesiones
#' Proceso Diario
#'
update_history = function(reverse = FALSE, backward = FALSE, logLevel = 0, logOutput = 0) {
   factory = NULL
   batch   <<- YATABatch$new("history", logLevel, logOutput)
   logger = batch$logger
   items  = 0

   if (batch$running) {
      logger$running()
      return (invisible(batch$rc$RUNNING))
   }

   rc = tryCatch({
      factory = Factory$new()

      tblctc = factory$getTable("Currencies")
      dfctc  = tblctc$table(active = 1)
      if (nrow(dfctc) == 0) return (batch$rc$NODATA)

      items = .updateHistory(factory, logger, dfctc, reverse)
      ifelse(items > 0, batch$rc$OK, batch$rc$NODATA)
   }, error = function (cond) {
      if (!is.null(factory)) factory$detroy()
      rc = batch$rc$FATAL
      if ("YATAERROR"  %in% class(cond)) rc = batch$rc$SEVERE
      if ("HTTP_FLOOD" %in% class(cond)) rc = batch$rc$FLOOD
      if ("KILLED"     %in% class(cond)) rc = batch$rc$KILLED
      rc
   })
   batch$destroy()
   invisible(rc)
}

.updateHistory = function (factory, logger, dfCTC, reverse) {
   tryCatch({
      prov    = factory$getDefaultProvider()
      tblCTC  = factory$getTable("Currencies")
      tblHist = factory$getTable("History")
      tables  = list(hist=tblHist, ctc=tblCTC)
      today   = Sys.Date()
   }, error   = function (cond) {
      YATABase::propagatError(cond)
   })

   rows = 1:nrow(dfCTC)
   if (reverse) rows = nrow(dfCTC):1
   count = 0

   tryCatch({
      for (row in rows) {
           last = dfCTC[row,"last"]
           if (is.na(last)) last = dfCTC[row,"since"] # Sys.Date() - 20
           logger$doing(5, "%5d - Retrieving %-15s", row, dfCTC[row,"symbol"])
           if (as.integer(today - last) < 2) {
               logger$done(5, "- skip")
               next
           }
           to    = today
           if (logger$level < 5) {
               logger$doing(1, "%5d - Retrieving %-12s", row, substr(dfCTC[row,"symbol"],1,12))
           }
           if (to - last > 25) to = last + 25
           data = prov$getHistorical(as.integer(dfCTC[row,"id"]), last + 1, to )
           txt = ifelse(is.null(data), "No info", "OK")
           logger$done(1, "- %s", txt)
           if (!is.null(data)) {
               count = count + 1
              .updateData(data, as.list(dfCTC[row,]), tables)
           }
           if ( is.null(data)) .updateLastDate(to, as.list(dfCTC[row,]), tables)
           .wait(row)
      }
   }, error = function (cond) {
      YATABase::propagatError(cond)
   })
   count
}
.updateData = function(data, ctc, tables) {
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
    }, error = function(cond) {
       tblhist$db$rollback()
       YATABase::propagateError(cond)
    })
}
.updateLastDate = function(to, ctc, tables) {
    tblctc  = tables$ctc
    tryCatch({
       tblctc$db$begin()
       tblctc$select(id = ctc$id)
       tblctc$set(last = as.character(to))
       tblctc$apply()
       tblctc$db$commit()
    }, error = function (cond) {
       tblctc$db$rollback()
       YATABase::propagateError(cond)
    })
}
.wait = function (row) {
   wait = 4
   batch$stop_process(TRUE) # Check for kill process

   if      ((row %% 200) == 0)  wait = 39
   else if ((row %% 100) == 0)  wait = 19
   else if ((row %%  10) == 0)  wait = 09
#   message(paste("Waiting", wait, "seconds at item", row))
   Sys.sleep(wait + 1)
}
