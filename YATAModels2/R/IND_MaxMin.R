library(R6)
# Maximo es aquel tal que x-1 < x >= x+1
# Tomamos el intervalo inicial (1:n)
# L = 1-n0
# Mientras veces < depth
#    Por cada elemento en L
#        coger el maximo
#              Si ninguno es igual a los extremos hay maximo (n1) -> 1-n1, n1-n
#                 Aladir a la lista L2, 1-n1,n1-n
#    Poner L2 como L


IND_MaxMin <- R6Class("IND_MaxMin", inherit=IND__BASE,
   public = list(
        name="Maximos y minimos"
       ,symbol="MM"
       ,initialize     = function(parms=NULL) {
           super$initialize(c(depth=2))
           self$target$value = self$target$CLOSE
       }
       ,hasData        = function() { FALSE }
       ,getDescription = function() { private$makeMD() }
       ,calculate = function(TSession) {
           depth = private$parameters[["depth"]]
           pos = private$getColPosition(TSession$df)
           private$dfDat = TSession$df[,pos]
           private$pMax = private$getPoints(private$dfDat,depth, TRUE)
           private$pMin = private$getPoints(private$dfDat,depth, FALSE)
       }
       ,plot = function(p, xAxis) {
           if (length(private$pMax)) {
               pos = c()
               tmp = sapply(private$pMax, function(x) { private$dfDat == x})
               for (i in 1:ncol(tmp)) pos = c(pos, which(tmp[,i]))
               p = YATACore::plotPoint(p, x=xAxis[pos], y=private$pMax, color="green", title = self$symbol)
           }
           if (length(private$pMin)) {
               pos = c()
               tmp = sapply(private$pMin, function(x) { private$dfDat == x})
               for (i in 1:ncol(tmp)) pos = c(pos, which(tmp[,i]))
               p = YATACore::plotPoint(p, x=xAxis[pos], y=private$pMin, color="red", title = self$symbol)
           }
           p

       }

       # ,calculateAction    = function(case, portfolio) {
       #     lInd = self$getIndicators()
       #     ind  = lInd[[self$symbol]]
       #     dfi  = as.data.frame(ind$result[[1]])
       #     dft  = case$tickers$df
       #
       #     fila     = case$current
       #     pCurrent = dft[fila, DF_PRICE]
       #     pInd     = dfi[fila, 1]
       #
       #     if (is.na(pInd) || pInd == 0 || pCurrent == pInd) return (c(0,100,100))
       #
       #     var = pCurrent / pInd
       #     if (var == 1) return (c(0,100,100))
       #
       #     prf = case$profile$profile
       #     thres = ifelse(var > 1,private$thresholds[["sell"]],private$thresholds[["buy"]])
       #     action = applyThreshold(prf, var, thres)
       #     action
       # }
       # ,calculateOperation = function(portfolio, case, action) {
       #     reg = case$tickers$df[case$current,]
       #     cap = portfolio$saldo()
       #     pos = portfolio$getActive()$position
       #     sym = case$config$symbol
       #
       #     # Por temas de redondeo, el capital puede ser menor de 0
       #     if (action[1] > 0 && cap  > 1)  return (YATAOperation$new(sym, reg[1,DF_DATE], cap,      reg[1,DF_PRICE]))
       #     if (action[1] < 0 && pos  > 0)  return (YATAOperation$new(sym, reg[1,DF_DATE], pos * -1, reg[1,DF_PRICE]))
       #     NULL
       # }
    )
    ,private = list(
         pMax = c()
        ,pMin = c()
        ,makeMD = function() {
            lines = c(
                "Muestra los maximos y minimos relativos"
            )
            data = ""
            for (line in lines) {
                data = paste(data, line, sep="\n")
            }
            data
         }
        ,getPoints = function(df, depth, maximum=TRUE) {
            getMax = function(x) {ifelse (x[2] >= x[1] && x[2] > x[3],  TRUE, FALSE)}
            getMin = function(x) {ifelse (x[2] <  x[1] && x[2] <= x[2], TRUE, FALSE)}
            funct =  ifelse(maximum, getMax, getMin)
            minmax = ifelse(maximum, max, min)
            nDepth = 1
            PBeg = c(1)
            PEnd = c(length(df))
            PSel = c()
            while (nDepth <= depth && length(PBeg) > 0) {
                MBeg = c()
                MEnd = c()

                for (i in 1:length(PBeg)) {
                    last = PEnd[i]
                    tmp = df[PBeg[i]:PEnd[i]]
                    points = rollapply(tmp, 3, funct, fill=0, align="center")
                    if (sum(points) > 0) {
                        VAL = minmax(tmp[points])
                        pos = which(tmp == VAL)
                        PSel = c(PSel, VAL)
                        MBeg = c(MBeg, PBeg[i], pos + 1)
                        MEnd = c(MEnd, pos - 1, last)
                    }
                }
                PBeg = MBeg
                PEnd = MEnd
                nDepth = nDepth + 1
            }
            PSel
        }
        ,maxmin = function(data, extreme=T) {
        df = data$df[,data$PRICE]
        Mm = rollapply(df,3,FUN=.detect_max_min,fill=0,align="center")

        # Tratamiento de infinitos
        if (sum(Mm ==  Inf) > 0) Mm <- process_inf(df,Mm,which(Mm ==  Inf), "left")
        if (sum(Mm == -Inf) > 0) Mm <- process_inf(df,Mm,which(Mm == -Inf), "right")
        list(Mm)
        }

# Los maximos son para un rango dado, aquellos por encima del mayor de los minimos
# Lo minimos a la inversa
# Si dos de lostres puntos son iguales, devuelve +/- Inf para procesarlos despues

,.detect_max_min = function(x) {
    if (x[2] > x[1] && x[2] > x[3]) return( x[2])
    if (x[2] < x[1] && x[2] < x[3]) return(-x[2])
    if (x[2] == x[1]) {
        if (x[2] > x[3]) return(+Inf)
        if (x[2] < x[3]) return(-Inf)
    }
    if (x[2] == x[3]) {
        if (x[2] > x[1]) return(+Inf)
        if (x[2] < x[1]) return(-Inf)
    }
    return(0)
}

# Detecta los maximos y minimos relativos
# En caso de alineacion, se marca el especificado en align

,process_inf = function(data, Mm, rows, align) {
    beg = rows[1]
    end = rows[2]
    left = data[beg - 1,1]
    i = 2
    while ( i <= length(rows)) {
        if (i < length(rows) && (rows[i] - rows[i - 1]) == 1) {
            end = rows[i]
        }
        else {
            Mm[beg:end] = 0
            if (rows[i] < length(Mm)) {
                right = data[end + 1,1]
                val = 0
                if (left < data[beg,1] && data[beg,1] > right) val = data[beg,1]
                if (left > data[beg,1] && data[beg,1] < right) val = data[beg,1] * -1
                if (val != 0) {
                    if (align == "left") {
                        Mm[beg] = val
                    }
                    else {
                        Mm[end] = val
                    }
                }
            }
            beg=rows[i]
        }
        i = i + 1
    }
    Mm

}

,MaxMin2 = function(data) {
    data$Mm = rollapply(c(data$precio, data$Mm),4,function(x, y) {detect_max_min(x)}
                        ,fill=0,align="right",by.column=T)
    data
}

    )
)


