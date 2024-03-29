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
YATATable = R6::R6Class("YATA.TABLE"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = FALSE
   ,public = list(
       name      = NULL
      ,dfCurrent = NULL   # Selected data
      ,current   = NULL   # Registro activo
      ,metadata  = NULL
      ,err       = NULL
      ,db        = NULL
      ,base      = NULL
      ,initialize  = function(name, tblName, fields, key=c("id"), db=NULL)    {
          self$name       = name
          private$tblName = tblName
          private$fields  = fields
          private$key     = key
          self$db         = db
      }
      ,print          = function() { cat(self$name)  }
      ,getDB          = function() { self$db         }
      ,getDBTableName = function() { return(tblName) }
      ,getColNames    = function() { fields          } # used by partitions
      ,translateColNames = function(yataNames) {
          pos = match(yataNames, names(fields))
          unlist(fields[pos])
      }
      ,selected = function() { .selected }
      ,loadAll  = function() {
         private$dfa = table()
         private$loaded = TRUE
         invisible(self)
      }
      ,load     = function(...) {
         filter = mountWhere(...)
         if (is.null(filter$values)) return (loadAll())
         private$dfa = table(...)
         private$loaded = TRUE
         invisible(self)
      }
      ,apply    = function(isolated = FALSE) {
          items = which(private$changed == TRUE)
          if (length(items) == 0) return()

          changes = self$current[names(private$changed)[items]]
          hasKeys = which(private$key %in% names(changes))
          if (length(hasKeys) > 0) changes[private$key] = NULL

          cols   = fields[names(changes)]
          cols   = paste(paste(cols, "= ?"), collapse=",")
#JGG Viejo?          cols   = sub(",$", "", cols)

          filter = mountWhere(self$current[private$key])

          sql    = paste("UPDATE ", tblName, "SET")
          sql    = paste(sql, cols, filter$sql)
          db$execute(sql, YATATools::list_merge(changes, filter$values), isolated)
          private$changed = list()
      }
      ,set      = function(...) {
          args = YATATools::args2list(...)
          lapply(names(args), function (field) setField(field, args[[field]]))
          invisible(self)
      }
      ,setField = function(field, value) {
         if (is.null(current))
             yataErrorLogical("No register active", action="Set field", origin=tblName)
         if (field %in% key) return (invisible(self))
         if (is.na(value))   return (invisible(self)) # NA genera ERROR
         if (field %in% names(current)) {
             val = current[[field]]
             if (is.na(val) || is.null(val)) {
                 self$current[field] = value
                 private$changed[field] = TRUE
             } else {
                 if (current[[field]] != value) {
                     self$current[[field]] = value
                     private$changed[field] = TRUE
                 }
             }
         }
         invisible(self)
      }
      ,getField = function(name)         { self$current[[name]] }
      ,addField = function(name, value)  { self$current[[name]] = self$current[[name]] + value }
      ,select   = function(..., create=FALSE, order = NULL, limit=0)  {
          # selecciona un registro o conjunto, segun los parametros (solo equal)
          # Devuelve si se ha seleccionado/creado y activa current
         created = TRUE

         reset()
         filter = mountWhere(...)
         qry = paste("SELECT * FROM ", tblName, filter$sql)
         qry = add_order(qry, order)
         if (limit > 0) {
             filter$values = YATATools::list_append_list(filter$values, limit_=limit)
             qry = paste(qry, "LIMIT ?")
         }
         df = db$query(qry, params=filter$values)

         if (nrow(df) == 0 && !create) return (FALSE)
         if (nrow(df) == 0 &&  create) {
             created = TRUE
             self$add(list(...))
             select(..., create=FALSE, limit=limit)

         } else {
            self$dfCurrent    = setColNames(df)
            self$current      = as.list(self$dfCurrent[1,])
         }
         created
      }
      ,recordset = function(..., limit = 0) {
         # A falta de nombre mejor
         filter = mountClause(...)
         if (length(filter$values) > 0) filter$values = unlist(filter$values)
         qry = paste("SELECT * FROM ", tblName, filter$sql)
         if (limit > 0) {
             filter$values = YATATools::list_append_list(filter$values, limit_=limit)
             qry = paste(qry, "LIMIT ?")
         }
         df = db$query(qry, params=filter$values)
         setColNames(df)
      }
      ,ordered = function(..., limit = 0) {
         filter = list(name=NULL, values = NULL)
         sorts = ""
         args = list(...)
         for (idx in 1:length(args)) {
             arg = args[[idx]]
             argl = tolower(arg)
             if (argl == "asc" || argl == "desc") {
                 sorts = paste(sorts, toupper(argl))
                 next
             }
             fld = fields[arg]
             if (is.null(fld)) next
             if (nchar(sorts) > 0) sorts = paste(sorts, ",")
             sorts = paste(sorts, fld)
         }
         qry = paste("SELECT * FROM ", tblName)
         if (length(sorts)) qry = paste(qry, "ORDER BY", sorts)
         if (limit > 0) {
             filter$values = limit
             qry = paste(qry, "LIMIT ?")
         }
         df = db$query(qry, params=filter$values)
         setColNames(df)
      }

      ,first    = function(...) {
         filter = mountWhere(...)
         qry = paste("SELECT * FROM ", tblName, filter$sql)
         filter$values = YATATools::list_append_list(filter$values, limit_=1)
         qry = paste(qry, "LIMIT ?")
         db$query(qry, params=filter$values)
      }
      ,delete   = function(..., isolated=FALSE)  {
         filter = mountWhere(list(...))
         sql = paste("DELETE FROM ", tblName, filter$sql)
         df = db$execute(sql, filter$values)
         invisible(self)
      }
      ,deleteUntil = function(..., equal = FALSE, isolated=FALSE) {
          # Borra registro por la clave primera < o <=
          filter= makeWhereGL(gt=FALSE,equal=equal,...)
          sql = paste("DELETE FROM ", tblName, filter$sql)
          df = db$execute(sql, filter$values, isolated=isolated)
          invisible(self)
      }
      ,deleteFrom = function(..., equal = FALSE, isolated=FALSE) {
          # Borra registro por la clave primera < o <=
          filter= makeWhereGL(gt=TRUE,equal=equal,...)
          sql = paste("DELETE FROM ", tblName, filter$sql)
          df = db$execute(sql, filter$values, isolated=isolated)
          invisible(self)
       }
      ,bulkAdd  = function(data, append=TRUE, isolated=FALSE) {
         colnames(data) = fields[colnames(data)]
         db$write(tblName, data, append, isolated)
      }
      ,from     = function( ..., equal=FALSE) {
          filter= makeWhereGL(gt=TRUE,equal=equal,...)
          qry = paste("SELECT * FROM ", tblName, filter$sql)
          df = db$query(qry, params=filter$values)
          setColNames(df)
      }
      ###############################################
      # Operaciones sobre la tabla
      ##############################################
      ,queryRaw  = function(sql,params=NULL) {
          # db$query(sql, params=params)
          setColNames(db$query(sql, params=params))
      }
      ,execRaw   = function(sql,params=NULL,isolated = FALSE) {
         db$execute(sql, params=params, isolated = isolated)
      }
      ,sql     = function(sql,...) {
         params = NULL
         args = list(...)
         stmt = paste(sql, "FROM", tblName)
         if (!is.null(args$where)) {
             filter = mountWhere(args$where)
             params = filter$values
             stmt = paste(stmt, filter$sql)
         }
         if (!is.null(args$group)) {
            grp = paste(args$group, sep=",")
            stmt = paste(stmt, "GROUP BY", grp)
         }
         setColNames(db$query(stmt, params=params))
      }
      ,raw     = function(stmt, params = NULL) { db$query(stmt, params) }
      ,query   = function(sql, ...) {
         # Query personalizada
         filter = mountWhere(...)
         df = db$query(paste("SELECT ", sql, "FROM ", tblName, filter$sql), params=filter$values)
         setColNames(df)
      }
      ,queryLimit   = function(sql, limit=1, ...) {
         # Query personalizada
         filter = mountWhere(...)
         filter$values = YATATools::list_append_list(filter$values, limit_=limit)

         qry = paste("SELECT ", sql, "FROM ", tblName, filter$sql, "LIMIT ?")
         df = db$query(qry, params=filter$values)
         setColNames(df)
      }
      ,table   = function(..., inValues=NULL, includeKeys = TRUE) {
          # Recupera los datos de la tabla completa en funcion de los params
         filter = mountWhere(..., inValues=inValues)
         sql = paste("SELECT * FROM ", tblName, filter$sql)
         df = db$query(sql, params=filter$values)
         df = setColNames(df)
         if (!includeKeys) df = df[,-getKeys(...)]
         reset()
         if (nrow(df) < 2) self$current = as.list(df)
         df
      }
      ,tableInterval   = function(from=NULL, to=NULL, ..., inValues=NULL, includeKeys = TRUE) {
          if (is.null(from)) from = as.POSIXct("2020-01-01", tz="UTC")
          if (is.null(to))   to   = as.POSIXct(Sys.time(), tz="UTC")
          # Recupera los datos de la tabla completa en funcion de los params y between tms
         filter = mountWhere(..., inValues=inValues)
         if (is.null(filter$sql)) {
            filter$sql = " WHERE TMS BETWEEN ? AND ?"
         } else {
            filter$sql = paste(filter$sql, "AND TMS BETWEEN ? AND ?")
         }
         if (is.null(filter$values)) {
            filter$values["from"] = from
            filter$values["to"]   = to
         } else {
            filter$values = YATATools::list_append_list(filter$values, from=from, to=to)
         }

         sql = paste("SELECT * FROM ", tblName, filter$sql)
         df = db$query(sql, params=filter$values)
         df = setColNames(df)
         if (!includeKeys) df = df[,-getKeys(...)]
         reset()
         if (nrow(df) < 2) self$current = as.list(df)
         df
       }
      ,tableLimit = function(..., limit=1, inValues=NULL, includeKeys = TRUE) {
          # Recupera los datos de la tabla completa en funcion de los params
         filter = mountWhere(..., inValues=inValues)
         if (is.null(filter$values)) {
            filter$values[limit_] = limit
         } else {
            filter$values = YATATools::list_append_list(filter$values, limit_=limit)
         }
         sql = paste("SELECT * FROM ", tblName, filter$sql, "LIMIT ?")
         df = db$query(sql, params=filter$values)
         df = setColNames(df)
         if (!includeKeys) df = df[,-getKeys(...)]
         reset()
         if (nrow(df) == 1) self$current = as.list(df)
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
          tryCatch({
              insert(data, isolated)
          }, SQL = function (cond) {
              browser()
              if (!db$SQLDuplicated(cond)) YATATools::propagateError(cond)
              self$select(private$key)
              self$set(data)
              self$apply()

          })
          invisible(self)
      }
      ,insert     = function(data, isolated=FALSE) {
          # solo inserta
          if (missing(data)) data = self$current
          if (is.data.frame(data)) data = as.list.data.frame(data)

          self$current = data
          private$changed = list()

          fields = YATATools::list_clean(private$fields[names(data)])
          values = YATATools::list_clean(data[names(fields)])
          names(values) = private$fields[names(values)]
          db$insert(tblName, values, isolated)
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
      ,max    = function(field, ..., inValues=NULL) {
          filter = mountWhere(..., inValues=inValues)
          sql = paste("SELECT MAX(", fields[field], ") FROM ", tblName, filter$sql)
          df = db$query(sql, params=filter$values)
          if (nrow(df) == 0) return (NULL)
          df[1,1]
       }

      ,update  = function(lstValues, ..., isolated=FALSE) {
          sql = paste("UPDATE ", tblName, "SET")
          cols = fields[names(lstValues)]
          cols = paste(paste(cols, "= ?"), collapse=",")
          cols = sub(",$", "", cols)

          filter = mountWhere(...)

          sql = paste(sql, cols, filter$sql)
          db$execute(sql, params=YATATools::list_merge(lstValues, filter$values), isolated=isolated)
      }
      ,updateSelected  = function(values, isolated=FALSE) {
          sql = paste("UPDATE ", tblName, "SET")
          cols = fields[names(values)]
          cols = paste(paste(cols, "= ?"), collapse=",")
          cols = sub(",$", "", cols)

          filter = mountWhere(self$current[private$primaryKey])

          sql = paste(sql, cols, filter$sql)
          executeUpdate(sql, params=YATATools::list_append(values, filter$values), isolated=isolated)
      }

      ,refresh = function(method = NULL, ...) {
        if (is.null(self$dfa)) { # dfa tiene todo, no tiene sentido refrescarlo
              ##JGG mirar con substitute
              #params = as.list(...)
              # Cargar por tabla
              if (is.null(method))  {
                  method = "loadTable"
                  params = list(self$table)
              }
              self$dfa = do.call(method, params)
              self$dfCurrent  = self$dfa
          }
          invisible(self)
      }
      ,setData     = function(df)            { self$dfa = df; self$dfCurrent=df; invisible(self) }
      ,emptydf = function() {
          dfempty = data.frame(matrix(ncol=length(fields), nrow=0))
          colnames(dfempty) = names(fields)
          dfempty
      }
      ,setColNames = function(df) {
          if (is.null(df)) return (df)
          pos = match(colnames(df), fields)
          colnames(df) = names(fields)[pos]
          self$dfCurrent = df
          df
      }
   )
   ,private = list(
       tblName = NULL   # Nombre fisico de la tabla
      ,fields  = NULL   # Nombres de las columnas de la tabla
      ,changed = list() # Lista de campos cambiados en el registro activo
      ,key     = c("id")   # Indice primario
      ,dfa     = NULL  # All data
      ,loaded  = FALSE   # Datos cargados?
      ,filtered = FALSE # Los datos estan filtrados
      ,.selected = FALSE
      ,mountWhere = function(..., inValues=NULL) {
          #devuelve una lista de 2: sql la parte WHERE y values los valores
          cond  = ""
          data = makeList(...)
          if (is.null(data) && is.null(inValues)) return (list(sql=NULL, values=NULL))
          values = YATATools::list_clean(data)
          if (is.null(values) && is.null(inValues))     return (list(sql="", values=NULL))
          if (length(values) == 0 && is.null(inValues)) return (list(sql="", values=NULL))
          if (!is.null(values) && length(values) > 0) {
              marks = lapply(values, function(x) " = ?") # Montar la secuencia campo = ? ...
              cond = asString(paste(fields[names(values)], marks), " AND ")
          }

          if (!is.null(inValues)) {
              marks  = lapply(inValues, function(x) asString(rep("?", length(x)), ","))
              stmt   = paste(fields[names(marks)], "IN (", marks, ")")
              stmt   = asString(stmt, " AND ")
              values = c(values, unlist(inValues))

              if (nchar(cond) > 0) cond = paste(cond, "AND")
              cond = paste(cond, stmt)
          }
          list(sql=paste("WHERE", cond),values=values)
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
           values        = YATATools::list_clean(data)
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
       ,reset = function() {
          private$changed = list()
          self$current = NULL
       }
      ,makeWhereGL = function (gt, equal, ...){
          # Primer campo es el que no va por =
          data=list(...)
          key = data[1]
          data[1] = NULL
          filter = mountWhere(data)
          match = ifelse(gt, ">", "<")
          if (equal) match = paste0(match, "=")
          prfx = paste("WHERE", fields[names(key)], match, "?")
          if (nchar(filter$sql) > 0) {
              filter$sql = paste(filter$sql, sub("WHERE", "AND", prfx, fixed=TRUE))
          } else {
              filter$sql = prfx
          }
          filter$values = append(filter$values, key)
          filter
      }
      ,mountClause = function(...) {
         parseParameter = function (item) {
            if (is.null(item$op)) item$op = "eq"
            op = tolower(item$op)
            col = item$name

            if (!is.null(item$func)) {
               col = paste(item$func, "(", col, ")")
            }
            if (length(item$value) == 1 && tolower(item$value) == "null") {
                if (op == "eq") return (list(sql = paste(col, "IS NULL"),     parms = NULL))
                if (op == "ne") return (list(sql = paste(col, "IS NOT NULL"), parms = NULL))
            }
            if (op == "eq") return (list(sql = paste(col, "=  ?"), parms = item$value))
            if (op == "ne") return (list(sql = paste(col, "<> ?"), parms = item$value))
            if (op == "gt") return (list(sql = paste(col, ">  ?"), parms = item$value))
            if (op == "ge") return (list(sql = paste(col, ">= ?"), parms = item$value))
            if (op == "lt") return (list(sql = paste(col, "<  ?"), parms = item$value))
            if (op == "le") return (list(sql = paste(col, "<= ?"), parms = item$value))
            if (op == "between") return (list(sql = paste(col, "BETWEEN ? AND ?"), parms = item$value))
            if (op == "in") {
                sql = paste(col, "IN (", paste(rep("?", length(item$value)), collapse=","), ")")
                parms = unlist(item$value)
                return (list(sql = sql, parms = parms))
            }
            stop(paste("Invalid op type in query:", op, "on", item$name))
          }

          data = list(...)
          if (length(data) == 0) return (list(sql=NULL, values=NULL))
          labels = names(data)

          fillName = function (idx) {
             item = data[[idx]]
             if (is.null(item$name)) {
                if (is.na(labels[idx]) || nchar(labels[idx]) == 0) return (NULL)
                item$name = labels[idx]
             }
             item$name = fields[[item$name]]
             item
          }

          # Aplica el nombre de la columna
          ndata = lapply(1:length(data), function(idx) fillName(idx))
          # Monta las partes de la clausula WHERE
          parms = lapply(ndata, parseParameter)
          cond = paste(sapply(parms, function(item) item$sql), collapse = " AND ")
          values = lapply(parms, function(item) item$parms)
          list(sql=paste("WHERE", cond),values=values)
       }
      ,add_order = function (qry, order) {
          flds = NULL
          if (is.null(order)) return (qry)
          for (idx in 1:length(order)) {
              item = order[[idx]]
              if (!is.list(item)) {
                  fld = fields[item]
                  if (!is.null(fld)) flds = c(flds, fld)
              } else {
                  fld = fields[item$name]
                  if (!is.null(fld)) {
                      clause = fld
                      if (!is.null(item$asc) && item$asc == FALSE) clause = paste(clause, "DESC")
                      flds = c(flds, clause)
                  }
              }
          }
          paste(qry, "ORDER BY", paste(flds, collapse = ","))
      }

   )
)
