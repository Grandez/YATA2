########################################################
### Los nombres de columnas, columnas, formatos, etc
### De los data frames para web se gestionan aqui
########################################################

preparePosition = function(df) {
   df = subset(df, select=c(currency,balance, priceBuy,priceSell,price))
   colnames(df) = c("currency", "balance", "cost", "return", "net")
   yataSetClasses(df)
}

prepareOperation = function(df, type="simple") {
    df = add_column(df, value = df$price * df$amount, .after = "price")
    df = yataSetClasses(df[,3:8])
   # df = subset(df, select=c(currency,balance, priceBuy,priceSell,price))
   # colnames(df) = c("currency", "balance", "cost", "return", "net")
   # yataSetClasses(df)
    df
}

prepareTop = function(df) {
    yataSetClasses(df, prc=c(3), imp=c(2,4))
}

               # ignore = c("id", "type", "active", "tms", "status", "parent", "alert", "dtAlert")
               # df = self$operations$getOperations(active = YATACodes$flag$active, status = status)
               # if (nrow(df) > 0) {
               #     df = add_column(df, value = df$price * df$amount, .after = "price")
               #     stname = YATACodes$xlateStatus(status)
               #     private$opIdx[[stname]] = df$id
               #     df = df[,!is.na(colnames(df))]
               #     df = df [, ! names(df) %in% ignore, drop = FALSE]
               # }
               # df
