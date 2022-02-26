schemeRedGreen = function() {
   function(x) rgb(colorRamp(c("red", "white", "green"))(x), maxColorValue = 255)
}
schemeVariation = function() {
    function(x) rgb(colorRamp(c("red", "yellow", "white", "yellow", "green"), interpolate = "linear")(x), maxColorValue = 255)
}
schemeOrange = function() {
   function(x) rgb(colorRamp(c("#ffe4cc", "#ff9500"))(x), maxColorValue = 255)
}
normalizeInterval = function(value, rank) {
    # Dado un intervalo [-x,x] y un valor
    # convierte el valor en una escala [0,2x]
    # Lo pasa al intervalo [0,1] para usar con colorRamp
    if (value > rank)        value = rank
    if (value < (rank * -1)) value = -rank
    (value + rank) / (2 * rank)
}
normalizeVariation = function(value) {
    # Normaliza un valor entre -1 y 1
    if (value > 1)  value = 1
    if (value < -1) value = 1
    ((value * 128) + 128) / 256
}

normalizeValue = function(value,data) {
    # Normaliza el valor en funcion de los datos de la columna
    (value - min(data)) / (max(data) - min(data))
}
