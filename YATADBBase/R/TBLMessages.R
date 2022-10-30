TBLMessages = R6::R6Class("TBL.MESSAGES"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,public = list(
        initialize = function(name, db=NULL) {
           super$initialize(name, tblName, fields=private$fields, key=private$key, db=db)
        }
        ,get = function(code, lang="XX", region="XX") {
            df = table(code=code, lang=lang, region=region)
            if (nrow(df) == 0) df = table(code = code, lang = lang, region = "XX")
            if (nrow(df) == 0) df = table(code = code, lang = "XX", region = "XX")
            if (nrow(df) == 0) return (code)
            df$value
        }
        ,getBlock = function(block, lang="XX", region="XX") {
            # No puede fallar. seria corrupcion de datos en el sistema
            df = table(block=block, lang=lang, region=region)
            if (nrow(df) == 0) df = table(block=block, lang=lang, region="XX")
            if (nrow(df) == 0) df = table(block=block, lang="XX", region="XX")
            df[,c("code", "value")]
        }
       ,getItem = function(block, code, lang="XX", region="XX") {
            # No puede fallar. seria corrupcion de datos en el sistema
            df = table(block=block, code=code, lang=lang, region=region)
            if (nrow(df) == 0) df = table(block=block, code=code, lang=lang, region="XX")
            if (nrow(df) == 0) df = table(block=block, code=code, lang="XX", region="XX")
            df[,c("code", "value")]
       }
     )
     ,private = list (
           tblName = "MESSAGES"
          ,key = c("block", "code", "lang", "region")
          ,fields = list(
              block  = "BLOCK"
             ,code   = "CODE"
             ,lang   = "LANG"
             ,region = "REGION"
             ,value  = "VALUE"
          )
     )
)
