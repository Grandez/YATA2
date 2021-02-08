
#' Genera un identificador unico
#' @return un identificador numerico unico
#' @export
getID <- function() {
    if (!exists(".yata_tools_cnt")) .yata_tools_cnt <<- 0
#    .cnt <- attr(getID, "cnt")
    epoch = as.integer(Sys.time())
    epoch = epoch %% 10000000
    epoch = epoch * 1000
    .yata_tools_cnt <<- .yata_tools_cnt + 1
    epoch + .yata_tools_cnt
}
#' Implementa un objeto hash map
#' @export
HashMap = R6::R6Class("JGG.HASHMAP"
    ,public = list(
         initialize = function()           { private$hmap = hash() }
        ,get        = function (key)       { private$hmap[[as.character(key)]] }
        ,put        = function(key, value) { private$hmap[[as.character(key)]] = value }
        ,remove     = function(key)        { private$hmap(as.character(key),hmap)  }
        ,keys       = function()           { keys(private$hmap)   }
        ,values     = function()           { values(private$hmap) }
        ,length     = function()           { length(private$hmap)}
    )
    ,private = list(
        hmap = NULL
    )
)
