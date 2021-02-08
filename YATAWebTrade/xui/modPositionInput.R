modPositionInput = function(id) {
    ns = NS(id)
    tagList(
      fluidRow(
        h2("Cotizaciones de las posiciones abiertas")
        ,tags$span(id="sessionLastUpdate", textOutput(ns("lastUpdate")))
      )
      ,tags$div(id=ns("monitor"), class="yataMonitors row")
      ,tags$div(id="divPosGlobal"
               ,yataBox(ns("tblPosGlobal"), "Posicion Global", DT::dataTableOutput(ns("tblPosGlobal")))
      )
      ,tags$div(id="divPosLast")
    )}
