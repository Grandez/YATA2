# Base libraries (notprefixed)
library(stringr, warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)

# Shinylibraries
library(shiny, warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
library(bslib, warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)

# YATA Libraries
library(YATAWebShiny, warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
library(YATAWebCore, warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
library(YATAWebTrade, warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
browser()
appDir = system.file("app", package = "YATAWebTrade")
browser()
if (appDir == "") {
    stop("Could not find myapp. Try re-installing `mypackage`.", call. = FALSE)
}

shiny::runApp(appDir, display.mode = "normal")

