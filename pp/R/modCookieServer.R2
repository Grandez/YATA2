modCookieServer <- function(id, parent, session) {
ns = NS(id)
PNLCookie = R6::R6Class("PNL.WEB.COOKIE"
  ,inherit = WEBPanel
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,public = list(
      initialize = function(id, parent, session) {
         super$initialize(id, parent, session)
      }
 )
 ,private = list(
  )
 )

moduleServer(id, function(input, output, session) {
   cat("moduleCookie beg\n")
    pnl = WEB$getPanel(PNLCookie, id, NULL, session)
    if (is.null(pnl)) pnl = WEB$addPanel(PNLCookie$new(id, NULL, session))

    output$cookies = renderPrint({
        lst = WEB$getCookies()
    print(lst)
  })
   cat("moduleCookie end\n")
})   # END MODULE

}    # END SOURCE
