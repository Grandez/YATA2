# Metodos para chapus

toolsUpdateToken = function() {
   # Copiado de updateCurrencies
   beg   = 1

   codes = YATACore::YATACODES$new()
   fact  = YATACore::YATAFactory$new()
   prov  = fact$getDefaultProvider()
   tbl   = fact$getTable(codes$tables$currencies)

   df = prov$getCurrencies(beg, 500)

browser()
   rc = tryCatch({
      process = TRUE
      while (process) {
         if (nrow(df) < 500) process = FALSE
         values = df[df$token == 1, "id"]
         marks = paste(rep("?", length(values)), collapse=",")
         tbl$db$begin()
         sql = paste("UPDATE CURRENCIES SET TOKEN = 1 WHERE ID IN (", marks, ")")
         tbl$db$execute(sql,values)
         tbl$db$commit()
         beg = beg + nrow(df)

         if (is.null(df) || nrow(df) == 0) process = FALSE
         if (process) df   = prov$getCurrencies(beg, 500)
      }
         0
      }, YATAERROR = function (cond) {
              browser()
              16
      }, error = function (cond) {
              browser()
              16
      })

      logger$executed(rc, begin, "Executed")
}
