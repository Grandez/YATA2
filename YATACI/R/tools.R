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
