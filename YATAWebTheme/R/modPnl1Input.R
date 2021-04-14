modPnl1Input = function(id) {
   ns = NS(id)  
      blocks = c( "Bloque 1"="block1","Bloque 2"="block2","Bloque 3"="block3","Bloque 4"="block4"
                 ,"Bloque 5"="block5","Bloque 6"="block6","Bloque 7"="block7","Bloque 8"="block8"
                 ,"Hide" = "none")

   objLayout = OBJLayout$new(ns, c(2,2,2), blocks)
   left = tagList( objLayout$getConfig())
   
   blocks = tagList(fluidRow(id=ns("block1"), h2("Header 1"))
      ,fluidRow(id=ns("block1"), h2("Header 1"))
      ,fluidRow(id=ns("block2"), h2("Header 2"))
      ,fluidRow(id=ns("block3"), h2("Header 3"))
      ,fluidRow(id=ns("block4"), h2("Header 4"))
      ,fluidRow(id=ns("block5"), h2("Header 5"))
      ,fluidRow(id=ns("block6"), h2("Header 6"))
      ,fluidRow(id=ns("block7"), h2("Header 7"))
      ,fluidRow(id=ns("block8"), h2("Header 8"))
      
   )
#   main = tagList(makeLayout(), makeBlocks())
   main = tagList(h2("Panel"))
   list(left=left, main=objLayout$getBody(blocks), right=NULL)   
}

    # main = tagList(
    #    fluidRow(id=ns("block_1"), fluidRow(tags$div(id=ns("monitor"), class="yata_monitors")))
    #   ,fluidRow(id=ns("block_2")
    #      ,column(6, fluidRow(id=ns("block_2_1"),yuiPlot(ns("plot1"))))
    #      ,column(6, fluidRow(id=ns("block_2_2"),yuiPlot(ns("plot2"))))
    #   )
    #   ,fluidRow(id=ns("block_3")
    #      ,column(6, fluidRow(id=ns("block_3_1")))
    #      ,column(6, fluidRow(id=ns("block_3_2")))
    #   )
    #   #,hidden(tags$div(id=ns("blocks")#
    #   ,yuiBlocks(ns("blocks")
    #       ,yuiBox(ns("Best"), yuiLabelText(ns("lblBest")), yuiDataTable(ns("tblBest")))
    #       ,yuiBox(ns("Top"),  yuiLabelText(ns("lblTop")),  yuiDataTable(ns("tblTop")))
    #       ,yuiBox(ns("Fav"),  yuiLabelText(ns("lblFav")),  yuiDataTable(ns("tblFav")))
    #       ,tags$div(id=ns("Position"), style="width: 100%;"
    #                 ,yuiBox(ns("PosGlobal"), "Posicion Global", yuiDataTable(ns("tblPosGlobal")))
    #        )
    #    )
    #   #)
    # )
