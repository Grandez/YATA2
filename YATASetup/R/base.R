checkEnv = function() {
    msg = YATASTD$new()
    var = Sys.getenv("YATA_ROOT")
    if (nchar(var) == 0) msg$fatal(16, "Missing environment variable YATA_ROOT")
}

processFile = function(file, objini) {
    data = readLines(file)
    toks = NULL
    regx = regexpr("__[a-zA-Z0-9]+__", data)
    if (length(regx) == 0) return (data)

    len = attr(regx, "match.length")
    toks = lapply(which(regx > -1), function(idx) {
                 substr(data[idx], regx[idx], regx[idx] + len[idx] - 1)
                 })
    toks = unique(toks)
    for (tok in toks) {
        data = gsub(tok, objini$getPattern(tok), data)
    }
    data
}
