update_handler = function(.req, .res) {
    cat("Recibe UPDATE\n")
    message(Sys.time(), "update Called\n")
    tryCatch({
       sess = Factory$getObject(Factory$CODES$object$session)
       sess$updateLatest()
      .res$set_status_code(200)
      .res$set_content_type("text/plain")
      .res$set_body("OK\n")
      cat(Sys.time(), "UPDATE OK\n")
    }, error = function(e) {
        cat("UPDATE ERROR\n")
        message(Sys.time(), "UPDATE ERROR")
        message(Sys.time(), e)
      .res$set_status_code(500)
      .res$set_content_type("text/plain")
      .res$set_body(e)
    })
    .res
}
