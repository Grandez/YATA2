R6Icons = R6::R6Class("R6.ICONS"
    ,cloneable  = FALSE
    ,portable   = FALSE
    ,lock_class = TRUE
    ,public = list(
        initialize = function() {
            private$icons = loadIcons()
        }
        ,getIcon = function(name) {
            ico = icons$get(name)
            if (is.null(ico)) ico = "icons/YATA.png"
            ico
        }
    )
    ,private = list(
        icons = NULL
       ,loadIcons = function() {
           icons = HashMap$new()
           sf = system.file("extdata/icons", package="YATACore")
           lapply(list.files(sf),function(x) icons$put(x, paste0("icons/", x)))
           sf = normalizePath("P:\\R\\YATA2\\YATAExternal\\icons")
           lapply(list.files(sf),function(x) icons$put(x, paste0("resext/icons/", x)))
           icons
         }
    )
)
