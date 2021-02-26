
#' Genera un identificador unico
#' @return un identificador numerico unico
#' El EPOCH UNix da los segundos (rounded) desde 1970-01-01
#' Quitamos Desde una fecha dada
#' Quitamos el digito mas significativo
#' el añadimos dos digitos y un contador estatico
#' ESto nos dice que, dentro de un segundo: 166653 podemos tener 100 identificadores
#' 16665300 - 16665399
#' Si en el mismo segundo generamos 101 id
#' 16665400 (El 3 pasa a 4) pero ese numero no se puede repetir por que en el siguiente
#' segundo el id daria 102, con lo que seria 16665501
#' Estos ID se pueen guardar en un int de 4 bytes sin signo:  	2147483647/4294967295
#' @export
getID <- function() {
    if (!exists(".yata_tools_cnt")) .yata_tools_cnt <<- 0
    epoch = as.integer(Sys.time()) - 1577836860 # Restamos el epoch desde 2020-01-01
    epoch = (epoch %% 1000000)                  # Quitamos el digito significativo
    epoch = epoch * 100                         # Le damos 2 menos significativos
    .yata_tools_cnt <<- .yata_tools_cnt + 1     # Contador estatico
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
