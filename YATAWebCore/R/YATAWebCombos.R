# Este objeto solo gestiona los combos comunes:
# - Camaras, monedas, etc.
# Y los combos que estan asociados a grupos de codigos
# Es una parte de YATAWebEnv
# Utiliza las tablas de manera directa
YATAWebCombos = R6::R6Class("YATA.WEB.COMBOS"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,public = list(
      initialize = function(factory) {
         private$factory       = factory
         # private$tblCameras    = factory$getTable(factory$codes$tables$cameras)
         # private$tblCurrencies = factory$getTable(factory$codes$tables$currencies)
         # private$tblPosition   = factory$getTable(factory$codes$tables$position)
         private$objParms      = factory$parms
         private$objMsgs       = factory$msg
         # refresh()
     }
#      ,refresh = function() {
#          private$cache$cameras  = NULL
#          private$cache$position = private$tblPosition$table()
#      }
#      ,cameras = function( all=FALSE, inactive=FALSE, exclude=NULL,balance=FALSE, available=FALSE, set=NULL) {
#          if (is.null(cache$cameras)) loadCameras()
#          df = cache$cameras
#
#          if (!is.null(set)) df = df[df$camera %in% set,]
#          if (!inactive) df = df[df$active != 0,]
#          if (!is.null(exclude)) df = df[!(df$camera %in% exclude),]
#          if (balance || available) {
#              df = dplyr::left_join(df, cache$position, by="camera")
#              if (balance)   df = df %>% filter( !is.na(balance)   & balance   > 0)
#              if (available) df = df %>% filter( !is.na(available) & available > 0)
#          }
#          data = makeCombo(df, id="camera", name="desc")
#          checkAll(data, all)
#      }
#      ,portfolios = function() {
#          df = objParms$getPortfolios()
#          lst = df$id
#          names(lst) = paste(df$title, df$name, sep = " - ")
#          lst
#      }
     ,currencies = function(set=NULL, merge=TRUE, all=FALSE) {
         df = WEB$getCurrencyNames(set)
         # if (!is.null(set)) {
         #     df = filterCurrencies (df, set)
         # } else {
             df = df[df$type > -1,]  # -1 son FIAT
             if (!all) df = df[df$active > 0,]
#         }
         if (nrow(df) == 0) return (list())
         if (merge) df$name = paste(df$symbol, "-", df$name)
         makeCombo(df, id="id")
     }
#      ,getCurrenciesKey = function(id=TRUE, currencies) {
#          if (is.null(cache$currencies)) loadCurrencies()
#          if (id) {
#              df = cache$currencies[cache$currencies$id %in% currencies,]
#              data = df$symbol
#              names(data) = df$id
#          } else {
#              df = cache$currencies[cache$currencies$symbol %in% currencies,]
#              data = df$id
#              names(data) = df$symbol
#          }
#          data
#      }
     ##############################################################
     ## Using labels from messages
     ##############################################################
     ,operations = function(all=FALSE) {
         if (is.null(cache$operations)) loadOperations()
         # Solo operaciones de compra/venta
         df = cache$operations[cache$operations$code < 40, ]
         colnames(df) = c("id", "name")
         makeCombo(df)
     }
     ,reasons = function(type="all") {
         if (is.null(cache$reasons)) loadReasons()
         df = cache$reasons
         df0 = df[df$code < 10,]
         if (type == "buy")
             df1 = subset(df, code >  9 & code < 30)
         else if (type == "sell")
             df1 = subset(df, code > 29 & code < 50)
         else
             df1 = subset(df, code > 9)

         dfr = rbind(df0, df1)
         colnames(dfr) = c("id", "name")
         makeCombo(dfr)
     }
     ,blog = function() {
         if (is.null(cache$blog)) loadBlog()
         makeCombo(cache$blog)
     }

#      ,periods = function() { msg_block(factory$codes$labels$periods) }
#      ,scopes  = function() { msg_block(34) }
#      ,targets = function() { msg_block(35) }
#      ,blog = function(type=9) {
#          if (is.null(cache$blog)) loadBlog()
#          df = cache$reasons[(cache$reasons$block %% 10) == 0,] # General
#          df = rbind(df, cache$reasons[(cache$reasons$block %% 10) == type,]) # Especifico
#          df = df[,c("id", "name")]
#          data = makeCombo(df)
#          checkAll(data, FALSE)
#      }

  )
  ,private = list(
      factory       = NULL
    #  ,tblCameras    = NULL
    #  ,tblCurrencies = NULL
    #  ,tblPosition   = NULL
     ,objParms      = NULL
     ,objMsgs       = NULL
     ,cache = list(
          cameras = NULL
      )
    #  ,loadCameras    = function() { private$cache$cameras = tblCameras$table()       }
     ,loadCurrencies = function() {
         private$cache$currencies = private$factory$backend$currencies()
      }
     ,loadOperations = function() {
         df = objParms$getLabelsCoded("oper")
         df$code = as.integer(df$code)
#
#          data = objParms$getBlock(50, 1)
#          lst = objMsgs$getBlock(YATACODE$labels$operation)
#          dft = data.frame(msg=unlist(lst))
#          dft$label = names(lst)
#
#          df = dplyr::left_join(data,dft,by="label")
#          df = df[,c("key","label")]
#          colnames(df) = c("id", "name")
         private$cache$operations = df
     }
     ,loadReasons = function() {
         df = objParms$getLabelsCoded("reasons")
         df$code = as.integer(df$code)
         private$cache$reasons = df
     }
     ,loadBlog = function() {
         df = objParms$getLabelsCoded("blog")
         df$code = as.integer(df$code)
         colnames(df) = c("id", "name")
         private$cache$blog = df
     }

    #  ,loadBlog = function() {
    #      data = objParms$getBlock(50, 3)
    #      data$label = gsub("[a-z0-9]+\\.", "", data$label, ignore.case=TRUE)
    #      # txts = objMsgs$getBlock(factory$codes$labels$reasons)
    #      # dft = as.data.frame(unlist(txts))
    #      # dft$id = row.names(dft)
    #      # colnames(dft) = c("msg", "label")
    #      # df = dplyr::left_join(data,dft,by="label")
    #      # df = df[,c("block", "key","msg")]
    #      # colnames(df) = c("block", "id", "name")
    #      # private$cache$reasons = df
    #  }
    #
     ,makeCombo = function(df, id="id",name="name", invert=FALSE) {
        if (invert) {
            data = as.list(df[,name])
            names(data) = as.character(df[,id])
        } else {
            data = as.list(df[,id])
            names(data) = df[,name]
        }
        data
    }
     ,checkAll = function(data, all) {
         if (!all || length(data) == 0) return (data)

         checkNumber = suppressWarnings(as.integer(data[[1]]))
         lstAll = list(ifelse(is.na(checkNumber), " ","0"))
         names(lstAll) = objMsgs$get("WORD.ALL")
         jgg_list_merge(lstAll, data)
      }
    #  ,filterCurrencies = function (df, set) {
    #    values = set
    #    if (is.list(set)) values = unlist(set)
    #    if (is.integer(values[1])) return (df[df$id %in% values,])
    #    df[df$symbol %in% values,]
    #  }
    #  ,msg_block = function(id) {
    #      data = objMsgs$getBlock(id)
    #      lst = names(data)
    #      names(lst) = data
    #      lst
    #  }

  )
)
