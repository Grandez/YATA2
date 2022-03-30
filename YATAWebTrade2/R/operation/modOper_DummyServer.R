# Trick
# Tenemos una pestaña vacia. Cuando mandamos la seleccion de operacion
# se fuerza a pasar por aqui para forzar el cambio de pestaña
#
modOperDummyServer = function(id, full, pnl, parent) {
   ns = NS(id)
   moduleServer(id, function(input, output, session) {
      carea = pnl$getCommarea()
      if (!is.null(carea$action)) {
         if (carea$action == "buy" || carea$action == "buy") 
             updateTabsetPanel(parent, "pnlOpType", selected="oper-oper")
      }
    })
}

