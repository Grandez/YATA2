# Diccionario de datos de la BBDD
# Contiene los codigos que se usan en la BBDD
DBParms = list(
    # Para simplificar la escritura
    ids = list(
         currency    = "001 001 001"  # Moneda por defecto
        ,altCurrency = "001 001 002"  # Moneda por defecto
        ,plugins     = "001 001 003"  # directorio externo
        ,autoConnect = "001 002 001"  # Auto abrir la ultima BBDD
        ,DBDefault   = "001 002 002"  # BBDD Default
        ,lastOpen    = "001 002 003"  # Ultima BBDD abierta
        ,alert       = "001 003 001"  # Dias para alerta
        ,online      = "003 001 001"  # Proveedor de informacion Online
        ,interval    = "003 001 002"  # Intervalo en minutos para update
        ,base        = "003 001 003"  # Moneda base
        ,closeTime   = "003 001 004"  # Hora de cierre de las sesiones
    )
    ,group = list(
       general   =  1

      ,providers =  3
      ,databases =  5
      ,prefs     = 10
    )
    ,general   =  list(
        subgroup = list(
           config     = 1
          ,databases  = 2
          ,operations = 3
        )
       ,databases = list(
            autoConnect = 1
           ,DBDefault   = 2
           ,lastOpen    = 3
        )
        ,operations = list(
           alert = 1
        )
    )
    ,databases = list(
         subgroup = list(db = "db")
         ,db = list(
           name     =  1
          ,engine   =  2
          ,dbname   =  3
          ,user     =  4
          ,password =  5
          ,host     =  6
          ,port     =  7
          ,active   = 10
        )
    )
    ,providers = list(

    )
   ,prefs = list(

  )
)
