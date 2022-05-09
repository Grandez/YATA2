# Core
library(utils)
library(R6)
library(tibble)
library(rlist)
library(stringr)
library(data.table)
library(YATABase)

suppressMessages(library(plyr,  warn.conflicts = FALSE))
suppressMessages(library(tidyr, warn.conflicts = FALSE))
suppressMessages(library(dplyr, warn.conflicts = FALSE))

# Shiny
suppressMessages(library(shiny,     warn.conflicts = FALSE))
suppressMessages(library(htmltools, warn.conflicts = FALSE))
suppressMessages(library(shinyjs,   warn.conflicts = FALSE))
suppressMessages(library(bslib,     warn.conflicts = FALSE))

rm("WEB")
onStart = function() {
      cat("Doing application setup\n")
}
onStop(function() {
  cat("Doing application cleanup\n")
})
