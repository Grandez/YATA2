modOperHistInput = function(id, title) {
   ns = NS(id)
   lblCurrency = WEB$MSG$get("LBL.CURRENCY")
   main = tagList(
      br()
     ,fluidRow( guiColumn(2)
              ,guiColumn(1, h4(WEB$MSG$get("LBL.OPER")))
              ,guiColumn(1, guiCombo( ns("cboOper"), choices=WEB$combo$operations(all=TRUE)))
                                           #,choices=c(WEB$getMsg("TXT.BID") = 10, "Comprar"=2, "Vender"=3)
                                           #,selected=1))
              ,guiColumn(1,h4(lblCurrency))
              ,guiColumn(2 ,guiComboSelect(ns("cboCurrency")
                           ,choices=WEB$combo$currencies(id=FALSE, all=TRUE),text=lblCurrency))

              ,guiColumn(1, h4(WEB$MSG$get("LBL.CAMERA")))
              ,guiColumn(1, guiCombo(ns("cboCamera"), choices=WEB$combo$cameras(all=TRUE)))
              #,guiColumn(1)
   )
   ,fluidRow(yuiTable(ns("tblHistory")))
  )
  list(left=NULL, main=main, right=NULL)
}
