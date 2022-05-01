JGGDashboard("DashBoard", id="dashboard"
    ,JGGTab("test", "Test", NULL, JGGModule("test"))
    ,JGGTab("test1", "Test1", NULL, JGGModule("test"))
    ,JGGTab("Dashboard", id="dash", NULL,  JGGModule("dash"))
, title="DashBoard"
    , cssFiles = "layout.css" #,jsFiles  = list(js="layout.js")
    ,lang="es"
    )

# YATAWebCore::YATAPage("YATA", id="mainMenu",titleActive = TRUE, theme = NULL,lang = NULL
# ,YATATab("Test", id="test",   YATAModule("test"))
# )
#cat(paste(Sys.time(), " - After YATAPage"), file="P:/R/YATA2/web.log", append=TRUE)


# YATAWebCore::YATAPage("DASHBOARD", id = "mainMenu", css = "layout.css",js  = "layout.js"
#     ,YATATab("Dashboard", id="dash",   YATAModule("dash"))
# )

# blocks= list(
#   items=list(
#       block01 = list(label = "Bloque 1")
#      ,block02 = list(label = "Bloque 2")
#      ,block03 = list(label = "Bloque 3")
#      ,block04 = list(label = "Bloque 4")
#   )
#  ,selected = c("lbl_block01","lblt_block02","lbl_block03","lbl_block04")
#  ,widgets = list(
#      tbl    = list(lblSuffix="Data", widget="reactableOutput" )
#     ,plot   = list(lblPreffix="Plot", widget="plotlyOutput" )
#     ,lbl    = list(lblPreffix="Label")
#   )
# )
# lay = JGGLayout$new("prueba", blocks)
# dashboardPage(
#   dashboardHeader(title = "cran.rstudio.com"),
#   dashboardSidebar(
# tags$head(
#     tags$link(rel = "stylesheet", type = "text/css", href = "layout.css")
#   ),
# tags$script(src = "layout.js"),
#
#     sliderInput("rateThreshold", "Warn when rate exceeds",
#       min = 0, max = 50, value = 3, step = 0.1
#     ),
#     sidebarMenu(
#       menuItem("Dashboard", tabName = "dashboard"),
#       menuItem("Raw data", tabName = "rawdata")
#       ,textOutput("nombre_lbl")
#      ,lay$config()
#      ,tags$br()
#     )
#   ),
#   dashboardBody(
#       tags$div(id="page", class="jgg_page"
#           ,tags$div(id="cuerpo", class="jgg_body"
#               # ,tags$div(class="jgg_layout_row", style="background-color: gray;", tags$h2("Fila 1"))
#               # ,tags$div(class="jgg_layout_row", style="background-color: aqua;", tags$h2("Fila 2"))
# #              ,tags$h1("Pagina")
# #      ,plotlyOutput("nombre_plot")
#
#               # , uiOutput("plot1")
#              ,lay$body()
#
#
#
#            )
#           ,tags$footer("pie")
#       )
#   )
# )
#
