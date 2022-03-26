startDaemons = function() {
    .startRest()
}
.startRest = function() {
    browser()
    resp = tryCatch({
       httr::GET("http://127.0.0.1:4005/alive")
    }, error = function(cond) {
        list(status_code = 500)
    })

    if (resp$status_code == 200) return()
    args = c("--default-packages=YATAREST", "-e", "'YATAREST::start(4005)'")
    resp = processx::process$new("Rscript", args=args)
    browser()

}
