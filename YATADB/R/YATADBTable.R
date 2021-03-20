# Clase base de los ficheros y tablas
# Emula una tabla y maneja 3 conceptos
#
# dfa    = data frame con la tabla por defecto o completa
# df     = Conjunto de registros activos
# current = registro activo
#
# Registro activo
#    select
#    apply
#    setField
#    getField
#    set
#    getById
#    getByName
# Metodos
#   table - Obtiene la tabla segun filtros
#   load  - Carga la tabla con filtros
#   loadAll - Carga la tabla sin filtros
YATATable <- R6::R6Class("YATA.TABLE"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = FALSE
   ,public = list(
       name      = NULL
      ,dfCurrent = NULL   # Selected data
      ,current   = list()   # Registro activo
      ,metadata  = NULL
      ,err       = NULL
      ,initialize  = function(name, fields, key=c("id"), db=NULL)    {
          self$name       = name
          private$tblName = DBDict$tables[[name]]
          if (is.null(tblName)) private$tblName = DBDict$baseTables[[name]]
          private$fields  = fields
          private$key     = key
          private$db      = db
      }
      ,print       = function() { cat(self$name)                              }
      ,getDB       = function() { private$db }  # Para debug
      ,getColNames = function() { private$fields }
      ,selected    = function() { .selected }
      ,loadAll     = function() {
         private$dfa = table()
         private$loaded = TRUE
         invisible(self)
      }
      ,load        = function(...) {
         filter = mountWhere(...)
         if (is.null(filter$values)) return (loadAll())
         private$dfa = table(...)
         private$loaded = TRUE
         invisible(self)
      }
      # ,get = function() {
      #    if (!loaded) loadAll()
      #    private$dfa
      # }
      ,apply   = function(isolated = FALSE) {
          items = which(private$changed == TRUE)
          if (length(items) == 0) return()

          changes = self$current[names(private$changed)[items]]
          hasKeys = which(private$key %in% names(changes))
          if (length(hasKeys) > 0) changes[private$key] = NULL

          cols   = fields[names(changes)]
          cols   = paste(paste(cols, "= ?"), collapse=",")
          cols   = sub(",$", "", cols)

          filter = mountWhere(self$current[private$key])

          sql    = paste("UPDATE ", tblName, "SET")
          sql    = paste(sql, cols, filter$sql)
          db$execute(sql, list.merge(changes, filter$values), isolated)
          private$changed = list()
      }
      ,set      = function(...) {
          args = args2list(...)
          self$current = rlist::list.merge(self$current, args)
          lapply(names(args), function (field) private$changed[field] = TRUE)
          invisible(self)
      }
      ,setField = function(field, value) {
         # Actualiza un campo
         # marca la lista de cambiados para hacer el apply (UPDATE)
         self$current[field] = value
         private$changed[field] = TRUE
         invisible(self)
      }
      ,getField = function(name)         { self$current[[name]] }
      ,addField = function(name, value)  { self$current[[name]] = self$current[[name]] + value }
      ,select   = function(..., create=FALSE)  {
         private$.selected = FALSE
         # selecciona un registro o conjunto, segun los parametros (solo equal)
         # almacena el resultado en dfCurrent y el primero en current
         # .selected me dice donde esta: 0 - No esta,
         self$current = list()
         filter = mountWhere(...)
         sql = paste("SELECT * FROM ", tblName, filter$sql)
         df = db$query(sql, filter$values)
         if (nrow(df) == 0) {
            if (create) {
                self$add(list(...))
                df = db$query(sql, filter$values)
            }
            else {
               private$.selected = FALSE
               return (FALSE)
            }
         }
         self$dfCurrent    = setColNames(df)
         self$current      = as.list(self$dfCurrent[1,])
         private$.selected = nrow(self$dfCurrent)
         TRUE
      }
      ,delete   = function(...)  {
         filter = mountWhere(list(...))
         sql = paste("DELETE FROM ", tblName, filter$sql)
         df = db$execute(sql, filter$values)
         invisible(self)
      }
      ,bulkAdd  = function(data, append=TRUE, isolated=FALSE) {
         colnames(data) = fields[colnames(data)]
         db$write(tblName, data, append, isolated)
      }
      # ,getById   = function(id)   { getBySimpleKey("id", id) }
      # ,getByName = function(name) { getBySimpleKey("name", name) }
      ###############################################
      # Operaciones sobre la tabla
      ##############################################
      ,queryRaw  = function(sql,parms) {
         db$query(sql, params=parms)
      }
      ,execRaw   = function(sql,parms) {
         db$execute(sql, params=parms)
      }
      ,sql     = function(sql,...) {
         parms = NULL
         args = list(...)
         stmt = paste(sql, "FROM", tblName)
         if (!is.null(args$where)) {
             filter = mountWhere(args$where)
             parms = filter$values
             stmt = paste(stmt, filter$sql)
         }
         if (!is.null(args$group)) {
            grp = paste(args$group, sep=",")
            stmt = paste(stmt, "GROUP BY", grp)
         }
         setColNames(db$query(stmt, params=parms))
      }
      ,query   = function(sql, ...) {
         # Query personalizada
         filter = mountWhere(list(...))
         setColNames(db$query(paste(sql, filter$sql), params=filter$values))
      }
      ,table   = function(..., inValues=NULL, includeKeys = TRUE) {
          # Recupera los datos de la tabla completa en funcion de los parms
         filter = mountWhere(..., inValues=inValues)
         sql = paste("SELECT * FROM ", tblName, filter$sql)
         df = db$query(sql, params=filter$values)
         df = setColNames(df)
         if (!includeKeys) df = df[,-getKeys(...)]
         df
      }
      ,uniques = function(fields, ...) {
          # Obtiene una lista de valores unicos
          filter = mountWhere(...)
          if (is.list(fields)) fields = unlist(fields)
          flds = private$fields[fields]
          flds = asString(flds, ",")
          sql  = paste("SELECT DISTINCT", flds, " FROM ", tblName, filter$sql)
          setColNames(db$query(sql, filter$values))
      }
      ,add     = function(data, isolated=FALSE) {
          if (missing(data)) data = self$current
          fields = rlist::list.clean(private$fields[names(data)])
          values = rlist::list.clean(data[names(fields)])
          names(values) = private$fields[names(values)]
          db$add(tblName, values, isolated)
      }
      ,remove  = function(..., inValues=NULL, isolated=FALSE) {
         filter = mountWhere(..., inValues=inValues)
         sql = paste("DELETE FROM ", tblName, filter$sql)
         df = db$execute(sql, params=filter$values, isolated)
       }
      ,rows    = function(..., inValues=NULL) {
          filter = mountWhere(..., inValues=inValues)
          sql = paste("SELECT COUNT(*) FROM ", tblName, filter$sql)
          df = db$query(sql, params=filter$values)
          as.numeric(df[1,1])
       }
      ,update  = function(lstValues, ..., isolated=FALSE) {
          sql = paste("UPDATE ", tblName, "SET")
          cols = fields[names(lstValues)]
          cols = paste(paste(cols, "= ?"), collapse=",")
          cols = sub(",$", "", cols)

          filter = mountWhere(...)

          sql = paste(sql, cols, filter$sql)
          db$execute(sql, params=list.merge(lstValues, filter$values), isolated=isolated)
      }
      ,updateSelected  = function(values, isolated=FALSE) {
          sql = paste("UPDATE ", tblName, "SET")
          cols = fields[names(values)]
          cols = paste(paste(cols, "= ?"), collapse=",")
          cols = sub(",$", "", cols)

          filter = mountWhere(self$current[private$primaryKey])

          sql = paste(sql, cols, filter$sql)
          executeUpdate(sql, parms=list.append(values, filter$values), isolated=isolated)
      }

      ,refresh = function(method = NULL, ...) {
        if (is.null(self$dfa)) { # dfa tiene todo, no tiene sentido refrescarlo
              ##JGG mirar con substitute
              #parms = as.list(...)
              # Cargar por tabla
              if (is.null(method))  {
                  method = "loadTable"
                  parms = list(self$table)
              }
              self$dfa = do.call(method, parms)
              self$dfCurrent  = self$dfa
          }
          invisible(self)
      }
      ,setData     = function(df)            { self$dfa = df; self$dfCurrent=df; invisible(self) }
   )
   ,private = list(
       db      = NULL
      ,tblName = NULL   # Nombre fisico de la tabla
      ,fields  = NULL   # Nombres de las columnas de la tabla
      ,changed = list() # Lista de campos cambiados en el registro activo
      ,key     = c("id")   # Indice primario
      ,dfa     = NULL  # All data
      ,loaded  = FALSE   # Datos cargados?
      ,filtered = FALSE # Los datos estan filtrados
      ,.selected = FALSE
      # ,mountInsert = function(...) {
      #      data = makeList(...)
      #      values        = list.clean(data)
      #      names(values) = fields[names(values)]
      #      cols = asString(names(values), " , ")
      #      marks = paste(rep("?", length(cols)), collapse=",")
      #      stmt = paste("(", cols, ") VALUES (", marks, ")")
      #      list(sql=stmt,values=values)
      #  }
       ,mountWhere = function(..., inValues=NULL) {
           #devuelve una lista de 2: sql la parte WHERE y values los valores
           where  = ""

           data = makeList(...)
           if (is.null(data) && is.null(inValues)) return (list(sql="", values=NULL))
           values = list.clean(data)      # Quitar nulos

           if (!is.null(values)) {
               marks = lapply(values, function(x) " = ?") # Montar la secuencia campo = ? ...
               where = asString(paste(fields[names(values)], marks), " AND ")
           }

           if (!is.null(inValues)) {
               marks = lapply(inValues, function(x) asString(rep("?", length(x)), ","))
               stmt = paste(fields[names(marks)], "IN (", marks, ")")
               stmt = asString(stmt, " AND ")
               values = list.append(values, unlist(inValues))
               if (nchar(where) > 0) where = paste(where, "AND")
               where = paste(where, stmt)
           }
           list(sql=paste("WHERE", where),values=values)
       }
      ,makeList = function(...) {
           data = list(...)
           if (missing(data) || length(data) == 0)  return (NULL)
           if (length(data) == 1 && is.list(data[[1]])) data = data[[1]]
           data
      }
       ,getKeys = function(...) {
           #devuelve los campos usados como claves
           data = list(...)
           if (missing(data))      return (NULL)
           if (length(data) == 0)  return (NULL)
           if (length(data) == 1 && is.list(data[[1]])) data = data[[1]]
           values        = list.clean(data)      # Quitar nulos
           names(values)
       }
      ,getBySimpleKey = function(key, value) {
         parm = list(value)
         names(parm) = key
         getByKey(parm)
      }
      ,getByKey = function(key=NULL) {
         pkey = key
         if (is.null(pkey)) pkey = current[private$key]
         # Recupera un registro segun la clave
         # Si tiene la tabla cargada, lo busca en dfa
         # Si no hace la query
         self$dfCurrent = NULL
         # if (!is.null(private$dfa)) self$dfCurrent = private$dfa[private$dfa[key] == value,]
         # if (is.null(self$dfCurrent)) {
         filter = mountWhere(pkey)
             sql = paste("SELECT * FROM ", tblName, filter$sql)
             self$dfCurrent = db$query(sql, params=pkey)

         if (is.null(self$dfCurrent)) return(NULL)
         setColNames(self$dfCurrent)
         self$current = as.list(self$dfCurrent)
         self$current
      }
      ,setColNames = function(df) {
          if (is.null(df)) return (NULL)
          pos = match(colnames(df), fields)
          colnames(df) = names(fields)[pos]
          self$dfCurrent = df
          df
      }
      ,asString = function(data, sep) {
         if (missing(sep)) {
            paste(data)
         }
         else {
            tmp = paste(data, collapse = sep)
            sub(paste0(sep, "$"), "" , tmp)
         }
      }
      ,.asList = function(...) {
         args = list(...)
         if (length(args) == 1 && is.list(args[[1]])) {
            args[[1]]
         } else {
            args
         }


      }
   )
)
