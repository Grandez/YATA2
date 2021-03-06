OBJMessages = R6::R6Class("OBJ.MESSAGES"
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        print          = function() { message("Locale Messages")}
       ,initialize     = function(codes, dbf) {
           private$tblMsg = dbf$getTable(codes$tables$Messages)
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
      ,getBlock = function(block) {
        df = tblMsg$table(block = block)
        data = df$msg
        names(data) = df$code
        data
      }
      ,getBlockAsMap = function(block) {
          df = tblMsg$table(block = block)
          map = HashMap$new()
          if (nrow(df) > 0) {
             lapply(1:nrow(df), function(row) map$put(df[row, "code"], df[row, "msg"]))
          }
          map
      }
      ,title    = function(code)  { getMessage(paste0("TITLE.", code)) }
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
