number2string = function(value, dec, round=FALSE) {
    decimals = NULL
    if (!missing(dec)) decimals = dec
    if (round) {
        if (value > 100) {
            value = round(value)
        }
    }
    format(value, digits=decimals, big.mark=".", decimal.mark=",", mode="character")
}
percentage2string = function(value, calc=FALSE, dec=2, symbol=TRUE) {
    if (calc) {
        if (value >= 1) {
            value = value - 1
        } else if (value <  1 && value > 0) {
            value = (1 - value) * -1
        }
    }
    txt = format(value * 100, digits=dec, big.mark=".", decimal.mark=",", mode="character")
    sfx = ifelse(symbol, " %","")
    sprintf("%s%s", txt, sfx)
}
