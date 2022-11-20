TBLBlog = R6::R6Class("YATA.TBL.BLOG"
  ,inherit    = YATATable
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = FALSE
  ,public = list(
      initialize = function(name, db=NULL) {
         super$initialize(name, private$tblName, fields=private$fields, db=db)
      }
  )
  ,private = list (
      tblName = "BLOG"
     ,fields = list(
         id      = "ID"
        ,tms     = "TMS"
        ,type    = "TYPE"
        ,target  = "TARGET"
        ,title   = "TITLE"
        ,data    = "DATA"
      )
   )
)

