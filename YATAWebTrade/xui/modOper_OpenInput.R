modOperOpenInput = function(id) {
  ns = NS(id)
  tagList(  
     yataRow(align="center", h2("Abrir Posicion"))  
    ,fluidRow(column(4)
      ,column(3, yataFormTable(list("Moneda",  yataComboSelect(ns("cboCounter"),text="Counter"))))
    )
    ,fluidRow(column(1)
      ,column(3,
             h2("Base")
            ,yataFormTable(
                 list("Camara",   yataCombo(ns("cboCamera"), choices=list(" ")))
                ,list("Base",     yataCombo(ns("cboBase"),   choices=list(" ")))
                ,list("Cantidad", numericInput(ns("impAmount"), NULL, value = 0))
                ,list("Precio",   numericInput(ns("impPrice"),  NULL, value = 0))
            )
        )
      ,column(3,
             h2("Control")
            ,yataFormTable(
                list("Objetivo", numericInput(ns("target"),  NULL, value = 0))
               ,list("Plazo",    numericInput(ns("deadline"),  NULL, value = 0))
               ,list("Stop",    numericInput(ns("stop"),   NULL, value = 0))
               ,list("Limit",   numericInput(ns("limit"),  NULL, value = 0))
               ,list("Revisar",  numericInput(ns("alert"),  NULL, value = 0))
           )
        )
      ,column(3,
             h2("Resumen")
            ,yataFormTable(
                 list("Disponible",    uiOutput(ns("lblAvailable")), uiOutput(ns("lblNew")))
                ,list("Importe",       ""                          , uiOutput(ns("lblImp")))
                ,list("Comision",      textOutput(ns("lblFee"))    , uiOutput(ns("lblFeeImp")))
                ,list("Gas",           textOutput(ns("lblGas"))    , uiOutput(ns("lblGasImp")))
                ,list("Total Base",    ""                          , uiOutput(ns("lblTotBase")))
                ,list("Total Counter", ""                          , uiOutput(ns("lblTotCounter")))   
           )
        )
       
    )
    # ,fluidRow(column(1)
    #    ,column(6,
             ,h2("Notas")
        # ,fluidRow(
  ,           yataArea(ns("comment"), label=NULL, cols="200", rows="10")
        # )
         # )
   # )
    ,fluidRow(column(1), tags$div(id=ns("msg")))
    ,fluidRow(column(1)
       ,column(4, yataBtnOK(ns("btnOK"), "Abrir posicion"), yataBtnKO(ns("btnKO"), "Cancelar"))
    )
  
  
)}
