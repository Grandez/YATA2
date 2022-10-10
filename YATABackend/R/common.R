.getParm = function(req, parm, default) {
    p  = req$parameters_query[[parm]]
    ifelse(is.null(p), dafult, p)
}
.setResponse = function (res, data, status) {
    if (missing(status)) {
        status = list(rc=422,count=0)
        if (!is.null(data) && nrow(data) > 0) {
            status$rc = 200
            status$count = nrow(data)
        }
    }
    resp  = json_to(data, "data")
    stat  = json_to(status, "status")
    json = json_append(resp,stat)
    # res$set_status_code(status$rc)
    # res$set_content_type("application/json")
    # res$set_body(json)
    res$set_response(status$rc, body = json, content_type = "text/plain")
}
.setError = function(res, cond) {
    .setResponse(res, NULL, list(rc=500))
}

