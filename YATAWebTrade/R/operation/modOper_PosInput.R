modOperPosInput = function(id, title) {
    ns = NS(id)
    main = tagList(
       tags$div(id=ns("data")
          ,tags$div(column(7, yuiBox(ns("opOpen"),     "Abiertas",  yuiDataTable(ns("tblOpen")))))           
          ,tags$div( column(6,yuiBox(ns("opPending"),  "Pendiente", yuiDataTable(ns("tblPending"))))
                    ,column(6,yuiBox(ns("opAccepted"), "Aceptadas", yuiDataTable(ns("tblAccepted")))))

        )
       ,hidden(tags$div(id=ns("nodata"), h2("No hay operaciones pendientes")))
    )
    list(left=NULL, main=main, right=NULL)
}