frmPortfolioChange = function(factory, failed = FALSE) {
    data    = factory$parms$getPortfolios()
    current = factory$parms$getLastPortfolio()
    values  = data$id

    names(values) = data$name

   modalDialog(
      title =  WEB$getMsg("TITLE.PORTFOLIO_CHG")
     ,easyClose = TRUE
     ,size = "m"
     ,guiRadio("radPortfolio", label=NULL, choices=values, selected=current, inline=FALSE)
     ,footer = tagList(
           modalButton (                      WEB$getMsg("LABEL.BTN.KO"))
          ,actionButton("btnChangePortfolio", WEB$getMsg("LABEL.BTN.CHANGE"))
        )
      )
}
