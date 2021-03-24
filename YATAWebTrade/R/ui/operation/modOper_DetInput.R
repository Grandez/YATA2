# Titulo
# Cabecera
# 4 graficos seleccionables
# Resumen
# Detalles Operacion
# Detalles camara/conjunto
# Log

modOperDetailInput = function(id, title="") {
   ns = NS(id)
   left = tagList(
       h4("Plots")
      ,yuiCombo(ns("cboPlot1Left"),  "Left Top Plot" , choices="")
      ,yuiCombo(ns("cboPlot1Right"), "Right Top Plot", choices="")
      ,yuiCombo(ns("cboPlot2Left"),  "Left Bottom Plot" , choices="")
      ,yuiCombo(ns("cboPlot2Right"), "Right Bottom Plot", choices="")
      ,yuiFlex(yuiBtnOK(ns("btnPlotOK"),"Aceptar"), yuiBtnKO(ns("btnPlotKO"),"Anular"))
      ,hr()
     
    )
  
  main = tagList(
      fluidRow(htmlOutput(ns("icon")), h3(yuiLabelText(ns("title"))))
     ,fluidRow(id=ns("plotl1"), yuiPlot(ns("plot10")))
     ,hidden(fluidRow(id=ns("plot1x"), column(6,yuiPlot(ns("plot11"))), column(6,yuiPlot(ns("plot12")))))
     ,fluidRow(id=ns("plotl2"), yuiPlot(ns("plot20")))
     ,hidden(fluidRow(id=ns("plot2x"), column(6,yuiPlot(ns("plot21"))), column(6,yuiPlot(ns("plot22")))))
       
      ,actionButton(ns("btnTest"), "Probar")
            ,fluidRow(tags$table(
                 tags$tr(tags$td("Camara"),   tags$td(yuiLabelText(ns("lblCamera"))))
                ,tags$tr(tags$td("Base"),     tags$td(yuiLabelText(ns("lblBase"))))
                ,tags$tr(tags$td("Counter"),  tags$td(yuiLabelText(ns("lblCounter"))))
                ,tags$tr(tags$td("Amount"),   tags$td(yuiLabelText(ns("lblAmount"))))
                ,tags$tr(tags$td("Price"),    tags$td(yuiLabelText(ns("lblPriceIn"))))
                ,tags$tr(tags$td("Value"),    tags$td(yuiLabelText(ns("lblValueIn"))))
                ,tags$tr(tags$td("Motivo"),  tags$td(yuiCombo(ns("cboReasons"))))
            ))
      
  )
  list(left=left, main=main, right=NULL)
}

# modOperOperInput = function(id, title="") {
#   ns = YATANS(id)
#   main = tagList(
#      fluidRow( yuiColumn(2)
#               ,yuiColumn(1, h4("Operacion"))
#               ,yuiColumn(1, yuiComboSelect( ns("cboOper")
#                                            ,choices=c("Abrir posicion"=1, "Comprar"=2, "Vender"=3)
#                                            ,selected=1))
#               ,yuiColumn(1)
#               ,yuiColumn(1,h4("Moneda"))
#               ,yuiColumn(1,yuiComboSelect(ns("cboCounter"),text="Counter"))
#      )
#     ,fluidRow(
#          yuiColumn(2)
#         ,yuiColumn(2
#             ,fluidRow(h2("Base"))
#             ,fluidRow(tags$table(
#                  tags$tr(tags$td("Camara"),   tags$td(yuiCombo(ns("cboCamera"), choices=list(" "))))
#                 ,tags$tr(tags$td("Base"),     tags$td(yuiCombo(ns("cboBase"),   choices=list(" "))))
#                 ,tags$tr(tags$td("Cantidad"), tags$td(yuiNumericInput(ns("impAmount"), NULL, value = 0)))
#                 ,tags$tr(tags$td("Precio"),  tags$td(yuiNumericInput(ns("impPrice"),  NULL, value = 0)))
#                 ,tags$tr(tags$td("Motivo"),  tags$td(yuiCombo(ns("cboReasons"))))
#             ))
#         )
#         ,yuiColumn(3
#             ,fluidRow(h2("Control"))
#             ,fluidRow(tags$table(
#                  tags$tr(tags$td("Objetivo"), tags$td(yuiSwitch(ns("swTarget"),onLbl="%", offLbl="Value")), tags$td(yuiNumericInput(ns("target"),   NULL, value = 0)))
#                 ,tags$tr(tags$td("Plazo"),    tags$td(colspan=2, yuiIntegerInput(ns("deadline"), NULL, value = 0)))
#                 ,tags$tr(tags$td("Stop"),     tags$td(yuiSwitch(ns("swStop"),onLbl="%", offLbl="Value")),tags$td(yuiNumericInput(ns("stop"),     NULL, value = 0)))
#                 ,tags$tr(tags$td("Limit"),    tags$td(colspan=2, yuiNumericInput(ns("limit"),    NULL, value = 0)))
#                 ,tags$tr(tags$td("Revisar"),  tags$td(colspan=2, yuiIntegerInput(ns("alert"),    NULL, value = 0)))
#             ))
#         )
#         ,yuiColumn(3
#             , fluidRow(h2("Resumen"))
#             ,fluidRow(tags$table(
#                  tags$tr(tags$td("Disponible"),   tags$td(yuiLabelNumeric(ns("lblAvailable"))), tags$td(yuiLabelNumeric(ns("lblNew"))))
#                 ,tags$tr(tags$td("Importe",       tags$td("")                                 , tags$td(yuiLabelNumeric(ns("lblImp"))))
#                 ,tags$tr(tags$td("Comision"),     tags$td( yuiLabelNumeric(ns("lblFee")))     , tags$td(yuiLabelNumeric(ns("lblFeeImp"))))
#                 ,tags$tr(tags$td("Gas"),          tags$td( yuiLabelNumeric(ns("lblGas")))     , tags$td(yuiLabelNumeric(ns("lblGasImp"))))
#                 ,tags$tr(tags$td("Total Base"),   tags$td(""))                                , tags$td(yuiLabelNumeric(ns("lblTotBase"))))
#                 ,tags$tr(tags$td("Total Counter"),tags$td(""))                                , tags$td(yuiLabelNumeric(ns("lblTotCounter"))))
#            )
# 
#             )
#      )  
#     ,fluidRow(yuiColumn(2), yuiColumn(4, h2("Notas")))
#     ,fluidRow(yuiColumn(2), yuiColumn(7, yuiTextArea(ns("comment"), label=NULL, cols="200", rows="20")))
#     ,fluidRow(yuiColumn(2), yuiYesNo(id=ns("tpl"), "Procesar", "Cancelar"))
#   )
#   list(left=NULL, main=main, right=NULL)
# }
