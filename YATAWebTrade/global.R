unloadNamespace("YATAWebCore")
unloadNamespace("YATACore")
unloadNamespace("YATADT")
unloadNamespace("YATAProviders")
unloadNamespace("YATADB")
unloadNamespace("YATATools")

# Core
library(utils)
library(R6)
library(tibble)
library(rlist)
library(plyr)
library(tidyr)
library(dplyr)

# YATA
suppressMessages(library(YATATools))
suppressMessages(library(YATACore))
suppressMessages(library(YATAWebCore))
suppressMessages(library(YATADT))

# Shiny
library(shiny)
library(shinyjs)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets)
library(bslib)
library(shinycookie)

# General
library(data.table)

# Plots
library(ggplot2)
library(gridExtra)
library(plotly)
library(RColorBrewer)

# Async
suppressMessages(library(jsonlite))
suppressMessages(library(promises))
suppressMessages(library(future))

options( warn = -1
        ,DT.options = list(dom = "t", bPaginate = FALSE, rownames = FALSE, escape=FALSE, scrollX = F)
        ,java.parameters = "-Xmx2048m"
          # ,shiny.reactlog=TRUE
          # ,shiny.trace=TRUE
)


plotly::config(plot_ly(), displaylogo = FALSE, collaborate = FALSE, displayModeBar = FALSE, responsive=TRUE)

######################################
### Carga de fuentes
### En R busca subdirectorios
#####################################

files = list.files(path="R", pattern="\\.R$", recursive=TRUE, full.names=T, ignore.case=F)
sapply(files,source)

YATAWEB = YATAWebEnv$new()

if (Sys.info()[["sysname"]] == "Windows") {
   future::plan(strategy="sequential")    
} else {
  future::plan(list(tweak(multisession, workers = availableCores() %/% 4),
                    tweak(multisession, workers = 4)))
}

panel = list(
     pos    = "pos"
    ,oper   = "oper"
    ,ana    = "ana"
    ,config = "config"
    ,log    = "log"
)
