OBJMessages = R6::R6Class("OBJ.MESSAGES"
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        print          = function() { message("Locale Messages")}
       ,initialize     = function(dbf) {
           if (missing(dbf)) {
               dbf = YATADBBase::DBFactory$new()
               private$disconnect = TRUE
           }
           private$tblMsg = dbf$getTable("Messages")
#           private$db     = dbf$getDB()
       }
       ,finalize = function () {
           if (disconnect) db$disconnect()
       }
       ,setLang = function(lang, region) {
          private$lang   = lang
          private$region = region
        }
      ,get      = function(code, ...) {
          txt="ERROR"
          if (is.null(cache[[code]])) {
              txt = tblMsg$get(code, lang, region)
              if (!is.null(txt)) private$cache[[code]] = txt
          }
          txt = cache[[code]]
          if (is.null(txt))  txt = code
          if (!is.null(txt)) txt = sprintf(txt, ...)
          txt
       }
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
      ,log = function(code) {
          if (is.null(private$log_data)) private$log_data = getBlock(90)
          ifelse(is.null(private$log_data[[code]]), code, private$log_data[[code]])
      }
    )
    ,private = list(
        tblMsg = NULL
       ,db     = NULL
       ,disconnect = FALSE
       ,lang   = "XX"
       ,region = "XX"
       ,cache  = list()
       ,cacheBlock = list()
       ,log_data = NULL
       ,size   = 20      # Long. de la cache
       ,getMessage = function(code) {
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
