modOperXferInput = function(id, title) {
   ns = NS(id)
   main = tagList(  
   yataRow(align="center", h2("Transferir entre cuentas"))
   ,fluidRow(column(1)
      ,column(2
         ,yataFormTable(
             list("De",       yuiCombo(ns("cboFrom"), choices=list("")))
            ,list("A",        yuiCombo(ns("cboTo"),   choices=list("")))
            ,list("Moneda",   yuiCombo(ns("cboCurrency"),choices=list("")))
            ,list("Cantidad", yuiNumericInput(ns("impAmount"), NULL, value = 0))
         )
       )
    )
    ,fluidRow(column(1), tags$div(id=ns("msg")))
    ,fluidRow(column(1), column(6, yuiYesNo("Transferir", "Cancelar", ns("tpl"))))
  )
  list(left=NULL, main=main, right=NULL)
}
