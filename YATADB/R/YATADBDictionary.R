# Diccionario de datos de la BBDD
# Contiene los codigos que se usan en la BBDD
DBDict = list(
    tables = list(
         Position     = "POSITION"
        ,PositionHist = "HIST_POSITION"
        ,Flows        = "FLOWS"
        ,Operations   = "OPERATIONS"
        ,OperControl  = "OPERATIONS_CONTROL"
        ,OperLog      = "OPERATIONS_LOG"
        ,Control      = "SESSION_CONTROL"
        ,Session      = "SESSION"
        ,sesExchanges = "SESSION_EXCHANGES"
    )
    ,baseTables = list(
         Currencies   = "CURRENCIES"
        ,Cameras      = "CAMERAS"
        ,Exchanges    = "EXCHANGES"
        ,Parameters   = "PARMS"
        ,Providers    = "PROVIDERS"
        ,Path         = "PATH"
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
    )
)
