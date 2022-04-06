TBLParameters = R6::R6Class("TBL.PARMS"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,public = list(
        initialize = function(name, db=NULL) {
            super$initialize(name, fields=private$fields, key=private$key, db=db)
        }
        ####################################################
        ### Generic methods by ID
        ####################################################
        ,groupAsList = function(group) {
            parms = list()
            block = NULL
            blk = -1
            df = table(group=group)
            for (row in 1:nrow(df)) {
                if (df[row, "subgroup"] != blk) {
                    blk = df[row, "subgroup"]
                    if (!is.null(block)) {
                        lbl = ifelse(is.null(block$label), block$name, block$label)
                        parms[[lbl]] = block
                    }
                    block = list()
                }
                block[df[row, "name"]] = applyType(df[row,"value"], df[row,"type"])
            }
            lbl = ifelse(is.null(block$label), block$name, block$label)
            parms[[lbl]] = block
            parms
        }
        ,applyType = function(value, type) {
             if (type == DBDict$types$integer) return (as.integer(value))
             if (type == DBDict$types$numeric) return (as.numeric(value))
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
        ,getSubGroup = function(group, subgroup) { table(group=group, subgroup=subgroup) }
        ,getByName   = function(name)            { table(name = name) }
        ####################################################
        ### Generic methods by subgroup
        ####################################################
        ,getSubgroup = function(group, subgroup) {
            df = table(grupo=group, subgroup=subgroup)
            lst = lapply(df$value, function(x) applyType())
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
        ####################################################
        ### Friendly methods
        ####################################################
        ,getDatabases = function() {
            # Devuelve la lista de bases de datos
            ids = uniques( "subgroup", list(group=DBParms$databases$id))
            uniques( list("subgroup", "value")
                    ,list(group = DBParms$databases$id, subgroup=ids, id = DBParms$databases$keys$name))
        }
        ,getDBInfo    = function(id) {
            # Recupera la informacion de la conexion de base de datos
            df = table(group=DBParms$groups$databases, subgroup = id)
        }
        ####################################################
        ### Updates
        ####################################################
        ,setByName = function(name, value) {
            update(value=as.character(value), )
        }
     )
     ,private = list (
           key = c("group", "subgroup", "id")
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
