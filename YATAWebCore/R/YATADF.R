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
    df = df[, c("symbol", "price", "var", "volume")]
    yataSetClasses(df)
}

prepareVariation = function(df) {
   prcVar = function(x) { ifelse (x[1] == 0, 0, (x[2] / x[1] - 1) * 100) }
   # Obtiene las variaciones
   cols = colnames(df)
   idx = which(cols == "close")
   if (length(idx) > 0) {
      if (length(cols) > 7) {
          dft = rollapply(df[,8:ncol(df)], 2, prcVar, by.column=TRUE,fill=0, na.pad=0, align="right")
      } else {
         dft = rollapply(df[,"close"], 2, prcVar, by.column=TRUE,fill=0, partial=TRUE)
      }
      df2 = as.data.frame(cbind(df[,"tms"], dft))
      colnames(df2) = c("tms", cols[8:length(cols)])
   }
   df2
}
