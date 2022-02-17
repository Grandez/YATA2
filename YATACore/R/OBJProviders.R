# Este es el que sabe el PATH
OBJProviders = R6::R6Class("OBJ.PROVIDER"
    ,inherit    = OBJBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        print       = function() { message("Providers Object")}
       ,initialize  = function(factory) {
           super$initialize(factory)
           private$providers    = HashMap$new()
           private$tblProviders = factory$getTable(codes$tables$providers)
           self$id              = parms$getOnlineProvider()

           private$dfProviders  = tblProviders$table(active = codes$flag$active)
           if (nrow(private$dfProviders) == 0) stop("No hay proveedores activos")
           prov = dfProviders[dfProviders$id == self$id,]

           #JGG Especial
           private$mktcap = factory$getProvider("MKTCAP", "MarketCap")

           self$name = prov[1,"name"]
          # private$provider = factory$getProvider(self$id, prov[1,"object"])
           private$provider = private$mktcap
           private$providers$put(self$id, private$provider)

           private$providers$put("MKTCAP", mktcap)
       }
       ,getProviders = function() { private$dfProviders }
       # ,getMonitors = function(base, counter) {
       #     res = list()
       #     data = getLatests(base, counter)
       #     if (is.null(data)) return (NULL)
       #     if (nrow(data) == 0) return(NULL)
       #
       #     colnames(data) = c("tms", "id", "name", "symbol", "last", "hour", "day","week","month", "bimonth", "quarter", "volume")
       #
       #     if (nrow(data) > 0) {
       #         for (row in 1:nrow(data)) {
       #              lst = as.list(data[row,])
       #              res[[data[row,"symbol"]]] = lst
       #         }
       #     }
       #    res
          # now = Sys.time()
          # from = now - as.difftime(1, unit="days")

          # data2 = lapply(counter, function(x) getSessionDays(base, x, asUnix(from), asUnix(now)))
          # names(data2) = counter
          # lst2 = lapply(data2, function(x) list(day = x[1,"close"]))
          # names(lst2) = counter
          # data = list.merge(data,lst2)
          # from = now - as.difftime(7, unit="days")
          # getSessionDays("EUR", "BTC", asUnix(from), asUnix(now))
          # data2 = lapply(counter, function(x) getSessionDays(base, x, asUnix(from), asUnix(now)))
          # lst2  = lapply(data2, function(x) list(week = x[1,"close"]))
          # names(lst2) = counter
          # list.merge(data,lst2)
#      }
       ,getLatests  = function(base, counter) {
           df = provider$getLatest()
           df %>% filter(symbol %in% counter)
        }
    )
    ,private = list(
        provider     = NULL  # Porvider por defecto
       ,mktcap       = NULL  # Objeto MarketCap
       ,tblProviders = NULL
       ,providers    = NULL
       ,dfProviders  = NULL
    )
)
