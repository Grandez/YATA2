library(R6)

if ("YATACore" %in% (.packages())) detach("package:YATACore", unload=T)

if (!require("pacman")) install.packages("pacman")

# Common
pacman::p_load("R6")
pacman::p_load("dplyr")

pacman::p_load("YATACore")

#' @export
loadModel <- function(idModel) {
    SQLConn = YATACore::openConnection()

    dfm   = YATACore::getModel(as.integer(idModel))
    model = YATAModel$new(dfm[1,"ID_MODEL"])

    model$name   = dfm[1,"NAME"]
    model$desc   = dfm[1,"DESCR"]
    model$scope  = dfm[1,"FLG_SCOPE"]
    model$parent = dfm[1,"ID_PARENT"]
    model
}

#' @export
loadIndicators = function(model, scopes) {
    parents = c(model$id)
    parent = model$parent
    # Carga los padres en orden inverso
    while (parent != 0) { # Root Parent
        dfm = YATACore::getModel(parent)
        if (AND(dfm[1, "FLG_SCOPE"], model$scope)) {
            parents = c(dfm[1, "ID_MODEL"], parents)
        }
        parent = dfm[1, "ID_PARENT"]
    }

    for (mod in parents) {
        dfLst = YATACore::getModelIndicators(mod)
        reg = 1
        while (reg <= nrow(dfLst)) {
            dfInd      = YATACore::getIndicator(dfLst[reg, "ID_IND"])

            # Para corto, mdio, largo
            for (term in c(TERM_SHORT, TERM_MEDIUM, TERM_LONG)) {
                if (bitwAnd(term, dfLst[reg, "FLG_TERM"])) {
                    # Para cada grafico
                    for (i in 1:length(TARGETS)) {
                        idx = bitwShiftL(1, i - 1)
                        if (bitwAnd(idx, dfLst[reg, "FLG_DAT"]) > 0) {
                            ind        = eval(parse(text=paste0("IND_",dfInd[1,"NAME"],"$new()")))
                            ind$id     = dfInd[1, "ID_IND"]
                            ind$parent = dfInd[1, "ID_PARENT"]
                            ind$target = TARGETS[i]
                            ind$xAxis  = XAXIS[i]
                            ind$idPlot = i
                            .addIndicatorParameters(ind, scopes[i], term)
                            model$addIndicator(ind, term)
                        }
                    }
                }

            }
            reg = reg + 1
        }

    }

    YATACore::closeConnection(SQLConn)
    model
}

.addIndicatorParameters <- function(ind, scope, term) {
    lstInd = ind$id
    parent = ind$parent
    while (parent != 0) {
        dfTmp = YATACore::getIndicator(parent)
        lstInd = c(dfTmp[1,"ID_IND"],lstInd)
        parent = dfTmp[1,"ID_PARENT"]
    }

    for (i in lstInd) {
        parms = YATACore::getIndicatorParameters(i, scope, term)
        ind$addParameters(parms)
    }
}


