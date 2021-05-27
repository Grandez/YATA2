

library(markdown)

navbarPage("Navbar!",
  tabPanel("Plot",
    sidebarLayout(
      sidebarPanel(
          numericInput("numPoints", label = h3("Puntos"), value = 100),
        radioButtons("plotType", "Plot type",
          c("Scatter"="p", "Line"="l")
        )
        ,actionButton("btnStart", "Inicio"), actionButton("btnNext", "Next")
      ),
      mainPanel( # fluidRow(column(6,plotOutput("plot1")), column(6,plotOutput("plot2")))
           fluidRow(column(6,plotOutput("plot1"), uiOutput('eq1'), textOutput('alpha1')), column(6,plotOutput("plot2"), textOutput('eq2'), uiOutput('alpha2')))
          ,fluidRow(column(6,plotOutput("plot3"), uiOutput('eq3'), textOutput('alpha3')), column(6,plotOutput("plot4"), textOutput('eq4'), uiOutput('alpha4')))
      )
    )
  ),
  tabPanel("Summary",
    verbatimTextOutput("summary")
  ),
  navbarMenu("More",
    tabPanel("Table",
      DT::dataTableOutput("table")
    )
    # tabPanel("About",
    #   fluidRow(
    #     column(3,
    #       img(class="img-polaroid",
    #         src=paste0("http://upload.wikimedia.org/",
    #         "wikipedia/commons/9/92/",
    #         "1919_Ford_Model_T_Highboy_Coupe.jpg")),
    #       tags$small(
    #         "Source: Photographed at the Bay State Antique ",
    #         "Automobile Club's July 10, 2005 show at the ",
    #         "Endicott Estate in Dedham, MA by ",
    #         a(href="http://commons.wikimedia.org/wiki/User:Sfoskett",
    #           "User:Sfoskett")
    #       )
    #     )
    #   )
    # )
  )
)

