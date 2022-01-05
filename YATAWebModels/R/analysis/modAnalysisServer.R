modAnalysisServer <- function(id, full, pnlParent, parent=NULL) {
   ns = NS(id)
   ns2 = NS(full)
   PNLAnalysis = R6::R6Class("PNL.MODEL.ANALYSIS"
      ,inherit = YATAPanel
      ,cloneable  = FALSE
      ,lock_class = TRUE
      ,public = list(
           plot = NULL
          ,initialize    = function(session) {
             super$initialize(id, pnlParent, session, ns)
             self$plot = YATAPlot$new("plot", type="Marker")
          }
         ,init = function() {
            root = self$getRoot()
            self$data$df    = root$getData()
            self$data$model = root$getModel()
         }
         ,getData = function() { self$data$df }
    )
   )
    moduleServer(id, function(input, output, session) {
       pnl = YATAWEB$getPanel(full)
       if (is.null(pnl)) pnl = YATAWEB$addPanel(PNLAnalysis$new(session))


      if (!pnl$loaded) {
          pnl$init()
          df = pnl$getData()
          info = list(event=ns2("tableData"), target="Data")
          tblDef = list(info=info,df=df)
          pnl$plot$setData(df[,1:2], "data")
          output$tblData = updTable(tblDef)
          output$plot = updPlot(pnl$plot, ns("plot"))

      }
   })
}
