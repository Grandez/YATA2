# El indicador es el que deberia saber como dibujarse
# Pero entonces cada uno de ellos seria un objeto diferente

YATAIndicator2 <- R6::R6Class("YATAIndicator2",
    public = list(
          title    = NULL
         ,name     = NULL
         ,columns  = NULL
         ,method   = NULL
         ,plot     = NULL
         ,type     = IND_LINE
         ,scope    = 1
         ,blocks   = 1  # bitmask xx
         ,parms    = NULL
         ,result   = NULL
        ,initialize = function(title=NULL, name=NULL,  type=IND_OVERLAY, columns=NULL,
                               method=NULL,  plot=NULL,  scope=1,  blocks=1 ,       parms=NULL) {
            if (is.null(title)) stop(MSG_MISSING("title"))
            if (is.null(name))  stop(MSG_MISSING("name"))
            self$title   = title
            self$name    = name
            self$type    = type
            self$columns = columns
            self$plot    = plot;
            self$blocks  = blocks
            self$method  = ifelse(is.null(method), toupper(name), method)
            self$scope   = scope
            self$parms   = parms

            if (is.null(self$plot)) self$plot    = self$type
            if (is.null(columns))   self$columns = c(name)
        }
    )
)
