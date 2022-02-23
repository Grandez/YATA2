YATARUN = R6::R6Class("YATA.R6.RUN"
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,portable   = FALSE
   ,public = list(
      initialize    = function() {
          fname = system.file("", "yata.cfg", package="YATASetup")
          private$cfg = ini::read.ini(fname)
      }
      ,install = function() {
          args = c('CMD', 'INSTALL', '--no-multiarch', '--with-keep.source', pkg)
          res = processx::run( 'R', args, TRUE,Sys.getenv("YATA_ROOT"))
      }
    )
   ,private = list(

    )
)
#proc = subprocess.Popen(['R', 'CMD', 'INSTALL', '--no-multiarch', '--with-keep.source', pkg],
