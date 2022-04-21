# Tabla de parametros
# Maneja los parametros de sistema y de usuario
#JGG PEND de crear la lista completa de friendly names
OBJParms = R6::R6Class("OBJ.PARMS"
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,portable   = FALSE
    ,public = list(valid=TRUE
        ,err = NULL
        ,print = function() { message("YATA Parameters")}
        ,initialize = function(dbf, msg) {
            tryCatch({
                private$tblParms  = dbf$getTable("Parameters") # , dbf$getDBBase())
                private$tblConfig = dbf$getTable("Config") #,     dbf$getDBUser())
                private$objMsg   = msg
             }, error = function(cond) {
                 YATABase:::error("Error de inicializacion de OBJParms", subclass=NULL, origin="OBJParms", cond)
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
            tblConfig$getSubgroup(group=1, subgroup=2, asList=TRUE)
        }
        ,setPreferences   = function(lst) {
            prefs = c(default=1,autoOpen=2,last=3,cookies=4)
            old = getPreferences()
            tblConfig$db$begin()
            for (idx in 1:length(lst)) {
                lbl = names(lst)[idx]
                if (old[[lbl]] != lst[[lbl]]) {
                    value = as.character(lst[[lbl]])
                    if(is.logical(lst[[lbl]])) value = ifelse(lst[[lbl]], "1", "0")
                    tblConfig$update(lst(value=value), group=1, subgroup=2, id=prefs[lbl], isolated=F)
                }
            }
            tblConfig$db$commit()
        }
        # ,getDefaultCamera = function() { tblConfig$getInteger (group=1, subgroup=2, id=1, default=1) }
        # ,getAutoOpen      = function() { tblConfig$getInteger (group=1, subgroup=2, id=2, default=0) }
        # ,getLastCamera    = function() { tblConfig$getInteger (group=1, subgroup=2, id=3, default=1) }
        # ,getCookies       = function() { tblConfig$getBoolean (group=1, subgroup=2, id=4, default=TRUE) }
        # ,setDefaultCamera    = function(value, isolated=T) {
        #     value = as.character(value)
        #     tblConfig$update(lst(value=value), group=1, subgroup=2, id=1, isolated=isolated)
        #     invisible (self)
        #  }
        # ,setAutoOpen    = function(value, isolated=T) {
        #     value = as.character(as.integer(value))
        #     tblConfig$update(lst(value=value), group=1, subgroup=2, id=2, isolated=isolated)
        #     invisible (self)
        #  }
        # ,setLastCamera = function(value, isolated=T) {
        #     value = as.character(value)
        #     tblConfig$update(lst(value=value), group=1, subgroup=2, id=3, isolated=isolated)
        #     invisible (self)
        # }
        # ,setCookies = function(value, isolated=T) {
        #     value = ifelse (value, 1, 0)
        #     value = as.character(vallue)
        #     tblConfig$update(lst(value=value), group=1, subgroup=2, id=4, isolated=isolated)
        #     invisible (self)
        # }
        ################################################
        ### User - Group 5 - Camera/portfolios
        ################################################
        ,getPortfolios = function(all=FALSE) {
            df = tblConfig$getBlocks(group=5)
            if (!all) df = df[df$active == TRUE,]
            df
        }
        ,getCameraInfo = function(camera) {
            data = tblConfig$getSubgroup(group=5, subgroup=camera, asList=TRUE)
            db = getDBInfo(data$db, TRUE)
            list(camera=data, db=db)
        }

#        ,getDefaultDB      = function() tblParms$getInteger(DBParms$ids$DBDefault)
        # ,lastOpen          = function() {
        #     getDBInfo(tblParms$getInteger(DBParms$ids$lastOpen))
        # }
        ,defaultDB         = function() {
            id=getDefaultDb()
            getList(DBParms$group$databases, id)
        }
        ,setLastOpen       = function(iddb) {
            keys = splitKeys(DBParms$ids$lastOpen)
            tblParms$update( list(value=as.character(iddb))
                            ,group = keys[1], subgroup = keys[2], id=keys[3]
                            ,isolated=TRUE)
            invisible(self)
        }

        ,get         = function(group, subgroup, id) { tblParms$table(group=group, subgroup=subgroup,id=id) }
        ,getGroup    = function(group)               { tblParms$table(group=group) }
        ,getSubgroup = function(group, subgroup)     { tblParms$table(group=group, subgroup=subgroup) }
        ,getBlock    = function(group, subgroup) {
            df = tblParms$table(group=group, subgroup=subgroup)
            dfr = data.frame(block=unique(df$block))
            keys = unique(df$name)
            for (idx in 1:length(keys)) dfr = cbind(dfr, df[df$name == keys[idx],"value"])
            colnames(dfr) = c("block", keys)
            dfr
        }
        ,getList = function(group, subgroup)     {
            df = tblParms$getSubGroup(group, subgroup)
            data = list()
            for (idx in 1:nrow(df)) {
                data = list.append(data, tblParms$applyType(df[idx,"value"], df[idx,"type"]))
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
         ### Providers
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
            data = lapply(df, function(x) tblParms$applyType(xvalue,x$type))
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
       ,tblProviders  = NULL
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
    )
)

