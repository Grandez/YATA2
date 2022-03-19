YATACODES = R6::R6Class("YATA.CODES"
   ,portable  = FALSE
   ,cloneable = FALSE
   ,lock_class = TRUE
   ,public     = list(
    print = function() { message("Global Names and Codes")}
   ,object = list(
      parms      = "Parms"
     ,operation  = "Operation"
     ,cameras    = "Cameras"
     ,position   = "Position"
     ,currencies = "Currencies"
     ,providers  = "Providers"
     ,session    = "Session"
     ,blog       = "Blog"
     ,history    = "History"
     ,favorites = "Favorites"
     ,SVG        = "SVG"
    )
    ,tables = list(
         position       = "Position"
        ,regularization = "Regularization"
        ,transfer       = "Transfers"
        ,positionHist   = "PositionHist"
        ,clearings      = "Clearings"
        ,cameras        = "Cameras"
        ,currencies     = "Currencies"
        ,exchanges      = "Exchanges"
        ,operations     = "Operations"
        ,operControl    = "OperControl"
        ,operLog        = "OperLog"
        ,flows          = "Flows"
        ,providers      = "Providers"
        ,parameters     = "Parameters"
        ,messages       = "Messages"
        ,session        = "Session"
        ,sessionCtrl    = "SessionCtrl"
        ,blog           = "Blog"
        ,history        = "History"
        ,favorites      = "Favorites"
    )
    ,flag = list(inactive=0, active=1, parent=2)
    ,oper = list( oper  =  0
                 ,bid   =  1, buy  =  2
                 ,ask   = 11, sell = 12
                 ,xfer  = 21, reg  = 22
                 ,split = 31, net  = 32
                 ,close = 50)

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
        ,net       = 64  # Se ha neteado
    )
    ,default = list(
      interval = 15
    )
    #JGG A revisar
    ,log    = list(log=0,open=1,buy=2,sell=3,accept=10,executed=11, cancel=99,reject=98)
    ,reason = list(accept=90,executed=91, cancel=92,reject=93)
    ,xlateStatus = function(status) { private$xlate(self$status, status) }
   )
  ,private = list(
     xlate = function(src, value) {
       names(which(src == value))[1]
     }
  )
)
