TBLMessages = R6::R6Class("TBL.MESSAGES"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,public = list(
        initialize = function(name, db=NULL) {
           super$initialize(name, fields=private$fields, key=private$key, db=db)
        }
        ,get = function(code, lang, region) {
            data = table(code=code,lang=lang,region=region)
            data$msg
        }
     )
     ,private = list (
           key = c("code", "lang", "region")
          ,fields = list(
              code   = "CODE"
             ,lang   = "LANG"
             ,region = "REGION"
             ,msg    = "MSG"
          )
     )
)
