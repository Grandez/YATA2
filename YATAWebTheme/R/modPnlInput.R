modPnlInput = function(id) {
  ns = NS(id)  
#   main = tagList(makeLayout(), makeBlocks())
   main = tagList(
     #YATATabPanel(ns("tab"))
     YATATabPanel(ns("tab"),YATATab("tab 1", "tab1"), YATATab("tab 2", "tab2"), YATATab("tab 3", "tab3"))
     ,textOutput(ns("salida"))
     ,actionButton(ns("add"), "crear")
     )
   list(left=NULL, main=main, right=NULL)   
}
