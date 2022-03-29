#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Base libraries (notprefixed)
library(stringr, warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)

# Shinylibraries
library(shiny, warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
library(bslib, warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)

# YATA Libraries
library(YATAWebShiny, warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
library(YATAWebCore, warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
library(YATAWebTrade, warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)

  appDir <- system.file("app", package = "YATAWebTrade")
  if (appDir == "") {
    stop("Could not find myapp. Try re-installing `mypackage`.", call. = FALSE)
  }
#setwd(appDir)
  shiny::runApp(appDir, display.mode = "normal")

