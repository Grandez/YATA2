YATAGIT = R6::R6Class("YATA.R6.GIT"
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
          res
      }
      ,getPackages = function() {
#          pkgs = c()
          .parseOut(" YATA[a-zA-Z0-9_]+/")
          # greps = .parseOut(" YATA[a-zA-Z0-9_]+/")
          # greps = NULL
          # out = unlist(strsplit(gitout, "\n"))
          # res = regexpr(" YATA[a-zA-Z0-9_]+/", out)
          # if (length(res) == 0) return (pkgs)
          # len = attr(res, "match.length")
          # for (idx in 1:length(res)) {
          #     if (res[idx] > -1) {
          #         greps = c(greps, substr(out[idx], res[idx] + 1, res[idx] + len[idx] - 2))
          #     }
          # }
          # if (is.null(greps)) return (pkgs)
          # greps = unique(greps)
          #
          # rpkgs = objini$getSectionValues("packages")
          # rpkgs[which(rpkgs %in% greps)]
      }
      ,getBinaries = function() {
          .parseOut(" YATACLI/[a-zA-Z0-9_/]+x[a-zA-Z0-9_\\.]+ ")
          # pkgs = c()
          # greps = NULL
          # out = unlist(strsplit(gitout, "\n"))
          # res = regexpr(" YATACLI[a-zA-Z0-9_/]+x[a-zA-Z0-9_]+ ", out)
          # if (length(res) == 0) return (pkgs)
          # len = attr(res, "match.length")
          # for (idx in 1:length(res)) {
          #     if (res[idx] > -1) {
          #         greps = c(greps, substr(out[idx], res[idx] + 1, res[idx] + len[idx] - 2))
          #     }
          # }
          # if (is.null(greps)) return (pkgs)
          # unique(greps)
          #
          # rpkgs = objini$getSectionValues("packages")
          # rpkgs[which(rpkgs %in% greps)]

      }
    )
   ,private = list(
        cfg = NULL
       ,objini = NULL
       ,gitout = ""
       ,.parseOut = function(expr) {
          greps = NULL
          out = unlist(strsplit(gitout, "\n"))
          res = regexpr(expr, out)
          if (length(res) > 0) {
              len = attr(res, "match.length")
              for (idx in 1:length(res)) {
                   if (res[idx] > -1) {
                       greps = c(greps, substr(out[idx], res[idx] + 1, res[idx] + len[idx] - 2))
                   }
              }
              greps = unique(greps)
          }
          greps
       }
    )
)
