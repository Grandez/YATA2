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
     ,fluidRow( yuiColumn(2)
              ,yuiColumn(1, h4(YATAWEB$MSG$get("LBL.OPER")))
              ,yuiColumn(1, yuiCombo( ns("cboOper"), choices=operTypes, selected=20))
                                           #,choices=c(YATAWEB$getMsg("TXT.BID") = 10, "Comprar"=2, "Vender"=3)
                                           #,selected=1))
              ,yuiColumn(1,h4(YATAWEB$MSG$get("LBL.CURRENCY")))
              ,yuiColumn(2,yuiComboSelect(ns("cboCurrency"),text="Counter"))

              ,yuiColumn(1, h4(YATAWEB$MSG$get("LBL.CAMERA")))
              ,yuiColumn(1, yuiCombo(ns("cboCamera"), choices=list(" ")))
              #,yuiColumn(1)
     )
    ,fluidRow(
         yuiColumn(2)
        ,yuiColumn(3
            ,fluidRow(h2("Base"))
            ,fluidRow(tags$table(
                 tags$tr( tags$td(YATAWEB$MSG$get("LBL.AMOUNT"))
                         ,tags$td(colspan="2", yuiNumericInput(ns("impAmount")))
                         ,tags$td(yuiBtnIconCalc(id=ns("btnCalcAmount"))))
                ,tags$tr( tags$td(YATAWEB$MSG$get("LBL.PRICE"))
                         ,tags$td(colspan="2", yuiNumericInput(ns("impPrice")))
                         ,tags$td(yuiBtnIconCalc(id=ns("btnCalcPrice"))))
                ,tags$tr( tags$td(YATAWEB$MSG$get("LBL.IMPORT"))
                         ,tags$td(colspan="2", yuiNumericInput(ns("impValue")))
                         ,tags$td(yuiBtnIconCalc(id=ns("btnCalcValue"))))
                ,tags$tr( tags$td(YATAWEB$MSG$get("LBL.FEE"))
                         ,tags$td(yuiSwitch(ns("swFee"),onLbl="%", offLbl="Value"))
                         ,tags$td(yuiNumericInput(ns("impFee"),  NULL, value = 0)))
                ,tags$tr( tags$td(YATAWEB$MSG$get("LBL.GAS"))
                         ,tags$td(yuiSwitch(ns("swGas"),onLbl="%", offLbl="Value"))
                         ,tags$td(yuiNumericInput(ns("impGas"),  NULL, value = 0)))
                ,tags$tr( tags$td(YATAWEB$MSG$get("LBL.REASON"))
                         ,tags$td(colspan="2", yuiCombo(ns("cboReasons"))))
            )
        ))
        ,yuiColumn(3
            ,fluidRow(h2("Control"))
            ,fluidRow(tags$table(
                 tags$tr( tags$td(YATAWEB$MSG$get("LBL.TARGET"))
                         ,tags$td(yuiSwitch(ns("swTarget"),onLbl="%", offLbl="Value"))
                         ,tags$td(yuiNumericInput(ns("target"), NULL, value = 5)))
                ,tags$tr( tags$td(YATAWEB$MSG$get("LBL.DEADLINE"))
                         ,tags$td(colspan=2, yuiIntegerInput(ns("deadline"), NULL, value = 7)))
                ,tags$tr( tags$td(YATAWEB$MSG$get("LBL.STOP"))
                         ,tags$td(yuiSwitch(ns("swStop"),onLbl="%", offLbl="Value"))
                         ,tags$td(yuiNumericInput(ns("stop"), NULL, value = 3)))
                ,tags$tr( tags$td(YATAWEB$MSG$get("LBL.LIMIT"))
                         ,tags$td(colspan=2, yuiNumericInput(ns("limit"), NULL, value = 0)))
                ,tags$tr( tags$td(YATAWEB$MSG$get("LBL.REVIEW"))
                         ,tags$td(colspan=2, yuiIntegerInput(ns("alert"), NULL, value = 3)))
            ))
        )
        ,yuiColumn(3
            , fluidRow(h2(YATAWEB$MSG$get("LBL.SUMMARY")))
            ,fluidRow(tags$table(
                 tags$tr(tags$td(YATAWEB$MSG$get("LBL.AVAILABLE")), tags$td(yuiLabelNumber(ns("lblAvailable"))))
                ,tags$tr(tags$td(YATAWEB$MSG$get("LBL.AMOUNT")),    tags$td(yuiLabelNumber(ns("lblAmount"))))
                ,tags$tr(tags$td(YATAWEB$MSG$get("LBL.FEE")),       tags$td(yuiLabelNumber(ns("lblFee"))))
                ,tags$tr(tags$td(YATAWEB$MSG$get("LBL.GAS")),       tags$td(yuiLabelNumber(ns("lblGas"))))
                ,tags$tr(tags$td("Total FIAT"),                     tags$td(yuiLabelNumber(ns("lblTotFiat"))))
                ,tags$tr(tags$td("Total Moneda"),                   tags$td(yuiLabelNumber(ns("lblTotCtc"))))
                )
           )

            )
     )  
    ,fluidRow(yuiColumn(2), yuiColumn(4, h2("Notas")))
    ,fluidRow(yuiColumn(2), yuiColumn(7, yuiTextArea(ns("comment"), label=NULL, cols="200", rows="20")))
    ,fluidRow(yuiColumn(2), yuiColumn(6, yuiYesNo(id=ns("tpl"), "Procesar", "Cancelar")))
  )
  list(left=NULL, main=main, right=NULL)
}


