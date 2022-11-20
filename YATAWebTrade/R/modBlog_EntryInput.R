modBlogEntryInput = function(id, title = "") {
   ns = NS(id)
   lbl = WEB$getLabelsPanel()

   main = tagList(
       br()
     ,fluidRow(h4(lbl$APPLY), guiCombo(ns("cboType"), choices=WEB$combo$blog()))
     ,fluidRow(h4("Titulo"), guiTextInput(ns("txtTitle")))
     ,fluidRow( guiColumn(1)
              ,guiColumn(5, guiTextArea(ns("txtNote"), label=NULL, cols="200", rows="10"))
              ,guiColumn(1)
              ,guiColumn(5, uiOutput(ns("mdNote")))
     )
    ,fluidRow(guiColumn(2), guiColumn(4, guiLabelText(id=ns("msg"))))
       ,fluidRow(guiColumn(2), guiColumn(4,yuiBtnOK(ns("btnOK"), "Procesar")
                                          ,yuiBtnKO(ns("btnKO"), "Cancelar")))
  )
  list(left=NULL, main=main, right=NULL)
}
