modSvgInput = function(id) {
   ns = NS(id)   
   main = tagList(
       fluidRow(h2("Ficheros SVG"))
      ,fluidRow(tags$div(id=ns("svg")))
      )   
   list(left=NULL, main=main, right=NULL)   
}

    
   

