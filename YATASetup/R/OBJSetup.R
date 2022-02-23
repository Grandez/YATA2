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
                }, system_command_error = function(res) {
                   .msg$ko()
                   .msg$err("ERROR %d making package", res$status)
                   16
                })
           rc = tryCatch({
                   .makeBinaries()
                }, system_command_error = function(res) {
                   .msg$ko()
                   .msg$err("ERROR %d processing scripts", res$status)
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
               return(0)
           }
           rpkgs = .ini$getSectionValues("packages")
           pkgs = rpkgs[which(rpkgs %in% changes)]
           if (length(pkgs) == 0) {
               .msg$out("Nothing to do\n")
               return(0)
           }

           for (pkg in pkgs) {
               .msg$out("\tMaking %s", pkg)
               .run$install(pkg)
               .msg$ok()
           }
           0
       }
       ,.makeBinaries = function () {
           browser()
           .msg$lbl("Checking binaries and scripts")
           from = .git$getBinaries()
           if (is.null(from) || length(from) == 0) {
               .msg$out("Nothing to do\n")
               return(0)
           }
           to = c()
           for (script in from) {
               bin = sub("/x", "/", script)
               bin = sub("\\.[a-zA-Z0-9]+$", "", bin)
               bin = sub("/[a-zA-Z0-9/]+/", "/bin/", bin)
               to = c(to, bin)
           }
           for (idx in 1:length(from)) {
               src = paste0(Sys.getenv("YATA_ROOT"), "/", from[idx])
               if (file.exists(src)) {
                   dst = paste0(Sys.getenv("YATA_ROOT"), "/", to[idx])
                   .run$copy(src, dst)
                   .run$chmod(dst, "775")
               }
           }
           browser()
       }
    )
)
