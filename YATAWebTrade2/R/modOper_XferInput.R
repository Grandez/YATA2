modOperXferInput = function(id, title) {
   ns = NS(id)
   mnu = WEB$getLabelsMenuOper()
   lbl = WEB$getLabelsPanel()
   main = tagList(
    fluidRow( guiColumn(3), guiRow(align="center", h2(mnu$XFER)))
   ,br()
   ,fluidRow( guiColumn(2), guiColumn(1, h4(lbl$FROM))
                          , guiColumn(2, guiCombo(ns("cboFrom")))
   )
   ,fluidRow( guiColumn(2), guiColumn(1, h4(lbl$TO))
                          , guiColumn(2, guiCombo(ns("cboTo")))
                          , guiColumn(1)
                          , guiColumn(1, yuiLabelBold(ns("lblTo")))
   )

   ,fluidRow( guiColumn(2), guiColumn(1, h4(lbl$CURRENCY))
                          , guiColumn(2, guiCombo(ns("cboCurrency")))
                          , guiColumn(1)
                          , guiColumn(1, yuiLabelBold(ns("lblFrom")))
    )

   ,fluidRow( guiColumn(2), guiColumn(1, h4(lbl$AMOUNT))
                          , guiColumn(2, guiNumericInput(ns("impAmount"), NULL, value = 0)))

   ,guiYesNo(id=ns("tpl"), "Transferir", "Cancelar", left=3, width=2)
  )
  list(left=NULL, main=main, right=NULL)
}
