OBJMessages = R6::R6Class("OBJ.MESSAGES"
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        print          = function() { message("Locale Messages")}
       ,initialize     = function(dbf) {
           private$tblMsg = dbf$getTable(YATACodes$tables$Messages)
           private$db     = dbf$getDBBase()
       }
       ,setLang = function(lang, region) {
          private$lang = lang
          private$region = region
       }
      ,get = function(code, ...)  {
          txt = getMessage(code)
          sprintf(txt, ...)
      }
    )
    ,private = list(
        tblMsg = NULL
       ,db     = NULL
       ,lang   = "XX"
       ,region = "XX"
       ,cache  = list()
       ,size   = 20      # Long. de la cache
       ,getMessage = function(code) {
          if (code %in% names(cache)) return(cache[[code]])
          txt = tblMsg$get(code, lang, region)
          private$cache[[code]] = txt
          if (length(cache) > size) private$cache[1] = NULL
          txt
       }
    )
)
