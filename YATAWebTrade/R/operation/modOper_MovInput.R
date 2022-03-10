modOperMovInput = function(id, title) {
  ns = YATANS(id)
  labels = c(
      YATAWEB$getMsg("TXT.BID")       
     ,YATAWEB$getMsg("TXT.ASK")       
     ,YATAWEB$getMsg("TXT.BUY")       
     ,YATAWEB$getMsg("TXT.SELL")      
     ,YATAWEB$getMsg("TXT.OPEN.POS")  
     ,YATAWEB$getMsg("TXT.CLOSE.POS") 
      
  )
  operTypes = list(10, 11, 20, 21, 30, 31)
  names(operTypes) = labels
  
  main = tagList(
      br()
     ,fluidRow( guiColumn(2)
              ,guiColumn(1, h4(YATAWEB$MSG$get("LBL.OPER")))
              ,guiColumn(1, guiCombo( ns("cboOper"), choices=operTypes, selected=20))
                                           #,choices=c(YATAWEB$getMsg("TXT.BID") = 10, "Comprar"=2, "Vender"=3)
                                           #,selected=1))
              ,guiColumn(1,h4(YATAWEB$MSG$get("LBL.CURRENCY")))
              ,guiColumn(2,guiComboSelect(ns("cboCurrency"),text="Counter"))

              ,guiColumn(1, h4(YATAWEB$MSG$get("LBL.CAMERA")))
              ,guiColumn(1, guiCombo(ns("cboCamera"), choices=list(" ")))
              #,guiColumn(1)
     )
    ,fluidRow(
         guiColumn(2)
        ,guiColumn(3
            ,fluidRow(h2("Base"))
            ,fluidRow(tags$table(
                 tags$tr( tags$td(YATAWEB$MSG$get("LBL.AMOUNT"))
                         ,tags$td(colspan="2", guiNumericInput(ns("impAmount")))
                         ,tags$td(yuiBtnIconCalc(id=ns("btnCalcAmount"))))
                ,tags$tr( tags$td(YATAWEB$MSG$get("LBL.PRICE"))
                         ,tags$td(colspan="2", guiNumericInput(ns("impPrice")))
                         ,tags$td(yuiBtnIconCalc(id=ns("btnCalcPrice"))))
                ,tags$tr( tags$td(YATAWEB$MSG$get("LBL.IMPORT"))
                         ,tags$td(colspan="2", guiNumericInput(ns("impValue")))
                         ,tags$td(yuiBtnIconCalc(id=ns("btnCalcValue"))))
                ,tags$tr( tags$td(YATAWEB$MSG$get("LBL.FEE"))
                         ,tags$td(yuiSwitch(ns("swFee"),onLbl="%", offLbl="Value"))
                         ,tags$td(guiNumericInput(ns("impFee"),  NULL, value = 0)))
                ,tags$tr( tags$td(YATAWEB$MSG$get("LBL.GAS"))
                         ,tags$td(yuiSwitch(ns("swGas"),onLbl="%", offLbl="Value"))
                         ,tags$td(guiNumericInput(ns("impGas"),  NULL, value = 0)))
                ,tags$tr( tags$td(YATAWEB$MSG$get("LBL.REASON"))
                         ,tags$td(colspan="2", guiCombo(ns("cboReasons"))))
            )
        ))
        ,guiColumn(3
            ,fluidRow(h2("Control"))
            ,fluidRow(tags$table(
                 tags$tr( tags$td(YATAWEB$MSG$get("LBL.TARGET"))
                         ,tags$td(yuiSwitch(ns("swTarget"),onLbl="%", offLbl="Value"))
                         ,tags$td(guiNumericInput(ns("target"), NULL, value = 5)))
                ,tags$tr( tags$td(YATAWEB$MSG$get("LBL.DEADLINE"))
                         ,tags$td(colspan=2, guiIntegerInput(ns("deadline"), NULL, value = 7)))
                ,tags$tr( tags$td(YATAWEB$MSG$get("LBL.STOP"))
                         ,tags$td(yuiSwitch(ns("swStop"),onLbl="%", offLbl="Value"))
                         ,tags$td(guiNumericInput(ns("stop"), NULL, value = 3)))
                ,tags$tr( tags$td(YATAWEB$MSG$get("LBL.LIMIT"))
                         ,tags$td(colspan=2, guiNumericInput(ns("limit"), NULL, value = 0)))
                ,tags$tr( tags$td(YATAWEB$MSG$get("LBL.REVIEW"))
                         ,tags$td(colspan=2, guiIntegerInput(ns("alert"), NULL, value = 3)))
            ))
        )
        ,guiColumn(3
            , fluidRow(h2(YATAWEB$MSG$get("LBL.SUMMARY")))
            ,fluidRow(tags$table(
                 tags$tr(tags$td(YATAWEB$MSG$get("LBL.AVAILABLE")), tags$td(guiLabelNumber(ns("lblAvailable"))))
                ,tags$tr(tags$td(YATAWEB$MSG$get("LBL.AMOUNT")),    tags$td(guiLabelNumber(ns("lblAmount"))))
                ,tags$tr(tags$td(YATAWEB$MSG$get("LBL.FEE")),       tags$td(guiLabelNumber(ns("lblFee"))))
                ,tags$tr(tags$td(YATAWEB$MSG$get("LBL.GAS")),       tags$td(guiLabelNumber(ns("lblGas"))))
                ,tags$tr(tags$td("Total FIAT"),                     tags$td(guiLabelNumber(ns("lblTotFiat"))))
                ,tags$tr(tags$td("Total Moneda"),                   tags$td(guiLabelNumber(ns("lblTotCtc"))))
                )
           )

            )
     )  
    ,fluidRow(guiColumn(2), guiColumn(4, h2("Notas")))
    ,fluidRow(guiColumn(2), guiColumn(7, guiTextArea(ns("comment"), label=NULL, cols="200", rows="10")))
    ,fluidRow(guiColumn(2), guiColumn(6, yuiYesNo(id=ns("tpl"), "Procesar", "Cancelar")))
  )
  list(left=NULL, main=main, right=NULL)
}


