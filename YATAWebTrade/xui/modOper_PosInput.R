modOperPosInput = function(id) {
    ns = NS(id)
    tagList(
       yataBox(ns("opPending"),  "Pendiente", DT::dataTableOutput(ns("tblPending")))
      ,yataBox(ns("opAccepted"), "Aceptadas", DT::dataTableOutput(ns("tblAccepted")))
      ,yataBox(ns("opOpen"),     "Abiertas",  DT::dataTableOutput(ns("tblOpen")))
         ,fluidRow(column(1)
       ,column(4, yataBtnOK(ns("btnOK"), "Guardar"), yataBtnKO(ns("btnKO"), "Cancelar"))
    )

)}