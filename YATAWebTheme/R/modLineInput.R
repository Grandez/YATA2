modLineInput = function(id) {
   ns = NS(id)   
   main = tagList(
         fluidRow(h2("Lineas con un solo grafico"))
         ,fluidRow( column(4, plotlyOutput(ns("plotLine01")))
                   ,column(4, plotlyOutput(ns("plotLine02")))
                   ,column(4, plotlyOutput(ns("plotLine03")))
         )
         ,fluidRow(h2("Lineas con varios grafico"))
         ,fluidRow( column(4, plotlyOutput(ns("plotLine11")))
                   ,column(4, plotlyOutput(ns("plotLine12")))
                   ,column(4, plotlyOutput(ns("plotLine13")))
         )
      
      )   
   list(left=NULL, main=main, right=NULL)   
}
