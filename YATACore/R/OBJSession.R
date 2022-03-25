OBJSession = R6::R6Class("OBJ.SESSION"
    ,inherit    = OBJBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        print       = function() { message("Session Object")}
       ,initialize = function(Factory) {
           super$initialize(Factory)
           .getTables(Factory)
       }
       ,getDBTableName = function()         { tblSession$getDBTableName() }
       ,getLastUpdate  = function() {
           tblControl$select(id = 1)
           last = as.POSIXct("2020-01-01 00:00:00")
           if (!is.null(tblControl$current)) last = tblControl$current$last
           last
       }
       ,updateLastUpdate = function(last, total) {
           tblControl$db$begin()
           tblControl$select(id = 1)
           if (!is.character(last)) last = strptime(last, "%Y-%m-%d %H:%M:%S")
           tblControl$set(last = last, total = total)
           tryCatch({
              tblControl$apply()
              tblControl$db$commit()
           }, YATAERROR = function (cond) {
              tblControl$db$rollback()
              YATABase:::propagateError(cond)
           })
           invisible(self)
       }
       ,getBest        = function(top=10, from=7, group=0) {
            session = tblSession$getLatest()
            if (nrow(session) == 0) session = updateLatest(TRUE)
            session = session[session$volume > 10,] # Solo los que se mueven
            getBestDF(session, top, from, group)
       }
       ,getSessionPrices = function(currencies = NULL) {
           getLatest(0, currencies)
       }
       ,getPrice = function(currency) {
           tblSession$select(symbol=currency,limit = 1)
           ifelse(is.null(tblSession$current), 0, tblSession$current$price)
       }
       ,getLatest = function(rank=0, currencies = NULL) {
           last = getLastUpdate()
           df = tblSession$table(last = last)
           if (!is.null(currencies)) {
               df = df[df$id %in% currencies,]
           } else {
               if (rank > 0) df = df[df$rank <= rank,]
           }
           df
        }
       ,getColumnNames = function(yataNames) {
           tblSession$translateColNames(yataNames)
       }
    )
    ,private = list(
        tblSession    = NULL
       ,tblControl    = NULL
       ,tblCurrencies = NULL
       ,getBestDF = function(df, top, from, group) {
           groups = c(25, 150)
           col = ""
           if (from ==  1) col = "hour"
           if (from == 24) col = "day"
           if (from ==  7) col = "day"
           if (from == 30) col = "month"
           if (col == "") return (NULL)
           if (group > 0) df = df[df$rank <= groups[group],]
           dft = df[order(df[col], decreasing = TRUE),]
           dft[1:top,]
       }
      ,.getTables = function (Factory) {
           private$tblSession    = Factory$getTable(self$codes$tables$session)
           private$tblControl    = Factory$getTable(self$codes$tables$control)
           private$tblCurrencies = Factory$getTable(self$codes$tables$currencies)
       }
    )
)

