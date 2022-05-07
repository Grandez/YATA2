modOperRegInput = function(id, title) {
   ns = NS(id)
   mnu = WEB$getLabelsMenuOper()
   lbl = WEB$getLabelsPanel()

   main = tagList(
   guiRow(align="center", h2(WEB$MSG$get("MNU.REGULARIZE")))
   ,fluidRow(column(3)
      ,column(3
         ,yataFormTable(
             list(lbl$CTC,    guiCombo(ns("cboCurrency")))
            ,list(lbl$FROM,   guiCombo(ns("cboFrom")))
            ,list(lbl$TO,     guiCombo(ns("cboTo")))
            ,list(lbl$AMOUNT, guiNumericInput(ns("impAmount"), NULL, value = 0))
          )
          ,br()
         ,guiYesNo(id=ns("reg"), "Transferir", "Cancelar") # , cols=3, left=3)
       )))
  list(left=NULL, main=main, right=NULL)
}
