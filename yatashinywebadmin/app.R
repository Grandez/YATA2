#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
unloadNamespace("YATAWebTrade")
library(shiny, warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
library(YATAWebTrade)

  appDir <- system.file("app", package = "YATAWebTrade")
  if (appDir == "") {
    stop("Could not find myapp. Try re-installing `mypackage`.", call. = FALSE)
  }
setwd(appDir)
  shiny::runApp(appDir, display.mode = "normal")

