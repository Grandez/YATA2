.onAttach = function(libname, pkgname) {
   assign("YATABase", YATABase$new(), envir = .GlobalEnv)
}
