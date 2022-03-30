modOperDetailInput = function(id, title="") {
    ns = NS(id)
    main = tagList(
        h3(textOutput(ns("title")))
        ,yuiBox(ns("boxData"),  "", tags$div(yuiPlot(ns("plot"))))
#        ,yuiPlot(ns("plot2"), height="200px")
        ,yuiBox(ns("boxData"),  "", tags$div(yuiTable(ns("session"))))
    )
    # main = tagList(h3(textOutput(ns("title")))
    #     ,yuiPlot(ns("plot"))
    #     # ,fluidRow(column(6,yuiTable(ns("session"))), column(6, yuiTable(ns("flows"))))
    #     ,yuiTable(ns("session"))
    # )
    list(left=NULL, main=main, right=NULL)
}
