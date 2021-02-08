modOperXferInput = function(id) {
   ns = NS(id)
   tagList(  
   yataRow(align="center", h2("Transferir entre cuentas"))
   ,fluidRow(column(1)
      ,column(2
         ,yataFormTable(
             list("De",       yataCombo(ns("cboFrom"), choices=list(1,2,3)))
            ,list("A",        yataCombo(ns("cboTo"),   choices=list(1,2,3)))
            ,list("Moneda",   yataCombo(ns("cboCurrency"),choices=list(1,2,3)))
            ,list("Cantidad", numericInput(ns("impAmount"), NULL, value = 0))
         )
       )
    )
   ,fluidRow(column(1), tags$div(id=ns("msg")))
   ,fluidRow(column(1)
       ,column(4, yataBtnOK(ns("btnOK"), "Transferir"), yataBtnKO(ns("btnKO"), "Cancelar"))
    )
)}
