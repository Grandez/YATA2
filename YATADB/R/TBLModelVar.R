TBLModelVar = R6::R6Class("TBL.MODEL.VAR"
  ,inherit    = YATATable
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = FALSE
  ,public = list(
     initialize = function(name, db=NULL) {
        super$initialize(name, fields=private$fields, db=db)
     }
  )
  ,private = list (
      fields = list(
           id = "ID"
          ,symbol    = "SYMBOL"
          ,rank      = "RANK"
          ,price00   = "PRICE00"
          ,price01   = "PRICE01"
          ,price02   = "PRICE02"
          ,price03   = "PRICE03"
          ,price04   = "PRICE04"
          ,price05   = "PRICE05"
          ,volume00 = "VOLUME00"
          ,volume01 = "VOLUME01"
          ,volume02 = "VOLUME02"
          ,volume03 = "VOLUME03"
          ,volume04 = "VOLUME04"
          ,volume05 = "VOLUME05"
          ,var01     = "VAR01"
          ,var02     = "VAR02"
          ,var03     = "VAR03"
          ,var04     = "VAR04"
          ,var05     = "VAR05"
          ,vol01     = "VOL01"
          ,vol02     = "VOL02"
          ,vol03     = "VOL03"
          ,vol04     = "VOL04"
          ,vol05     = "VOL05"
          ,indPrice  = "IND_PRICE"
          ,indVol    = "IND_VOL"
          ,indVar    = "IND_VAR"
          ,updated   = "UPDATED"
          ,tms       = "TMS"
  )
 )
)

