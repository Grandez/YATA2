modOperXferInput = function(id, title) {
   ns = NS(id)
   tagList(  
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
   ,fluidRow(column(1)
       ,column(4, yuiBtnOK(ns("btnOK"), "Transferir"), yuiBtnKO(ns("btnKO"), "Cancelar"))
    )
)}
