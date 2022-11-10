result = function(rc, ok="OK", ko="KO") {
    if (rc == 0)
        cat(crayon::bold(paste0("\t", ok)))
    else
        cat(crayon::red(paste0("\t", ko)))
    cat("\n")
    FALSE
}
print = function(level = 0, txt) {
    if (level > 0) cat(paste0(rep("    ", level, sep="",collapse="")))
    cat(txt)
}
println = function(level = 0, txt) {
    print(level, txt)
    cat("\n")
}
fail = function (message) {
    cat(crayon::red(message))
    stop()
}
checkRecord = function (object, current, target) {
    lapply(names(target), function (field) {
        if (is.null(current[[field]])) fail(sprintf("%s: No hay valor para %s", object, field))
        tgt  = as.character(target[[field]])
        real = as.character(current[[field]])
        if (tgt != real) fail(sprintf("%s: Error en %s - Objetivo: %s. Real: %s", object, field, tgt, real))
    })
}
