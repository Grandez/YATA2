modLogServer <- function(id, full, pnlParent, invalidate=FALSE, parent=NULL) {
   ns = NS(id)
    moduleServer(id, function(input, output, session) {
        message("Ejecutando server para Log")
    })
}    
