OBJBlog = R6::R6Class("YATA.OBJ.BLOG"
    ,inherit    = OBJBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        print          = function() { message("Blog")}
       ,initialize     = function(factory) {
           super$initialize(factory)
           private$tblBlog   = factory$getTable("Blog")
        }
       ,add = function(data) {
          data$id = factory$getID()
          tblBlog$add(data,isolate=TRUE)
          data$id
       }
      # ,select = function(idBlog) {
      #     df = tblBlog$table(id=idBlog)
      #     self$current = NULL
      #     if (nrow(df) > 0) { # Solo hay uno
      #         self$current = as.list(df[1,])
      #         self$current$type = names(which(DBDict$blog == self$current$type))
      #     }
      #     invisible(self)
      # }
    )
    ,private = list(
        tblBlog = NULL
       # ,tblExchanges = NULL
       # ,tblControl   = NULL
       # ,tblPosition  = NULL
       # ,icons        = NULL
    )
)
