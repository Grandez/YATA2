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

elapsed <- function(start, end) {
  dsec <- as.numeric(difftime(end, start, unit = "secs"))
  hours <- floor(dsec / 3600)
  minutes <- floor((dsec - 3600 * hours) / 60)
  seconds <- dsec - 3600*hours - 60*minutes
  paste0(
    sapply(c(hours, minutes, seconds), function(x) {
      formatC(x, width = 2, format = "d", flag = "0")
    }), collapse = ":")
}
