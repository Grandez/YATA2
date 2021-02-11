modBarInput = function(id) {
   ns = NS(id)   
   main = tagList(
         fluidRow(h2("Lineas con un solo grafico"))
         ,fluidRow( column(4, plotlyOutput(ns("plotBar01")))
                   ,column(4, plotlyOutput(ns("plotBar02")))
                   ,column(4, plotlyOutput(ns("plotBar03")))
         )
         ,fluidRow(h2("Lineas con varios grafico"))
         ,fluidRow( column(4, plotlyOutput(ns("plotBar11")))
                   ,column(4, plotlyOutput(ns("plotBar12")))
                   ,column(4, plotlyOutput(ns("plotBar13")))
         )
      
      )   
   list(left=NULL, main=main, right=NULL)   
}
