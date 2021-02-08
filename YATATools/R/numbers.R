number2string = function(value, dec) {
    decimals = NULL
    if (!missing(dec)) decimals = dec
    format(value, digits=decimals, big.mark=".", decimal.mark=",", mode="character")
}
number2percentage = function(value, dec=2, symbol=TRUE) {
    txt = format(value * 100, digits=dec, big.mark=".", decimal.mark=",", mode="character")
    sfx = ifelse(symbol, " %","")
    sprintf("%s%s", txt, sfx)
}
