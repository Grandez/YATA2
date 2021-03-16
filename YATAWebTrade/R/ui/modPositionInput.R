modPosInput = function(id, title) {
    ns = NS(id)
    left = tagList(
         yuiLabelDate(ns("dtLast"),"Last Update: ", inline=FALSE)
        ,yuiNumericInput(ns("numInterval"), label="Intervalo")
        ,hr()
        ,yuiNumericInput(ns("numDays"), label="Dias",value=15,step=1,min=7,max=60)
        ,hr()      
        ,yuiTitle4("Mejores")
        ,yuiFormTable(
             yuiFormRow("Top"     , yuiIntegerInput(ns("numBestTop"),value=10,step=1,min=5,max=30))
            ,yuiFormRow("Interval", yuiCombo(ns("cboBestFrom"), choices=c("Hora"=1,"Dia"=24,"Semana"=7,"Mes"=30),selected=24))
         )
        ,yuiFlex(yuiBtnOK(ns("btnTopOK"),"Aceptar"), yuiBtnKO(ns("btnTopKO"),"Anular"))
        ,hr()
        ,yuiCombo(ns("cboPlotLeft"),  "Left Plot" , choices="")
        ,yuiCombo(ns("cboPlotRight"), "Right Plot", choices="")
       
    )
    main = tagList(
       fluidRow(column(8, tags$div(id=ns("monitor"), class="yata-monitors")))
      ,fluidRow(column(6,yuiPlot(ns("plotLeft"))), column(6,yuiPlot(ns("plotRight"))))
      ,fluidRow(column(6
          ,fluidRow(id="divPosGlobal"
                   ,yuiBox(ns("tblPosGlobal"), "Posicion Global", DT::dataTableOutput(ns("tblPosGlobal")))
            )
          ,fluidRow(id="divPosLast")
         )
         ,column(6,yuiBox(ns("boxBest"), yuiLabelText(ns("lblBest")),DT::dataTableOutput(ns("tblBest"))))
      )
    )
    list(left=left, main=main, right=NULL)
}
