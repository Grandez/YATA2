asUnix    = function(date)  { as.numeric(date) }
asPosix   = function(epoch) { anytime(epoch)   }
asDate    = function(epoch) { anydate(epoch)   }

# Redondea la fecha al intervalo dado en segundos
# prev Redondea a la fecha anterior o igual
#      Redondea a la fecha posterior o igual
round2Epoch = function(date, interval, prev=TRUE) {
    org = asUnix(date)
    dif = org %% interval
    res =  org - dif
    if (!prev) res = res + interval
    res
}
round2Posix = function(date, interval, prev=TRUE) {
    org = asUnix(date)
    dif = org %% interval
    res =  org - dif
    if (!prev) res = res + interval
    as.POSIXct(res)
}
