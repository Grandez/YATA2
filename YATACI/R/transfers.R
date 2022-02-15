message("Chequeando transferencias ")

# Encapsulamos las funciones del modulo en una clase
# Factoria para Obtener diferentes objetos
# Los dejamos en lazy para no crear referencias circulares con los
# singletons YATABase.

TSTTransfer = R6::R6Class("YATA.CI.XFER"
   ,portable  = FALSE
   ,cloneable = FALSE
   ,lock_class = TRUE
   ,inherit    = YATACIBase
   ,public = list(
       db  = NULL
      ,tblXfer = NULL
      ,objOper = NULL

      ,initialize = function(mode) {
          super$initialize(mode, "Transferencias")
          self$db      = Factory$getDB()
          self$tblXfer = Factory$getTable(Tables$transfer)
          self$objOper = Factory$getObject(Codes$object$operation)
       }
      ,finalize   = function() {
          message("Deleting TSTTransfer")
        }
      ,initEnv = function() {
          cleanEnv()
          tblPos = Factory$getTable(Tables$position)
          tryCatch({
             db$begin()
             tblPos$add(list(camera="CASH", currency="EUR", balance="10000", available="10000", value=1))
             db$commit()
          }, error = function (e) {
               db$rollback()
              .error(e, "iniciando entorno")
          })
      }
     ,cleanEnv = function() {
          TablesDB = YATADB:::DBDict$tables
          tbls   = list( TablesDB$Position
                        ,TablesDB$Operations, TablesDB$OperControl, TablesDB$OperLog
                        ,TablesDB$Transfer
                        ,TablesDB$Flows
                       )
          tryCatch({
             db$begin()
             lapply(tbls, function(tbl) db$execute(paste("DELETE FROM", tbl)))
             db$commit()
          }, error = function (e) {
               db$rollback()
              .error(e, "Deleting tables")
          })
     }
   )
)


.xferInitial = function(cls) {
    cls$lbl("Transferring from CASH to YATA")
    cls$initEnv()
    res = cls$objOper$xfer(from="CASH", to="YATA",currency="EUR", amount=10000, price=1)
    rows = list(
        list(table=Tables$transfer,   rows = 1)
       ,list(table=Tables$position,   rows = 2)
       ,list(table=Tables$operations, rows = 2)
       ,list(table=Tables$flows,      rows = 2)
    )
    rc = tryCatch({
        checkNumRows(rows)
        values = list(amount=10000)
        checkRowValues(Tables$transfer, NULL, values)
        values = list(base="EUR", counter="EUR", amount=10000, value=10000)
        checkRowValues(Tables$operations, list(camera="CASH"), values)
        checkRowValues(Tables$operations, list(camera="YATA"), values)
        values = list(balance=0, available=0)
        checkRowValues(Tables$position, list(camera="CASH", currency="EUR"), values)
        values = list(balance=10000, available=10000)
        checkRowValues(Tables$position, list(camera="YATA", currency="EUR"), values)
        FALSE
    }, error = function(e) { TRUE })

    if (rc) return (TRUE)
    cls$ok()
    FALSE
}
.xferReturn  = function(cls) {
    cls$lbl("Returning 2500 to CASH")
    res = cls$objOper$xfer(from="YATA", to="CASH",currency="EUR", amount=2500)

    rc = tryCatch({
        rows = list(
            list(table=Tables$transfer,   rows = 2)
           ,list(table=Tables$position,   rows = 2)
           ,list(table=Tables$operations, rows = 4)
           ,list(table=Tables$flows,      rows = 4)
        )
        checkNumRows(rows)
        values = list(amount=2500, value=1)
        checkRowValues(Tables$transfer, list(cameraIn="CASH", cameraOut="YATA"), values)
        values = list(balance=2500, available=2500, value=1)
        checkRowValues(Tables$position, list(camera="CASH", currency="EUR"), values)
        values = list(balance=7500, available=7500, value=1)
        checkRowValues(Tables$position, list(camera="YATA", currency="EUR"), values)
        FALSE
    }, error = function(e) { TRUE })

    if (rc) return (TRUE)
    cls$ok()
    FALSE
}
.xferCTC_01  = function(cls) {
    # de YATA/CTC/100 a OTHER/CTC/75
    cls$lbl("Transferring BTC between cameras")

    # Prepare Environment
    cls$cleanEnv()
    tryCatch({
       cls$db$begin()
       tblPos = Factory$getTable(Tables$position)
       tblPos$add(list(camera="YATA", currency="CTC", balance="100", available="100", value=150))
       cls$db$commit()

    }, error = function (e) {
       cls$db$rollback()
       .error(e, "Setting environment for xferCTC_01")
    })

    res = cls$objOper$xfer(from="YATA", to="OTHER",currency="CTC", amount=75)
    rc = tryCatch({
        rows = list(
            list(table=Tables$transfer,   rows = 1)
           ,list(table=Tables$position,   rows = 2)
           ,list(table=Tables$operations, rows = 2)
           ,list(table=Tables$flows,      rows = 2)
        )
        checkNumRows(rows)
        values = list(amount=75, value=150)
        checkRowValues(Tables$transfer, list(cameraOut="YATA", cameraIn="OTHER"), values)
        values = list(balance=25, available=25)
        checkRowValues(Tables$position, list(camera="YATA", currency="CTC"), values)
        values = list(balance=75, available=75, value=150)
        checkRowValues(Tables$position, list(camera="OTHER", currency="CTC"), values)
        FALSE
    }, error = function(e) { TRUE })

    if (rc) return (TRUE)
    cls$ok()
    FALSE
}

testTransfers = function(mode) {
    cls = TSTTransfer$new(mode)
    .xferInitial (cls)
    .xferReturn  (cls)
    .xferCTC_01  (cls)
    cls = NULL
}
