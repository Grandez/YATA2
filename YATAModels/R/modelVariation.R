ModelVariation = R6::R6Class("YATA.MODEL.VARIATION"
  ,inherit    = YATAModel
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,public = list(
      name = "Variation"
     ,initialize    = function(...) {
        super$initialize(...)
         if (is.null(args$scope))   stop(sprintf("El modelo %s necesita un scope", name))
         if (is.null(args$factory)) stop(sprintf("El modelo %s requiere una factoria", name))
         private$scope = private$scopes[[args$scope]]
     }
     ,batch = function(blockSize=200) {
         log = paste0(Sys.getenv("YATA_SITE"),"/data/log/parallel.log")
         ctc = preprocess()

         cores = parallel::detectCores(logical=TRUE) # Cores no CPUs
         # En Windows esta haciendo muchas mas cosas, en Unix esta casi dedicado
         cores = ifelse (.Platform$OS.type == "windows", cores / 3, cores - 2)
#         registerDoParallel(cores)
         blocks = ceiling(nrow(ctc) / blockSize) - 1
#         cat(sprintf("%s - Workers to use %d\n", Sys.time(), getDoParWorkers()), file=log, append=TRUE)
#         foreach (i = 0:blocks) %dopar% {
         for (i in 0:blocks) {
             cat(sprintf("%s - starting block %d\n", Sys.time(), i), file=log, append=TRUE)
             from = (i * blockSize) + 1
             to = (i + 1) * blockSize
             if (to > nrow(ctc)) to = nrow(ctc)
             private$process(data.frame(id=ctc[from:to,]), i)
             cat(sprintf("%s - ending code for block %d\n", Sys.time(), i), file=log, append=TRUE)
         }
         cat(sprintf("%s - Sale del foreach\n", Sys.time()), file=log, append=TRUE)
     }
   )
  ,private = list (
      scopes = list(
          short  = c(1, 2,  3,  7, 14)
         ,medium = c(1, 3,  7, 14, 30)
         ,long   = c(1, 7, 15, 30, 90)

       )
      ,scope  = NULL
      ,fact   = NULL
      ,latest = NULL
      ,preprocess = function(ctc) {
          tblCurrencies = args$factory$getTable("Currencies")
          ctc = tblCurrencies$table(token = 0, active=1)

          tblModel = args$factory$getTable("ModelVar")
          tblModel$db$execute("UPDATE MODEL_VAR SET UPDATED = NULL", isolated=TRUE)
          objSession = args$factory$getObject("Session")
          private$latest = objSession$getLatest(currencies = ctc$id)
          data.frame(id=ctc[,"id"])
      }
     ,process = function(data, block) {
                  log = paste0(Sys.getenv("YATA_SITE"),"/data/log/parallel.log")
         cat(sprintf("%s - Entra en process con block %d\n", Sys.time(), block), file=log, append=TRUE)
         dfv = NULL
         df = inner_join(latest, data, by="id")
         df = df[,c("id", "symbol", "rank","price","volume")]
         from = Sys.Date() - (scope[5] + 1)
         dfh = getHistoryData(df[1,"id"], df[nrow(df), "id"], from)
         for (row in 1:nrow(df)) {
             lst = processCurrency(df[row,], dfh %>% filter(ID == data[row,"id"]))
             dfv = rbind(dfv, as.data.frame(lst))
         }
         dfv$UPDATED = Sys.Date()
         loadData(dfv, block)
         cat(sprintf("%s - Sale de process con block %d\n", Sys.time(), block), file=log, append=TRUE)
     }
     ,processCurrency = function(df, dfh) {
         labels = c("PRICE", "VOLUME", "VAR", "VOL")
         data = as.list(df)
         names(data) = c("id", "symbol", "rank", "price00", "volume00")
         for (idx in 1:5) {
             lbls = sprintf("%s%02d", labels, idx)
             dft = dfh[dfh$TMS == (Sys.Date() - scope[idx]),]
             val =
             if (nrow(dft) != 0) {
                 data[[lbls[1]]] = dft[1,"CLOSE"]
                 data[[lbls[2]]] = dft[1,"VOLUME"]
                 data[[lbls[3]]] = calculate(data$price00,  dft[1,"CLOSE"], scope[idx])
                 data[[lbls[4]]] = calculate(data$volume00, dft[1,"VOLUME"], scope[idx])
             } else {
                 data[[lbls[1]]] = NA
                 data[[lbls[2]]] = NA
                 data[[lbls[3]]] = NA
                 data[[lbls[4]]] = NA
             }
         }
         data = predict(data, scope)
         data
     }
     ,getHistoryData = function(from, to, date) {
         tblh   = args$fact$getTable("History")
         qry    = "SELECT * FROM HISTORY WHERE ID BETWEEN ? AND ? AND TMS > ?"
         params = list(from, to, date)
         df     = tblh$db$query(qry,params)
         df
     }
     ,calculate = function(last, first, periods=1) {
         last = signif(last)
         first = signif(first)
         if (last == 0 || first == 0) return (NA)
         if (last == first)           return (0)
         if (last > first) res = ( last / first) ^ (1 / periods) - 1
         else              res = ((first / last) ^ (1 / periods) - 1) * -1
         signif(res, digits=3)
     }
     ,loadData = function(df, block) {
         colnames(df) = toupper(colnames(df))
         YATABase::loadTable(df, table="MODEL_VAR", dbname="YATAData", suffix=sprintf(".%03d", block))
     }
     ,predict = function(data,scope) {
         len = max(scope)
         labels = c("PRICE", "VOLUME")
         x = 1:len
         y = rep(NA, len)
         z = rep(NA, len)
         for (idx in 1:length(scope)) {
             lbls = sprintf("%s%02d", labels, idx)
             y[len - scope[idx]] = data[[lbls[1]]]
             z[len - scope[idx]] = data[[lbls[2]]]
         }
         df = data.frame(x=x, y=y)
         mod = lm(formula = y ~ x + I(x^2) + I(x^3), data = df)
         data$IND_VAR = calculate(makePredict(mod, len + 1), data$PRICE00)

         df = data.frame(x=x, y=Z)
         mod = lm(formula = y ~ x + I(x^2) + I(x^3), data = df)
         data$IND_VOL = calculate(makePredict(mod, len + 1), data$VOL00)
         data
     }
     ,makePredict = function(model, point) {
        res = 0
        for (idx in 1:length(model$coefficients)) {
             res = res + (input * (model$coefficients[idx] ^ (idx - 1)))
        }
        res
     }
   )
)
