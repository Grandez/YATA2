modSvgServer <- function(id, full, pnlParent, invalidate=FALSE) {
   ns = NS(id)
   moduleServer(id, function(input, output, session) {
    svgFiles = list.files("www/svg")
    lapply(svgFiles, function(svg)
         insertUI("#svg-svg",where="beforeEnd", ui=img(src=paste0('svg/', svg), width='48px',height='48px', alt=svg))
    )
      
  })
}    
