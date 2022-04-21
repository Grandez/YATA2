modAnaServer <- function(id, full, pnlParent, parent=NULL) {
   ns = NS(id)
    moduleServer(id, function(input, output, session) {
        message("Ejecutando server para Analisis")
    })
}    
