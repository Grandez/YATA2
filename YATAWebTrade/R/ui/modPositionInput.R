modPosInput = function(id, title) {
    ns = NS(id)
    left = tagList(
         yuiLabelDate(ns("dtLast"),"Last Update: ", inline=FALSE)
        ,yuiNumericInput(ns("numInterval"), label="Intervalo")
        ,yuiCombo(ns("cboPlotLeft"),  "Left Plot" , choices="")
        ,yuiCombo(ns("cboPlotRight"), "Right Plot", choices="")
       
    )
    main = tagList(
      # fluidRow(
      #   h2("Cotizaciones de las posiciones abiertas")
      #   ,tags$span(id="sessionLastUpdate", textOutput(ns("lastUpdate")))
      # )
      fluidRow(id=ns("monitor"), class="yataMonitors")
#      ,fluidRow(yuiBox(ns("tblPosGraph"), "Informacion"
         ,fluidRow(column(6,plotlyOutput(ns("plotLeft"))), column(6,plotlyOutput(ns("plotRight"))))
#       ))
      ,fluidRow(id="divPosGlobal"
               ,yuiBox(ns("tblPosGlobal"), "Posicion Global", DT::dataTableOutput(ns("tblPosGlobal")))
      )
      ,fluidRow(id="divPosLast")
    )
    list(left=left, main=main, right=NULL)
}
