unloadNamespace("YATABatch")
unloadNamespace("YATACore")
# Core
library(utils)
library(R6)
library(tibble)
library(rlist)
library(stringr)
library(data.table)

suppressMessages(library(plyr,  warn.conflicts = FALSE))
suppressMessages(library(tidyr, warn.conflicts = FALSE))
suppressMessages(library(dplyr, warn.conflicts = FALSE))

# YATA
suppressMessages(library(YATABase,       warn.conflicts = FALSE))
suppressMessages(library(YATACore,       warn.conflicts = FALSE))
suppressMessages(library(YATAWebShiny,   warn.conflicts = FALSE))
suppressMessages(library(YATAWebCore,    warn.conflicts = FALSE))
# library(YATABatch)

# Shiny
library(shiny)
suppressMessages(library(shinyjs             ,warn.conflicts = FALSE))
suppressMessages(library(bslib,              warn.conflicts = FALSE))

# Async
# #suppressMessages(library(jsonlite, warn.conflicts = FALSE))
suppressMessages(library(promises, warn.conflicts = FALSE))
suppressMessages(library(future,   warn.conflicts = FALSE))

suppressMessages(library(plotly, warn.conflicts = FALSE))
suppressMessages(library(reactable, warn.conflicts = FALSE))

# options( warn = -1
# #        ,DT.options = list(dom = "t", bPaginate = FALSE, rownames = FALSE, escape=FALSE, scrollX = F)
#         ,java.parameters = "-Xmx2048m"
#           # ,shiny.reactlog=TRUE
#           # ,shiny.trace=TRUE
# )


# plotly::config(plot_ly(), displaylogo = FALSE, collaborate = FALSE, displayModeBar = FALSE, responsive=TRUE)

if (.Platform$OS.type != "windows") {
   future::plan(strategy="sequential")
} else {
  future::plan(list(tweak(multisession, workers = availableCores() %/% 4),
                    tweak(multisession, workers = 4)))
}

if (exists("WEB")) rm("WEB")
web = YATAWebCore::YATAWebEnv$new(YATACore::YATAFACTORY$new())
assign("WEB", web, envir=.GlobalEnv)

######################################
### Carga de fuentes
### En R busca subdirectorios
#####################################

files = list.files(path="R", pattern="\\.R$", recursive=TRUE, full.names=T, ignore.case=F)
sapply(files,source)

# WEB$startDaemons() # Esto bloquea en windows


# WEB$startDaemons()
onStart = function() {
      cat("Doing application setup\n")
}
onStop(function() {
  cat("Doing application cleanup\n")
})
