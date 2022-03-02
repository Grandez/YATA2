updateEuro = function(verbose=3) {
    if (bitwAnd(verbose, 1)) cat("Actualizando cotizacion EUR ...")
    env = YATACore::YATAENV$new()
    YATAFactory$env = env
    exch = YATAFactory$getObject("Euro")
    df = exch$lastExchanges() # Me da la lista de cambios EUR/xxx
    prov = YATAFactory$getProvider(id="Euro")
    .updEuro(exch, prov,df, verbose)
    if (bitwAnd(verbose, 1)) cat("\n")
}

.updEuro = function(exch, prov, df, verbose) {
    # Lo hacemos lineal para controlar la transaccionalidad
    to = Sys.Date() - as.difftime(1, unit="days")
    for (idx in 1:nrow(df)) {
        clearing = df[idx,"base"]
        if (bitwAnd(verbose, 2)) cat(paste("Actualizando", clearing))
        from = df[idx,"tms"] + as.difftime(1, unit="days")
        diff = difftime(to, from, units = "days") # days
        if (diff > 365) to = from + as.difftime(365, unit="days")

        df = prov$exchanges(clearing, from, to)
        exch$updateExchanges(df)
        if (bitwAnd(verbose, 2)) cat("\n")
    }

}
