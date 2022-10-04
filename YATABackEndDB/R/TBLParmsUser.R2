TBLConfig = R6::R6Class("TBL.PARMS.USER"
    ,inherit    = TBLParms
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,public = list(
        initialize = function(name, db) { super$initialize(name, db) }
        ####################################################
        ### Friendly methods
        ####################################################
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
)
