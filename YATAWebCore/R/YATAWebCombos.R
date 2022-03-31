# Este objeto solo gestiona los combos comunes:
# - Camaras, moendas, etc.
# Y los combos que estan asociados a grupos de codigos
# Es una parte de YATAWebEnv
# Utiliza las tablas de manera directa
YATAWebCombos = R6::R6Class("YATA.WEB.ENV"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,public = list(
      MSG      = NULL
     ,initialize = function(factory) {
         private$tblCameras    = factory$getTable(factory$CODES$tables$cameras)
         private$tblCurrencies = factory$getTable(factory$CODES$tables$currencies)
         private$objParms   = factory$parms
         private$objMsgs    = factory$MSG
     }
     ,cameras = function(all=FALSE, inactive=FALSE) {
         if (is.null(cache$cameras)) loadCameras()
         df = cache$cameras
         if (!inactive) df = df[df$active != 0,]
         data = makeCombo(df, id="camera", name="desc")
         checkAll(all, data)
     }
     ,currencies = function(id=TRUE, all=FALSE, set=NULL, byId=FALSE, merge = TRUE) {
         if (is.null(cache$currencies)) loadCurrencies()
         df = cache$currencies
         if (!is.null(set)) df = filterCurrenciesByCurrencies (df, set)
         if (merge) df$name = paste(df$symbol, "-", df$name)
         key = ifelse(id, "id", "symbol")
         data = makeCombo(df, id=key)
         checkAll(all, data)
     }
     ##############################################################
     ## Using labels from messages
     ##############################################################
     ,operations = function(all=FALSE) {
         if (is.null(cache$operations)) loadOperations()
         data = makeCombo(cache$operations)
         checkAll(all, data)
     }
     ,reasons = function(type=9) {
         if (is.null(cache$reasons)) loadReasons()
         df = cache$reasons[(cache$reasons$block %% 10) == 0,] # General
         df = rbind(df, cache$reasons[(cache$reasons$block %% 10) == type,]) # Especifico
         df = df[,c("id", "name")]
         data = makeCombo(df)
         checkAll(FALSE, data)
     }

  )
  ,private = list(
      tblCameras    = NULL
     ,tblCurrencies = NULL
     ,objParms      = NULL
     ,objMsgs       = NULL
     ,cache = list(
          cameras = NULL
      )
     ,loadCameras    = function() { private$cache$cameras = tblCameras$table()       }
     ,loadCurrencies = function() { private$cache$currencies = tblCurrencies$table() }
     ,loadOperations = function() {
         data = objParms$getBlock(50, 1)
         txts = objMsgs$getBlockBueno(2)
         colnames(txts) = c("label", "msg")
         df = dplyr::left_join(data,txts,by="label")
         df = df[,c("key","msg")]
         colnames(df) = c("id", "name")
         private$cache$operations = df
     }
     ,loadReasons = function() {
         data = objParms$getBlock(50, 2)
         txts = objMsgs$getBlockBueno(12)
         colnames(txts) = c("label", "msg")
         df = dplyr::left_join(data,txts,by="label")
         df = df[,c("block", "key","msg")]
         colnames(df) = c("block", "id", "name")
         private$cache$reasons = df
     }

    ,makeCombo = function(df, id="id",name="name") {
        data = as.list(df[,id])
        names(data) = df[,name]
        data
    }
   ,checkAll = function(all, data) {
       if (!all || length(data) == 0) return (data)

       checkNumber = suppressWarnings(as.integer(data[[1]]))
       lstAll = list(ifelse(is.na(checkNumber), " ","0"))
       names(lstAll) = objMsgs$get("WORD.ALL")
       list.merge(lstAll, data)
   }
   ,filterCurrenciesByCurrencies = function (df, set) {
       values = set
       if (is.list(set)) values = unlist(set)
       if (is.integer(values[1])) return (df[df$id %in% values,])
       df[df$symbol %in% values,]
   }
  )
)
