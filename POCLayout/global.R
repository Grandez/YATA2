library(shiny)
#library(shinySignals)   # devtools::install_github("hadley/shinySignals")
library(dplyr)
#library(shinydashboard)
#library(bubbles)        # devtools::install_github("jcheng5/bubbles")
# source("bloomfilter.R")
library(reactable)
library(plotly)
library(stringr)

library(YATAWebShiny)
library(YATAWebCore)

files = list.files(path="R", pattern="\\.R$", recursive=TRUE, full.names=T, ignore.case=F)
sapply(files,source)

web = JGGWEBROOT$new()
assign("WEB", web, envir=.GlobalEnv)
