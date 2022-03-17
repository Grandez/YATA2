OBJBlog = R6::R6Class("OBJ.BLOG"
    ,inherit    = OBJBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        print          = function() { message("Cameras")}
       ,initialize     = function(Factory) {
           super$initialize(Factory)
           private$tblBlog   = Factory$getTable(YATACodes$tables$Blog)
           # private$tblExchanges = Factory$getTable(YATACodes$tables$Exchanges)
           # private$icons        = Factory$getClass("Icons")
       }
       ,add = function(data) {
          data$id = YATABase$getID()
          data$type = DBDict$blog[[data$type]]
          self$current = data
          tblBlog$add(data,isolate=TRUE)
          data$id
       }
      ,select = function(idBlog) {
          private$selected = FALSE
          df = tblBlog$table(id=idBlog)
          if (nrow(df) > 0) {
              self$current = as.list(df[1,])
              self$current$type = names(which(DBDict$blog == self$current$type))
              private$selected = TRUE
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
