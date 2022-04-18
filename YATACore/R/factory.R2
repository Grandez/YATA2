getFactory = function(force = FALSE) {
   if (length(ls(".GlobalEnv", pattern="Factory")) == 0 || is.null(Factory)) {
       force = TRUE
   }
   if (force || !Factory$valid()) {
       fact = YATACore::YATAFactory$new()
       assign("Factory",   fact,       envir=.GlobalEnv)
       assign("YATACodes", fact$CODES, envir=.GlobalEnv)
   }
   Factory
}
