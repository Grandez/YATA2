TBLBlog = R6::R6Class("TBL.BLOG"
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
      id  = "ID_BLOG"
      ,tms   = "TMS"
      ,type   = "TYPE"
      ,target = "TARGET"
      ,title   = "TITLE"
      ,summary = "SUMMARY"
      ,data    = "DATA"
  )
 )
)

