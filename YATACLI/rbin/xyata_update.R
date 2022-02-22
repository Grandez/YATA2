#!/usr/bin/env Rscript
library(YATASetup)
yata_update = function() {
    ini = YATAINI$new()
    git = YATAGIT$new(ini)
    browser()
    rc = git$pull()
    browser()
#    makeBinaries(git$getBinaries())
#    makePackages(git$getPackages())
}