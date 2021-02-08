# Este es el que sabe el PATH
OBJProviders = R6::R6Class("OBJ.PROVIDER"
    ,inherit    = OBJBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        print           = function() { message("Clearings Object")}
       ,initialize      = function(provider) {
           super$initialize()
           private$providers    = HashMap$new()
           private$tblProviders = YATAFactory$getTable(YATACodes$tables$Providers)
           private$id           = parms$getOnlineProvider()
           private$name         = tblProviders$getNames(private$id)
           df  = tblProviders$table(active = YATACodes$flag$active)

           if (nrow(df) > 0 ) private$dfProviders = df[order(df$order),]
#           if (!missing(provider)) private$name = provider
#            private$provider = YATAFactory$getProvider(private$name)
           # private$provider$setInterval(base$getOnlineInterval())
       }
      ,getSessionDays = function(base, counter, from, to) {
          if (is.null(private$provider)) .setProvider(1)
          provider$getSessionDays(base, counter, from, to)
      }
      ,getMonitors = function(base, counter) {
          data = getLatests(base, counter)
          now = Sys.time()

          from = now - as.difftime(1, unit="days")
          data2 = lapply(counter, function(x) getSessionDays(base, x, asUnix(from), asUnix(now)))
          names(data2) = counter
          lst2 = lapply(data2, function(x) list(day = x[1,"close"]))
          names(lst2) = counter
          data = list.merge(data,lst2)
          from = now - as.difftime(7, unit="days")
          getSessionDays("EUR", "BTC", asUnix(from), asUnix(now))
          data2 = lapply(counter, function(x) getSessionDays(base, x, asUnix(from), asUnix(now)))
          lst2  = lapply(data2, function(x) list(week = x[1,"close"]))
          names(lst2) = counter
          list.merge(data,lst2)
      }
      ,getLatests = function(base, counter) {
          # va buscando la info por cada provider en orden
          done = FALSE
          row = 0
          while (!done) {
              if (nrow(dfProviders) > 0) {
                  row = row + 1
                  .setProvider(row)
              }
              done = TRUE
              # res = provider$getLatests(base, counter)
              # browser()
          }
          provider$getLatests(base, counter)
      }
    )
    ,private = list(
        selected     = FALSE
       ,id           = NULL
       ,name         = NULL
       ,provider     = NULL
       ,tblProviders = NULL
       ,providers    = NULL
       ,dfProviders  = NULL
       ,.setProvider = function(row) {
            rr = as.list(dfProviders[row,])
            private$provider = providers$get(rr$object)
            if (is.null(private$provider))  {
                private$provider = YATAFactory$getProvider(rr$id, rr$object)
                private$providers$put(rr$object, private$provider)
            }
        }
    )
)
