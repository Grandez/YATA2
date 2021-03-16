.scriptSQL = function(script, connInfo) {
    cmd = "mysql"
    if (!missing(connInfo)) {
        cmd = paste(cmd, paste0("--defaults-extra-file=", connInfo))
    }
    cmd = paste(cmd, paste0("-e '", script, "'"))
    rc = system(cmd, intern = FALSE,
                ignore.stdout = FALSE, ignore.stderr = FALSE,
                wait = TRUE, input = NULL, show.output.on.console = TRUE,
                minimized = FALSE, invisible = TRUE, timeout = 0)
}
.deleteFiles = function(...) {
    files = list(...)
    files = unlist(files)
    if (length(files) > 0) {
        for (f in files) {
           if (file.exists(f)) file.remove(f)
        }
    }
}
