modPltInput = function(id) {
   ns = NS(id)   
   main = tagList(
       fluidRow(column(6, yui2Plot(ns("plot11"))),column(6, yui2Plot(ns("plot12"))))
      ,fluidRow(column(6, yui2Plot(ns("plot21"))),column(6, yui2Plot(ns("plot22"))))
      )   
   list(left=NULL, main=main, right=NULL)   
}
