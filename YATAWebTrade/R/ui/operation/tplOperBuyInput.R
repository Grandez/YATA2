tplOperBuyInput = function(id, title="") {
  ns = NS(id)
  main = tagList(
     if (nchar(title) > 0) yataPageTitle(title)
    ,fluidRow(column(4)
      ,column(3, yuiFormTable(list("Moneda",  yuiComboSelect(ns("cboCounter"),text="Counter"))))
    )
    ,fluidRow(column(1)
      ,column(3,
             h2("Base")
            ,yuiFormTable(
                 list("Camara",   yuiCombo(ns("cboCamera"), choices=list(" ")))
                ,list("Base",     yuiCombo(ns("cboBase"),   choices=list(" ")))
                ,list("Cantidad", yuiNumericInput(ns("impAmount"), NULL, value = 0))
                ,list("Precio",   yuiNumericInput(ns("impPrice"),  NULL, value = 0))
            )
        )
      ,column(3,
             h2("Control")
            ,yuiFormTable(
                list("Objetivo", yuiNumericInput(ns("target"),   NULL, value = 0))
               ,list("Plazo",    yuiIntegerInput(ns("deadline"), NULL, value = 0))
               ,list("Stop",     yuiNumericInput(ns("stop"),     NULL, value = 0))
               ,list("Limit",    yuiNumericInput(ns("limit"),    NULL, value = 0))
               ,list("Revisar",  yuiIntegerInput(ns("alert"),    NULL, value = 0))
           )
        )
      ,column(3,
             h2("Resumen")
            ,yuiFormTable(
                 list("Disponible",    yuiLabelNumeric(ns("lblAvailable")), yuiLabelNumeric(ns("lblNew")))
                ,list("Importe",       ""                                , yuiLabelNumeric(ns("lblImp")))
                ,list("Comision",      yuiLabelNumeric(ns("lblFee"))      , yuiLabelNumeric(ns("lblFeeImp")))
                ,list("Gas",           yuiLabelNumeric(ns("lblGas"))      , yuiLabelNumeric(ns("lblGasImp")))
                ,list("Total Base",    ""                                , yuiLabelNumeric(ns("lblTotBase")))
                ,list("Total Counter", ""                                , yuiLabelNumeric(ns("lblTotCounter")))
           )
        )

    )
    ,fluidRow(column(1), h2("Notas"))
    ,fluidRow(column(1), column(9, yuiArea(ns("comment"), label=NULL, cols="200", rows="10")))
    ,fluidRow(column(1), tags$div(id=ns("msg")))
    ,fluidRow(column(1), column(6, yuiYesNo("Procesar", "Cancelar", ns("tpl"))))
  )
  list(left=NULL, main=main, right=NULL)
}
