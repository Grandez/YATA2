modTestInput = function(id, title) {
    ns = NS(id)
    cbo = c("bloque 1"="block1","bloque 2"="block2","bloque 3"="block3","bloque 4"="block4","Bloque 5"="block5")
    left = tagList(    
          fluidRow(column(4, "linea1"),  column(8, yuiCombo(ns("cboBlk1"), choices=cbo, selected="block1")))
         ,fluidRow(column(4, "linea2"),  column(8, yuiCombo(ns("cboBlk2"), choices=cbo, selected="block3")))
         ,fluidRow(column(4, "linea3"),  column(8, yuiCombo(ns("cboBlk3"), choices=cbo, selected="block5")))
    )  
    main = tagList(fluidRow(id=ns("block_1")),fluidRow(id=ns("block_2")),fluidRow(id=ns("block_3"))
      ,hidden(tags$div(id=ns("blocks"),
         tags$div(id=ns("block1"), h2("Bloque 1"))
         ,tags$div(id=ns("block2"), h2("Bloque 2"))
        ,tags$div(id=ns("block3"), h2("Bloque 3"))
        ,tags$div(id=ns("block4"), h2("Bloque 4"))
        ,tags$div(id=ns("block5"), h2("Bloque 5"))
        ))
    )
    list(left=left, main=main, right=NULL)
}
