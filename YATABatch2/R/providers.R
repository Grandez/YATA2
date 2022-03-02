updateExchanges = function(verbose=3) {
    if (bitwAnd(verbose, 1)) cat("Actualizando exchanges ...")
    browser()
    tblProviders = YATAFactory$getTable("Providers", YATAEnv$getDBBase())
    data = tblProviders$table(active = YATACodes$flag$active)
    if (verbose > 1) cat("\n")
    for(rec in data) {
        browser()
        .updExch(exch, clearings[,c("id","name")], verbose)
    }
    if (bitwAnd(verbose, 1)) cat("\n")
}
.updExch = function(id, clearings, verbose) {
    # Lo hacemos lineal para controlar la transaccionalidad
    for (idx in 1:nrow(clearings)) {
        name = clearings[idx, "name"]
        code = clearings[idx, "id"]
        if (bitwAnd(verbose, 2)) cat(paste("Actualizando", name))
        prov = YATAFactory$getProvider(id=name)
        data = prov$exchanges()
        browser()
        clearing = rep(code, nrow(data))
        data = cbind(clearing, data[,c("base", "counter", "active")])
        exch$updateExchanges(code, data)
        if (bitwAnd(verbose, 2)) cat("\n")
    }
}

