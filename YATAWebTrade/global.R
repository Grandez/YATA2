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
suppressMessages(library(plyr,  warn.conflicts = FALSE))
suppressMessages(library(tidyr, warn.conflicts = FALSE))
suppressMessages(library(dplyr, warn.conflicts = FALSE))

# YATA
suppressMessages(library(YATATools))
suppressMessages(library(YATACore))
suppressMessages(library(YATAWebCore, warn.conflicts = FALSE))
suppressMessages(library(YATADT))

# Shiny
library(shiny)
library(shinyjs)
suppressMessages(library(shinydashboard,     warn.conflicts = FALSE))
suppressMessages(library(shinydashboardPlus, warn.conflicts = FALSE))
suppressMessages(library(shinyWidgets,       warn.conflicts = FALSE))
library(bslib)
library(shinycookie)
library(shinybusy)

# General
library(data.table)

library(reactable)

# Plots
suppressMessages(library(ggplot2,   warn.conflicts = FALSE))
suppressMessages(library(gridExtra, warn.conflicts = FALSE))
suppressMessages(library(plotly,    warn.conflicts = FALSE))
#library(RColorBrewer)

# Async
suppressMessages(library(jsonlite, warn.conflicts = FALSE))
suppressMessages(library(promises, warn.conflicts = FALSE))
suppressMessages(library(future,   warn.conflicts = FALSE))

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
    ,hist   = "hist"
)
