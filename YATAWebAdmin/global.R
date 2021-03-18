#-- if ("YATAModels" %in% (.packages()))    detach("package:YATAModels", unload=T, force=T)
# if ("YATADB"   %in% (.packages()))    detach("package:YATADB", unload=T, force=T)

unloadNamespace("YATAWebCore")
unloadNamespace("YATACore")
unloadNamespace("YATAProviders")
unloadNamespace("YATADB")
unloadNamespace("YATATools")

# Core
library(R6)
library(dplyr)
library(rlist)

# YATA
library(YATATools)
library(YATACore)
library(YATAWebCore)

# Shiny
library(shiny)
library(shinyjs)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets)

#library(DT)

options( warn = -1
#        ,DT.options = list(dom = "t", bPaginate = FALSE, rownames = FALSE, scrollX = F)
#        ,DT.options = list(dom = "t", rownames = FALSE, scrollX = F, style="",
#          language = list(url = 'http//cdn.datatables.net/plug-ins/1.10.22/i18n/Spanish.json'))
        ,java.parameters = "-Xmx2048m"
          ,shiny.reactlog=TRUE
          ,shiny.trace=TRUE
)

######################################
### Paneles
######################################

pnl = list(
   parms   = "parms"
  ,data   = "data"
  ,ctc    = "ctc"  
  ,prov   = "prov"
  ,camera = "camera"
)

######################################
### Carga de fuentes
######################################

files = list.files(path="R", pattern="\\.R$", recursive=TRUE, full.names=T, ignore.case=F)
sapply(files,source)

######################################
### Datos globales
######################################

YATACodes   = YATACore::YATACODES$new()
YATAFactory = YATACore::YATAFACTORY$new() # Va primero
YATAWEB     = YATAWebEnv$new()

