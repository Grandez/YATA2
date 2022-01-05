modTableServer <- function(id, full, pnlParent, invalidate=FALSE) {
   ns = NS(id)
   makeDF = function(size=10) {
      int = seq(1,size)
      text = paste("Texto", LETTERS[seq( from = 1, to = size )])
      prc = seq(-1, 1, length.out = size)
      dt = seq.Date(as.Date("2020/01/01"), by=1,length.out = size)
      tms = seq(c(ISOdate(2000,3,20)), by = "hour", length.out = size)
      fct = sample(c("uno","dos","tres"), size, T)
      fct = factor(fct, labels=c("X", "Y","Z"))
      data.frame(entero=int, texto=text, porcentaje=prc, dates=dt, tms=tms,nada=seq(1,size),factor=fct)
   }
   updateTable = function(table, ...) {
      # Aqui actualiza los datos y devuelve la tabla actualizada
      table
   }
    # makeDF = function() {
   #    dfpos = data.frame( currency = c("EUR", "BTC", "ETH")
   #                       ,balance  = c(12345, 0.25, 2.34)
   #                       ,available = c(12000, 0.20, 1)
   #                       ,price     = c(1, 15000, 523)
   #                       ,value     = c(12345, 3750, 1223.82)
   #                       ,from      = c(Sys.time(), Sys.time(), Sys.time())
   #                       ,last      = c(Sys.time(), Sys.time(), Sys.time())
   #                       ,var1      = c(0, 0, 0)
   #                       ,var2      = c(0.1, -0.1, 0)
   #                       ,var3      = c(-0.01, -0.0223, 0.345)
   #                       ,var4      = c(0, 0, 0)
   #    )
   #    #yataSetClasses(dfpos, prc = c(8,9,10,11), imp=c(2,3,4,5), lbl=c(1), dat=c(6,7)) 
   #    dfpos
   # }
   moduleServer(id, function(input, output, session) {
      df = makeDF()
      browser()
      tbl = WDGTable$new()
      #tableDef = createTableDef(df, types="ispdmh", titles="xxxxu", colors="xxod")
      #output$tbl01 = updTable(df, tableDef)
      output$tbl01 = tbl$render(df)
  })
}    
