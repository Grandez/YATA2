modOperPosInput = function(id, title) {
  browser()
    ns = NS(id)
    main = tagList(
       yuiBox(ns("opPending"),  "Pendiente", yuiDataTable(ns("tblPending")))
      ,yuiBox(ns("opAccepted"), "Aceptadas", yuiDataTable(ns("tblAccepted")))
      ,yuiBox(ns("opOpen"),     "Abiertas",  yuiDataTable(ns("tblOpen")))
      # ,fluidRow(column(1)
      #     ,column(4, yataBtnOK(ns("btnPEPE"), "Guardar"), yataBtnKO(ns("btnKO"), "Cancelar"))
      #)

    )
    list(left=NULL, main=main, right=NULL)
}