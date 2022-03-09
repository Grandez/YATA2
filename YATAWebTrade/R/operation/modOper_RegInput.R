modOperRegInput = function(id, title) {
    
   ns = NS(id)
   main = tagList(  
   yataRow(align="center", h2(YATAWEB$MSG$get("TITLE.REGULARIZATION")))
   ,fluidRow(column(3)
      ,column(3
         ,yataFormTable(
             list("De",       guiCombo(ns("cboFrom"))) #, choices=list("")))
            ,list("A",        guiCombo(ns("cboTo"))) #,   choices=list("")))
            ,list("Moneda",   guiCombo(ns("cboCurrency"))) #,choices=list("")))
            ,list("Cantidad", guiNumericInput(ns("impAmount"), NULL, value = 0))
         )
       )
    )
    ,yuiYesNo(id=ns("reg"), "Transferir", "Cancelar") # , cols=3, left=3)     
  )
  list(left=NULL, main=main, right=NULL)
}
