# Lo gestiona el modulo llamante
yataCloseModal = function() {
     removeModal()
}
yataModalYesNo = function(id, title, ...) {
   ns = NS(id)
   moduleServer(id, function(input, output, session) {
     showModal(modalDialog(title = title
               , footer = list(yataBtnOK(ns("OK"), "Aceptar"), yataBtnKO(ns("KO"), "Cancelar"))
         ,...
    ))
  })
}

yataModalForm = function(id, title, ...) {
   ns = NS(id)
   moduleServer(id, function(input, output, session) {
     showModal(modalDialog(title = title
               , footer = list(yataBtnOK(ns("OK"), "Aceptar"), yataBtnKO(ns("KO"), "Cancelar"))
         ,...
    ))
  })
}
