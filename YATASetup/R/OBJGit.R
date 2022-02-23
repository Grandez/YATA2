YATAGIT = R6::R6Class("YATA.R6.GIT"
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,portable   = FALSE
   ,public = list(
       pull = function() {
          res = processx::run("git", c("pull"), FALSE, Sys.getenv("YATA_ROOT"))
          private$gitout = res$stdout
          res
      }
      ,getPackages = function() { .parseOut(" YATA[a-zA-Z0-9_]+/")                       }
      ,getBinaries = function() { .parseOut(" YATACLI/[a-zA-Z0-9_/]+x[a-zA-Z0-9_\\.]+ ") }
    )
   ,private = list(
        gitout = ""
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
