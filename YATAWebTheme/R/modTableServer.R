modTableServer <- function(id, full, pnlParent, invalidate=FALSE) {
   ns = NS(id)
   makeDF = function() {
      dfpos = data.frame( currency = c("EUR", "BTC", "ETH")
                         ,balance  = c(12345, 0.25, 2.34)
                         ,available = c(12000, 0.20, 1)
                         ,price     = c(1, 15000, 523)
                         ,value     = c(12345, 3750, 1223.82)
                         ,from      = c(Sys.time(), Sys.time(), Sys.time())
                         ,last      = c(Sys.time(), Sys.time(), Sys.time())
                         ,var1      = c(0, 0, 0)
                         ,var2      = c(0.1, -0.1, 0)
                         ,var3      = c(-0.01, -0.0223, 0.345)
                         ,var4      = c(0, 0, 0)
      )
      yataSetClasses(dfpos, prc = c(8,9,10,11), imp=c(2,3,4,5), lbl=c(1), dat=c(6,7)) 
      
   }
   moduleServer(id, function(input, output, session) {
      df = makeDF()
      browser()
      output$tblPos01 = updTablePosition(id=ns("posGlobal"), df)
  })
}    
