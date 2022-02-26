titleCase = function(texts, locale="es") { stringr::str_to_title(texts, locale) }
toLower   = function(texts) { base::tolower(texts) }
toUpper   = function(texts) { base::toupper(texts) }

msg <- function (..., out=stdout(), domain = NULL, appendLF = TRUE)  {
    args <- list(...)
    cond <- if (length(args) == 1L && inherits(args[[1L]], "condition")) {
        if (nargs() > 1L)
            warning("additional arguments ignored in message()")
        args[[1L]]
    }
    else {
        msg <- .makeMessage(..., domain = domain, appendLF = appendLF)
        call <- sys.call()
        simpleMessage(msg, call)
    }
    defaultHandler <- function(c) {
        cat(conditionMessage(c), file = out, sep = "")
    }
    withRestarts({
        signalCondition(cond)
        defaultHandler(cond)
    }, muffleMessage = function() NULL)
    invisible()
}
