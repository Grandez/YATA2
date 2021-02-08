# Tabla sencilla, tiene un id y posiblemente un nombre
YATATableSimple <- R6::R6Class("YATA.TABLE.SIMPLE"
   ,inherit    = YATATable
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = FALSE
   ,public = list(
       initialize = function(name, fields, key=c("id"), db=NULL)    {
          super$initialize( name, fields, key, db)
       }
      ,getTable   = function(all=FALSE, ...) {
         # Para distinguir de table,
         # Igual pero contempla el flag active
         if (all) super$table(...)
         else  {
            args = list(...)
            args = list.append(args,active=YATACodes$flag$active)
            super$table(args)
         }
      }
      ,getNames   = function(code, full = FALSE) {
         if (missing(code)) {
             df = table()
             if (full) df$name = paste(df$id, df$name, " - ")
             data = as.list(df$name)
             names(data) = df$id
             return(data)
         }
         df = table(inValues = list(id=code))
         if (nrow(df) > 0) {
             data = as.list(df$name)
             names(data) = df$id
             return (data)
         }
         NULL
      }
      ,isActive   = function() {
         if (self$current$active == 1) return (TRUE)
         FALSE
      }
   )
)
