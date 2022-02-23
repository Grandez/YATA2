YATASetup = R6::R6Class("YATA.R6.SETUP"
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,portable   = FALSE
   ,active = list(
        ini = function(value) { private$.ini }
       ,git = function(value) { private$.git }
       ,msg = function(value) { private$.msg }
   )
   ,public = list(
      initialize    = function() {
          private$.msg = YATASTD$new()
          private$.ini = YATAINI$new()
          private$.run = YATARUN$new()
          private$.git = YATAGIT$new(.ini)
      }
      #,print       = function()             {}
      ,fatal       = function(rc, fmt, ...) { .msg$fatal(rc, fmt, ...) }
      ,getPackages = function()             { .git$getPackages()       }
      ,updateYATA  = function() {
          browser()
          .msg$out("Retrieving repository")
           res = .git$pull()
           if (res$status == 0) {
               .msg$ok()
           } else {
               .msg$ko()
               .msg$err("ERROR %d retrieving repo", res$status)
               return (127)
           }
           rc = tryCatch({
                   .makePackages()
                   0
                }, system_command_error = function(res) {
                   .msg$ko()
                   .msg$err("ERROR %d making package", res$status)
                   16
                })
           rc = tryCatch({
                   .makeBinaries()
                   0
                }, system_command_error = function(res) {
                   .msg$ko()
                   .msg$err("ERROR %d making package", res$status)
                   16
                })

           if (rc != 0) return (rc)

           0
      }
    )
   ,private = list(
        .git = NULL
       ,.ini = NULL
       ,.msg = NULL
       ,.run = NULL
       ,.makePackages = function() {
           .msg$lbl("Making packages")
           changes = .git$getPackages()
           if (is.null(changes) || length(changes) == 0) {
               .msg$out("Nothing to do\n")
               return()
           }
           rpkgs = .ini$getSectionValues("packages")
           pkgs = rpkgs[which(rpkgs %in% changes)]
           if (length(pkgs) == 0) {
               .msg$out("Nothing to do\n")
               return()
           }

           for (pkg in pkgs) {
               .msg$out("\tMaking %s", pkg)
               .run$install(pkg)
               .msg$ok()
           }
       }
       ,.makeBinaries = function () {
           .msg$lbl("Checking binaries and scripts")
           changes = .git$getBinaries()
           browser()
       }
    )
)
