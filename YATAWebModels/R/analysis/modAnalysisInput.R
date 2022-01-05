modAnalysisInput = function(id, title) {
    ns = NS(id)
    main = tagList( h3("Analisis")
      ,fluidRow( column(3, h4("Datos")
                     ,fluidRow(yuiTable(ns("tblData")))
                 )
                ,column(9,h4("graficos")
                    ,fluidRow(yuiPlot(ns("plot")))
            ))
    )
    list(left=NULL, main=main, right=NULL)
}
