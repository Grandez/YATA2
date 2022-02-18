modOperXferInput = function(id, title) {
   ns = NS(id)
   main = tagList(  
    fluidRow( yuiColumn(3), yataRow(align="center", h2(YATAWEB$MSG$get("TITLE.XFER"))))
   ,br()   
   ,fluidRow( yuiColumn(2), yuiColumn(1, h4(YATAWEB$MSG$get("LBL.FROM")))
                          , yuiColumn(2, yuiCombo(ns("cboFrom")))
                          , yuiColumn(1)
                          , yuiColumn(1, yuiLabelBold(ns("lblFrom")))
   ) 
   ,fluidRow( yuiColumn(2), yuiColumn(1, h4(YATAWEB$MSG$get("LBL.CURRENCY"))), yuiColumn(2, yuiCombo(ns("cboCurrency"))))      
      
   ,fluidRow( yuiColumn(2), yuiColumn(1, h4(YATAWEB$MSG$get("LBL.TO")))
                          , yuiColumn(2, yuiCombo(ns("cboTo")))
                          , yuiColumn(1)
                          , yuiColumn(1, yuiLabelBold(ns("lblTo")))
   ) 
   ,fluidRow( yuiColumn(2), yuiColumn(1, h4(YATAWEB$MSG$get("LBL.AMOUNT")))      
                          , yuiColumn(2, yuiNumericInput(ns("impAmount"), NULL, value = 0)))

   ,yuiYesNo(id=ns("tpl"), "Transferir", "Cancelar", left=3, width=2)
  )
  list(left=NULL, main=main, right=NULL)
}
