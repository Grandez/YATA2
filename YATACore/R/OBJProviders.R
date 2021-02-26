# Este es el que sabe el PATH
OBJProviders = R6::R6Class("OBJ.PROVIDER"
    ,inherit    = OBJBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        print           = function() { message("Proivders Object")}
       ,initialize      = function(provider) {
           super$initialize()
           private$providers    = HashMap$new()
           private$tblProviders = YATAFactory$getTable(YATACodes$tables$Providers)
           private$id           = parms$getOnlineProvider()
           private$name         = tblProviders$getNames(private$id)

           private$dfProviders  = tblProviders$table(active = YATACodes$flag$active)
           if (nrow(private$dfProviders) == 0) stop("No hay proveedores activos")
           private$mktcap = YATAFactory$getProvider("MKTCAP", "MarketCap")
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
     ,getBest = function(interval=1,top=5) {
         # interval = numero en dias: 1 o 7
         col = 4
         df = private$mktcap$getLatest()

         if (interval == 1) {
             col = 4
             df = df[order(df$var1, decreasing=TRUE),]
         } else {
             col = 5
             df = df[order(df$var7, decreasing = TRUE),]
         }
         df[1:top, c(2,3,col)]
     }
    )
    ,private = list(
        selected     = FALSE
       ,id           = NULL
       ,name         = NULL
       ,provider     = NULL
       ,mktcap       = NULL  # Objeto MarketCap
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
