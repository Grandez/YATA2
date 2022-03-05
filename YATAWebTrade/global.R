unloadNamespace("YATAWebCore")
unloadNamespace("YATACore")
unloadNamespace("YATADT")
unloadNamespace("YATAProviders")
unloadNamespace("YATADB")
unloadNamespace("YATAWebWidgets")
unloadNamespace("YATABase")

# Core
library(utils)
library(R6)
library(tibble)
library(rlist)
suppressMessages(library(plyr,  warn.conflicts = FALSE))
suppressMessages(library(tidyr, warn.conflicts = FALSE))
suppressMessages(library(dplyr, warn.conflicts = FALSE))

# YATA
suppressMessages(library(YATABase,      warn.conflicts = FALSE))
suppressMessages(library(YATACore,       warn.conflicts = FALSE))
suppressMessages(library(YATAWebCore,    warn.conflicts = FALSE))
suppressMessages(library(YATAWebWidgets, warn.conflicts = FALSE))
# suppressMessages(library(YATADT))

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
# library(data.table)

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
if (.Platform$OS.type != "windows") {
   future::plan(strategy="sequential")    
} else {
  future::plan(list(tweak(multisession, workers = availableCores() %/% 4),
                    tweak(multisession, workers = 4)))
}

