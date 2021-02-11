modOperSellInput = function(id, title) {
    ns = NS(id)
    tagList(
       yuiBox(ns("opPending"),  "Pendiente", DT::dataTableOutput(ns("tblPending")))
      ,yuiBox(ns("opAccepted"), "Aceptadas", DT::dataTableOutput(ns("tblAccepted")))
      ,yuiBox(ns("opOpen"),     "Abiertas",  DT::dataTableOutput(ns("tblOpen")))
)}