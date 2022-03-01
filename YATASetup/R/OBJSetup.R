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
      ,updateYATA  = function() {
          base$msg$lblGroup("Generating/Updating services")

          rc = tryCatch({
              browser()
             .retrieveRepo()
              .manageCode()
             .managePackages()
             .manageWebSites()
             .manageBinaries()
             .manageServices()
             .manageCode()
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
       ,.fail = function(rc, fmt, ..., ext) {
           base$msg$err(fmt, ...)
           txt = sprintf(fmt, ...)
           strerr = structure(list(msg = txt, rc=rc, ext=ext),class = c("YATAERROR", "error", "condition"))
           stop(strerr)
        }
       ,.checkfail = function(rc, rc2, fmt, ..., ext=NULL) {
           if (rc2 != 0) {
               base$msg$ko()
               .fail(rc, "ERROR %d retrieving repo", rc2, ext)
           }
           base$msg$ok()
           FALSE
        }
       ,.makePackages = function(packages) {
           changed = c()
           if (length(packages) == 0) {
               base$msg$out("Nothing to do\n")
               return(changed)
           }
           rpkgs = .ini$getSectionValues("packages")
           pkgs = rpkgs[which(rpkgs %in% packages)]
           if (length(pkgs) == 0) {
               base$msg$out("Nothing to do\n")
               return(changed)
           }
           base$msg$out("\n")
           for (pkg in pkgs) {
               base$msg$out("\tMaking %s", pkg)
               .run$install(pkg)
               base$msg$ok()
               changed = c(changed, pkg)
           }
           changed
       }
       ,.makeBinaries = function () {
           base$msg$lbl("Checking binaries and scripts")
           from = .git$getBinaries()
           if (is.null(from) || length(from) == 0) {
               base$msg$out("Nothing to do\n")
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
           base$msg$lblProcess1("Retrieving repository")
           res = .git$pull()
           .checkfail(127, res$status, "ERROR %d retrieving repo", res$status)
      }
      ,.managePackages = function() {
          rc2 = 0
          base$msg$lblProcess1("Making packages")
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
          base$msg$lbl("Checking services")
          from = .git$getServices()
          if (length(from) == 0) return (.msg$out("Nothing to do\n"))
          .makeServices(from)
     }
     ,.manageCode = function() {
         browser()
          base$msg$lblProcess1("Checking non R code")
          .run$wd = Sys.getenv("YATA_ROOT")
          oldcwd = getwd()
          scripts = .git$getChanges(" YATACode/scripts/_[a-zA-Z0-9_\\.]+ ")
          lapply(scripts, function(script) {
              to = script
              to = sub("scripts/_", "bin/", to)
              .run$copyExe(script, to)
              .checkfail(32, rc, "Generating %s code", folder)
          })

          code = .git$getChanges(" YATACode/[a-zA-Z0-9_]+/")
          if (length(code) == 0) return (.msg$out("Nothing to do\n"))
          # Quitamos YATACode/scripts si existe
          # Cogemos la fecha y hora
          # Ejecutamos YATACode/bin/make_{dir}.sh
          # Si va bien lo pasamos a YATACLI/bin lo que tenga la fecha mas nueva
          root = Sys.getenv("YATA_ROOT")
          for (pkg in from) {
              # si no es YATACode/scripts
              if (!grep("YATACode/scripts", pkg)) {
                  grepout = regexpr("/.*", pkg)
                  folder = substr(pkg, grepout + 1, grepout + attr("grepout", "match.length") - 2)
                  wd = paste(root, "YATACode/bin", sep="/")
                  rc = .run$command(paste0("make_", folder, ".sh"), wd=wd)
                  .checkfail(32, rc, "Generating %s code", folder)
              }
          }
          now = as.POSIXct(Sys.time)
          files = file.info(list.files(paste(root, "YATACode/bin", sep="/")))
          row = 1
          while (row <= nrow(files)) {
              if (!files[row, "isdir"] && files[row,"mtime"] >= now) {
                  .run$copyFile(file, from, to, mode=775, su = NULL)
                  .checkfail(32, rc, "Publishing %s code", folder)
              }
          }
     }

     ,.manageWebSites = function () {
          base$msg$lbl("Making Web sites")
          changed = list()
          changes = .git$getPackages()
          if (is.null(changes) || length(changes) == 0) {
              base$msg$out("Nothing to do\n")
              return(changed)
          }
           rpkgs = .ini$getSectionValues("web")
           pkgs = rpkgs[which(rpkgs %in% changes)]
           if (length(pkgs) == 0) {
               .msg$out("Nothing to do\n")
               return(changed)
           }

           for (pkg in pkgs) .run$copy2web(pkgs)
           base$msg$ok()
     }
     ,.makeServices = function (services) {
          base=Sys.getenv("YATA_ROOT")
          for (srv in services) {
              f = paste0(base,srv)
              data = processFile(f, .ini)
              f = sub(".*/_", paste0(.ini$getSite(),"/"))
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
