PRTSession = R6::R6Class("PART.SESION"
    ,inherit    = TBLSession
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
         initialize = function(name, db=NULL) {
             super$initialize(name, db=db)
             private$tblControl = TBLSessionCtrl$new("SessionCtrl", db)
         }
         ,getLastUpdate = function() {
             tblControl$select(id=1)
             if (is.null(tblControl$current)) return (0)
             as.numeric(tblControl$current$tms)
         }
         ,update = function(data, isolated = FALSE) {
             if (nrow(data) == 0) return (invisible(self))
             tblControl$select(id=1, create = TRUE)
             tblControl$setField("tms", as.integer(as.POSIXct(data[1,"last"])))
             tblControl$apply()
             super$update(data)
             invisible(self)
         }
         ,getLatest     = function(rank=0, currencies = NULL) {
             last=max("last")
             if (is.null(currencies)) {
                 df = table(last=last)
             } else {
                 df = table(last=last, inValues=list(id=currencies))
             }
             if (rank > 0) df = df[df$rank <= rank,]
             df
         }
        ,getSessionData = function(currencies = NULL) {
            from = as.Date(Sys.time())
            parms = list(tms=as.POSIXct(from, tz="UTC"))
            qry = paste("SELECT * FROM ", tblName, "WHERE LAST > ?")
            if (!is.null(currencies)) {
                marks = rep(",?", length(currencies))
                marks = substr(marks, 2, nchar(marks))
                qry = paste(qry, "AND ID IN (", marks, ")")
                parms$id = currencies
            }
            setColNames(queryRaw(qry, parms))
        }
     )
     ,private = list (
         tblControl = NULL
     )
)
