modOperXferInput = function(id, title) {
   ns = NS(id)
   main = tagList(  
    fluidRow( yuiColumn(3), yataRow(align="center", h2(WEB$MSG$get("TITLE.XFER"))))
   ,br()   
   ,fluidRow( yuiColumn(2), yuiColumn(1, h4(WEB$MSG$get("LBL.FROM")))
                          , yuiColumn(2, guiCombo(ns("cboFrom")))
                          , yuiColumn(1)
                          , yuiColumn(1, yuiLabelBold(ns("lblFrom")))
   ) 
   ,fluidRow( yuiColumn(2), yuiColumn(1, h4(WEB$MSG$get("LBL.CURRENCY"))), yuiColumn(2, guiCombo(ns("cboCurrency"))))      
      
   ,fluidRow( yuiColumn(2), yuiColumn(1, h4(WEB$MSG$get("LBL.TO")))
                          , yuiColumn(2, guiCombo(ns("cboTo")))
                          , yuiColumn(1)
                          , yuiColumn(1, yuiLabelBold(ns("lblTo")))
   ) 
   ,fluidRow( yuiColumn(2), yuiColumn(1, h4(WEB$MSG$get("LBL.AMOUNT")))      
                          , yuiColumn(2, guiNumericInput(ns("impAmount"), NULL, value = 0)))

   ,yuiYesNo(id=ns("tpl"), "Transferir", "Cancelar", left=3, width=2)
  )
  list(left=NULL, main=main, right=NULL)
}
