# Cada modulo lleva asociado un objeto
# es el que gestiona la creacion del objeto y guarda sus variables

modTestServer <- function(id, full, parent, session) {
   ns = NS(id)
   PNLTest = R6::R6Class("PNL.TEST"
      ,inherit = WEBPanel
      ,cloneable  = FALSE
      ,lock_class = TRUE
      ,public = list(
          initialize    = function(id, parent, session) {
             super$initialize(id, parent, session)
             private$definition$id = id
          }
      )
      ,private = list(
         definition = list(id = "",left = 0, right=0)
      )

   )
    moduleServer(id, function(input, output, session) {
      pnl = WEB$getPanel(PNLTest, id, NULL, session)

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
