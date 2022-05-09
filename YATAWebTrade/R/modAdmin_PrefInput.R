modAdminPrefInput = function(id, title) {
  ns = YATANS(id)
  lbl = WEB$getLabelsAdmin()

  main = tagList(
      br()
    ,guiDivCenter(
            fluidRow(tags$table(
                 tags$tr( tags$td(lbl$AUTOOPEN)
                         ,tags$td(colspan="3",
                                   guiRadio(ns("radOpen"), choices=c(Ninguna=0,Ultima=1,defecto=2), inline=FALSE
                                            ,tooltip=WEB$tooltip("AUTOPEN")) ))
                ,tags$tr( tags$td(lbl$DEFAULT)
                         ,tags$td(colspan="3", guiListbox(ns("lstPortfolios"))))
                ,tags$tr( tags$td(lbl$LAYOUT)
                         ,tags$td(guiSwitch(ns("swCookies"),onLbl="Auto", offLbl="On Demand")))

                # ,tags$tr( tags$td(lbl$IMPORT)
                #          ,tags$td(colspan="3", guiNumericInput(ns("impValue")))
                #          ,tags$td(yuiBtnIconCalc(id=ns("btnCalcValue"))))
                # ,tags$tr( tags$td(lbl$FEE)
                #          ,tags$td(yuiSwitch(ns("swFee"),onLbl="%", offLbl="Value"))
                #          ,tags$td(guiNumericInput(ns("impFee"),  NULL, value = 0)))
                # ,tags$tr( tags$td(lbl$REASON)
                #          ,tags$td(colspan="2", guiCombo(ns("cboReasons"))))
            )
            ,guiYesNo(id=ns("prefs"))
       )
  ))
  list(left=NULL, main=main, right=NULL)
}
