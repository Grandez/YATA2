#
# YATA Continuos Integration
#
# Este paquete realiza los test funcionales y/o mas complejos que una prueba unitaria
#
# testthat no se detiene con browser() por lo que la elaboracion y depuracion de las pruebas se
# hace mas laboriosa segun implique mas componentes
#
# La idea basica de este paquete es:
#
# 1. Realizar las pruebas funcionales
# 2. Permitir que sean usadas de forma aislada
# 3. Permitir integrarlas en testthat
# 4. Permitir que se ejecuten en un entorno grafico por desarrollar
#
# En cualquier caso, este es el paquete que gestiona la correccion del sistema
#

.error = function(e, msg) {
    CI$ko()
    err(e)
    throw(msg)
}

# Errors es el numero de errores a soportar. 0 - Todos
start = function(mode="console", errors=0) {
    CI <<- YATACI$new(mode, errors)
    testTransfers(mode)
    testOperations(mode)
}
