YATASetup = R6::R6Class("YATA.R6.SETUP"
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,portable   = FALSE
   ,public = list(
       print = function() { message("Setup object")}
      ,initialize    = function() {
          private$base = YATABase::YATABase$new()
          private$.ini = base$ini(system.file("config/yata.cfg", package = packageName()))
          private$.run = YATASetup:::YATARUN$new()
          private$.git = YATASetup:::YATAGIT$new()
          if (file.exists(file.path(Sys.getenv("HOME"), "yata.cfg"))) {
              .ini$add(file.path(Sys.getenv("HOME"), "yata.cfg"))
          }
      }
      ,updateYATA  = function() {
          base$msg$lblGroup("Generating/Updating YATA System")

          rc = tryCatch({
             .retrieveRepo()
             .managePackages()
             .manageWebSites()
             .manageBinaries()
             .manageServices()
             .manageCode()
             0
          }, YATAERROR = function (cond) {
              base$msg$ko()
             cond$rc
          })
      }
      ,updateServices = function(full = FALSE) {
          base$msg$lbl("Generating/Updating services")
          if (full) updateYATA()
          path = file.path(Sys.getenv("YATA_ROOT"), "YATACLI/services")
          .makeServices(list.files(path))
          base$msg$ok()
          0
      }
      ,updatePackages = function() {
          base$msg$lbl("Generating/Updating packages")
          rpkgs = .ini$getSection("packages")
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
       ,.fail           = function(rc, fmt, ..., ext) {
           base$msg$err(fmt, ...)
           txt = sprintf(fmt, ...)
           strerr = structure(list(msg = txt, rc=rc, ext=ext),class = c("YATAERROR", "error", "condition"))
           stop(strerr)
        }
       ,.checkfail      = function(rc, rc2, fmt, ..., ext=NULL) {
           if (rc2 != 0) {
               base$msg$ko()
               .fail(rc, "ERROR %d retrieving repo", rc2, ext)
           }
           base$msg$ok()
           FALSE
        }
       ,.retrieveRepo   = function() {
           count = 0 # A veces da fallo el PULL
           rc = 0
           base$msg$lblProcess1("Retrieving repository")
           while (count < 5) {
              res = .git$pull()
              if (res$status == 0) return (base$msg$ok())
              Sys.sleep(2)
              count = count + 1
           }
           base$msg$ko()
           YATABase$cond$EXEC( "EXEC", action="run"
                                ,command = "git pull"
                                ,rc      = res$status
                                ,type    = "Exec"
                                ,su      = NULL
                                ,stdout  = res$stdout
                                ,stderr  = res$stderr)
       }
       ,.managePackages = function() {
          rc2 = 0
          base$msg$lblProcess1("Making packages")
          pkgs = .makePackages(.git$getPackages())
          .run$copy2site(pkgs)
       }
       ,.manageBinaries = function() {
           base$msg$lblProcess1("Making binaries and scripts")
           from = .git$getChanges(" YATACLI/[a-rt-z][a-zA-Z0-9_/]+x[a-zA-Z0-9_\\.]+ ")
           if (is.null(from) || length(from) == 0) {
               base$msg$out("\tNothing to do\n")
               return(0)
           }
           site = paste0(Sys.getenv("YATA_SITE"), "/cli")
           to = c()
           for (script in from) {
               bin = sub("/x", "/", script)
               bin = sub("\\.[a-zA-Z0-9]+$", "", bin)
               bin = sub("/[a-zA-Z0-9/]+/", "/bin/", bin)
               to = c(to, bin)
           }
           for (idx in 1:length(from)) {
               src  = paste0(Sys.getenv("YATA_ROOT"), "/", from[idx])
               if (file.exists(src)) { # Modificado/Creado
                   dst = paste0(Sys.getenv("YATA_ROOT"), "/", to[idx])
                   .run$copyExe(src, dst)
                   .run$copyExe(dst, paste(site, basename(to[idx]), sep="/"))
               } else { # Borrado
                   .run$command("rm", paste(site, basename(to[idx]), sep="/"))
               }
           }
           base$msg$ok()
     }
       ,.manageServices = function() {
           base$msg$lblProcess1("Making services")
           from = .git$getServices()
           if (length(from) == 0) return (base$msg$out("\tNothing to do\n"))
           .makeServices(from)
           base$msg$ok()
        }
       ,.manageCode     = function() {
          # Quitamos YATACode/scripts si existe
          # Cogemos la fecha y hora
          # Ejecutamos YATACode/bin/make_{dir}.sh
          # Si va bien lo pasamos al servidor lo que tenga la fecha mas nueva

          base$msg$lblProcess1("Making non R code")
          .run$wd = Sys.getenv("YATA_ROOT")

          # Process scripts
          scripts = .git$getChanges(" YATACode/scripts/_[a-zA-Z0-9_\\.]+ ")
          lapply(scripts, function(script) {
                 to = script
                 to = sub("scripts/_", "bin/scripts/", to)
                 .run$copyExex(script, to)
          })

          # Process projects (exclude scripts)
          dirs = .git$getChanges(" YATACode/[a-zA-Z0-9_]+/")
          dirs = dirs [-which(dirs == "YATACode/scripts")]
          if (length(dirs) == 0) return (base$msg$out("\tNothing to do\n"))

          now = as.POSIXct(Sys.time())

          for (pkg in dirs) {
               grepout = regexpr("/.*", pkg)
               beg = grepout[1]
               folder = substr(pkg,  beg + 1, beg + attr(grepout, "match.length")[1] - 1)
               .run$wd = paste(.run$wd, "YATACode", folder, sep="/")
               .run$commandx(paste0("../bin/scripts/make_", folder, ".sh"))
          }

          from = paste0(Sys.getenv("YATA_ROOT"), "/YATACode/bin")
          to   = "/srv/yata/bin"

          lapply(list.files(from, full.names=TRUE), function(file) {
                  nfo = file.info(file)
                  if (!nfo[1, "isdir"] && nfo[1,"mtime"] >= now) {
                         .run$copyx(file, to)
                     }
                })

          base$msg$ok()
       }
       ,.manageWebSites = function() {
           base$msg$lblProcess1("Making Web sites")
           changed = list()
           changes = .git$getPackages()
           if (is.null(changes) || length(changes) == 0) {
               base$msg$out("\tNothing to do\n")
               return(changed)
           }
           rpkgs = .ini$getSection("web")
           pkgs = rpkgs[which(rpkgs %in% changes)]
           if (length(pkgs) == 0) {
               base$msg$out("\tNothing to do\n")
               return(changed)
           }
           for (pkg in pkgs) .run$copy2web(pkgs)
           base$msg$ok()
       }
       ,.makePackages   = function(packages) {
           changed = c()
           if (length(packages) == 0) {
               base$msg$out("\tNothing to do\n")
               return(changed)
           }
           rpkgs = .ini$getSection("packages")
           pkgs = rpkgs[which(rpkgs %in% packages)]
           if (length(pkgs) == 0) {
               base$msg$out("\tNothing to do\n")
               return(changed)
           }
           base$msg$out("\n")
           for (pkg in pkgs) {
               base$msg$out("\t\tMaking %s", pkg)
               .run$install(pkg)
               base$msg$ok()
               changed = c(changed, pkg)
           }
           changed
       }
       ,.makeServices   = function(services) {
           base=Sys.getenv("YATA_ROOT")
           for (srv in services) {
                f = paste0(base,srv)
                data = processFile(f, .ini)
                f = sub(".*/_", paste0(.ini$getSite(),"/"))
                f = sub("\\.[a-zA-Z0-9]+$", "", f)
                ftmp = sub(".*/","/tmp/")
                writeLines(data,ftmp)
                .run$copy_su (.ini$getUserPass(), ftmp, f )
                .run$chmod_su(.ini$getUserPass(), f, 775 )
                file.remove(ftmp)
            }
        }
    )
)
