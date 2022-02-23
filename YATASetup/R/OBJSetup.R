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
          private$.git = YATAGIT$new(.ini)
      }
      ,fatal       = function(rc, fmt, ...) { .msg$fatal(rc, fmt, ...) }
      ,getPackages = function()             { .git$getPackages()       }
    )
   ,private = list(
        .git = NULL
       ,.ini = NULL
       ,.msg = NULL
    )
)
