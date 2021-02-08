modPositionInput = function(id, title) {
    ns = NS(id)
    left = tagList(
         yataTextDate(ns("dtLast"),"Last Update: ", inline=FALSE)
        ,yataNumericInput(ns("numInterval"), label="Intervalo")
        ,yataCombo(ns("cboPlotLeft"),  "Left Plot" , choices="")
        ,yataCombo(ns("cboPlotRight"), "Right Plot", choices="")
       
    )
    main = tagList(
      # fluidRow(
      #   h2("Cotizaciones de las posiciones abiertas")
      #   ,tags$span(id="sessionLastUpdate", textOutput(ns("lastUpdate")))
      # )
      fluidRow(id=ns("monitor"), class="yataMonitors")
#      ,fluidRow(yataBox(ns("tblPosGraph"), "Informacion"
         ,fluidRow(column(6,plotlyOutput(ns("plotLeft"))), column(6,plotlyOutput(ns("plotRight"))))
#       ))
      ,fluidRow(id="divPosGlobal"
               ,yataBox(ns("tblPosGlobal"), "Posicion Global", DT::dataTableOutput(ns("tblPosGlobal")))
      )
      ,fluidRow(id="divPosLast")
    )
    list(left=left, main=main, right=NULL)
}
