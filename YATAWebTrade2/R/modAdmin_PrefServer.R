modAdminPrefServer = function(id, full, parent, session) {
   ns  = NS(id)
   ns2 = NS(full)
   PNLAdmPref = R6::R6Class("PNL.ADMIN.PREF"
        ,inherit    = WEBPanel
        ,cloneable  = FALSE
        ,lock_class = TRUE
        ,public = list(
        #     session      = NULL
        #    ,fiat = "$FIAT"
        #    ,initialize    = function(id, pnlParent, session) {
        #        super$initialize(id, pnlParent, session)
        #        self$session    = self$factory$getObject(self$codes$object$session)
        #        private$oper    = self$factory$getObject(self$codes$object$operation)
        #        private$pos     = self$factory$getObject(self$codes$object$position)
        #        # self$fiat       = pnlParent$factory$fiat
        #        private$initVars()
        #    }
        #    ,getPosition   = function(camera)    { private$pos$getCameraPosition(camera)         }
        #    ,operation     = function(data)      {
        #        tryCatch({
        #            private$oper$add(data$type, data)
        #        },error = function(cond) {
        #            yataErrGeneral(10, WEB$txtError, cond, input, output, session, web=WEB)
        #            0
        #        })
        #    }
        # # Inherit
        #   ,getCurrenciesBuy  = function()          { self$parent$getCurrenciesBuy() }
        #   ,getCurrenciesSell = function(currency)  { self$parent$getCurrenciesSell() }
        #   ,getCboCameras     = function (currency) { self$parent$getCboCameras(currency) }
        #
        )
       ,private = list(
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

})
}

