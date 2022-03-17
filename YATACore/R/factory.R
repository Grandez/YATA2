getFactory = function(force = FALSE) {
    message("Getting factory")
   if (length(ls(".GlobalEnv", pattern="Factory")) == 0 || is.null(Factory)) {
       force = TRUE
   }
   if (force || !Factory$valid()) {
       message("creating Factory")
       fact = YATACore::YATAFactory$new()
       assign("Factory",   fact,       envir=.GlobalEnv)
       assign("YATACodes", fact$CODES, envir=.GlobalEnv)
   }
   Factory
}
