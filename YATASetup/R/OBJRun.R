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

    )
   ,private = list(

    )
)
#proc = subprocess.Popen(['R', 'CMD', 'INSTALL', '--no-multiarch', '--with-keep.source', pkg],
