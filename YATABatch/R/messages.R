# Para los Logs usaremos un numero de dos digitos
# el primero, para el detalle
# el segundo parael sumario
# Ejemplo:  1 - Imprmir sumario simple
#          32 - Imprimir mensajes de detalle de nievl 3 y resumen de nivel 2

setVerbose = function(verbose) {
    msgDet <<- 0
    msgSum <<- 0
    if (!missing(verbose)) {
        det = verbose %% 10
        msgDet <<- verbose %% 10
        msgSum <<- floor( verbose / 10)
    } else {
        lvl = Sys.getenv("YATA.VERBOSE")
        if (nchar(lvl) > 0) {
            lvl = as.integer(lvl)
            msgDet <<- lvl %% 10
            msgSum <<- floor( lvl / 10)
        }
    }

}

log = function(level, txt, ...) {
    if (level > msgDet) return()
    if (level > 0) {
        prfx = paste0(rep("   ",level), collapse="")
        txt = paste0(prfx,txt, collapse="")
    }
    msg(sprintf(txt, ...))
}
warn = function(txt, ...) { msg(.msg("wARNING:", txt, ...), out=stderr()) }
info = function(txt, ...) { msg(.msg("INFO   :", txt, ...), out=stdout()) }
err  = function(txt, ...) { msg(.msg("ERROR  :", txt, ...), out=stderr()) }
cont = function(txt, ...) { msg(sprintf(paste0("        ",txt), ...), out=stderr()) }
summary = function(level, txt, ...) {
    if (level <= msgSum) msg(.msg("", txt, ...))
}

.msg = function(head="", txt, ...) {
    lbl = trimws(paste(head, txt))
    sprintf(lbl, ...)
}
