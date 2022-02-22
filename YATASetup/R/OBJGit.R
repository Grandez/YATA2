YATAGIT = R6::R6Class("YATA.R6.GIT"
   ,inherit    = YATASTD
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,portable   = FALSE
   ,public = list(
      initialize    = function(objini) {
          if (!missing(objini)) private$objini = objini
          # fname = system.file("", "yatacfg")
          # private$cfg = ini::read.ini(fname)
      }
      ,pull = function() {
          res = processx::run("git", c("pull"), FALSE, Sys.getenv("YATA_ROOT"))
          private$gitout = res$stdout
          res$status
      }
      ,getPackages = function() {
          browser()
          greps = NULL
          out = unlist(strsplit(gitout, "\n"))
          res = regexpr(" YATA[a-zA-Z0-9_]+/", out)
          len = attr(res, "match.length")
          for (idx in 1:length(res)) {
              if (res > -1) {
                  greps = c(greps, substr(out[idx], res[idx] + 1, res[idx] + len[idx] - 1))
              }
          }
          greps = unique(greps)
          pkgs = NULL
          rpkgs = objini$getSectionValues("packages")
          for (pkg in rpkgs) {
              if (pkg %in% greps) pkgs = c(pkgs, pkg)
          }
          pkg
      }
      ,getBinaries = function() {

      }
    )
   ,private = list(
        cfg = NULL
       ,objini = NULL
       ,gitout = ""
    )
)
