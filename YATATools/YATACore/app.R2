library(shiny)
library(shinyWidgets)
library(shinydashboard)
library(shinydashboardPlus)

shinyApp(
    ui = dashboardPagePlus(
        header = dashboardHeaderPlus(
            fixed = TRUE,
            enable_rightsidebar = TRUE,
            rightSidebarIcon = "gears",
            left_menu = tagList(
                tabsetPanel(
                    tabPanel("Plot", plotOutput("plot")),
                    tabPanel("Summary", verbatimTextOutput("summary")),
                    tabPanel("Table", tableOutput("table"))
                )            ),
            dropdownMenu(
                type = "tasks",
                badgeStatus = "danger",
                taskItem(value = 20, color = "aqua", "Refactor code"),
                taskItem(value = 40, color = "green", "Design new layout"),
                taskItem(value = 60, color = "yellow", "Another task"),
                taskItem(value = 80, color = "red", "Write documentation")
            )
        ),
        sidebar = dashboardSidebar(),
        body = dashboardBody(
            setShadow(class = "dropdown-menu")
        ),
        rightsidebar = rightSidebar(),
        title = "DashboardPage"
    ),
    server = function(input, output) { }
)
