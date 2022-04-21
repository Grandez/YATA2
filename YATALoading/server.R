function(input, output, session) {

vars = reactiveValues(
    page = NULL
)
loadLibraries = function() {
   unloadNamespace("YATABatch")
   unloadNamespace("YATACore")
   # Core
   library(utils)
   library(R6)
   library(tibble)
   library(rlist)
   library(stringr)
   library(data.table)

   suppressMessages(library(plyr,  warn.conflicts = FALSE))
   suppressMessages(library(tidyr, warn.conflicts = FALSE))
   suppressMessages(library(dplyr, warn.conflicts = FALSE))

suppressMessages(library(plotly, warn.conflicts = FALSE))
suppressMessages(library(reactable, warn.conflicts = FALSE))

   # YATA
   suppressMessages(library(YATABase,       warn.conflicts = FALSE))
   suppressMessages(library(YATACore,       warn.conflicts = FALSE))
   suppressMessages(library(YATAWebCore,    warn.conflicts = FALSE))

      #
# # Async
# # #suppressMessages(library(jsonlite, warn.conflicts = FALSE))
# suppressMessages(library(promises, warn.conflicts = FALSE))
# suppressMessages(library(future,   warn.conflicts = FALSE))
   FALSE
}
checkDaemons = function() {
   FALSE
}
createVariables = function() {
    YATA = rlang::env()
    factory = YATAFACTORY$new()
    web     = YATAWebEnv$new(factory)
    assign("WEB", web, envir = rlang::env_parent(), inherits=TRUE)
   FALSE
}

loadSources = function() {
    browser()
files = list.files(path="R", pattern="\\.R$", recursive=TRUE, full.names=T, ignore.case=F)
sapply(files,source)

   FALSE
}
createPage = function() {
browser()
lbl = WEB$getLabelsMenuMain()

#JGGDashboardFull(title="YATA", id = "mainMenu"
#cat(paste(Sys.time(), " - Before YATAPage"), file="P:/R/YATA2/web.log", append=TRUE)
pp = YATAWebShiny::JGGDashboardRaw("YATA", id="mainMenu",titleActive = TRUE, theme =  my_theme,lang = NULL
#  ,YATATabPanel(lbl$POSITION,  value="pos",    YATAModule("pos")    )
    ,YATATab(lbl$ADMIN,    id="admin", YATAModule("admin") )
   ,YATATab(lbl$OPERATION, id="oper",   YATAModule("oper"))
  # ,YATATabPanel(lbl$HISTORY,   value="hist",   YATAModule("hist")   )
  # ,YATATabPanel(lbl$ANALYSIS,  value="ana",    YATAModule("ana")    )
  # ,YATATabPanel(lbl$LOG,       value="log",    YATAModule("log")    )
  # ,YATATabPanel(lbl$ADMIN,     value="admin",  YATAModule("admin")  )
  # ,YATATabPanel(lbl$STATUS,    value="status", YATAModule("status") )

)
vars$page = pp

#cat(paste(Sys.time(), " - After YATAPage"), file="P:/R/YATA2/web.log", append=TRUE)
    FALSE
}

switchPage = function() {
   insertUI("#jgg_container",where = "beforeEnd", vars$page, multiple=TRUE, immediate=TRUE)
   removeUI("#jgg_page_loader", immediate = TRUE)
   FALSE
}
loadProcess = function(block, session) {
    res = FALSE
    shinyjs::show(id=paste0("block", block), time=0)
    if (block == 0) res = loadLibraries()
    if (block == 1) res = checkDaemons()
    if (block == 2) res = createVariables()
    if (block == 3) res = loadSources()
    if (block == 4) res = createPage()
    if (block == 5) res = switchPage()
    if (res) {
        shinyjs::show(id=paste0("block", block, "KO"))
        updateNumericInput(session, "block", value = 5)
    } else {
        shinyjs::show(id=paste0("block", block, "OK"))
    }
#    shinyjs::refresh()
}

observeEvent(input$block, {
#   if (input$block > 3) return()
   future_promise({ eval(parse(text=paste0("loadProcess(", input$block, ",session)"))) }) %...>% {
                    updateNumericInput(session, "block", value = (input$block + 1))
                  }})
output$appTitle = renderText({ "YATA" })
}
