# Diccionario de datos de la BBDD
# Contiene los codigos que se usan en la BBDD
DBDict = list(
    parts  = list(
       Operations   = "OPERATIONS"
      ,FIAT         = "FIAT"        # Completa
    )
    ,base = list(
       Messages     = "MESSAGES"
      ,Parameters   = "PARMS"
      ,Parms        = "PARMS"
      ,Providers    = "PROVIDERS"
    )
    ,data = list(
       Control       = "CONTROL"
      ,Currencies    = "CURRENCIES"
      ,Exchanges     = "EXCHANGES"
      ,ExchangesCtc  = "EXCHANGES_CTC"
      ,ExchangesFiat = "EXCHANGES_FIAT"
      ,ExchangesPair = "EXCHANGES_PAIR"
      ,Fiat          = "FIAT"   # Solo la moneda
      ,History       = "HISTORY"
      ,ModelVar      = "MODEL_VAR"
      ,Session       = "SESSION"

    )
    ,tables = list(
       Alerts         = "ALERTS"
      ,Blog           = "BLOG"
      ,Cameras        = "CAMERAS"
      ,Favorites      = "FAVORITES"
      ,Flows          = "FLOWS"
      ,Operations     = "OPERATIONS"
      ,OperControl    = "OPERATIONS_CONTROL"
      ,OperLog        = "OPERATIONS_LOG"
      ,Position       = "POSITION"
      ,PositionHist   = "HIST_POSITION"
      ,Regularization = "REGULARIZATION"
      ,Transfers      = "TRANSFERS"
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
