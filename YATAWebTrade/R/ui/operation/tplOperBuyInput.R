tplOperBuyInput = function(id, title="") {
  ns = NS(id)
  tagList(
     if (nchar(title) > 0) yataPageTitle(title)
    ,fluidRow(column(4)
      ,column(3, yataFormTable(list("Moneda",  yuiComboSelect(ns("cboCounter"),text="Counter"))))
    )
    ,fluidRow(column(1)
      ,column(3,
             h2("Base")
            ,yataFormTable(
                 list("Camara",   yuiCombo(ns("cboCamera"), choices=list(" ")))
                ,list("Base",     yuiCombo(ns("cboBase"),   choices=list(" ")))
                ,list("Cantidad", yuiNumericInput(ns("impAmount"), NULL, value = 0))
                ,list("Precio",   yuiNumericInput(ns("impPrice"),  NULL, value = 0))
            )
        )
      ,column(3,
             h2("Control")
            ,yataFormTable(
                list("Objetivo", yuiNumericInput(ns("target"),  NULL, value = 0))
               ,list("Plazo",    yuiIntegerInput(ns("deadline"),  NULL, value = 0))
               ,list("Stop",     yuiNumericInput(ns("stop"),   NULL, value = 0))
               ,list("Limit",    yuiNumericInput(ns("limit"),  NULL, value = 0))
               ,list("Revisar",  yuiIntegerInput(ns("alert"),  NULL, value = 0))
           )
        )
      ,column(3,
             h2("Resumen")
            ,yataFormTable(
                 list("Disponible",    yuiLabelNumber(ns("lblAvailable")), yuiLabelNumber(ns("lblNew")))
                ,list("Importe",       ""                          , yuiLabelNumber(ns("lblImp")))
                ,list("Comision",      yuiLabelNumber(ns("lblFee"))    , yuiLabelNumber(ns("lblFeeImp")))
                ,list("Gas",           yuiLabelNumber(ns("lblGas"))    , yuiLabelNumber(ns("lblGasImp")))
                ,list("Total Base",    ""                          , yuiLabelNumber(ns("lblTotBase")))
                ,list("Total Counter", ""                          , yuiLabelNumber(ns("lblTotCounter")))
           )
        )

    )
    # ,fluidRow(column(1)
    #    ,column(6,
             ,h2("Notas")
        # ,fluidRow(
  ,           yuiArea(ns("comment"), label=NULL, cols="200", rows="10")
        # )
         # )
   # )
    ,fluidRow(column(1), tags$div(id=ns("msg")))
    ,fluidRow(column(1)
       ,column(4, yuiBtnOK(ns("btnOK"), "Procesar"), yuiBtnKO(ns("btnKO"), "Cancelar"))
    )
)}
