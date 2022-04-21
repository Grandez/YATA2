modOperHistInput = function(id, title) {
   ns = NS(id)
   lblCurrency = WEB$MSG$get("LBL.CURRENCY")
   main = tagList(
      br()
     ,fluidRow( guiColumn(1)
              ,guiColumn(1, h4(WEB$MSG$get("LBL.OPER")))
              ,guiColumn(1, guiCombo( ns("cboOper"), choices=WEB$combo$operations(all=TRUE)))
              ,guiColumn(1, h4(lblCurrency))
              ,guiColumn(2 ,guiComboSelect(ns("cboCurrency")
                           ,choices=WEB$combo$currencies(id=FALSE, all=TRUE),text=lblCurrency))

              ,guiColumn(1, h4(WEB$MSG$get("LBL.CAMERA")))
              ,guiColumn(1, guiCombo(ns("cboCamera"), choices=WEB$combo$cameras(all=TRUE)))
              ,guiColumn(1, h4(WEB$MSG$get("LBL.SINCE")))
              ,guiColumn(1, dateInput(ns("dtDate"), label=NULL, value="2020-01-01"))

              #,guiColumn(1)
   )
   ,fluidRow(yuiTable(ns("tblHistory")))
  )
  list(left=NULL, main=main, right=NULL)
}
