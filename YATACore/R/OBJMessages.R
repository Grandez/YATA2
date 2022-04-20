OBJMessages = R6::R6Class("OBJ.MESSAGES"
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        print          = function() { message("Locale Messages")}
       ,initialize     = function(tblMessages, dbf) {
           private$tblMsg = dbf$getTable(tblMessages)
           private$db     = dbf$getDBBase()
        }
       ,setLang = function(lang, region) {
          private$lang   = lang
          private$region = region
        }
      ,get      = function(code, ...) { sprintf(getMessage(code), ...) }
      ,getWords = function()          { getBlockData(1) } # Esto viene de codes
      ,getBlock = function(block, inverted=FALSE) {
          lst = getBlockData(block)
          if (inverted) {
            data = names(lst)
            names(data) = lst
        } else {
            data = lst
        }
        data
      }
      ,getBlockAsMap = function(block) {
          df = tblMsg$table(block = block)
          map = YATABase::map()
          if (nrow(df) > 0) {
             lapply(1:nrow(df), function(row) map$put(df[row, "code"], df[row, "msg"]))
          }
          map
      }
      ,getBlockAsVector = function(block) {
          df = tblMsg$table(block = block)
          c(df$msg)
      }
      ,tooltip  = function(code)  {
          data = tblMsg$getItem(block = 99, code = paste("POPUP", code, sep="."))
          if (nrow(data) == 0) return ("Not Found")
          data[1,2]
      }
      ,title    = function(code)  { getMessage(paste0("TITLE.", code)) }
    )
    ,private = list(
        tblMsg = NULL
       ,db     = NULL
       ,lang   = "XX"
       ,region = "XX"
       ,cache  = list()
       ,cacheBlock = list()
       ,size   = 20      # Long. de la cache
       ,getMessage = function(code) {
           txt="ERROR"
          if (code %in% names(cache)) return(cache[[code]])
           tryCatch({
              txt = tblMsg$get(code, lang, region)
              private$cache[[code]] = txt
              if (length(cache) > size) private$cache[1] = NULL
           }, error = function(cond){
               # Nothing
           })
          txt
       }
       ,getBlockData = function(block) {
           label = paste0("L", block)
           if (!(label %in% names(cacheBlock))) {
               df = tblMsg$getBlock(block, lang, region)
               df$code = as.character(sub("([A-Z0-9]+\\.)+", "", df$code, ignore.case = TRUE))
               lst = as.list(df$value)
               names(lst) = df$code
               private$cacheBlock[[label]] = lst
           }
          private$cacheBlock[[label]]
       }
    )
)
