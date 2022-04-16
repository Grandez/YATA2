# Emula un factor o una enumeracion
FTARGET <- R6::R6Class("FTARGET",
    public = list(
         value  = 0
        ,name   = "None"
        ,select = TRUE  # Para el combo, acepta cambiar el target
        ,size   = 6
        ,NONE   = 0
        ,OPEN   = 1
        ,CLOSE  = 2
        ,HIGH   = 3
        ,LOW    = 4
        ,VOLUME = 5
        ,MACD   = 6
        ,names  = c("Open", "Close", "High", "Low", "Volume", "MACD")
        ,initialize = function(tgt = 0) { self$value = as.integer(tgt) }
        ,print = function() { cat(self$value) }
        ,setValue = function (val) {
            nVal       = as.integer(val)
            self$value = nVal
            self$name  = self$names[nVal]
        }
        ,getName = function(id = 0) {
            if (id == 0) id = self$value
            self$names[id]
        }
        ,getCombo = function(none = F) {
            start = ifelse(none, 0, 1)
            nm = self$names
            if (none) nm = c("None", nm)
            values = seq(start, self$size)
            names(values) = nm
            values
        }

     )
)

