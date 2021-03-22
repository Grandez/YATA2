logger = function(endp, beg=TRUE) {
    cat(paste(format(Sys.time(), "%H:%M:%S"), endp, ifelse (beg, "Started", "Ended"), "\n"))
}
best_body = function(top, count, best) {
    logger("best")
    tryCatch({
    fact = YATACore::YATAFACTORY$new()
    sess = fact$getObject(fact$codes$object$session)
    res = sess$getBest(top, count, best)
    fact$clear()
    logger("best", FALSE)
    res
    }, error = function(e) print("ERROR en best: ", e, "\n"))
}
latest_body = function() {
    tryCatch({
    logger("latest")
    fact = YATACore::YATAFACTORY$new()
    sess = fact$getObject(fact$codes$object$session)
    res = sess$getLatest()
    fact$clear()
    res
    logger("latest", FALSE)
}, error = function(e) print("ERROR en latest: ", e, "\n"))
}
update_body = function() {
    tryCatch({
    logger("update")
    fact = YATACore::YATAFACTORY$new()
    sess = fact$getObject(fact$codes$object$session)
    res = sess$updateLatest()
    fact$clear()
    logger("update", FALSE)
}, error = function(e) print("ERROR en update: ", e, "\n"))
}

hist_body = function(id, from, to) {

    tryCatch({
    logger("hist")
    fact = YATACore::YATAFACTORY$new()
    sess = fact$getObject(fact$codes$object$session)
    res = sess$getHistorical("EUR", id,from,to)
    fact$clear()
    res
}, error = function(e) print("ERROR en Hist: ", e, "\n"))
}

execLatest = function() {
    fact = YATACore::YATAFACTORY$new()
    session = fact$getObject(fact$codesodes$object$session)
    res = session$updateLatest()
    fact$clear()
    res
}
