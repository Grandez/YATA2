YATARUN = R6::R6Class("YATA.R6.RUN"
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,portable   = FALSE
   ,public = list(
       install = function(pkg) {
          args = c('CMD', 'INSTALL', '--no-multiarch', '--with-keep.source', pkg)
          processx::run( 'R', args, TRUE,Sys.getenv("YATA_ROOT"))
       }
       ,copy = function(src, dst, su = NULL) {
           if (!is.null(su)) {
               processx::run( 'echo', c(su, paste(" | sudo -S cp", src, dst)), TRUE)
           } else {
               processx::run( 'cp', c(src, dst), TRUE)
           }
       }
       ,chmod = function(what, mode, su = NULL) {
           if (!is.null(su)) {
               processx::run( 'echo', c(su, paste(" | sudo -S chmod", mode, what)), TRUE)
           } else {
               processx::run( 'chmod', c(mode, what), TRUE)
           }
       }
       ,copyFile(file, from, to, mode=NULL), su = NULL) {
           org = paste(from, file, sep="/")
           dst = paste(to,   file, sep="/")
           if (!is.null(su)) {
               processx::run( 'echo', c(su, paste(" | sudo -S cp", org, dst)), TRUE)
               if (!is.null(mode)) {
                   processx::run( 'echo', c(su, paste(" | sudo -S chmod", mode, dst)), TRUE)
               }
           } else {
               processx::run( 'cp', c(org, dst), TRUE)
               if (!is.null(mode)) processx::run( 'chmod', c(mode, dst), TRUE)
           }
        }
       ,wait = function(program, args = NULL, su = NULL) {
           if (!is.null(su)) {
               processx::run( 'echo', c(su, paste(" | sudo -S", program)), FALSE)
           } else {
               processx::run( program, args, FALSE)
           }
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
