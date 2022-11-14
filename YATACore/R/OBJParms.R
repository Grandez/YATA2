# Tabla de parametros
# Maneja los parametros de sistema y de usuario
# JGG PEND de crear la lista completa de friendly names
OBJParms = R6::R6Class("OBJ.PARMS"
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,portable   = FALSE
    ,public = list(valid=TRUE
        ,err         = NULL
        ,preferences = NULL
        ,print       = function() { message("YATA Parameters")}
        ,initialize = function(dbf, msg) {
            tryCatch({
                private$tblParms  = dbf$getTable("Parameters") # , dbf$getDBBase())
#                private$tblConfig = dbf$getTable("Config") #,     dbf$getDBUser())
                private$objMsg   = msg
#                self$preferences = tblConfig$getSubgroup(group=1, subgroup=2, asList=TRUE)
             }, error = function(cond) {
                 ERROR("Error de inicializacion de OBJParms", cond, origin="OBJParms")
            })
        }
        ################################################
        ### Friendly methods
        ################################################
        ### User - Group 1
        ################################################
        ,getUser    = function() { tblConfig$getString(group=1, subgroup=1, id=1) }
        ,getPwd     = function() { tblConfig$getString(group=1, subgroup=1, id=2) }
        ,getFIAT    = function() { tblConfig$getString(group=1, subgroup=1, id=3) }
        ,getLang    = function() { tblConfig$getString(group=1, subgroup=1, id=4) }
        ,getDialect = function() { tblConfig$getString(group=1, subgroup=1, id=5) }

        ,setUser    = function(value, isolated=T) {
            tblConfig$update(lst(value=value), group=1, subgroup=1, id=1, isolated=isolated)
            invisible (self)
         }
        ,setPwd     = function(value, isolated=T) {
            tblConfig$update(lst(value=value), group=1, subgroup=1, id=2, isolated=isolated)
            invisible (self)
         }
        ,setFIAT    = function(value, isolated=T) {
            tblConfig$update(lst(value=value), group=1, subgroup=1, id=3, isolated=isolated)
            invisible (self)
         }
        ,setLang    = function(value, isolated=T) {
            tblConfig$update(lst(value=value), group=1, subgroup=1, id=4, isolated=isolated)
            invisible (self)
         }
        ,setDialect = function(value, isolated=T) {
            tblConfig$update(lst(value=value), group=1, subgroup=1, id=5, isolated=isolated)
            invisible (self)
         }

        ################################################
        ### User - 1-2 Actions
        ################################################
        ,getPreferences   = function() {
            if (is.null(preferences))
                self$preferences = tblConfig$getSubgroup(group=1, subgroup=2, asList=TRUE)
            preferences
        }
        ,setPreferences   = function(lst) {
            prefs = c(default=1,autoOpen=2,last=3,cookies=4)
            getPreferences()
            tblConfig$db$begin()
            for (idx in 1:length(lst)) {
                lbl = names(lst)[idx]
                if (preferences[[lbl]] != lst[[lbl]]) {
                    value = as.character(lst[[lbl]])
                    if(is.logical(lst[[lbl]])) value = ifelse(lst[[lbl]], "1", "0")
                    tblConfig$update(lst(value=value), group=1, subgroup=2, id=prefs[lbl], isolated=F)
                }
            }
            tblConfig$db$commit()
            getPreferences()
        }
        ,getDefaultPortfolio = function() { preferences$default  }
        ,getAutoOpen         = function() { preferences$autoOpen }
        ,getLastPortfolio    = function() { preferences$last     }
        ,getCookies          = function() { preferences$cookies  }
        ,setLastPortfolio    = function(value, isolated=T) {
            value = as.character(value)
            tblConfig$update(lst(value=value), group=1, subgroup=2, id=3, isolated=isolated)
            invisible (self)
        }
        # ,setCookies = function(value, isolated=T) {
        #     value = ifelse (value, 1, 0)
        #     value = as.character(vallue)
        #     tblConfig$update(lst(value=value), group=1, subgroup=2, id=4, isolated=isolated)
        #     invisible (self)
        # }
        ################################################
        ### User - Group 5 - Carteras/portfolios
        ################################################
        ,getPortfolios = function(all=FALSE) {
            df = tblConfig$getBlocks(group=5)
            if (!all) df = df[df$active == TRUE,]
            df
        }
        ,getTargets = function() {

        }
        ,getPortfolioInfo = function(portfolio, user) {
            data   = tblConfig$getSubgroup(group=5, subgroup=portfolio, asList=TRUE)
            dbInfo = tblConfig$getSubgroup(group=10, subgroup=1, asList=TRUE)

            data$db        = dbInfo
            data$db$name   = data$title
            data$db$descr  = data$comment
            data$db$dbname = paste(user, data$db_sfx, sep="_")

            data
        }
        ,setLastOpen       = function(iddb) {
            keys = splitKeys(DBParms$ids$lastOpen)
            tblParms$update( list(value=as.character(iddb))
                            ,group = keys[1], subgroup = keys[2], id=keys[3]
                            ,isolated=TRUE)
            invisible(self)
        }
        ,getLabelsTable = function(group) { getSubgroup(60, group, as_list=TRUE) }
        ,get         = function(group, subgroup, id) { tblParms$table(group=group, subgroup=subgroup,id=id) }
        ,getGroup    = function(group)               { tblParms$table(group=group) }
        ,getSubgroup = function(group, subgroup, as_list=FALSE)     {
            df = tblParms$table(group=group, subgroup=subgroup)
            if (!as_list) return (df)
            data = list()
            for (idx in 1:nrow(df)) {
                data = list.append(data, applyType(df[idx,"value"], df[idx,"type"]))
            }
            names(data) = df$name
            data
         }
        ,getBlock    = function(group, subgroup) {
            df = tblParms$table(group=group, subgroup=subgroup)
            dfr = data.frame(block=unique(df$block))
            keys = unique(df$name)
            for (idx in 1:length(keys)) dfr = cbind(dfr, df[df$name == keys[idx],"value"])
            colnames(dfr) = c("block", keys)
            dfr
        }
        ,getList = function(group, subgroup)     {
            stop("JGG ESTA FUNCION ES getSubgroup(group, subgroup, as_list=TRUE")
            df = tblParms$getSubGroup(group, subgroup)
            data = list()
            for (idx in 1:nrow(df)) {
                data = list.append(data, applyType(df[idx,"value"], df[idx,"type"]))
            }
            names(data) = df$name
            data
        }

        ,currencies        = function(codes) {
             tblCurrencies$codeNames(codes)
         }
        ,getCurrencyNames  = function(codes, full) {
             private$tblCurrencies$getNames(codes, full)
        }
        ,getServers = function() {
            tblParms$groupAsList(DBParms$group$servers)
        }
         ##############################################
         ### providers
         ##############################################
        ,getOnlineProvider = function()          tblParms$getString (DBParms$ids$online)
        ,getOnlineInterval = function()          tblParms$getInteger(DBParms$ids$interval)
        ,getBaseCurrency   = function()          tblParms$getString (DBParms$ids$base)
        ,getCloseTime      = function()          tblParms$getInteger(DBParms$ids$closeTime)
        ,getAlertDays      = function(default=1) tblParms$getInteger(DBParms$ids$alert, default=default)
         ##############################################
         ### Databases
         ##############################################
        ,getDBData = function(all=FALSE) {
            df = getGroup(5)
            df = df[,c("subgroup","name","value")]
            df = spread(df,name,value)
            if (!all) df = df[df$active == 1,]
            df
         }
        ,getDBActive = function() {

         }
        ,getSessionData = function(asList=TRUE) {
            data = tblParms$getBlock(DBParms$block$session)
            for (i in 1:ncol(data)) data[,i] = as.integer(data[,1])
            if (asList) data = as.list(data)
            data
        }
        ,getHistoryData = function(asList=TRUE) {
            data = tblParms$getBlock(DBParms$block$history)
            for (i in 1:ncol(data)) data[,i] = as.integer(data[,1])
            if (asList) data = as.list(data)
            data
         }
         ##############################################
         ### REST
         ##############################################
        ,getRESTHost = function() {
            keys = splitKeys(DBParms$ids$rest)
            tblParms$getString (keys[1], keys[2], 1, default="127.0.0.1")
        }
        ,getRESTPort = function() {
            keys = splitKeys(DBParms$ids$rest)
            tblParms$getInteger (keys[1], keys[2], 2, default=9090)
        }
        ################################################
        ### Metodos de acceso a parametros
        ################################################
        ,getByName = function(name) { tblParms$table(name=name) }
        ,DF2List = function(df) {
            # TO DO
            data = lapply(df, function(x) applyType(xvalue,x$type))
            names(data) = df$name
            data
        }
        ################################################
        ### Metodos de actualizacion
        ################################################
        ,updateParameter = function(group, subgroup, id, value, transactional = TRUE) {
            # Debe existir. transaccional es por si son varias actualizaciones
            tblParms$select(group=group, subgroup=subgroup, id=id)
            if (nrow(df) == 0) stop("El parametro debe existir")
            checkParameterType(value, df[1,"type"])
            if (transactional) db$begin()
            tblParms$setField("value", value)
            tblParms$apply()
            if (transactional) db$commit()
        }
        ,updateParmsBulk = function(parms) {
            db$begin()
            tryCatch({
                for (item in names(parms)) {
                    df = tblParms$getByName(item)
                    tblParms$update(list(value=as.character(parms[[item]])),
                                    group    = df[1,"group"]
                                   ,subgroup = df[1,"subgroup"]
                                   ,id=df[1,"id"])
                }
                db$commit()
            },error = function(cond) {
                db$rollback()
            })
        }

    )
    ,private = list(
        cfg           = NULL
       ,tblParms      = NULL
       ,tblConfig     = NULL

       ,tblCurrencies = NULL
       ,objMsg        = NULL
       ,splitKeys = function(id) { as.integer(strsplit(id, " ", fixed=TRUE)[[1]]) }
       ,checkParameterType = function (value, type) {
           if (type == 10 && !is.integer(value)) stop("Debe ser numerico")
           if (type == 11 && !is.numeric(value)) stop("Debe ser numerico")
           if (type == 20) {}  #JGG Tirar de as.boolean
           #JGG etc
       }
      ,getDBInfo         = function(id, user) {
          tbl     = tblParms
          if (user) tbl = tblConfig
          data    = tbl$getSubgroup(group=10, subgroup=id, asList=TRUE)
          data$id=id
          data
      }
     ,applyType = function(value, type) {
         if (type == 10) return (as.integer(value))
         if (type == 11) return (as.numeric(value))
         if (type == 30) return (as.POSIXct(value, tz="UTC"))
         if (type == 31) return (as.Date(value))
         if (type == 32) return (strptime(value, tz="UTC"))
         if (type == 99) return (objMsg$get(value))

         if (type == 20) {
             if (is.logical(value)) return (value)
             if (is.character(value)) {
                 if (value == "0" || value == "FALSE" || value == "false") return (FALSE)
                 return (TRUE)
             }
             return (ifelse(as.integer(value) == 0, FALSE, TRUE))
         }
         value
     }
  )
)

