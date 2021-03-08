#-- if ("YATAModels" %in% (.packages()))    detach("package:YATAModels", unload=T, force=T)
# if ("YATADB"   %in% (.packages()))    detach("package:YATADB", unload=T, force=T)

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
library(YATATools)
library(YATACore)
library(YATAWebCore)
library(YATADT)

# Shiny
library(shiny)
library(shinyjs)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets)
library(bslib)

# General
library(data.table)

# Plots
library(ggplot2)
library(gridExtra)
library(plotly)
library(RColorBrewer)

# Async
library(jsonlite)
library(promises)
library(future)

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

YATACodes   = YATACore::YATACODES$new()
YATAFactory = YATACore::YATAFACTORY$new() # Va primero

#YATAFactory$env = YATACore::YATAENV$new()
YATAWEB = YATAWebEnv$new()

# Esto va en el .onLoad
#registerInputHandler("sf_coord_point", convertToPoint)

future::plan(future::multisession(workers = 4))
