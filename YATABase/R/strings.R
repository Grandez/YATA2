YATABaseStr = R6::R6Class("YATA.BASE.STR"
   ,portable  = FALSE
   ,cloneable = FALSE
   ,lock_class = TRUE
   ,public = list(
       titleCase = function(texts, locale="es") { stringr::str_to_title(texts, locale) }
      ,toLower   = function(texts) { base::tolower(texts) }
      ,toUpper   = function(texts) { base::toupper(texts) }
      ,number2string = function(value, dec=-1, round=FALSE) {
          if (round && value > 100) value = round(value)
          if (dec > -1) format(value, nsmall=dec, big.mark=".", decimal.mark=",", mode="character", scientific=FALSE)
          else          format(value, big.mark=".", decimal.mark=",", mode="character", scientific=FALSE)
       }
      ,percentage2string = function(value, calc=FALSE, dec=2, symbol=TRUE) {
          if (calc) {
             if (value >= 1) {
                value = value - 1
             } else if (value <  1 && value > 0) {
                value = (1 - value) * -1
             }
          }
          txt = format(round(value * 100, dec), nsmall=dec, big.mark=".", decimal.mark=",", mode="character", scientific=FALSE)
          sfx = ifelse(symbol, " %","")
          sprintf("%s%s", txt, sfx)
       }
   )
   ,private = list(
   )
)

