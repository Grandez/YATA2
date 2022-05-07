modAdminPrefServer = function(id, full, parent, session) {
   ns  = NS(id)
   ns2 = NS(full)
   PNLAdmPref = R6::R6Class("PNL.ADMIN.PREF"
        ,inherit    = WEBPanel
        ,cloneable  = FALSE
        ,lock_class = TRUE
        ,public = list(
            portfolios = NULL
           ,preferences = NULL
           ,initialize    = function(id, parent, session) {
               super$initialize(id, parent, session)
               private$parms = WEB$factory$parms
               self$update()
           }
          ,update = function(prefs) {
              if (!missing(prefs)) private$parms$setPreferences(prefs)
               self$portfolios = WEB$combo$portfolios()
               self$preferences = private$parms$getPreferences()
          }
        )
       ,private = list(
           parms = NULL
          #  oper = NULL
          # ,pos  = NULL
          # ,initVars = function() {
          #     # Sirve de memoria
          #     self$vars$price = 0
          #     self$vars$cboOper  = 0
          # }
        )
   )


moduleServer(id, function(input, output, session) {
   pnl = WEB$root$getPanel(PNLAdmPref, id, parent, session)

   updRadio("radOpen", selected=pnl$preferences$autoOpen)
   updListbox("lstPortfolios", choices=pnl$portfolios, selected=pnl$preferences$default)
   updSwitch("swCookies", value=pnl$preferences$cookies)

   observeEvent(input$btnOK, {
       browser()
       prefs = pnl$preferences
       prefs$autoOpen = input$radOpen
       prefs$default  = input$lstPortfolios
       prefs$cookies  = input$swCookies
       pnl$update(prefs)
   })
   observeEvent(input$btnKO, {
       updRadio("radOpen", selected=pnl$autoOpen)
       updListbox("lstPortfolios", choices=pnl$portfolios, selected=pnl$default)
       updSwitch("swCookies", value=pnl$preferences$cookies)
   })

})
}

