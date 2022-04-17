modNoleftServer <- function(id, parent, session) {
ns = NS(id)
PNLPos = R6::R6Class("PNL.JGG.LBL"
  ,inherit = JGGPanel
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,public = list(
 )
 ,private = list(
  )
 )

moduleServer(id, function(input, output, session) {
   cat("moduleServer beg\n")
   cat("moduleserver end\n")
})   # END MODULE

}    # END SOURCE
