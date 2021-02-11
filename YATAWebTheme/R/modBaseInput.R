modBaseInput = function(id) {
   ns = NS(id)   
   main = tagList(
         fluidRow(h2("En linea"))
         ,fluidRow("Etiquetas")
         ,fluidRow(
            column(2, yuiTextLabel(ns("lbl01"))), yuiBtnOK(ns("btnLbl01"), "actualiza")
         )
         ,fluidRow(
            column(2, yuiTextDate(ns("dt01"))), yuiBtnOK(ns("btnDt01"), "actualiza")
         )

      )   
   list(left=NULL, main=main, right=NULL)   
}
