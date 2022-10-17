.getParm = function(req, parm, default) {
    p  = req$parameters_query[[parm]]
    ifelse(is.null(p), dafult, p)
}
.setResponse = function (.res, data, status) {
    rc = 200
    if (is.null(data) || nrow(data) == 0) rc = 204 # NO DATA
    # if (missing(status)) {
    #     status = list(rc=422,count=0)
    #     if (!is.null(data) && nrow(data) > 0) {
    #         status$rc = 200
    #         status$count = nrow(data)
    #     }
    # }
    .res$set_status_code(rc)
    .res$set_content_type("application/json")
    .res$set_body(jsonlite::toJSON(data, data.frame = "rows"))
}
.missingParms = function (.res, ...) {
    resp = list(message="Missing parameters", rc=400)
    resp = jgg_list_merge(resp, list(...))
    .sendError(.res, 400, resp)
}
.invalidParms = function(.res, ...) {
    resp = list(message="Invalid parameters", rc=400)
    resp = jgg_list_merge(resp, list(...))
    .sendError(.res, 400, resp)
}
.setError = function(.res, cond) {
    .sendError(.res, 500, as.list(cond))
}
.sendError = function(.res, rc, data) {
    .res$set_status_code(rc)
    .res$set_content_type("application/json")
    .res$set_body(jsonlite::toJSON(data))
}
