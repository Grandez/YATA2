.getParm = function(req, parm, default) {
    p  = req$parameters_query[[parm]]
    ifelse(is.null(p), dafult, p)
}
post_begin = function(.req, .res) {
    interval = .req$parameters_query[["interval"]]
    alive    = .req$parameters_query[["alive"]]
    if (is.null(interval)) interval = ""
    if (is.null(alive))    alive    = ""

    if (.Platform$OS.type != "windows") {
        processx::run( '/srv/yata/bin/yata_mqcli', c("start", interval, alive), FALSE)
    }
   .res$set_status_code(200)
   .res$set_body("OK")
}
post_end = function(.req, .res) {
    if (.Platform$OS.type != "windows") {
        processx::run( '/srv/yata/bin/yata_mqcli', "stop", FALSE)
    }
   .res$set_status_code(200)
   .res$set_body("OK")
}
