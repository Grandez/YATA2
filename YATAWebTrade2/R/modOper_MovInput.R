#TODO cambiar fluidRow por guiRow jode la pagina
#     No se por que
modOperMovInput = function(id, title) {
  ns = YATANS(id)
  lbl = WEB$getLabelsMenuMain()
  main = tagList(
      br()
     ,fluidRow( guiColumn(2)
              ,guiColumn(1, h4(lbl$OPER))
              ,guiColumn(1, guiCombo(ns("cboOper"), choices=WEB$combo$operations()))
              ,guiColumn(1, h4(lbl$CURRENCY))
              ,guiColumn(2, disabled(guiComboSelect(ns("cboCurrency"),choices = NULL)))

              ,guiColumn(1, h4(lbl$CAMERA))
              ,guiColumn(1, disabled(guiCombo(ns("cboCamera"), choices=list(" "))))
              #,guiColumn(1)
     )
    ,fluidRow(
         guiColumn(2)
        ,guiColumn(3
            ,fluidRow(h2(lbl$BASE))
            ,fluidRow(tags$table(
                 tags$tr( tags$td(lbl$AMOUNT)
                         ,tags$td(colspan="2", guiNumericInput(ns("impAmount")))
                         ,tags$td(yuiBtnIconCalc(id=ns("btnCalcAmount"))))
                ,tags$tr( tags$td(lbl$PRICE)
                         ,tags$td(colspan="2", guiNumericInput(ns("impPrice")))
                         ,tags$td(yuiBtnIconCalc(id=ns("btnCalcPrice"))))
                ,tags$tr( tags$td(lbl$IMPORT)
                         ,tags$td(colspan="2", guiNumericInput(ns("impValue")))
                         ,tags$td(yuiBtnIconCalc(id=ns("btnCalcValue"))))
                ,tags$tr( tags$td(lbl$FEE)
                         ,tags$td(yuiSwitch(ns("swFee"),onLbl="%", offLbl="Value"))
                         ,tags$td(guiNumericInput(ns("impFee"),  NULL, value = 0)))
                ,tags$tr( tags$td(lbl$GAS)
                         ,tags$td(yuiSwitch(ns("swGas"),onLbl="%", offLbl="Value"))
                         ,tags$td(guiNumericInput(ns("impGas"),  NULL, value = 0)))
                ,tags$tr( tags$td(lbl$REASON)
                         ,tags$td(colspan="2", guiCombo(ns("cboReasons"))))
            )
        ))
        ,guiColumn(3
            ,fluidRow(h2(lbl$TARGET))
            ,fluidRow(tags$table(
                 tags$tr( tags$td(lbl$TARGET)
                         ,tags$td(yuiSwitch(ns("swTarget"),onLbl="%", offLbl="Value"))
                         ,tags$td(guiNumericInput(ns("target"), NULL, value = 5)))
                ,tags$tr( tags$td(lbl$DEADLINE)
                         ,tags$td(colspan=2, guiIntegerInput(ns("deadline"), NULL, value = 7)))
                ,tags$tr( tags$td(lbl$STOP)
                         ,tags$td(yuiSwitch(ns("swStop"),onLbl="%", offLbl="Value"))
                         ,tags$td(guiNumericInput(ns("stop"), NULL, value = 3)))
                ,tags$tr( tags$td(lbl$LIMIT)
                         ,tags$td(colspan=2, guiNumericInput(ns("limit"), NULL, value = 0)))
                ,tags$tr( tags$td(lbl$REVIEW)
                         ,tags$td(colspan=2, guiIntegerInput(ns("alert"), NULL, value = 3)))
            ))
        )
        ,guiColumn(3
            ,fluidRow(h2(lbl$SUMMARY))
            ,fluidRow(tags$table(
                 tags$tr(tags$td(lbl$AVAILABLE), tags$td(guiLabelNumber(ns("lblAvailable"))))
                ,tags$tr(tags$td(lbl$AMOUNT),    tags$td(guiLabelNumber(ns("lblAmount"))))
                ,tags$tr(tags$td(lbl$FEE),       tags$td(guiLabelNumber(ns("lblFee"))))
                ,tags$tr(tags$td(lbl$GAS),       tags$td(guiLabelNumber(ns("lblGas"))))
                ,tags$tr(tags$td(paste(lbl$TOTAL, lbl$FIAT)), tags$td(guiLabelNumber(ns("lblTotFiat"))))
                ,tags$tr(tags$td(paste(lbl$TOTAL, lbl$CTC)),  tags$td(guiLabelNumber(ns("lblTotCtc"))))
                ) # end table
           ) # end row
        ) #end column
     )
    ,fluidRow(guiColumn(2), guiColumn(4, h2(lbl$NOTES)))
    ,fluidRow(guiColumn(2), guiColumn(7, guiTextArea(ns("comment"), label=NULL, cols="200", rows="10")))
    ,fluidRow(guiColumn(2), guiColumn(6, yuiYesNo(id=ns("tpl"), lbl$PROCESS, lbl$CANCEL)))
  )
  list(left=NULL, main=main, right=NULL)
}
