getLatest = function(console=FALSE, log=1) {
    browser()
    begin = as.numeric(Sys.time())
    logger = YATABase::YATALogger$new("latest", console, log)
    fact = YATACore::YATAFACTORY$new()
    rc = tryCatch({
       session = fact$getObject(fact$codes$object$session)
       session$updateLatest()
    }, error = function (cond) {
        16
    })
    logger$executed(rc, elapsed=as.numeric(Sys.time()) - begin, "Executed")
    rc
}
