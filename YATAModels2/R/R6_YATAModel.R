# El Modelo es un conjunto de indicadores que se aplican en tres ambitos:
# Largo - Medio - Corto
# Largo me indica que NO puedo hacer
# Medio me indica si pasar o si hacer lo que me esta permitido
# Corto elige el momento de ejecutar la accion

YATAModel <- R6::R6Class("YATAModel",
    public = list(
         id         = NULL
        ,parent     = 0
        ,name       = "Abstract Base Model"
        ,desc       =  NULL
        ,initialize = function(idModel = 0) {
            self$id = idModel
            private$tgt = FTARGET$new()
            sc = FSCOPE$new()
            private$indArr = array(0, dim = c(4,private$tgt$size,2)
                                    , dimnames = list(sc$names,private$tgt$names,c("a","b")))
            private$indCalc  = c()
        }
        ,addIndicator  = function(ind, scope) {
            private$indicators = list.append(private$indicators, ind)
            private$indCalc    = c(private$indCalc, FALSE)
            private$addToMatrix(ind, as.integer(scope), length(private$indicators))
            invisible(self)
        }
        ,getIndicators = function(scope) {
            private$indicators[private$getIndicatorsPos(scope)]
        }
        ,calculateIndicators = function(TSession, scope, force=F) {
            tgt = FSCOPE$new()
            sc = as.integer(scope)
            if (force || bitwAnd(tgt$LONG,   sc) > 0) private$calcInd(TSession, tgt$LONG)
            if (force || bitwAnd(tgt$MEDIUM, sc) > 0) private$calcInd(TSession, tgt$MEDIUM)
            if (force || bitwAnd(tgt$SHORT,  sc) > 0) private$calcInd(TSession, tgt$SHORT)
            invisible(self)
        }
        ,plotIndicators        = function(plot, scope, target, xAxis) {
            m = private$indArr[scope,,]
            inds = m[target,]
            for (idx in 1:length(inds)) {
                if (inds[idx] != 0) plot = private$indicators[[inds[idx]]]$plot(plot, xAxis)
            }
            plot
            # if (!self$calculated) self$calculateIndicators(data, term)
            # TTickers = data$getTickers(term)
            # lista = self$getIndicators(term)
            # # for (name in names) {
            # #     ind = private$indicators[[name]]
            # #     plotFunc = ind$plot
            # #     if (is.numeric(plotFunc)) plotFunc = PLOT_FUNC[plotFunc]
            # #     plots = do.call(plotFunc, list(data, ind, plots))
            # # }
            # idx = 1
            # while (idx <= length(lista)) {
            #     ind = lista[[idx]]
            #     plots[[ind$idPlot]] = ind$plot(plots[[ind$idPlot]], TTickers)
            #     idx = idx + 1
            # }
            # plots
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
        ,getIndicatorsName = function()   { nm = unlist(names(private$indicators))
                                           tt = unlist(sapply(private$indicators, function(x) {x$title}))
                                           names(nm) = tt
                                           as.list(nm)
        }

        ,print          = function()      { cat(self$name)  }
    )
   ,private = list(
         tgt        = NULL
        ,indicators = list()
        ,indCalc    = NULL
        ,indArr     = NULL    # Matriz 4 col (scope) y una fila por cada indicador

        ,addToMatrix = function(ind, scope, idx) {
            tgt = ind$getTarget()
            max = dim(private$indArr)[3]
            for (i in 1:max) {
                if (private$indArr[scope, tgt$value, i] == 0) {
                    private$indArr[scope, tgt$value, i] = idx
                    if (i == max)  private$indArr = abind(private$indArr, array(0,dim=c(4,tgt$size)),along=3)
                    break
                }
            }
        }
        ###############################################################
        # Private Generic Methods
        ###############################################################
        ,calcInd = function(TSession, scope) {
            for (idx in private$getIndicatorsPos(scope)) {
                private$indicators[[idx]]$calculate(TSession)
                private$indCalc[idx] = TRUE
            }
        }
        ,getIndicatorsPos = function(scope) {
            m = private$indArr[scope,,]
            m[which(!m == 0)]
        }

   )
)

