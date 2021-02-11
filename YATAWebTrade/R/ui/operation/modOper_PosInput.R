modOperPosInput = function(id, title) {
    ns = NS(id)
    tagList(
       yuiBox(ns("opPending"),  "Pendiente", yataTable(ns("tblPending")))
      ,yuiBox(ns("opAccepted"), "Aceptadas", yataTable(ns("tblAccepted")))
      ,yuiBox(ns("opOpen"),     "Abiertas",  yataTable(ns("tblOpen")))
      # ,fluidRow(column(1)
      #     ,column(4, yataBtnOK(ns("btnPEPE"), "Guardar"), yataBtnKO(ns("btnKO"), "Cancelar"))
      #)

)}