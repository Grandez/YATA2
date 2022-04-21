frmErrorsevere = function(web) {

browser()
   modalDialog(
       fluidRow( column( 2, h3("Aqui el icono"))
                ,column(10, h3("Aqui los datos"))
        )
     ,title =  WEB$MSG$get("TITLE.ERR.SEVERE")
     ,easyClose = TRUE
     ,size = "xl"
#     ,guiRadio("radDB", label=NULL, choices=values, selected=current$id, inline=FALSE)
     ,footer = tagList(
          actionButton("dbOK",     WEB$MSG$get("LABEL.BTN.CHANGE"))
        )
      )
}
