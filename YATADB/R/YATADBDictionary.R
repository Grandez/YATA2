# Diccionario de datos de la BBDD
# Contiene los codigos que se usan en la BBDD
DBDict = list(
    parts  = list(
#      Position     = "POSITION"
      Operations   = "OPERATIONS"
    )
    ,tables = list(
         Position     = "POSITION"
        ,Regularization = "REGULARIZATION"
        ,PositionHist = "HIST_POSITION"
        ,Operations   = "OPERATIONS"
        ,OperControl  = "OPERATIONS_CONTROL"
        ,OperLog      = "OPERATIONS_LOG"
        ,Flows        = "FLOWS"
        ,Session      = "SESSION"
        ,Blog         = "BLOG"
        ,Transfers    = "TRANSFERS"
    )
    ,baseTables = list(
         Cameras      = "CAMERAS"
        ,Currencies   = "CURRENCIES"
        ,Exchanges    = "EXCHANGES"
        ,Parameters   = "PARMS"
        ,Providers    = "PROVIDERS"
        ,Path         = "PATH"
        ,Messages     = "MESSAGES"
        ,History      = "HISTORY"
    )
    ,fields = list(
         active    = "ACTIVE"
        ,available = "AVAILABLE"
        ,fee       = "FEE"
        ,gas       = "GAS"
        ,symbol    = "SYMBOL"
    )
    ,types = list(
       string =   1
      ,integer = 10
      ,numeric = 11
      ,boolean = 20
      ,tms     = 30
      ,date    = 31
      ,time    = 32
    )
    ,flag = list(
       on = 1
      ,off = 0
      ,parent = 2
    )
  ,blog = list(
      gral = 0
      ,all  = 1
      ,note = 2
      ,currency = 10
      ,oper = 11
  )
  ,messages = list(
      oper    =  1
     ,monitor = 10
     ,plots   = 11
  )
)
