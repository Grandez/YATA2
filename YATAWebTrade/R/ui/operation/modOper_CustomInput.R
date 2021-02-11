modOperCustomInput = function(id, title) {
  ns = NS(id)
tagList(  
   yataRow(align="center", h2("Transferir entre cuentas"))
  ,fluidRow(column(1)
    ,column(2
        ,yataFormTable(
            list("De",       yuiCombo(ns("cboFrom"), choices=list(1,2,3)))
           ,list("A",        yuiCombo(ns("cboTo"),   choices=list(1,2,3)))
           ,list("Moneda",   yuiCombo(ns("cboCurrency"),choices=list(1,2,3)))
           ,list("Cantidad", yuiNumericInput(ns("impAmount"), NULL, value = 0))
        )
    )
  )
    ,fluidRow(column(1)
       ,column(4, yuiBtnOK(ns("btkOK"), "Transferir"), yuiBtnKO(ns("btkKO"), "Cancelar"))
    )

)}
