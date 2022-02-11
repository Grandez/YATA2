#-- if ("YATAModels" %in% (.packages()))    detach("package:YATAModels", unload=T, force=T)
# if ("YATADB"   %in% (.packages()))    detach("package:YATADB", unload=T, force=T)

# unloadNamespace("YATAWebCore")
# unloadNamespace("YATACore")
# unloadNamespace("YATADT")
# unloadNamespace("YATAProviders")
# unloadNamespace("YATADB")

# Core
#library(R6)
library(tibble)
library(rlist)
library(plyr)
library(tidyr)

# YATA
#library(YATATools)
#library(YATACore)
library(YATAWebCore)
#library(YATAWebWidgets)
#library(YATADT)

# Shiny
library(shiny)
library(shinyjs)
library(htmlwidgets)
# library(shinydashboard)
# library(shinydashboardPlus)
library(shinyWidgets)
library(bslib)

# General
#library(DT)

# Plots
library(ggplot2)
library(gridExtra)
library(plotly)
library(RColorBrewer)
library(reactable)
# options( warn = -1
#         ,DT.options = list(dom = "t", bPaginate = FALSE, rownames = FALSE, escape=FALSE, scrollX = F
#            ,autoWidth = TRUE)
#         ,java.parameters = "-Xmx2048m"
#           # ,shiny.reactlog=TRUE
#           # ,shiny.trace=TRUE
# )

#JGG No hace ni puto caso
# plotly::config(plot_ly(), displaylogo = FALSE, collaborate = FALSE
#                ,displayModeBar = FALSE, responsive=TRUE
#                ,locale="es")

######################################
### Carga de fuentes
### En R busca subdirectorios
#####################################

files = list.files(path="R", pattern="\\.R$", recursive=TRUE, full.names=T, ignore.case=F)
sapply(files,source)

YATACodes   = YATACore::YATACODES$new()
YATAFactory = YATACore::YATAFACTORY$new() # Va primero
YATAWEB     = YATAWebEnv$new()


# Esto va en el .onLoad
#registerInputHandler("sf_coord_point", convertToPoint)