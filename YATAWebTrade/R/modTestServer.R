# Cada modulo lleva asociado un objeto
# es el que gestiona la creacion del objeto y guarda sus variables

modTestServer <- function(id, full, pnlParent, parent=NULL) {
   ns = NS(id)
   PNLTest = R6::R6Class("PNL.TEST"
      ,inherit = YATAPanel
      ,cloneable  = FALSE
      ,lock_class = TRUE
      ,public = list(
          initialize    = function(id, pnlParent, session) {
             super$initialize(id, pnlParent, session)
             private$definition$id = id
          }
      )   
      ,private = list(
         definition = list(id = "",left = 0, right=0)
      )
      
   )
    moduleServer(id, function(input, output, session) {
       message("Ejecutando server para Test")
      pnl = YATAWEB$getPanel(id)
      if (is.null(pnl)) pnl = YATAWEB$addPanel(PNLTest$new(id, pnlParent, session))

      observeEvent(input$cboBlk1, {
         session$sendCustomMessage('yataShowBlock',list(ns=id,row=1,col=0,block=input$cboBlk1))
      })
      observeEvent(input$cboBlk2, {
          session$sendCustomMessage('yataShowBlock',list(ns=id,row=2,col=0,block=input$cboBlk2))
      })
      observeEvent(input$cboBlk3, {
          session$sendCustomMessage('yataShowBlock',list(ns=id,row=3,col=0,block=input$cboBlk3))
      })
      
  })
}    
