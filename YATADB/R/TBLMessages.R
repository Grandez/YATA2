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
            if (nrow(data) == 0) {
                return (paste("Missing message ", code))
            }
            data$msg
        }
        ,getBlock = function(block, lang, region) {
            table(block=block,lang=lang,region=region)
        }
     )
     ,private = list (
           key = c("code", "lang", "region")
          ,fields = list(
              block  = "BLOCK"
             ,code   = "CODE"
             ,lang   = "LANG"
             ,region = "REGION"
             ,msg    = "MSG"
          )
     )
)
