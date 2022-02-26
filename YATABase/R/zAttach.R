.onAttach = function(libname, pkgname) {
   assign("YATABase", YATABASE$new(), envir = .GlobalEnv)
}
