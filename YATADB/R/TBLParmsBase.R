TBLParms = R6::R6Class("TBL.PARMS.BASE"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,public = list(
        initialize = function(name, db) {
            super$initialize(name, fields=private$fields, key=private$key, db=db)
        }
        ####################################################
        ### Generic methods by ID
        ####################################################
        ,groupAsList = function(group) {
            params = list()
            block = NULL
            blk = -1
            df = table(group=group)
            for (row in 1:nrow(df)) {
                if (df[row, "subgroup"] != blk) {
                    blk = df[row, "subgroup"]
                    if (!is.null(block)) {
                        lbl = ifelse(is.null(block$label), block$name, block$label)
                        params[[lbl]] = block
                    }
                    block = list()
                }
                block[df[row, "name"]] = applyType(df[row,"value"], df[row,"type"])
            }
            lbl = ifelse(is.null(block$label), block$name, block$label)
            params[[lbl]] = block
            params
        }
        ,applyType = function(value, type) {
             if (type == DBDict$types$integer) return (as.integer(value))
             if (type == DBDict$types$numeric) return (as.numeric(value))
             if (type == DBDict$types$date)    return (as.Date(value))
             if (type == DBDict$types$time)    return (strptime(value, tz="UTC"))
             if (type == DBDict$types$tms)     return (as.POSIXct(value, tz="UTC"))

             if (type == DBDict$types$boolean) {
                 if (is.logical(value)) return (value)
                 if (is.character(value)) {
                     if (value == "0" || value == "FALSE" || value == "false") return (FALSE)
                     return (TRUE)
                 }
                 return (ifelse(as.integer(value) == 0, FALSE, TRUE))
             }
             value
        }
        ,applyType2df = function(df, column, type) {
             if (type == DBDict$types$integer) df[,column] = as.integer(df[,column])
             if (type == DBDict$types$numeric) df[,column] = as.numeric(df[,column])
             if (type == DBDict$types$date)    df[,column] = as.Date(df[,column])
             if (type == DBDict$types$time)    df[,column] = strptime(df[,column])
             if (type == DBDict$types$tms)     df[,column] = as.POSIXct(df[,column])
             if (type == DBDict$types$boolean) df[,column] = as.logical(as.integer(df[,column]))
             df
         }

        ,getRaw      = function(group, subgroup, id) {
            df = table(group=group, subgroup=subgroup, id=id)
            if (nrow(df) == 0) {
                NULL
            }
            else {
                df$value
            }
        }
        ,getValue    = function(group, subgroup, id) {
            res = NULL
            if (missing(subgroup)) {
                keys = splitKeys(group)
                df = table(group=keys[1], subgroup=keys[2], id=keys[3])
            }
            else {
                df = table(group=group, subgroup=subgroup, id=id)
            }
            if (nrow(df) == 1) res = applyType(df[1,"value"], df[1,"type"])
            res
        }
        ,getString   = function(group, subgroup, id, default = NULL) {
            res = getValue(group, subgroup, id)
            if (is.null(res)) res = default
            res
        }
        ,getInteger  = function(group, subgroup, id, default = 0) {
            res = getValue(group, subgroup, id)
            if (is.null(res)) res = default
            res
        }
        ,getNumber   = function(group, subgroup, id, default = 0) {
            res = getValue(group, subgroup, id)
            if (is.null(res)) res = default
            res
        }
        ,getBoolean  = function(group, subgroup, id, default = FALSE) {
            res = getValue(group, subgroup, id)
            if (is.null(res)) res = default
            if (res == "0" || res == "FALSE") return (FALSE)
            TRUE
        }
        ####################################################
        ### Generic methods by subgroup
        ####################################################
        ,getByName   = function(name)            { table(name = name) }
        ,getSubgroup = function(group, subgroup, asList=FALSE) {
            df = table(group=group, subgroup=subgroup)
            if (asList) {
                data = lapply(1:nrow(df), function(row) applyType(df[row,"value"], df[row,"type"]))
                names(data) = df$name
                df = data
            }
            df
        }
        ,getBlocks = function(group) {
            df = NULL
            data = table(group = group)
            if (nrow(data) == 0) return (df)
            types = NULL
            blocks = unique(data$block)
            dft = data %>% filter(block == blocks[1])
            types = tidyr::spread(dft[,c("name", "type")], name, type)
            for (blk in blocks) {
                dft = data %>% filter(block == blk)
                dfv = dft[,c("name", "value")]
                df = rbind(df, tidyr::spread(dfv, name, value))
            }
            for (col in 1:ncol(types)) df = applyType2df(df, col, types[1,col])
            df
        }
        ,getBlock = function(group, subgroup, block) {
            if (missing(subgroup)) { # Is a dictionary key?
                keys = splitKeys(group)
            } else {
                keys = c(group, subgroup, block)
            }
            if (length(keys) == 2) {
                df = table(group=keys[1], subgroup=keys[2])
            } else {
                df = table(group=keys[1], subgroup=keys[2], block=keys[3])
            }
            df = df[,c("subgroup","name","value")]
            tidyr::spread(df,name,value)
        }
        # ####################################################
        # ### Friendly methods
        # ####################################################
        # ,getDatabases = function() {
        #     # Devuelve la lista de bases de datos
        #     ids = uniques( "subgroup", list(group=DBParms$databases$id))
        #     uniques( list("subgroup", "value")
        #             ,list(group = DBParms$databases$id, subgroup=ids, id = DBParms$databases$keys$name))
        # }
        # ,getDBInfo    = function(id) {
        #     # Recupera la informacion de la conexion de base de datos
        #     df = table(group=DBParms$groups$databases, subgroup = id)
        # }
        ####################################################
        ### Updates
        ####################################################
        # ,setByName = function(name, value) {
        #     update(value=as.character(value), )
        # }
     )
     ,private = list (
           key = c("group", "subgroup", "block", "id")
          ,fields = list(
               group     = "GRUPO"
              ,subgroup  = "SUBGROUP"
              ,block     = "BLOCK"
              ,id        = "ID"
              ,type      = "TYPE"
              ,name      = "NAME"
              ,value     = "VALUE"
              ,active    = "ACTIVE"
          )
         ,splitKeys = function(id) { as.integer(strsplit(id, " ", fixed=TRUE)[[1]]) }
     )
)
