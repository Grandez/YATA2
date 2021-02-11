library(R6)
library(data.table)
#' Abstract Class acting as Interface for each Qunatitative model in YATA
#'
# El Modelo es un conjunto de indicadores
#

IND__BASE <- R6::R6Class("IND__BASE",
    public = list(
         id      = 0
        ,symbol  ="N/A"
        ,name    = "Abstract Base Model"
        ,parent  = 0
        ,target  = FTARGET$new()    # Si se puede aplicar el indicador a varios campos, aqui va el defecto
        ,term    = 15
        ,xAxis   = "Date"
        ,idPlot  = 1
        ,title   = NULL
        ,df      = data.frame()
        ,blocks   = 1  # bitmask xx
        ,indNames = c("ID_IND","FLG_SCOPE","FLG_TERM","NAME","TYPE","VALUE","DESCR")
        ,initialize = function(parms=NULL)  { private$parameters = c(private$parameters, parms) }
        ,hasData         = function()       { FALSE }
        ,getParameters   = function()       { private$parameters }
        ,getTarget       = function()       { self$target }
        ,getTargetID     = function()       { self$target$value }
        ,getTargetName   = function()       { self$target$name  }
        ,setTarget       = function(target) { self$target = target }
        ,getData         = function()       { private$dfData       }
        ,getDoc = function() {
            txt = "No hay descripcion para este indicador"

            fname = paste0("IND_", self$symbol, ".Rmd")
            f = system.file("rmd", fname, package = "YATAModels")
            if (file.exists(f)) {
                txt = knit(text=read_file(f), quiet = TRUE)
            }
            txt
         }
        ,calculate  = function(data) { stop("This method must be implemented into a class") }
        ,plot       = function(p, TTickers)    { stop("This method is virtual") }

        ,addParameter = function(name, value) {
            old = private$parameters[[name]]
            if (!is.null(old)) {
                private$parameters[[name]] = value
            }
            else {
                private$parameters = c(private$parameters, value)
                names(private$parameters) = c(names(private$parameters), name)
            }
            # l = list(FLG_SCOPE=65525, FLG_TERM=15, NAME=name, VALUE=value)
            # if (is.null(private$parms)) {
            #     private$parms = as.data.table(l)
            # }
            # else {
            #     private$parms = rbind(private$parms, l)
            # }
        }
        # ,addParameters = function(parms)  {
        #     if (nrow(parms) > 0)  {
        #         parms$NAME = tolower(parms$NAME)
        #         if (is.null(private$parms)) {
        #             private$parms = as.data.table(parms)
        #         }
        #         else {
        #             tmp = merge(private$parms, parms, by=key(private$parms), all=T)
        #             tmp[is.na(tmp$TYPE.y), "TYPE.y"]   = tmp[is.na(tmp$TYPE.y),"TYPE.x"]
        #             tmp[is.na(tmp$VALUE.y),"VALUE.y"]  = tmp[is.na(tmp$VALUE.y),"VALUE.x"]
        #             tmp[is.na(tmp$DESCR.y), "DESCR.y"] = tmp[is.na(tmp$DESCR.y),"DESCR.x"]
        #             private$parms = set(tmp,NULL,c("TYPE.x", "VALUE.x", "DESCR.x"),NULL)
        #             colnames(private$parms) = self$indNames
        #         }
        #         setkey(private$parms, "ID_IND","FLG_SCOPE","FLG_TERM","NAME")
        #         invisible(self)
        #     }
        # }
        ,getParameter  = function(name, def = NA) {
            df = filter (private$parameters,NAME == name)
            if (nrow(df) == 0) return (def)
            df = df[order(-df$FLG_SCOPE, -df$FLG_TERM),]
            setDataType(df[nrow(df),"TYPE"], df[nrow(df),"VALUE"])
        }

        ###############################################################
        # Abstract functions
        ###############################################################
        # Devuelve un numero entre -5 y 5
        ,calculateAction    = function(portfolio, case, reg)       { stop("This method is virtual") }
        ,calculateOperation = function(cartera, caso, reg, action) { stop("This method is virtual") }

         ###############################################################
         # Generic functions
         ###############################################################
        # Devuelve las columnas para la tabla

        ,getThresholds     = function()   { private$thresholds }
        # ,getIndicators     = function()   { private$indicators }
        # ,getIndicatorsName = function()   { nm = unlist(names(private$indicators))
        #                                    tt = unlist(sapply(private$indicators, function(x) {x$title}))
        #                                    names(nm) = tt
        #                                    as.list(nm)
        #                                   }
        ,print          = function()      { cat(self$name)  }
        ,setParameters  = function(parms) { private$parameters = parms }
        ,setThresholds  = function(thres) { private$thresholds = thres }
        ,setParametersA = function(parms, pat) {
            private$parameters = private$updateList(private$parameters, parms, pat) }
        ,setThresholdsA = function(thres, pat) {
            private$thresholds = private$updateList(private$thresholds, thres, pat) }

        # ,calculateIndicatorsGlobal = function(data) { private$calcIndicators(data, 1) }
        # ,calculateIndicators       = function(data) { private$calcIndicators(data, 2) }
        # ,plotIndicators            = function(plots, data, names) {
        #     for (name in names) {
        #         ind = private$indicators[[name]]
        #         plotFunc = ind$plot
        #         if (is.numeric(plotFunc)) plotFunc = PLOT_FUNC[plotFunc]
        #         plots = do.call(plotFunc, list(data, ind, plots))
        #     }
        # }
    )

   ,private = list(

        ###############################################################
        # Private Abstract Properties
        ###############################################################
         parameters = list()
        ,dfDat      = NULL
        ,dfVal      = NULL
        ,dfVar      = NULL
        ,dfCycle    = NULL
        ,dfDate     = NULL
        # ,indicators=NULL

        ,calculated = 0  # En shiny es posible que se llame varias veces
        ,data = NULL

        ,getColPosition = function(data) {
            name  = toupper(self$target$getName())
            ucols = toupper(colnames(data))
            which(ucols == name)
        }
        ###############################################################
        # Private Generic Methods
        ###############################################################
        # ,addIndicators  = function(...) {
        #     input = list(...)
        #     names(input) = lapply(input,function(x) {x$name})
        #     private$indicators = c(private$indicators, input)
        # }
        # ,setColNames    = function(cols = NULL) {
        #     if (is.null(cols)) {
        #         c = paste(self$symbol,colnames(private$data), sep="_")
        #         colnames(private$data) = c
        #         return (c)
        #     }
        #     paste(self$symbol,cols, sep="_")
        #  }
        ,calcVariation  = function(colName, prc = TRUE) {
            applyDiff = function(x) {x[2] - x[1]}
            private$data[,"var"] = rollapply(private$data[,colName], 2, applyDiff, fill=0, align="right")
            if (prc) {
                private$data[,"var"] = private$data[,"var"] / private$data[,colName]
                private$data[,"var"] = as.percentage(private$data[,"var"])
            }
        }
        ,getXTS         = function(data) {
            # xts es una matriz, por eso hay que quitar los caracteres y la fecha
            base = data$df
            pos = which(colnames(base)  == data$getDateColumn())[1]
            tms =  as.POSIXlt(base[,pos])
            private$dfDate = data.frame(tms)
            res = base[,sapply(base,is.factor) | sapply(base,is.numeric)]
            xts::xts(res, order.by = tms)
        }

        # ,getXTS2         = function(data,price=T, pref=0) {
        #     #   Incluir datos previos para los calculos
        #     if (pref != 0) {
        #         beg = which(data$dfa[,data$DATE] == data$df[1, data$DATE])
        #         prev = data$dfa[seq(beg[1]-pref,by=1, length.out=pref),]
        #         prev[,data$PRICE] = prev[,data$VALUE]
        #         base = rbind(prev, data$df)
        #     }
        #     else {
        #         base= data$df
        #     }
        #     pos = which(colnames(base)  == data$DATE)[1]
        #     xts::xts(base[,-pos], order.by = base[,pos])
        # }
        ,setDF          = function(res, columns) {
            df = as.data.frame(res)
            colnames(df) = columns
            df
        }
        # ,calcIndicators = function(data, scope) {
        #     if (bitwAnd(scope, private$calculated) == 0) {
        #         for (ind in private$indicators) {
        #             if (ind$scope == scope) ind$result = self$calculate(data, ind)
        #         }
        #     }
        #     private$calculated = bitwOr(private$calculated, scope)
        # }
        ,updateList     = function(l, values, pat) {
            names = gsub(pat, "", names(values))
            for (i in 1:length(values)) {
                l[[names[i]]] = values[[i]]
            }
            l
        }
        ,setDataTypes   = function(type, columns) {
            for (col in columns) {
                private$data[,col] = eval(parse(text=paste0("as.", type, "(private$data[,'", col, "'])")))
            }
        }
   )
)

