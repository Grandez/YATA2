YATASetup = R6::R6Class("YATA.R6.SETUP"
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,portable   = FALSE
   ,public = list(
       print = function() { message("Setup object")}
      ,initialize    = function() {
          private$base = YATABase
          #private$.msg = YATASTD$new()
          private$.ini = YATAINI$new()
          private$.run = YATARUN$new()
          private$.git = YATAGIT$new()
          if (file.exists(file.path(Sys.getenv("HOME"), "yata.cfg"))) {
              .ini$add(file.path(Sys.getenv("HOME"), "yata.cfg"))
          }
      }
      #,print       = function()             {}
      # ,fatal       = function(rc, fmt, ...) { .msg$fatal(rc, fmt, ...) }
      # ,getPackages = function()             { .git$getPackages()       }
      ,updateYATA  = function() {
          base$msg$lblgroup("Generating/Updating services")
          return (0)
          rc = tryCatch({
             .retrieveRepo()
             .managePackages()
             .manageWebSites()
             .manageBinaries()
             .manageServices()
             .manageBinaries()
             0
          }, YATAERROR = function (cond) {
             cond$rc
          })
      }
      ,updateServices = function(full = FALSE) {
          .msg$lbl("Generating/Updating services")
          if (full) updateYATA()
          path = file.path(Sys.getenv("YATA_ROOT"), "YATACLI/services")
          .makeServices(list.files(path))
          .msg$ok()
          0
      }
      ,updatePackages = function() {
          .msg$lbl("Generating/Updating packages")
          rpkgs = .ini$getSectionValues("packages")
          .makePackages(rpkgs)
          0
      }
      ,fatal = function(fmt, ...) { .fail(16, fmt, ...) }

    )
   ,private = list(
        .git = NULL
       ,.ini = NULL
       ,.run = NULL
       ,base = NULL
       ,.fail = function(rc, fmt, ...) {
           .msg$err(fmt, ...)
           txt = sprintf(fmt, ...)
           strerr = structure(list(msg = txt, rc=rc),class = c("YATAERROR", "error", "condition"))
           stop(strerr)
        }
       ,.checkfail = function(rc, rc2, fmt, ...) {
           if (rc2 != 0) {
               .msg$ko()
               .fail(rc, "ERROR %d retrieving repo", rc2)
           }
           .msg$ok()
           FALSE
        }
       ,.makePackages = function(packages) {
           changed = c()
           if (length(packages) == 0) {
               .msg$out("Nothing to do\n")
               return(changed)
           }
           rpkgs = .ini$getSectionValues("packages")
           pkgs = rpkgs[which(rpkgs %in% packages)]
           if (length(pkgs) == 0) {
               .msg$out("Nothing to do\n")
               return(changed)
           }
           .msg$out("\n")
           for (pkg in pkgs) {
               .msg$out("\tMaking %s", pkg)
               .run$install(pkg)
               .msg$ok()
               changed = c(changed, pkg)
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
                  pkgs = .makePackages(.git$getPackages())
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
     ,.manageServices = function() {
          .msg$lbl("Checking services")
          from = .git$getServices()
          if (length(from) == 0) return (.msg$out("Nothing to do\n"))
          .makeServices(from)
     }
     ,.manageBinaries = function() {
          .msg$lbl("Checking services")
          from = .git$getChanges(" YATACode/[a-zA-Z0-9_]+/")
          if (length(from) == 0) return (.msg$out("Nothing to do\n"))
          base=Sys.getenv("YATA_ROOT")
          for (pkg in from) {
              f = paste0(base,pkg, ".sh")
              data = processFile(f, .ini)
              f = sub(".*/x", paste0(.ini$getSite(),"/"))
              f = sub("\\.[a-zA-Z0-9]+$", "", f)
              ftmp = sub(".*/","/tmp/")
              writeLines(data,ftmp)
              .run$copy(ftmp, f, .ini$getUserPass())
              .run$chmod(f, 775, .ini$getUserPass())
              file.remove(ftmp)
          }

          .makeServices(from)
     }

     ,.manageWebSites = function () {
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
     ,.makeServices = function (services) {
          base=Sys.getenv("YATA_ROOT")
          for (srv in services) {
              f = paste0(base,srv)
              data = processFile(f, .ini)
              f = sub(".*/x", paste0(.ini$getSite(),"/"))
              f = sub("\\.[a-zA-Z0-9]+$", "", f)
              ftmp = sub(".*/","/tmp/")
              writeLines(data,ftmp)
              .run$copy(ftmp, f, .ini$getUserPass())
              .run$chmod(f, 775, .ini$getUserPass())
              file.remove(ftmp)
          }

     }
    )
)
