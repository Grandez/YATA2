library(data.table)
#' Abstract Class acting as Interface for each Qunatitative model in YATA
#'
# El Modelo es un conjunto de indicadores
#

YATAIndicator <- R6::R6Class("YATAIndicator",
    public = list(
         id      = 0
        ,parent  = 0
        ,name    = "Abstract Base Model"
        ,term    = 15
        ,target  = "Price"
        ,xAxis   = "Date"
        ,idPlot  = 1
        ,doc     = NULL
        ,title   = NULL

        ,blocks   = 1  # bitmask xx
        ,indNames = c("ID_IND","FLG_SCOPE","FLG_TERM","NAME","TYPE","VALUE","DESCR")
        ,initialize = function(parms=NULL,thres=NULL) {}
        ,calculate  = function(TTickers, date) { stop("This method is virtual") }
        ,plot       = function(p, TTickers)    { stop("This method is virtual") }
        ,getData    = function()               { private$data                   }

        ,addParameters = function(parms)  {
            if (nrow(parms) > 0)  {
                parms$NAME = tolower(parms$NAME)
                if (is.null(private$parms)) {
                    private$parms = as.data.table(parms)
                }
                else {
                    tmp = merge(private$parms, parms, by=key(private$parms), all=T)
                    tmp[is.na(tmp$TYPE.y), "TYPE.y"]   = tmp[is.na(tmp$TYPE.y),"TYPE.x"]
                    tmp[is.na(tmp$VALUE.y),"VALUE.y"]  = tmp[is.na(tmp$VALUE.y),"VALUE.x"]
                    tmp[is.na(tmp$DESCR.y), "DESCR.y"] = tmp[is.na(tmp$DESCR.y),"DESCR.x"]
                    private$parms = set(tmp,NULL,c("TYPE.x", "VALUE.x", "DESCR.x"),NULL)
                    colnames(private$parms) = self$indNames
                }
                setkey(private$parms, "ID_IND","FLG_SCOPE","FLG_TERM","NAME")
                invisible(self)
            }
        }
        ,getParameter = function(name, def = NA) {
            df = filter (private$parms,NAME == name)
            if (nrow(df) == 0) return (def)
            if (nrow(df) == 1) return (setDataType(df[1,"TYPE"], df[1,"VALUE"]))
            df = df[order(-FLG_SCOPE, -FLG_TERM),]
            setDataType(rec[,"TYPE"], rec[,"VALUE"])

        }

        ###############################################################
        # Abstract functions
        ###############################################################

        ,calculateAction    = function(portfolio, case, reg)       { stop("This method is virtual") }
        ,calculateOperation = function(cartera, caso, reg, action) { stop("This method is virtual") }

         ###############################################################
         # Generic functions
         ###############################################################
        ,getParameters     = function()   { private$parameters }
        ,getThresholds     = function()   { private$thresholds }
        ,getIndicators     = function()   { private$indicators }
        ,getIndicatorsName = function()   { nm = unlist(names(private$indicators))
                                           tt = unlist(sapply(private$indicators, function(x) {x$title}))
                                           names(nm) = tt
                                           as.list(nm)
                                          }
        ,print          = function()      { cat(self$name)  }
        ,setParameters  = function(parms) { private$parameters = parms }
        ,setThresholds  = function(thres) { private$thresholds = thres }
        ,setParametersA = function(parms, pat) {
            private$parameters = private$updateList(private$parameters, parms, pat) }
        ,setThresholdsA = function(thres, pat) {
            private$thresholds = private$updateList(private$thresholds, thres, pat) }

        ,calculateIndicatorsGlobal = function(data) { private$calcIndicators(data, 1) }
        ,calculateIndicators       = function(data) { private$calcIndicators(data, 2) }
        ,plotIndicators            = function(plots, data, names) {
            for (name in names) {
                ind = private$indicators[[name]]
                plotFunc = ind$plot
                if (is.numeric(plotFunc)) plotFunc = PLOT_FUNC[plotFunc]
                plots = do.call(plotFunc, list(data, ind, plots))
            }
        }
    )

   ,private = list(

        ###############################################################
        # Private Abstract Properties
        ###############################################################
         parms = NULL
        ,indicators=NULL
        # ,parameters = list("PointsDepth"=3)
        # ,thresholds = list(buy=0.0, sell=0.0)
        ,calculated = 0  # En shiny es posible que se llame varias veces
        ,data = NULL

        ###############################################################
        # Private Generic Methods
        ###############################################################
        ,addIndicators = function(...) {
            input = list(...)
            names(input) = lapply(input,function(x) {x$name})
            private$indicators = c(private$indicators, input)
        }
        ,getXTS = function(data,price=T) {
            pos = which(colnames(data$df)  == data$DATE)[1]
            xts::xts(data$df[,-pos], order.by = data$df[,pos])
        }
        ,setDF = function(res, columns) {
            df = as.data.frame(res)
            colnames(df) = columns
            df
        }
        ,calcIndicators = function(data, scope) {
            if (bitwAnd(scope, private$calculated) == 0) {
                for (ind in private$indicators) {
                    if (ind$scope == scope) ind$result = self$calculate(data, ind)
                }
            }
            private$calculated = bitwOr(private$calculated, scope)
        }
        ,updateList = function(l, values, pat) {
            names = gsub(pat, "", names(values))
            for (i in 1:length(values)) {
                l[[names[i]]] = values[[i]]
            }
            l
        }
   )
)

