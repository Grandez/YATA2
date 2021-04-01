

modOperPosInput = function(id, title) {
    ns = NS(id)
    blocks = c("Plot" = "plotOpen", "Data"="data", "None"="none")
    left = tagList(
         fluidRow(column(4, "Up"),   column(8, yuiCombo(ns("cboUp"), choices=blocks, selected="plot")))
        ,fluidRow(column(4, "Down"), column(8, yuiCombo(ns("cboDown"), choices=blocks, selected="data")))
    )

    main = tagList(fluidRow(id=ns("block_1")), fluidRow(id=ns("block_2"))
                   #         ,fluidRow(yuiBox(ns("opOpen"),     "Abiertas",  yuiDataTable(ns("tblOpen"))))
                   # ,fluidRow( column(6, yuiBox(ns("opPending"),  "Pendiente", yuiDataTable(ns("tblPending"))))
                   #           ,column(6, yuiBox(ns("opAccepted"), "Aceptadas", yuiDataTable(ns("tblAccepted"))))
                   #  )
                   # 
#        )
      ,yuiBlocks(ns("blocks")
          ,tags$div(id=ns("data"), style="margin: auto;"
                   ,fluidRow(yuiBox(ns("opOpen"),     "Abiertas",  yuiDataTable(ns("tblOpen"))))
                   ,fluidRow( column(6, yuiBox(ns("opPending"),  "Pendiente", yuiDataTable(ns("tblPending"))))
                             ,column(6, yuiBox(ns("opAccepted"), "Aceptadas", yuiDataTable(ns("tblAccepted"))))
                    )
           )
          ,tags$div(id=ns("plot"), yuiPlot(ns("plotOpen")))
       )
     ,hidden(tags$div(id=ns("nodata"), h2("No hay operaciones pendientes")))
    )
    list(left=left, main=main, right=NULL)
}


