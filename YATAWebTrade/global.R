#-- if ("YATAModels" %in% (.packages()))    detach("package:YATAModels", unload=T, force=T)
# if ("YATADB"   %in% (.packages()))    detach("package:YATADB", unload=T, force=T)

unloadNamespace("YATAWebCore")
unloadNamespace("YATACore")
unloadNamespace("YATADT")
unloadNamespace("YATAProviders")
unloadNamespace("YATADB")
unloadNamespace("YATATools")

# Core
library(R6)
library(tibble)
library(rlist)
library(plyr)
library(tidyr)

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
#library(DT)

# Plots
library(ggplot2)
library(gridExtra)
library(plotly)
library(RColorBrewer)

# Shiny
#library(YATAWebCore)
# library(shiny)
# library(shinyjs)
# library(shinyBS)
# library(shinythemes)
# # library(shinydashboard)
# library(shinydashboardPlus)
# library(shinyWidgets)
# # library(shinyjqui)
# # library(V8)
#
# library(htmltools)
# library(htmlwidgets)
#
# # General
# library(dplyr)
# library(data.table)
# library(stringr)
# library(rlist)
# library(R6)
# library(readr)
# library(knitr)
# library(abind)
#
# # Plots
# library(ggplot2)
# library(gridExtra)
# library(plotly)
# library(RColorBrewer)
#
# # Quant
# library(lubridate)
# library(zoo)
#
# # YATA
# #-- library(YATAModels)
# #-- library(YATACore)
#
# # shhh(library(XLConnect,quietly = T))
#
# # shhh(library(knitr    ,quietly = T))
# # shhh(library(chron    ,quietly = T))
#
#

#
#
# library(markdown)

# shhh(library(readr    ,quietly = T))
# shhh(library(gsubfn   ,quietly = T))

#require(YATAModels)
#require(YATAProviders)
#--require(YATACore)

# rm(list=ls())
# .globals <- new.env(parent = emptyenv())
# 
options( warn = -1
        ,DT.options = list(dom = "t", bPaginate = FALSE, rownames = FALSE, escape=FALSE, scrollX = F)
        ,java.parameters = "-Xmx2048m"
          # ,shiny.reactlog=TRUE
          # ,shiny.trace=TRUE
)


#plotly::config(plot_ly(), displaylogo = FALSE, collaborate = FALSE, displayModeBar = FALSE, responsive=TRUE)

# files.widgets = list.files("widgets", pattern="*\\.R$", full.names=TRUE, ignore.case=F)
# sapply(files.widgets,source)
# 
# # Codigo auxiiar
# files.r = list.files("R", pattern="*\\.R$", full.names=TRUE, ignore.case=F)
# sapply(files.r, source)
# 
# # Modulos de interfaz UI
# files.sources = list.files("ui", pattern="*\\.R$", full.names=TRUE, ignore.case=F)
# sapply(files.sources,source)

# source("locale/messages_ES.R", local=T)

# Datos globales
# SQLConn <<- NULL
# Create YATAENV as Global

# tryCatch({
#   #-- YATACore::createEnvironment()
#   #-- YATAENV$dataSourceDBName = "CTC"
# }
# , YATAError = function(cond) {
#   browser()
#     stop("Error en la web")
#   #-- stop(YATAError(getLocaleMessage(ERR_NO_CONNECT)))
#   #        browser()
#   #        coreVars$lastErr = getLocaleMessage(ERR_NO_CONNECT)
#   NULL
# })

# YATAENV$dataSourceDBType = IO_SQL
# YATAENV$modelsDBType     = IO_SQL

# case         = YATACore::YATACase$new()
# case$profile = YATACore::TBLProfile$new()

#JGG addResourcePath("man", "d:/R/YATA/YATAManualUser")


######################################
### Paneles
######################################

pnl = list(
   pos    = "pos"
  ,oper   = "oper"  
  ,config = "config"
)

######################################
### Factores globales
######################################

#-- PLOT = YATACore::FACT_PLOT$new()


# onStop(function() {
#   cat("Doing application cleanup\n")
#   #cleanEnvironment()
# })

# onSessionEnded(function() {
#   #called after the client has disconnected.
#   cat("Doing application cleanup\n")
# })

########################################################
### Temporal
### Carga las fuentes en lugar de los paquetes
########################################################

# # YATADB
# files = list.files("../YATADB/R", pattern="*\\.R$", full.names=TRUE, ignore.case=F)
# sapply(files,source)
# 
# # YATAWebCore
# files = list.files("../YATAWebCore/objects", pattern="*\\.R$", full.names=TRUE, ignore.case=F)
# sapply(files,source)
# files = list.files("../YATAWebCore/R", pattern="*\\.R$", full.names=TRUE, ignore.case=F)
# sapply(files,source)
# files = list.files("../YATAWebCore/shiny", pattern="*\\.R$", full.names=TRUE, ignore.case=F)
# sapply(files,source)
# 
# files = list.files("../YATAWebCore/widgets", pattern="*\\.R$", full.names=TRUE, ignore.case=F)
# sapply(files,source)
# files = list.files("../YATAWebCore/wrappers", pattern="*\\.R$", full.names=TRUE, ignore.case=F)
# sapply(files,source)
# 
# 
# 
# files.widgets = list.files("widgets", pattern="*\\.R$", full.names=TRUE, ignore.case=F)
# sapply(files.widgets,source)


# Inicializa el entorno

######################################
### Paneles
######################################

# YATAEnv = YATAENV$new()
# factory = YATAFactory$new()
# YATADB  = MARIADB$new(list(dbname="YATATest",username = "YATA",password = "yata",host = "127.0.0.1",port = "3306"))

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