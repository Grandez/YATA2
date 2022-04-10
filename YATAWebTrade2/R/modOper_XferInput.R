modOperXferInput = function(id, title) {
   ns = NS(id)
   main = tagList(
    fluidRow( guiColumn(3), guiRow(align="center", h2(WEB$MSG$get("TITLE.XFER"))))
   ,br()
   ,fluidRow( guiColumn(2), guiColumn(1, h4(WEB$MSG$get("LBL.FROM")))
                          , guiColumn(2, guiCombo(ns("cboFrom")))
                          , guiColumn(1)
                          , guiColumn(1, yuiLabelBold(ns("lblFrom")))
   )
   ,fluidRow( guiColumn(2), guiColumn(1, h4(WEB$MSG$get("LBL.CURRENCY"))), guiColumn(2, guiCombo(ns("cboCurrency"))))

   ,fluidRow( guiColumn(2), guiColumn(1, h4(WEB$MSG$get("LBL.TO")))
                          , guiColumn(2, guiCombo(ns("cboTo")))
                          , guiColumn(1)
                          , guiColumn(1, yuiLabelBold(ns("lblTo")))
   )
   ,fluidRow( guiColumn(2), guiColumn(1, h4(WEB$MSG$get("LBL.AMOUNT")))
                          , guiColumn(2, guiNumericInput(ns("impAmount"), NULL, value = 0)))

   ,guiYesNo(id=ns("tpl"), "Transferir", "Cancelar", left=3, width=2)
  )
  list(left=NULL, main=main, right=NULL)
}
