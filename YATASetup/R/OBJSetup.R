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
          private$.git = YATAGIT$new()
      }
      #,print       = function()             {}
      ,fatal       = function(rc, fmt, ...) { .msg$fatal(rc, fmt, ...) }
      ,getPackages = function()             { .git$getPackages()       }
      ,updateYATA  = function() {
          rc = tryCatch({
             .retrieveRepo()
             .managePackages()
             .manageBinaries()
             .manageWebSites()
             0
          }, YATAERROR = function (cond) {
             cond$rc
          })
      }
    )
   ,private = list(
        .git = NULL
       ,.ini = NULL
       ,.msg = NULL
       ,.run = NULL
       ,.makePackages = function() {
           changed = list()
           changes = .git$getPackages()
           if (is.null(changes) || length(changes) == 0) {
               .msg$out("Nothing to do\n")
               return(changed)
           }
           rpkgs = .ini$getSectionValues("packages")
           pkgs = rpkgs[which(rpkgs %in% changes)]
           if (length(pkgs) == 0) {
               .msg$out("Nothing to do\n")
               return(changed)
           }

           for (pkg in pkgs) {
               .msg$out("\tMaking %s", pkg)
               .run$install(pkg)
               .msg$ok()
               changed = append(changed, pkg)
           }
           changed
       }
       ,.makeBinaries = function () {
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
           .msg$ok()
           0
       }
      ,.retrieveRepo = function() {
          .msg$out("Retrieving repository")
           res = .git$pull()
           .checkfail(127, res$status, "ERROR %d retrieving repo", res$status)
      }
      ,.managePackages = function() {
          rc2 = 0
           .msg$lbl("Making packages")
           rc = tryCatch({
                   pkgs = .makePackages()
                   .run$copy2site(pkgs)
                }, system_command_error = function(res) {
                    rc2 = res$status
                }, error = function (cond) {
                    rc2=32
                }
               ,finally = function() {
                   .checkfail(32, rc2, "")
               })

      }
     ,.manageBinaries = function() {
         rc2 = 0
           rc = tryCatch({
                   .makeBinaries()
                }, system_command_error = function(res) {
                   rc2 = 16
               },finally = function() {
                   .checkfail(32, rc2, "ERROR %d processing scripts", rc2)
               })
     }
     ,.manageWebSites = function () {
         browser()
          .msg$lbl("Making Web sites")
           changed = list()
           changes = .git$getPackages()
           if (is.null(changes) || length(changes) == 0) {
               .msg$out("Nothing to do\n")
               return(changed)
           }
           rpkgs = .ini$getSectionValues("web")
           pkgs = rpkgs[which(rpkgs %in% changes)]
           if (length(pkgs) == 0) {
               .msg$out("Nothing to do\n")
               return(changed)
           }

           for (pkg in pkgs) .run$copy2web(pkgs)
           .msg$ok()
     }
     ,.fail = function(rc, fmt, ...) {
         txt = sprintf(fmt, ...)
         strerr = structure(list(msg = txt, rc=rc),class = c("YATAERROR", "error", "condition"))
         stop(strerr)
     }
     ,.checkfail = function(rc, rc2, fmt, ...) {
         if (rc2 == 0) .msg$ok()
         if (rc2 == 0) .msg$KO()
         if (rc2 != 0) .fail(rc, "ERROR %d retrieving repo", rc2)
         FALSE
     }
    )
)
