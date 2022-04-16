modLblServer <- function(id, parent, session) {
ns = NS(id)
PNLLbl = R6::R6Class("PNL.JGG.LBL"
  ,inherit = JGGPanel
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,public = list(
 )
 ,private = list(
  )
 )

moduleServer(id, function(input, output, session) {
   cat("moduleCookie beg\n")
   cat("moduleCookie end\n")
})   # END MODULE

}    # END SOURCE
