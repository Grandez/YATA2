modAnaServer <- function(id, full, pnlParent, invalidate=FALSE) {
   ns = NS(id)
    moduleServer(id, function(input, output, session) {
        message("Ejecutando server para Analisis")
    })
}    
