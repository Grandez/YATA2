# Numeric codes in databases and values
YATACODE = list(
    # Palabras reservadas
    CAMFIAT = "FIAT"
   ,CAMEXT  = "CASH"
   ,CTCFIAT = 0
    ,flag = list(inactive=0, active=1, parent=2)
     # Code: x0 - Buy (Entra), x1 - Sell (Sale)
     #       1x - Proposal     2x - Real  3x - posicion
    ,oper = list( bid   = 10, ask    = 11
                 ,buy   = 20, sell   = 21
                 #,open  = 30, close  = 31
                 ,xfer  = 40, reg    = 41
                 ,split = 50, net    = 51
                 ,opBuy =  0, opSell =  1
                 )
    # Codigos para la razon de la operacion
    # El numero mayor indica a que aplica de acuerdo con el codigo de operacion
    # 0 - Todo
    # 1x/2x - Compras en general
    # 3x/4x - Ventas en general
    # 9x    - Fallos o rechazos
    # Los literales van el la tabla de mensajes. Clave 33
    ,reasons = list(
       none        =     0
      ,other       =     1
      ,up          =    11
      ,suggest     =    12
      ,top         =    13
      ,down        =    31
      ,target      =    32
      ,limit       =    33
      ,change      =    41
      ,cancel      =    90
      ,reject      =    91
      ,fail        =    99
    )
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
    ,blog = list (
        general   = 0
       ,session   = 1
       ,currency  = 2
       ,operation = 3
    )
    ,labels = list( # Bloques de mensajes/textos
        words     =   1
       ,periods   =   3
       ,monitors  =   5
       ,lblPanels =  20
       ,mnuMain   =  21
       ,mnuOper   =  22
       ,PnlError  =  29
       ,opecodes  =  31
       ,oper      =  32
       ,reasons   =  33
       ,target    =  34  # Intradia / Medio / largo
       ,currency  =  35  # Moneda o token
       ,blog      =  36
    )
    #JGG A revisar
    # ,log    = list(log=0,open=1,buy=2,sell=3,accept=10,executed=11, cancel=99,reject=98)
    # ,reason = list(accept=90,executed=91, cancel=92,reject=93)
    # ,xlateStatus = function(status) { private$xlate(self$status, status) }
   )

# YATACODES = R6::R6Class("YATA.CODES"
#    ,portable  = FALSE
#    ,cloneable = FALSE
#    ,lock_class = TRUE
#    ,public     = list(
#     print = function() { message("Global Names and Codes")}
#    ,object = list(
#       alerts     = "Alerts"
#      ,blog       = "Blog"
#      ,cameras    = "Cameras"
#      ,currencies = "Currencies"
#      ,exchanges  = "Exchanges"
#      ,favorites  = "Favorites"
#      ,history    = "History"
#      ,operation  = "Operation"
#      ,parms      = "Parms"
#      ,portfolio  = "Portfolio"
#      ,position   = "Position"
#      ,session    = "Session"
#      ,SVG        = "SVG"
#     )
#     ,tables = list(
#        alerts         = "Alerts"
#       ,blog           = "Blog"
#       ,cameras        = "Cameras"
#       ,config         = "Config"
#       ,control        = "Control"
#       ,currencies     = "Currencies"
#       ,exchanges      = "Exchanges"
#       ,exchanges_pair = "ExchangesPair"
#       ,favorites      = "Favorites"
#       ,flows          = "Flows"
#       ,history        = "History"
#       ,messages       = "Messages"
#       ,modelVar       = "ModelVar"
#       ,operations     = "Operations"
#       ,operControl    = "OperControl"
#       ,operLog        = "OperLog"
#       ,parameters     = "Parameters"
#       ,position       = "Position"
#       ,positionHist   = "PositionHist"
#       ,regularization = "Regularization"
#       ,session        = "Session"
#       ,transfer       = "Transfers"
#     )
#     ,flag = list(inactive=0, active=1, parent=2)
#      # Code: x0 - Buy (Entra), x1 - Sell (Sale)
#      #       1x - Proposal     2x - Real  3x - posicion
#     ,oper = list( bid   = 10, ask   = 11
#                  ,buy   = 20, sell  = 21
#                  ,open  = 30, close = 31
#                  ,xfer  = 40, reg   = 41
#                  ,split = 50, net   = 51
#                  )
#
#     ,flow = list( pending = 0
#                  ,input   = 20, regInput  = 21
#                  ,output  = 30, regOutput = 32
#                  ,xfer    = 40, xferIn    = 41, xferOut = 42
#                  ,fee     = 52, gas = 54
#       )
#     ,status = list(
#          pending   =  0  # Pendiente de procesar
#         ,accepted  =  1  # Aceptado para procesar
#         ,executed  =  2  # Ejecutada en el blockchain
#         ,cancelled =  4  # Cancelada
#         ,rejected  =  8  # No aceptada o no cumplio los parametros
#         ,closed    = 16  # Finalizada
#         ,split     = 32  # Se ha spliteado
#         ,net       = 64  # Se ha neteado
#     )
#     ,default = list(
#       interval = 15
#     )
#     ,labels = list( # Bloques de mensajes/textos
#         words     =   1
#        ,periods   =   3
#        ,monitors  =   5
#        ,lblPanels =  20
#        ,mnuMain   =  21
#        ,mnuOper   =  22
#        ,PnlError  =  29
#        ,opecodes  =  31
#        ,operation =  32
#        ,reasons   =  33
#     )
#     #JGG A revisar
#     ,log    = list(log=0,open=1,buy=2,sell=3,accept=10,executed=11, cancel=99,reject=98)
#     ,reason = list(accept=90,executed=91, cancel=92,reject=93)
#     ,xlateStatus = function(status) { private$xlate(self$status, status) }
#    )
#   ,private = list(
#      xlate = function(src, value) {
#        names(which(src == value))[1]
#      }
#   )
# )
