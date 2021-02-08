# Clase base para los paneles
YATAPanel = R6::R6Class("YATA.PANEL"
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,public = list(
     name       = NULL
    ,loaded     = FALSE
    ,valid      = FALSE
    ,parms      = NULL
    ,nextAction = NULL
    ,data       = list()  # Datos
    ,vars       = list()  # Variables temporales con memoria
    ,initialize = function(id, session) {
        self$name = id
        private$pnlDef$id = id
        if (!missing(session)) session$sendCustomMessage("setPanel", private$pnlDef)
        self$parms   = YATAFactory$getParms()
     }
    ,makeCombo = function(df) {
        data = as.list(df$id)
        names(data) = df$name
        data
     }
  )
  ,private = list(
      pnlDef = list(
         name="name"
         ,id=NULL
         ,leftSide=FALSE
         ,rightSide=FALSE
      )
  )
)
