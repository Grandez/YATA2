getLatest = function(mode="batch") {
    browser()
    fact = YATACore::YATAFACTORY$new()
    session = fact$getObject(fact$codes$object$session)
    res = session$updateLatest()

}
