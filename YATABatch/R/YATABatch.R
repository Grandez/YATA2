# Para los Logs usaremos un numero de dos digitos
# el primero, para el detalle
# el segundo parael sumario
# Ejemplo:  1 - Imprmir sumario simple
#          32 - Imprimir mensajes de detalle de nievl 3 y resumen de nivel 2


YATABATCH = R6::R6Class("OBJ.BATCH"
    ,cloneable  = FALSE
    ,portable   = FALSE
    ,lock_class = TRUE
    ,public = list(
        codes = NULL
        # Return codes
       ,OK  = 0
       ,NODATA = 4

       ,fact  = NULL
       ,initialize = function () {
           message("Creando YATABATCH Object")
           self$codes = YATACore::YATACODES$new()
           self$fact  = YATACore::YATAFACTORY$new()
           lvl = Sys.getenv("YATA.VERBOSE")
           if (nchar(lvl) > 0) setVerbose(lvl)
           self$begin()
       }
       ,setVerbose = function(verbose) {
           if (!missing(verbose)) {
               det = verbose %% 10
               private$msgDet = verbose %% 10
               private$msgSum = floor( verbose / 10)
           }
           invisible(self)
       }
       ,log = function(level, txt, ...) {
           if (level > 0 && level <= msgDet) {
               prfx = paste0(rep("   ",level), collapse="")
               txt = paste0(prfx,txt, collapse="")
               msg(sprintf(txt, ...))
           }
           invisible(self)
        }
       ,warn = function(txt, ...) { msg(.msg("wARNING:", txt, ...), out=stderr()) }
       ,info = function(txt, ...) { msg(.msg("INFO   :", txt, ...), out=stdout()) }
       ,err  = function(txt, ...) { msg(.msg("ERROR  :", txt, ...), out=stderr()) }
       ,cont = function(txt, ...) { msg(sprintf(paste0("        ",txt), ...), out=stderr()) }
       ,summary = function(level, txt, ...) {
          if (level <= msgSum) msg(.msg("", txt, ...))
        }
       ,begin = function() { private$tmsBeg = Sys.time()}
       ,end   = function(rc) {
           rc
       }
    )
    ,private = list(
         tmsBeg = 0
        ,tmsEnd = 0
        ,msgDet = 0
        ,msgSum = 0
        ,.msg = function(head="", txt, ...) {
           lbl = trimws(paste(head, txt))
           sprintf(lbl, ...)
        }
    )
)



