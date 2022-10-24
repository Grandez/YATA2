#' YATABase = R6::R6Class("YATA.BASE.BASE"
#'    ,portable  = FALSE
#'    ,cloneable = FALSE
#'    ,lock_class = TRUE
#'    ,active = list(
#'        msg   = function(value) { invisible(.msg)  }
#'       ,cond  = function(value) { invisible(.cond) }
#'       ,str   = function(value) { invisible(.str)  }
#'       ,dates = function(value) { invisible(.dat)  }
#'       ,http  = function(value) { invisible(.http) }
#'       ,id    = function(value) { self$getID()     }
#'
#'    )
#'    ,public = list(
#'       initialize = function() {
#'          private$.msg  = YATABaseMsg$new()
#'          private$.dat  = YATABaseDat$new()
#'          private$.str  = YATABaseStr$new()
#'          private$.cond = YATABaseCond$new()
#'          private$.http = YATAHTTP$new()
#'       }
#'       ,print = function() { message("Common tools and utilities for YATA")}
#'       ,ini   = function(iniFile) { YATABaseIni$new(iniFile) }
#'       ,map   = function() { invisible(YATABaseMap$new()) }
#'       ,ID    = function() { self$getID()   }
#'       ,exec  = function() { YATAExec$new() }
#' # Genera un identificador unico
#' # El EPOCH UNix da los segundos (rounded) desde 1970-01-01
#' # Quitamos Desde una fecha dada
#' # Quitamos el digito mas significativo
#' # el añadimos dos digitos y un contador estatico
#' # ESto nos dice que, dentro de un segundo: 166653 podemos tener 100 identificadores
#' # 16665300 - 16665399
#' # Si en el mismo segundo generamos 101 id
#' # 16665400 (El 3 pasa a 4) pero ese numero no se puede repetir por que en el siguiente
#' # segundo el id daria 102, con lo que seria 16665501
#' # Estos ID se pueen guardar en un int de 4 bytes sin signo:  	2147483647/4294967295
#'     ,getID = function() {
#'         epoch = as.integer(Sys.time()) - 1577836860 # Restamos el epoch desde 2020-01-01
#'         epoch = (epoch %% 1000000)                  # Quitamos el digito significativo
#'         epoch = epoch * 100                         # Le damos 2 menos significativos
#'         private$.cnt = private$.cnt + 1     # Contador estatico
#'         epoch + .cnt
#'     }
#'     #' Convierte un conjunto de parametros en una lista nombrada
#'     ,args2list = function(...) {
#'         args = list(...)
#'         if (length(args) == 0) return (NULL)
#'         if (length(args) == 1) {
#'             if ("shiny.tag" %in% class(args[[1]])) return (args)
#'             if (is.list(args[[1]])) return (args[[1]])
#'             if (is.vector(args[[1]]) && length(args[[1]]) > 1) return (as.list(args[[1]]))
#'         }
#'         args
#'      }
#'    )
#'    ,private = list(
#'       .msg   = NULL
#'       ,.str  = NULL
#'       ,.dat  = NULL
#'       ,.cond = NULL
#'       ,.http = NULL
#'       ,.cnt = 0
#'    )
#' )
