# Actualiza los datos de session cada interval minutos
update_tickers = function(interval = 15, logLevel = 0, logOutput = 0) {
   factory = NULL
   batch   = YATABatch$new("tickers", logLevel, logOutput)
   logger  = batch$logger

   if (batch$running) {
      logger$running()
      return (invisible(batch$rc$RUNNING))
   }

   rc = tryCatch({
      factory = Factory$new()
      prov    = factory$getDefaultProvider()
      tblCTC  = factory$getTable("Currencies")
      tblHist = factory$getTable("History")
#      coins   = prov$getCurrenciesNumber("all")

      process = TRUE
      while (process) {
         rc = .updateTickers(NULL, logger, factory)
         process = batch$stop_process()
         if (process) {
            message("Waiting")
            Sys.sleep(interval * 60)
         }
      }
      batch$rc$OK
   }, YATAError = function (cond) {
      browser()
      batch$rc$FATAL
   }, error = function (cond) {
      browser()
      batch$rc$SEVERE
   })
   invisible(batch$destroy(rc))
}
.updateTickers = function(coins, logger, factory) {
    results = list(added = 0, updated=0, items=c())
    block   = 100 # Number of items by request (same as maximum returned)
    beg     = 1

    prov       = factory$getDefaultProvider()
    tblCTC     = factory$getTable("Currencies")
    tblSession = factory$getTable("Session")
    dfCTC      = tblCTC$table()

    rc = tryCatch({
       browser()
       df   = prov$getTickers(beg, block)
       if (nrow(df) == 0) return (batch$rc$NODATA)

       repeat {
          message(paste("Procesando bloque", beg))
          if (beg > 9220) {
             browser()
          }
          tblSession$db$begin()
          for (row in 1:nrow(df)) {
               data = as.list(df[row,])
               # Si no existe, siguiente
               if (!tblCTC$select(id=data$id)) next

               data$token = tblCTC$current$token
               tblSession$add(data)
 #           .calculateVariations(data, factory)
          }
          tblSession$db$commit()
          beg = max(df$rank) + 1
          df   = prov$getTickers(beg, block)
          if (nrow(df) < block) break
       }
       batch$rc$NODATA
    }, error = function (cond) {
       tblSession$db$rollback()
       YATABase::propagateError(cond)
    })
}
.calculateVariations = function (data, factory) {
   browser()
   tbl  = factory$getTable("Variations")
   hist = factory$getTable("History")
   reg  = list( id = data$id,               symbol      = data$symbol
               ,price       = data$price,   volume      = data$volume
               ,price_day01 = data$day,     price_day07 = data$week,    price_day30 = data$month
               ,price_day60 = data$bimonth, price_day90 = data$quarter
   )
   if (hist$select(id=data$id, limit = 90)) {
      df = hist$dfCurrent
      df = df[order(df$timestamp, decreasing=TRUE),]
      if (nrow(df) >  0) reg$volume_day01 = .calcPercentage(reg$volume,df[ 1,"volume"])
      if (nrow(df) >  2) reg$volume_day03 = .calcPercentage(reg$volume,df[ 3,"volume"])
      if (nrow(df) > 14) reg$volume_day15 = .calcPercentage(reg$volume,df[15,"volume"])
      if (nrow(df) > 29) reg$volume_day30 = .calcPercentage(reg$volume,df[30,"volume"])
      if (nrow(df) > 59) reg$volume_day60 = .calcPercentage(reg$volume,df[60,"volume"])
      if (nrow(df) > 89) reg$volume_day90 = .calcPercentage(reg$volume,df[90,"volume"])

      if (nrow(df) >  2) reg$price_day03  = .calcPercentage(reg$price, df[ 3,"close"] )
      if (nrow(df) > 14) reg$price_day15  = .calcPercentage(reg$price, df[15,"close"] )
   }

   if (tbl$select(id = data$id)) { # update
       tbl$set(reg)
       tbl$apply()

   } else { # insert
      tbl$add(reg)
   }
}

.calcPercentage = function (num1,den1) {
   if (is.null(num1) || is.na(num1)) return (NULL)
   if (is.null(den1) || is.na(den1)) return (NULL)
   if (den1 == 0)                    return (NULL)
   res = num1 / den1
   if (res >= 1) return (res - 1)
   (1 - res) * -1

}
