# Diccionario de datos de la BBDD
# Contiene los codigos que se usan en la BBDD de configuracion
DBParms = list(
    # Para simplificar la escritura
    ids = list(
         fiat        = "001 001 001"  # Moneda por defecto
        ,camera      = "001 002 001"  # Camera real
        ,autoConnect = "001 003 001"  # Auto abrir la ultima BBDD
        ,DBDefault   = "001 003 002"  # BBDD Default
        ,lastOpen    = "001 003 003"  # Ultima BBDD abierta
        ,alert       = "001 003 001"  # Dias para alerta
        ,rest        = "001 004"      # REST Informacion
        ,online      = "003 001 001"  # Proveedor de informacion Online
        ,interval    = "003 001 002"  # Intervalo en minutos para update
        ,base        = "003 001 003"  # Moneda base
        ,closeTime   = "003 001 004"  # Hora de cierre de las sesiones

    )
    ,block = list ( # grupo - subgrupo - [block]
        session = "001 010 001"
       ,history = "001 011 001"
    )
    ,group = list(
       general   =  1
      ,servers   =  2
      ,providers =  3
      ,databases =  5
      ,prefs     = 10
      ,reasons   = 15
    )
    ,general   =  list(
        subgroup = list(
           config     = 1
          ,databases  = 2
          ,operations = 3
          ,rest       = 4
        )
       ,databases = list(
            autoConnect = 1
           ,DBDefault   = 2
           ,lastOpen    = 3
        )
        ,operations = list(
           alert = 1
        )
        ,rest = list(
            url  = 1
           ,port = 2
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
          ,descr    =  8
          ,active   = 10
        )
    )
    ,providers = list(

    )
   ,prefs = list(

  )
  ,reasons = list(
     gral  = 0
    ,buy   = 1
    ,sell  = 2
    ,open  = 3
    ,close = 4
  )
)
