my_theme <- bs_theme(bootswatch = "default",
                     base_font = font_collection(font_google("Source Sans Pro"), 
    "-apple-system", "BlinkMacSystemFont", "Segoe UI", 
    font_google("Roboto"), "Helvetica Neue", "Arial", 
    "sans-serif", "Apple Color Emoji", "Segoe UI Emoji"), 
    font_scale = NULL
    )
JGGDashboardFull(title="Navbar!", id = "mainMenu", 
#bslib_page_navbar(title="Navbar!", id = "mainMenu", 
#bslib_page_navbar(


  tabPanel("Plot",
    sidebarLayout(
      sidebarPanel(
        radioButtons("plotType", "Plot type",
          c("Scatter"="p", "Line"="l")
        )
      ),
      mainPanel(
        plotOutput("plot")
      )
    )
  ),
  tabPanel("Summary",
    verbatimTextOutput("summary")
  ),
  navbarMenu("More",
    tabPanel("Table",
      DT::dataTableOutput("table")
    ),
    tabPanel("About",
      fluidRow(
        column(6,
          includeMarkdown("about.md")
        ),
        column(3,
          img(class="img-polaroid",
            src=paste0("http://upload.wikimedia.org/",
            "wikipedia/commons/9/92/",
            "1919_Ford_Model_T_Highboy_Coupe.jpg")),
          tags$small(
            "Source: Photographed at the Bay State Antique ",
            "Automobile Club's July 10, 2005 show at the ",
            "Endicott Estate in Dedham, MA by ",
            a(href="http://commons.wikimedia.org/wiki/User:Sfoskett",
              "User:Sfoskett")
          )
        )
      )
    )
  )
#, theme =  bs_theme(),lang = NULL
    #, theme = bslib::bs_theme(bootswatch="default") ,lang = NULL
    , titleActive = TRUE, theme =  my_theme,lang = NULL
)

