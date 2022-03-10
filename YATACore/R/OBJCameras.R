OBJCameras = R6::R6Class("OBJ.CAMERAS"
    ,inherit    = OBJBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        print          = function() { message("Cameras")}
       ,initialize     = function(factory) {
           super$initialize(factory)
           private$tblCameras   = factory$getTable(factory$codes$tables$cameras)
           private$tblExchanges = factory$getTable(factory$codes$tables$exchanges)
           private$icons        = factory$getClass("Icons")
       }
       ,select         = function(id) {
           # Selecciona un registro concreto de las tablas
           private$selected = tblCameras$select(id = id)
           self$current = tblCameras$current
           private$selected
       }
       ,add     = function(data, isolated=FALSE) {
               select(id=data$id)
               if (selected) {
                   tblCameras$set(data)
                   tblCameras$apply(isolated=TRUE)
               }
               else {
                   tblCameras$add(data)
               }
       }
       ,getCameras         = function(cameras) {
           df = tblCameras$table()
           if (!missing(cameras)) df = df[df$id %in% cameras,]
           df
        }
       ,getCameraName      = function(codes, full=FALSE) { tblCameras$getCameraNames(codes,full) }
       ,getActiveCameras   = function() { tblCameras$getTable(all=FALSE) }
       ,getInactiveCameras = function() { tblCameras$table(active=factory$codes$flag$inactive) }
       ,getAllCameras      = function() { tblCameras$table()                               }
       ,switchStatus       = function(id, isolated=FALSE) {
           if (!missing(id)) select(id)
           tblCameras$set(active = ifelse(tblCameras$isActive(), factory$codes$flag$inactive
                                                               , factory$codes$flag$active))
           tblCameras$apply(isolated)
       }
       ,getPosition   = function(camera, currency) {
           tblPosition$getPosition(camera, currency)
       }
       ,getCameraPosition = function(camera, balance=FALSE, available = FALSE) {
          # Devuelve la posicion de la camara, con balance y/o con disponible
          if (!missing(camera)) select(camera)
          if (is.null(tblPosition)) private$tblPosition = factory$getTable(factory$codes$tables$Position)
           tblPosition$getCameraPosition(camera, balance, available)
       }
       ,updateExchanges = function(clearing, data) {
            tryCatch({
               db$begin()
               tblExchanges$delete(clearing = clearing)
               tblExchanges$bulkAdd(data)
               db$commit()

           },error = function(cond) {
               browser()
                env$setErr(YATAError$new("Error en update", cond, ext=db$lastErr))
                db$rollback()
                stop(errorCondition("YATA ERROR", class=c("YATAErr", "error")))
           })
       }
       ,intervals       = function(interval, clearing) {
          # Me devuelve, para un intervalo, el ultimo y el maximo de cada par
          browser()
          if (is.null(tblControl)) private$tblControl = TBLSessionControl$new(db)
          tblControl$load()
          if (missing(clearing) && !private$selected) {
              env$err(YATAError$new(text="No se ha seleccionado o indicado ninguna camara"))
          }
          camera = ifelse (missing(clearing), tblCameras$getField("id"), clearing)
          tblControl$select(clearing=camera)
       }
      ##################################################
      ### Caches
      ##################################################
      ,loadCameras = function(all = FALSE) {
          tblCameras$table()
          invisible(self)
      }
    )
    ,private = list(
        tblCameras = NULL
       ,tblExchanges = NULL
       ,tblControl   = NULL
       ,tblPosition  = NULL
       ,icons        = NULL
    )
)
