modOperPosInput = function(id, title) {
    ns = NS(id)
    tagList(
       yataBox(ns("opPending"),  "Pendiente", yataTable(ns("tblPending")))
      ,yataBox(ns("opAccepted"), "Aceptadas", yataTable(ns("tblAccepted")))
      ,yataBox(ns("opOpen"),     "Abiertas",  yataTable(ns("tblOpen")))
      # ,fluidRow(column(1)
      #     ,column(4, yataBtnOK(ns("btnPEPE"), "Guardar"), yataBtnKO(ns("btnKO"), "Cancelar"))
      #)

)}