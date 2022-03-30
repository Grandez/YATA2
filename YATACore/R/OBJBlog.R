OBJBlog = R6::R6Class("OBJ.BLOG"
    ,inherit    = OBJBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        print          = function() { message("Cameras")}
       ,initialize     = function(Factory) {
           super$initialize(Factory)
           private$tblBlog   = Factory$getTable(self$codes$tables$blog)
       }
       ,add = function(data) {
          data$id = Factory$getID()
          data$type = DBDict$blog[[data$type]]
          self$current = data
          tblBlog$add(data,isolate=TRUE)
          data$id
       }
      ,select = function(idBlog) {
          df = tblBlog$table(id=idBlog)
          self$current = NULL
          if (nrow(df) > 0) { # Solo hay uno
              self$current = as.list(df[1,])
              self$current$type = names(which(DBDict$blog == self$current$type))
          }
          invisible(self)
      }
    )
    ,private = list(
        tblBlog = NULL
       ,tblExchanges = NULL
       ,tblControl   = NULL
       ,tblPosition  = NULL
       ,icons        = NULL
    )
)
