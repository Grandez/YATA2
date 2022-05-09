frmPortfolioChange = function(factory, failed = FALSE) {
    data    = factory$parms$getPortfolios()
    current = factory$parms$getLastPortfolio()
    values  = data$id

    names(values) = data$name

   modalDialog(
      title =  WEB$MSG$get("TITLE.PORTFOLIO_CHG")
     ,easyClose = TRUE
     ,size = "m"
     ,guiRadio("radDB", label=NULL, choices=values, selected=current, inline=FALSE)
     ,footer = tagList(
          modalButton ("Cancel") #, WEB$MSG$get("LABEL.BTN.KO")),
          ,actionButton("dbOK",     WEB$MSG$get("LABEL.BTN.CHANGE"))
        )
      )
}
