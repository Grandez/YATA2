# Diccionario de datos de la BBDD
# Contiene los codigos que se usan en la BBDD
DBDict = list(
    parts  = list(
       Operations   = "OPERATIONS"
    )
    ,base = list(
       Parameters   = "PARMS"
      ,Providers    = "PROVIDERS"
      ,Messages     = "MESSAGES"
      ,Parms        = "PARMS"
    )
    ,data = list(
       Currencies    = "CURRENCIES"
      ,History       = "HISTORY"
      ,Session       = "SESSION"
      ,Exchanges     = "EXCHANGES"
      ,ExchangesFiat = "EXCHANGES_FIAT"
      ,ExchangesCtc  = "EXCHANGES_CTC"
      ,Control       = "CONTROL"
    )
    ,tables = list(
       Cameras        = "CAMERAS"
      ,Position       = "POSITION"
      ,PositionHist   = "HIST_POSITION"
      ,Regularization = "REGULARIZATION"
      ,Operations     = "OPERATIONS"
      ,OperControl    = "OPERATIONS_CONTROL"
      ,OperLog        = "OPERATIONS_LOG"
      ,Flows          = "FLOWS"
      ,Blog           = "BLOG"
      ,Transfers      = "TRANSFERS"
      ,Favorites      = "FAVORITES"
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
