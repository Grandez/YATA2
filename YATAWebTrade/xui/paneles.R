panel1 = function(id) {
    ns = NS(id)

  tabPanel("Plot", value="pnl1",
    sidebarLayout(
      sidebarPanel(
        radioButtons(ns("plotType"), "Plot type",
          c("Scatter"="p", "Line"="l")
        )
      ),
      mainPanel(
        plotOutput(ns("plot"))
      )
    )
  )
    
}
panel2 = function(id) {
    ns = NS(id)

  tabPanel("Summary", value="pnl2",
    verbatimTextOutput(ns("summary"))
  )
}
panel3 = function(id) {
    ns = NS(id)
    tabPanel("Table", value="pnl3",
      DT::dataTableOutput(ns("table"))
    )
}
panel4 = function(id) {
    ns = NS(id)
    tabPanel("About", value="pnl4",
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
}

panel5 = function(id) {
    ns = NS(id)
    tabPanel("Widgets", value="pnl5",
         checkboxGroupButtons(
          inputId = ns("chkGroup"),
          label = "Choices", 
          choices = c("Choice 1", "Choice 2", "Choice 3"),
          status = "danger"
        ),
         hr(),
  fluidRow(column(3, verbatimTextOutput(ns("value"))))
    )
}
modPlotInput = function(id) {
    ns = NS(id)
    tagList(
    sidebarLayout(
      sidebarPanel(
        radioButtons(ns("plotType"), "Plot type",
          c("Scatter"="p", "Line"="l")
        )
      ),
      mainPanel(
        plotOutput(ns("plot"))
      )
      
    )
  )
    
}

modSummaryInput = function(id) {
    ns = NS(id)

  tabPanel("Summary", value="pnl2",
    verbatimTextOutput(ns("summary"))
  )
  
}

modWidgetsInput = function(id) {
    ns = NS(id)
    tabPanel("Widgets", value="pnl5",
         checkboxGroupButtons(
          inputId = ns("chkGroup"),
          label = "Choices", 
          choices = c("Choice 1", "Choice 2", "Choice 3"),
          status = "danger"
        ),
         hr(),
  fluidRow(column(3, verbatimTextOutput(ns("value"))))
    )  
}


modPanel1 = function(id) {
    ns = NS(id)

  tagList(
    sidebarLayout(
      sidebarPanel(
        radioButtons(ns("plotType"), "Plot type",
          c("Scatter"="p", "Line"="l")
        )
      ),
      mainPanel(
        plotOutput(ns("plot"))
      )
    )
  )
    
}
modPanel2 = function(id) {
    ns = NS(id)

  tagList(
    verbatimTextOutput(ns("summary"))
  )
}
modPanel3 = function(id) {
    ns = NS(id)
    tagList(
      DT::dataTableOutput(ns("table"))
    )
}
modPanel4 = function(id) {
    ns = NS(id)
    tagList(
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
}

modPanel5 = function(id) {
    ns = NS(id)
    tagList(
         checkboxGroupButtons(
          inputId = ns("chkGroup"),
          label = "Choices", 
          choices = c("Choice 1", "Choice 2", "Choice 3"),
          status = "danger"
        ),
         hr(),
  fluidRow(column(3, verbatimTextOutput(ns("value"))))
    )
}
