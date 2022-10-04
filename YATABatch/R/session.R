# Actualiza los datos de session cada interval minutos
update_tickers = function(interval = 15, logLevel = 0, logOutput = 0) {
   begin   = as.numeric(Sys.time())

   batch   = YATABatch$new("tickers")
   logger  = batch$logger

   if (batch$running) return (invisible(batch$rc$RUNNING))

   rc = tryCatch({
      browser()
      factory = Factory$new()
      logger  = YATABase::YATALogger$new()
      prov    = factory$getDefaultProvider()
      tblCTC  = factory$getTable("Currencies")
      tblHist = factory$getTable("History")
      coins   = prov$getCurrenciesNumber("all")

      process = TRUE
      while (process) {
#         .updateTickers(coins, logger, factory)
         process = batch$stop_process()
         if (process) {
            message("Waiting")
            Sys.sleep(interval * 60)
         }
      }
      batch$rc$OK
   }, error = function (cond) {
      batch$rc$FATAL
   })
   invisible(batch$destroy(rc))
}
.updateTickers = function(coins, logger, factory) {
    results = list(added = 0, updated=0, items=c())
    block   = 250 # Number of items by request
    beg     = 1
    process = TRUE
#    msg   = factory$msg
    prov       = factory$getDefaultProvider()
    tblCTC     = factory$getTable("Currencies")
    tblSession = factory$getTable("Session")
    dfCTC      = tblCTC$table()

    tryCatch({
      df   = prov$getTickers(beg, block)
      message(paste("Procesando bloque", beg))
      while (process) {
         if (nrow(df) < block) process = FALSE
#         logger$info(3, msg$log("CTC_UPDATING"), type, beg)
         tblSession$db$begin()
         for (row in 1:nrow(df)) {
            data = as.list(df[row,])
            if (!tblCTC$select(id=df[row,"id"])) next

            data$token = tblCTC$current$token
            tblSession$add(data)
            .calculateVariations(data, factory)
         }
         tblSession$db$commit()
         beg = as.integer(df[nrow(df), "rank"]) + 1
         if (process) df   = prov$getCurrencies(beg, block)
      }
    }, error = function (cond) {
       tblSession$db$rollback()
       propagateError(cond)
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
