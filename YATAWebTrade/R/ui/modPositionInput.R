modPosInput = function(id, title) {
    ns = NS(id)
    left = tagList(
         yuiLabelDate(ns("dtLast"),"Last Update: ", inline=FALSE)
        ,yuiNumericInput(ns("numInterval"), label="Intervalo")
        ,yuiCombo(ns("cboPlotLeft"),  "Left Plot" , choices="")
        ,yuiCombo(ns("cboPlotRight"), "Right Plot", choices="")
       
    )
    main = tagList(
       fluidRow(column(8, tags$div(id=ns("monitor"), class="yata-monitors")), column(3, blkRank(ns("rank"), n=5)))
      ,fluidRow(column(6,yuiPlot(ns("plotLeft"))), column(6,yuiPlot(ns("plotRight"))))
      ,fluidRow(column(8
      ,fluidRow(id="divPosGlobal"
                   ,yuiBox(ns("tblPosGlobal"), "Posicion Global", DT::dataTableOutput(ns("tblPosGlobal")))
         )
          ,fluidRow(id="divPosLast")
         )
      ))
    list(left=left, main=main, right=NULL)
}
