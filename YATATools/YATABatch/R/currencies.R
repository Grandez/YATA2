updateCurrencies = function() {
    # Actualiza las monedas que maneja cada exchange
    # Obtiene los exchanges
    # a cada uno de ellos le aplica la lista de monedas
    fact = FactoryProvider$new()
    exch =
    lapply(getClearings(), function(clearing) .updateExch(fact, clearing))
}

.updateExch = function(fact, exchange) {
    exch = fact$get(exchange)
    ctcs = exch$currencies()
    #Borrar
    # Insertar las monedas
}
