YATACODES = R6::R6Class("YATA.CODES"
   ,portable  = FALSE
   ,cloneable = FALSE
   ,lock_class = TRUE
   ,public     = list(
    object = list(
      parms      = "Parms"
     ,operation  = "Operation"
     ,cameras    = "Cameras"
     ,position   = "Position"
     ,currencies = "Currencies"
     ,providers  = "Providers"
    )
    ,tables = list(
         Position     = "Position"
        ,Regularization = "Regularization"
        ,PositionHist = "PositionHist"
        ,Clearings    = "Clearings"
        ,Cameras      = "Cameras"
        ,Currencies   = "Currencies"
        ,Exchanges    = "Exchanges"
        ,Operations   = "Operations"
        ,OperControl  = "OperControl"
        ,OperLog      = "OperLog"
        ,Flows        = "Flows"
        ,Providers    = "Providers"
        ,Parameters   = "Parameters"

        # ,Control      = "SESSION_CONTROL"
        # ,Session      = "SESSION"
        # ,sesExchanges = "SESSION_EXCHANGES"

    )
    ,flag = list(inactive=0, active=1)
    ,oper = list( oper=1, buy=2, sell=3, xfer=4, split=5, net=6, reg=10)
    ,flow = list( pending = 0
                 ,input   = 20, regInput  = 21
                 ,output  = 30, regOutput = 32
                 ,xfer    = 40, xferIn    = 41, xferOut = 42
                 ,fee     = 52, gas = 54
      )
    ,status = list(
         pending   =  0  # Pendiente de procesar
        ,accepted  =  1  # Aceptado para procesar
        ,executed  =  2  # Ejecutada en el blockchain
        ,cancelled =  4  # Cancelada
        ,rejected  =  8  # No aceptada o no cumplio los parametros
        ,closed    = 16  # Finalizada
        ,split     = 32  # Se ha spliteado
    )
    ,default = list(
      interval = 15
    )
    ,xlateStatus = function(status) { private$xlate(self$status, status) }
   )
  ,private = list(
     xlate = function(src, value) {
       names(which(src == value))[1]
     }
  )
)
