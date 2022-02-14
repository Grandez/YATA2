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
          TablesDB = YATADB:::DBDict$tables
          tbls   = list( TablesDB$Position
                        ,TablesDB$Operations, TablesDB$OperControl, TablesDB$OperLog
                        ,TablesDB$Transfer
                        ,TablesDB$Flows
                       )
          tblPos = Factory$getTable(Tables$position)
          tryCatch({
             db$begin()
             lapply(tbls, function(tbl) db$execute(paste("DELETE FROM", tbl)))
             tblPos$add(list(camera="CASH", currency="EUR", balance="10000", available="10000"))
             db$commit()
          }, error = function (e) {
               db$rollback()
              .error(e, "iniciando entorno")
          })
       }
   )
)


.xferInitial = function(cls) {
    cls$out("Transferring from CASH to YATA")
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
    cls$out("Returning 5000 to CASH")
    res = cls$objOper$xfer(from="YATA", to="CASH",currency="EUR", amount=5000, price=1)
    rc = tryCatch({
        rows = list(
            list(table=Tables$transfer,   rows = 2)
           ,list(table=Tables$position,   rows = 2)
           ,list(table=Tables$operations, rows = 4)
           ,list(table=Tables$flows,      rows = 4)
        )
        checkNumRows(rows)
        values = list(amount=5000, price=1)
        checkRowValues(Tables$transfer, list(cameraIn="YATA", cameraOut="CASH"), values)
        # values = list(base="EUR", counter="EUR", amount=10000, value=10000)
        # checkRowValues(Tables$operations, list(camera="CASH"), values)
        # checkRowValues(Tables$operations, list(camera="YATA"), values)
        values = list(balance=5000, available=5000)
        checkRowValues(Tables$position, list(camera="CASH", currency="EUR"), values)
        checkRowValues(Tables$position, list(camera="YATA", currency="EUR"), values)
        FALSE
    }, error = function(e) { TRUE })

    if (rc) return (TRUE)
    cls$ok()
    FALSE
}

testTransfers = function(mode) {
    Cls = TSTTransfer$new(mode)
    .xferInitial(Cls)
    .xferReturn(Cls)
    Cls = NULL
}

# test_that("Transfer initial", {
#    browser()
#    res = pnl$operations$xfer(from="CASH", to="YATA",currency="EUR", amount=10000)
#    expect_equal(nrow(cameras$getCameras()),  1)
#    expect_equal(length(position$getCameras()), 1)
#
#    opers = oper$getOperationsExt()
#    oper$select(opers[1,"id"],full=TRUE)
#
#    expect_equal(nrow(opers),  1)
#    expect_equal(oper$current$amount, 1000)
#    expect_equal(nrow(oper$getFlows()),  1)
#
# })
