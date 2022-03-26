modAdminInput = function(id, title) {
    ns = NS(id)
    cbo = c("bloque 1"="block1","bloque 2"="block2","bloque 3"="block3","bloque 4"="block4","Bloque 5"="block5")
    left = tagList(    
          fluidRow(column(4, "linea1"),  column(8, guiCombo(ns("cboBlk1"), choices=cbo, selected="block1")))
         ,fluidRow(column(4, "linea2"),  column(8, guiCombo(ns("cboBlk2"), choices=cbo, selected="block3")))
         ,fluidRow(column(4, "linea3"),  column(8, guiCombo(ns("cboBlk3"), choices=cbo, selected="block5")))
    )  
    main = tagList(tags$h1("Pendiente de hacer"))
    
    list(left=NULL, main=main, right=NULL)
}
