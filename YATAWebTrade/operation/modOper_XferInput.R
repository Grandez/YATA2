modOperXferInput = function(id, title) {
   ns = NS(id)
   main = tagList(  
   yataRow(align="center", h2("Transferir entre cuentas"))
   ,fluidRow(column(3)
      ,column(3
         ,yataFormTable(
             list("De",       yuiCombo(ns("cboFrom"), choices=list("")))
            ,list("A",        yuiCombo(ns("cboTo"),   choices=list("")))
            ,list("Moneda",   yuiCombo(ns("cboCurrency"),choices=list("")))
            ,list("Cantidad", yuiNumericInput(ns("impAmount"), NULL, value = 0))
         )
       )
    )
    ,yuiYesNo(id=ns("tpl"), "Transferir", "Cancelar", cols=3, left=3)     
  )
  list(left=NULL, main=main, right=NULL)
}
