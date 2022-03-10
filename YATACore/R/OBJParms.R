# Tabla de parametros
# Necesita la DB Base
OBJParms = R6::R6Class("OBJ.PARMS"
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,portable   = FALSE
    ,public = list(valid = TRUE
        ,err = NULL
        ,print = function() { message("YATA Parameters")}
        ,initialize = function(codes, dbf) {
            tryCatch({
                private$tblParms = dbf$getTable(codes$tables$parameters)
                private$db       = dbf$getDBBase()
             }, error = function(cond) {
                 browser()
                     self$err   = cond
                     self$valid = FALSE
                     stop(errorCondition("Error de inicializacion de YATABase",
                                      class=c("YATAErr", "error")))

            })
        }
        ,get         = function(group, subgroup, id) { tblParms$table(group=group, subgroup=subgroup,id=id) }
        ,getGroup    = function(group)               { tblParms$table(group=group) }
        ,getSubgroup = function(group, subgroup)     { tblParms$table(group=group, subgroup=subgroup) }
        ,getList = function(group, subgroup)     {
            df = tblParms$getSubGroup(group, subgroup)
            data = list()
            for (idx in 1:nrow(df)) {
                data = list.append(data, tblParms$applyType(df[idx,"value"], df[idx,"type"]))
            }
            names(data) = df$name
            data
        }

        ################################################
        ### Metodos friendly
        ################################################
        ,getDefCurrency    = function() tblParms$getString(DBParms$ids$currency)
        ,getDefAltCurrency = function() tblParms$getString(DBParms$ids$altCurrency)
        ,pluginsDirectory  = function() tblParms$getString(DBParms$ids$plugins)
        ,autoConnect       = function() tblParms$getBoolean(DBParms$ids$autoConnect)
        ,getDefaultDbId    = function() tblParms$getInteger(DBParms$ids$DBDefault)
        ,getDBInfo         = function(id) {
            data = getList(DBParms$group$databases, id)
            data$id = id
            data
        }
        ,lastOpen          = function() {
            getDBInfo(tblParms$getInteger(DBParms$ids$lastOpen))
        }
        ,defaultDB         = function() {
            id = getDefaultDbId()
            getList(DBParms$group$databases, id)
        }
        ,setLastOpen       = function(iddb) {
            keys = splitKeys(DBParms$ids$lastOpen)
            tblParms$update( list(value=as.character(iddb))
                            ,group = keys[1], subgroup = keys[2], id = keys[3]
                            ,isolated=TRUE)
            invisible(self)
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
        ,getDBNames = function(active=TRUE) {
            df1 = tblParms$table(group=DBParms$group$databases, id=DBParms$databases$db$name)
            df1 = df1[,c("group", "subgroup","value")]
            colnames(df1) = c("group", "id","name")
            df2 = tblParms$table(group=DBParms$group$databases, id=DBParms$databases$db$active)
            df2 = df2[,c("group", "subgroup","value")]
            colnames(df2) = c("group", "id","active")

            df = inner_join(df1, df2, by=c("group", "id"))
            df = df[df$active != 0,]

            df[,c("id", "name")]
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
            tblParms$select(group=group, subgroup=subgroup, id = id)
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
                                   ,id = df[1,"id"])
                }
                db$commit()
            },error = function(cond) {
                db$rollback()
            })
        }

    )
    ,private = list(
        cfg           = NULL
       ,db            = NULL
       ,tblParms      = NULL
       ,tblCurrencies = NULL
       ,tblProviders  = NULL
       ,splitKeys = function(id) { as.integer(strsplit(id, " ", fixed=TRUE)[[1]]) }
       ,checkParameterType = function (value, type) {
           if (type == 10 && !is.integer(value)) stop("Debe ser numerico")
           if (type == 11 && !is.numeric(value)) stop("Debe ser numerico")
           if (type == 20) {}  #JGG Tirar de as.boolean
           #JGG etc
       }
    )
)

