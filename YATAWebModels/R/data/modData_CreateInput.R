modDatCreateInput = function(id, title) {
    ns = NS(id)
    main = tagList(h4("submenu")
        ,fluidRow(yuiBtnOK(ns("btnDone1"), "Done"), tags$span(style="float:right"), yuiBtnOK(ns("btnDone2"), "Done"))
        ,fluidRow(column(2, "Type"),column(3, yuiCombo(ns("cboMethod"), choices=list(" "))))
        # ,fluidRow(tags$table(
        #           tags$tr(tags$td("Orden"),   tags$td(yuiNumericInput(ns("row"), NULL, value =   1))
        #                   ,tags$td("Valor"),   tags$td(yuiNumericInput(ns("value"), NULL, value = 100))
        #                   ,tags$td(actionButton(ns("btnOK"), label="INsertar"))
        #                   )
        #  ))
        ,tags$table(
                  tags$tr( tags$td("Orden"), tags$td(yuiIntegerInput(ns("row"),   NULL, value =   1))
                          ,tags$td("Items"), tags$td(yuiIntegerInput(ns("times"), NULL, value =   1))
                          ,tags$td("Valor"), tags$td(yuiNumericInput(ns("value"), NULL, value = 100))
                          ,tags$td(yuiBtnMain(ns("btnValue"), label="Value"))
                          ,tags$td(yuiBtnWarning(ns("btnPrc"),   label="Percentage"))
                          )
        )
        ,fluidRow(
             column(6, yuiTable(ns("tblData")))
            ,column(6, yuiPlot(ns("plot")))
         )
    )
    list(left=NULL, main=main, right=NULL)
}

