OBJFavorites = R6::R6Class("OBJ.FAVORITES"
    ,inherit    = OBJBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        print          = function() { message("Favorites")}
       ,initialize     = function(factory) {
           super$initialize(factory)
           private$tblFavorites  = factory$getTable(self$codes$tables$favorites)
           private$tblCurrencies = factory$getTable(self$codes$tables$currencies)
       }
       ,add     = function(data, isolated=FALSE) {
           stop("Pendiente de implementar")
       }
       ,remove   = function(data, isolated=FALSE) {
           stop("Pendiente de implementar")
       }
       ,get  = function() {
           dff = tblFavorites$table()
           if (nrow(dff) > 0) {
               dfc = tblCurrencies$table(inValues=list(id=as.vector(dff$id)))
               dff = inner_join(dff,dfc,by=c("id", "symbol"))
           }
           dff
        }
    )
    ,private = list(
         tblFavorites = NULL
        ,tblCurrencies = NULL
    )
)
