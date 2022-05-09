modAdminExchInput = function(id, title) {
  ns = YATANS(id)
  lbl = WEB$getLabelsAdmin()

  main = tagList(
      br()
    ,guiDivCenter(fluidRow(
         column(4, guiListbox(ns("lstExchanges"), size = 25)
             ,actionButton(ns("btn_add"), "Pasar")
             )
        ,column(1)
        ,column(4, reactableOutput(ns("tbl_cameras")))
    ))

  )
  list(left=NULL, main=main, right=NULL)
}
