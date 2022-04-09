frmChangeDB = function(factory, failed = FALSE) {
    data    = factory$parms$getDBData()
    current = factory$parms$lastOpen()

    labels = paste0(data$descr, " (", data$name, ")")
    values = data$subgroup
    names(values) = labels

   modalDialog(
      title =  WEB$MSG$get("TITLE.DB.CHANGE")
     ,easyClose = TRUE
     ,size = "m"
     ,guiRadio("radDB", label=NULL, choices=values, selected=current$id, inline=FALSE)
     ,footer = tagList(
          modalButton ("Cancel") #, WEB$MSG$get("LABEL.BTN.KO")),
          ,actionButton("dbOK",     WEB$MSG$get("LABEL.BTN.CHANGE"))
        )
      )
}
