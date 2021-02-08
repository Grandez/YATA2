modOperBuyInput = function(id) {
    ns = NS(id)
    tagList(
       yataBox(ns("opPending"),  "Pendiente", DT::dataTableOutput(ns("tblPending")))
      ,yataBox(ns("opAccepted"), "Aceptadas", DT::dataTableOutput(ns("tblAccepted")))
      ,yataBox(ns("opOpen"),     "Abiertas",  DT::dataTableOutput(ns("tblOpen")))
)}