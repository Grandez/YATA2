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

prepareOpen = function (df, pnl) {
   if (nrow(df) == 0) return(df)
   last = pnl$getRoot()$getLatestSession()
   df$cost = df$price

   for (idx in 1:nrow(df)) {
        cc = df[idx, "counter"]
        if (!is.null(last[[cc]])) df[idx, "price"] = last[[cc]]$price
   }
   df$delta = (df$price / df$cost) - 1
   df$balance = df$delta * df$cost * df$amount
   df = df[,c("camera", "counter", "amount", "cost", "price", "delta", "value", "balance")]
   # labels     = pnl$cameras$getCameras()
   # df$camera  = labels[df$camera]
   labels     = YATAWEB$getCurrencyLabel(df$counter)
   df$counter = labels[df$counter]
   yataSetClasses(df, prc=c(6), imp=c(3, 4,5,7,8))
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
