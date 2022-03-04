# Diccionario de datos de la BBDD
# Contiene los codigos que se usan en la BBDD
DBDict = list(
    parts  = list(
#      Position     = "POSITION"
      operations   = "OPERATIONS"
    )
    ,base = list(
         parameters   = "PARMS"
        ,providers    = "PROVIDERS"
        ,messages     = "MESSAGES"
        ,parms        = "PARMS"
    )
    ,data = list(
         allCameras   = "GLOBAL_CAMERAS"
        ,currencies   = "CURRENCIES"
        ,history      = "HISTORY"
        ,session      = "SESSION"
        ,exchanges    = "EXCHANGES"
    )
    ,tables = list(
         cameras        = "CAMERAS"
        ,position       = "POSITION"
        ,positionHist   = "HIST_POSITION"
        ,regularization = "REGULARIZATION"
        ,operations     = "OPERATIONS"
        ,operControl    = "OPERATIONS_CONTROL"
        ,operLog        = "OPERATIONS_LOG"
        ,flows          = "FLOWS"
        ,blog           = "BLOG"
        ,transfers      = "TRANSFERS"
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
