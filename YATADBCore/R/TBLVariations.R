# Los campos no tienen nombre prefijado para poder usar cualquier variacion
#   pxx hace referencia a precios
#   vxx hace referencia a voumenes
# 1. Caso normal
#   p01 - var. session
#   p02 - var.  1 dia (rolling)
#   p03 - var.  3 dias
#   p04 - var.  7 dias
#   p05 - var. 15 dias
#   p06 - var. 30 dias
#   p07 - var. 60 dias
#   p08 - var. 90 dias
TBLVariations = R6::R6Class("TBL.VARIATIONS"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,public = list(
          initialize    = function(name,  db=NULL) {
              super$initialize(name, tblName, fields=private$fields, key=private$key, db=db)
          }
     )
     ,private = list (
           tblName = "VARIATIONS"
          ,key    = c("id", "tms")
          ,fields = list(
               id        = "ID"
              ,tms       = "TMS"
              ,symbol    = "SYMBOL"
              ,price     = "PRICE"
              ,volume    = "VOLUME"
              ,begPrice  = "BEGPRICE"
              ,begVolume = "BEGVOLUME"
              ,p01 = "P01"
              ,p02 = "P02"
              ,p03 = "P03"
              ,p04 = "P04"
              ,p05 = "P05"
              ,p06 = "P06"
              ,p07 = "P07"
              ,p08 = "P08"
              ,p09 = "P09"
              ,p10 = "P10"
              ,p11 = "P11"
              ,p12 = "P12"
              ,v01 = "V01"
              ,v02 = "V02"
              ,v03 = "V03"
              ,v04 = "V04"
              ,v05 = "V05"
              ,v06 = "V06"
              ,v07 = "V07"
              ,v08 = "V08"
              ,v09 = "V09"
              ,v10 = "V10"
              ,v11 = "V11"
              ,v12 = "V12"
          )
     )
)
