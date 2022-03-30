modOperHistInput = function(id, title) {
   ns = NS(id)
  labels = c(
      WEB$getMsg("TXT.BID")
     ,WEB$getMsg("TXT.ASK")
     ,WEB$getMsg("TXT.BUY")
     ,WEB$getMsg("TXT.SELL")
     ,WEB$getMsg("TXT.OPEN.POS")
     ,WEB$getMsg("TXT.CLOSE.POS")

  )
  # Match against YATACodes$oper
  operTypes = list(10, 11, 20, 21, 30, 31)
  names(operTypes) = labels

   main = tagList(
      br()
     ,fluidRow( guiColumn(2)
              ,guiColumn(1, h4(WEB$MSG$get("LBL.OPER")))
              ,guiColumn(1, guiCombo( ns("cboOper"), choices=operTypes, selected=20))
                                           #,choices=c(WEB$getMsg("TXT.BID") = 10, "Comprar"=2, "Vender"=3)
                                           #,selected=1))
              ,guiColumn(1,h4(WEB$MSG$get("LBL.CURRENCY")))
              ,guiColumn(2,guiComboSelect(ns("cboCurrency"),text="Counter"))

              ,guiColumn(1, h4(WEB$MSG$get("LBL.CAMERA")))
              ,guiColumn(1, disabled(guiCombo(ns("cboCamera"), choices=list(" "))))
              #,guiColumn(1)
   )
   ,fluidRow(yuiTable(ns("tblHistory")))
  )
  list(left=NULL, main=main, right=NULL)
}
