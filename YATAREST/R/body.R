best_body = function(top, count) {
    browser()
    fact = YATACore::YATAFACTORY$new()
    sess = fact$getObject(YATACodes$object$session)
    res = sess$getBest(top, count)
    fact$clear()
    res
}
latest_body = function() {
    browser()
    fact = YATACore::YATAFACTORY$new()
    sess = fact$getObject(YATACodes$object$session)
    res = sess$getLatest()
    browser()
    fact$clear()
    res

}
execLatest = function() {
    fact = YATACore::YATAFACTORY$new()
    session = fact$getObject(YATACodes$object$session)
    res = session$updateLatest()
    fact$clear()
    res
}
