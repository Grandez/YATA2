# esta query funciona aunque haya error en la columna LASt
# SELECT * FROM SESSION AS A, (SELECT ID AS ID, MAX(LAST) AS LAST FROM SESSION GROUP BY ID) AS B WHERE A.ID = B.ID AND A.LAST = B.LAST
# Podemos usar una cache para evitar las consultas duplicadas
OBJSession = R6::R6Class("OBJ.SESSION"
    ,inherit    = OBJBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        print       = function() { message("Session Object")}
       ,initialize = function(factory) {
           super$initialize(factory)
           private$dfLast = factory$backend$latest()
           # deferred = future_promise(factory$backend$latest())
           # private$dfLast = then(deferred, function(df) df, NULL)
       }
      ,getNames = function(id) { self$factory$backend$names(id) }
       # ,getLatest = function(rank=0, currencies = NULL) {
       #     if (.invalidCache()) .loadCache()
       #     df = dfLast
       #     if (rank > 0) df = df[df$rank <= rank,]
       #     if (is.null(currencies)) return (df)
       #     if (is.numeric(currencies))
       #         df = df[df$id %in% currencies,]
       #     else
       #         df = df[df$symbol %in% currencies,]
       #     df
       # }

       # ,getLastUpdate  = function() {
       #     tblControl$select(id = 1)
       #     last = as.POSIXct("2020-01-01 00:00:00")
       #     if (!is.null(tblControl$current)) last = tblControl$current$last
       #     last
       # }
       # ,updateLastUpdate = function(last, total) {
       #     tblControl$db$begin()
       #     tblControl$select(id = 1)
       #     if (!is.character(last)) last = strptime(last, "%Y-%m-%d %H:%M:%S")
       #     tblControl$set(last = last, total = total)
       #     tryCatch({
       #        tblControl$apply()
       #        tblControl$db$commit()
       #     }, YATAERROR = function (cond) {
       #        tblControl$db$rollback()
       #        YATABase:::propagateError(cond)
       #     })
       #     invisible(self)
       # }
       # ,getBest        = function(top=10, from=7, group=0) {
       #     browser()
       #      session = tblSession$getLatest()
       #      if (nrow(session) == 0) session = updateLatest(TRUE)
       #      session = session[session$volume > 10,] # Solo los que se mueven
       #      getBestDF(session, top, from, group)
       # }
       # ,getSessionPrices = function(currencies = NULL) {
       #     getLatest(0, currencies)
       # }
       # ,getData = function(id=NULL, symbol=NULL) { # Return data session from -8 hours
       #     from = Sys.time() - (8 * 60 * 60)
       #     df = tblSession$from(last=from)
       #     if (!is.null(id))     df = df[df$id     %in% id,    ]
       #     if (!is.null(symbol)) df = df[df$symbol %in% symbol,]
       #     df
       # }
       # ,getPrice = function(currency) {
       #     tblSession$select(symbol=currency,limit = 1)
       #     ifelse(is.null(tblSession$current), 0, tblSession$current$price)
       # }
       ,removeData = function (until) {
           tblSession$deleteUntil(last=until, equal=TRUE, isolated=TRUE)
           invisible(self)
       }
    )
    ,private = list(
        dfLast = NULL
       #  tblSession    = NULL
       # ,tblControl    = NULL
       # ,tblCurrencies = NULL
       # ,dfLast        = NULL
       # ,lastTMS       = NULL
       # ,lastLast      = NULL
       # ,getBestDF = function(df, top, from, group) {
       #     groups = c(25, 150)
       #     col = ""
       #     if (from ==  1) col = "hour"
       #     if (from == 24) col = "day"
       #     if (from ==  7) col = "day"
       #     if (from == 30) col = "month"
       #     if (col == "") return (NULL)
       #     if (group > 0) df = df[df$rank <= groups[group],]
       #     dft = df[order(df[col], decreasing = TRUE),]
       #     dft[1:top,]
       # }
      # ,.getTables = function (factory) {
      #      private$tblSession    = factory$getTable("Session")
      #      # private$tblControl    = factory$getTable(self$codes$tables$control)
      #      # private$tblCurrencies = factory$getTable(self$codes$tables$currencies)
      # }
      # ,.loadCache = function() {
      #     private$dfLast = private$tblSession$getLatest()
      #     if (factory$portfolio$target < 3) { # Monedas/Tokens/Todo
      #         tok = ifelse (factory$portfolio$target == 1, 0, 1)
      #         private$dfLast = private$dfLast %>% filter(token == tok)
      #     }
      #     df = tblControl$table(id = 1)
      #     private$lastTMS  = df[1,"tms"] # tblControl$currrent$tms
      #     private$lastLast = df[1, "last"] # tblControl$currrent$last
      # }
      # ,.invalidCache = function() {
      #     df = tblControl$table(id = 1)
      #     if (df[1,"tms"]  > lastTMS ||
      #         df[1,"last"] > lastLast) {
      #         private$lastTMS  = df[1,"tms"] # tblControl$currrent$tms
      #         private$lastLast = df[1, "last"] # tblControl$currrent$last
      #         TRUE
      #     } else {
      #         FALSE
      #     }
      # }
    )
)

