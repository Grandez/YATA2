YATARUN = R6::R6Class("YATA.R6.RUN"
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,portable   = FALSE
   ,active = list(
       wd = function(value) {
           if (missing(value)) {
               return (.wd)
           } else {
               private$.wd = value
           }
       }
   )
   ,public = list(
        install    = function(pkg) {
          args = c('CMD', 'INSTALL', '--no-multiarch', '--with-keep.source', pkg)
          processx::run( 'R', args, TRUE, Sys.getenv("YATA_ROOT"))
       }
       ,copy       = function (src,  dst,     su = NULL) { .copy      (su, FALSE, src, dst)   }
       ,copyx      = function (src,  dst,     su = NULL) { .copy      (su, TRUE, src, dst)    }
       ,copyExe    = function (src,  dst,     su = NULL) { .copyExe   (su, FALSE, src, dst)   }
       ,copyExex   = function (src,  dst,     su = NULL) { .copyExe   (su, TRUE, src, dst)    }
       ,chmod      = function (what, mode,    su = NULL) { .chmod     (su, FALSE, what, mode) }
       ,chmodx     = function (what, mode,    su = NULL) { .chmod     (su, TRUE, what, mode)  }
       ,command    = function (cmd,  args="", su = NULL) { .command(su, FALSE, cmd,args)    }
       ,commandx   = function (cmd,  args="", su = NULL) { .command(su, TRUE,  cmd,args)    }
       ,copyFile   = function (file, from, to, mode=NULL, su = NULL) {
           .copyFile(su, FALSE, file, from, mode)
       }
       ,copyFilex  = function (file, from, to, mode=NULL, su = NULL) {
           .copyFile(su, TRUE, file, from, mode)
        }

       # ,wait = function(program, args = NULL, su = NULL) {
       #     if (!is.null(su)) {
       #         processx::run( 'echo', c(su, paste(" | sudo -S", program)), FALSE)
       #     } else {
       #         processx::run( program, args, FALSE)
       #     }
       # }
       ,copy2site = function(pkgs) {
           libuser = Sys.getenv("R_LIBS_USER")
           libsite = Sys.getenv("R_LIBS_SITE")
           lapply(pkgs, function (pkg) {
               from = file.path(libuser, pkg)
               to   = file.path(libsite, pkg)
               file.copy(from, to, overwrite=TRUE, recursive = TRUE)
           })
       }
       ,copy2web  = function(pkgs) {
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
       .wd = NULL
       ,.copy      = function (su, excep, src, dst) {
           if (!is.null(su)) {
               processx::run( 'echo', c(su, paste(" | sudo -S cp", src, dst)), excep, .wd)
           } else {
               processx::run( 'cp', c(src, dst), excep, .wd)
           }
       }
       ,.copyExe   = function (su, excep, src, dst) {
           .copy (su, excep, src, dst)
           .chmod(su, excep, dst, 775)
       }
       ,.chmod     = function (su, excep, what, mode) {
           if (!is.null(su)) {
               processx::run( 'echo', c(su, paste(" | sudo -S chmod", mode, what)), excep, .wd)
           } else {
               processx::run( 'chmod', c(mode, what), excep, .wd)
           }
       }
       ,.copyFile  = function (su, excep, file, from, to, mode=NULL) {
           org = paste(from, file, sep="/")
           dst = paste(to,   file, sep="/")
           if (!is.null(su)) {
               processx::run( 'echo', c(su, paste(" | sudo -S cp", org, dst)), excep, .wd)
               if (!is.null(mode)) {
                   processx::run( 'echo', c(su, paste(" | sudo -S chmod", mode, dst)), excep, .wd)
               }
           } else {
               processx::run( 'cp', c(org, dst), excep, .wd)
               if (!is.null(mode)) processx::run( 'chmod', c(mode, dst), excep, .wd)
           }
       }
       ,.command   = function (su, excep, cmd, args) {
           if (!is.null(su)) {
               processx::run( 'echo', c(su, paste(" | sudo -S", cmd, args)), excep, .wd)
           } else {
               processx::run( cmd, args, excep, .wd)
           }
       }
    )
)
#proc = subprocess.Popen(['R', 'CMD', 'INSTALL', '--no-multiarch', '--with-keep.source', pkg],
