update_handler = function(.req, .res) {
    message(Sys.time(), "update Called")
    tryCatch({
        browser()
       fact = YATACore::YATAFACTORY$new()
       sess = fact$getObject(fact$codes$object$session)
       sess$updateLatest()
      .res$set_status_code(200)
      .res$set_content_type("text/plain")
      .res$set_body("OK")
    }, error = function(e) {
      .res$set_status_code(500)
      .res$set_content_type("text/plain")
      .res$set_body(e)
    }, finally =  {
        fact$clear()
    })
    .res
}
