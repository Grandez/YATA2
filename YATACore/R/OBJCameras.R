# Maneja las camaras de la base de datos actual
#        junto con lo exchanges
OBJCameras = R6::R6Class("OBJ.CAMERAS"
    ,inherit    = OBJBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        print          = function() { message("Cameras")}
       ,initialize     = function(factory) {
           super$initialize(factory)
           private$tblCameras   = factory$getTable("Cameras")
           private$cameras      = private$tblCameras$table()
#           private$tblExchanges = factory$getTable(self$codes$tables$exchanges)
#           private$icons        = factory$getClass("Icons")
       }
       # ,select         = function(id) {
       #     # Selecciona un registro concreto de las tablas
       #     private$selected = tblCameras$select(camera = id)
       #     self$current = tblCameras$current
       #     private$selected
       # }
       # ,getForCombo = function(cameras=NULL, exclude=NULL) {
       #     if (is.null(cameras)) {
       #         df = tblCameras$table()
       #     } else {
       #         df = tblCameras$table(inValues=list(camera=cameras))
       #     }
       #     if (!is.null(exclude)) df = df[!(df$camera %in% exclude),]
       #     df = df[,c("camera", "desc")]
       #     colnames(df) = c("id", "name")
       #     df
       # }
       # ,add     = function(data, isolated=TRUE) {
       #     tblCameras$add(data, isolated)
       #     invisible(self)
       # }
      ,getCameras         = function(all = FALSE) {
          if (all) return (private$cameras)
          cameras[cameras$active == 1,]
       }
       # ,getAllCameras      = function(cameras) { .getCameras(FALSE, cameras) }
       # ,getCameraName      = function(codes, full=FALSE) { tblCameras$getCameraNames(codes,full) }

       # ,getActiveCameras   = function() { tblCameras$getTable(all=FALSE) }
       # ,getInactiveCameras = function() { tblCameras$table(active=YATACodes$flag$inactive) }
       # ,getAllCameras      = function() { tblCameras$table()                               }
       # ,switchStatus       = function(id, isolated=FALSE) {
       #     if (!missing(id)) select(id)
       #     tblCameras$set(active = ifelse(tblCameras$isActive(), YATACodes$flag$inactive
       #                                                         , YATACodes$flag$active))
       #     tblCameras$apply(isolated)
       # }
       # ,getPosition   = function(camera, currency) {
       #     tblPosition$getPosition(camera, currency)
       # }
       # ,getCameraPosition = function(camera, balance=FALSE, available = FALSE) {
       #    # Devuelve la posicion de la camara, con balance y/o con disponible
       #    if (!missing(camera)) select(camera)
       #    if (is.null(tblPosition)) private$tblPosition = factory$getTable(YATACodes$tables$Position)
       #     tblPosition$getCameraPosition(camera, balance, available)
       # }
       # ,updateExchanges = function(clearing, data) {
       #      tryCatch({
       #         db$begin()
       #         tblExchanges$delete(clearing = clearing)
       #         tblExchanges$bulkAdd(data)
       #         db$commit()
       #
       #     },error = function(cond) {
       #         browser()
       #          env$setErr(YATAError$new("Error en update", cond, ext=db$lastErr))
       #          db$rollback()
       #          stop(errorCondition("YATA ERROR", class=c("YATAErr", "error")))
       #     })
       # }
       # ,intervals       = function(interval, clearing) {
       #    # Me devuelve, para un intervalo, el ultimo y el maximo de cada par
       #    browser()
       #    if (is.null(tblControl)) private$tblControl = TBLSessionControl$new(db)
       #    tblControl$load()
       #    if (missing(clearing) && !private$selected) {
       #        env$err(YATAError$new(text="No se ha seleccionado o indicado ninguna camara"))
       #    }
       #    camera = ifelse (missing(clearing), tblCameras$getField("id"), clearing)
       #    tblControl$select(clearing=camera)
       # }
      ##################################################
      ### Caches
      ##################################################
      # ,loadCameras = function(all = FALSE) {
      #     tblCameras$table()
      #     invisible(self)
      # }
    )
    ,private = list(
        tblCameras = NULL
       ,cameras    = NULL
       # ,tblExchanges = NULL
       # ,tblControl   = NULL
       # ,tblPosition  = NULL
       # ,.getCameras         = function(active, cameras) {
       #     if (active) {
       #         dfc = tblCameras$table(active=1)
       #     } else {
       #         dfc = tblCameras$table()
       #     }
       #     if (!missing(cameras)) dfc = dfc[dfc$camera %in% cameras,]
       #
       #     if (nrow(dfc) > 0) {
       #         dfe = tblExchanges$table(inValues=list(id=dfc$exchange))
       #         dfc  = left_join(dfc, dfe, by=c("exchange"="id"))
       #     }
       #     dfc
       # }

    )
)
