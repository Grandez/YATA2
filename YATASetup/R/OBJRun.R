YATARUN = R6::R6Class("YATA.R6.RUN"
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,portable   = FALSE
   ,public = list(
       install = function(pkg) {
          args = c('CMD', 'INSTALL', '--no-multiarch', '--with-keep.source', pkg)
          processx::run( 'R', args, TRUE,Sys.getenv("YATA_ROOT"))
       }
       ,copy = function(src, dst) {
          processx::run( 'cp', c(src, dst), TRUE)
       }
       ,chmod = function(what, mode) {
           processx::run( 'chmod', c(mode, what), TRUE)
       }
       ,copy2site = function(pkgs) {
           libuser = Sys.getenv("R_LIBS_USER")
           libsite = Sys.getenv("R_LIBS_SITE")
           lapply(pkgs, function (pkg) {
               from = file.path(libuser, pkg)
               to   = file.path(libsite, pkg)
               file.copy(from, to, overwrite=TRUE, recursive = TRUE)
           })
       }
       ,copy2web = function(pkgs) {
           libuser = Sys.getenv("YATA_ROOT")
           libweb  = Sys.getenv("R_LIBS_SHINY")
           lapply(pkgs, function (pkg) {
               from = file.path(libuser, pkg)
               to   = file.path(libweb, pkg)
               file.copy(from, to, overwrite=TRUE, recursive = TRUE)
           })
       }

    )
   ,private = list(

    )
)
#proc = subprocess.Popen(['R', 'CMD', 'INSTALL', '--no-multiarch', '--with-keep.source', pkg],
