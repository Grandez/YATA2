context("Transferencias")

initEnv = function() {
    tblPosition = Factory$getTable(Codes$tables$transfer)
    tables=list( Codes$tables$Position
                ,Codes$tables$Operations, Codes$tables$OperControl, Codes$tables$OperLog
                ,Codes$tables$Transfer
                ,Codes$tables$Flows
       )

    tryCatch({
        db$begin()
        lapply(tables, function(tbl) db$execute(paste("DELETE FROM", tbl)))
        tblPosition$add(camera="CASH", currency="EUR", balance="10000", available="10000")
        db$commit()
    }, error = function (e) { .oper_rollback(db,e, "Error iniciando entorno") })
}


test_that("Transfer initial", {
   browser()
   res = pnl$operations$xfer(from="CASH", to="YATA",currency="EUR", amount=10000)
   expect_equal(nrow(cameras$getCameras()),  1)
   expect_equal(length(position$getCameras()), 1)

   opers = oper$getOperationsExt()
   oper$select(opers[1,"id"],full=TRUE)

   expect_equal(nrow(opers),  1)
   expect_equal(oper$current$amount, 1000)
   expect_equal(nrow(oper$getFlows()),  1)

})

initDB()
oper     = YATAFactory$getObject(YATACodes$object$operation)
cameras  = YATAFactory$getObject(YATACodes$object$cameras)
position = YATAFactory$getObject(YATACodes$object$position)

test_that("Transfer External 1000", {
   oper$add( type = YATACodes$oper$xfer
            ,from="EXT"
            ,to="CASH"
            ,amount=1000
            ,currency="EUR")

   expect_equal(nrow(cameras$getCameras()),  1)
   expect_equal(length(position$getCameras()), 1)

   opers = oper$getOperationsExt()
   oper$select(opers[1,"id"],full=TRUE)

   expect_equal(nrow(opers),  1)
   expect_equal(oper$current$amount, 1000)
   expect_equal(nrow(oper$getFlows()),  1)

})

test_that("Transfer External 2000", {
   oper$xfer(from="EXT"
            ,to="CASH"
            ,amount=2000
            ,currency="EUR")

   expect_equal(nrow(cameras$getCameras()),  1)
   expect_equal(length(position$getCameras()), 1)

   opers = oper$getOperationsExt()
   expect_equal(nrow(opers),  2)
   df = position$getCameraPosition("CASH")
   expect_equal(df[1,"balance"],  3000)
})

test_that("Transfer Return all", {
   oper$xfer(from="CASH"
            ,to="EXT"
            ,amount=3000
            ,currency="EUR")

   expect_equal(nrow(cameras$getCameras()),  1)
   expect_equal(length(position$getCameras()), 1)

   opers = oper$getOperationsExt()
   expect_equal(nrow(opers),  3)
   df = position$getCameraPosition("CASH")
   expect_equal(df[1,"balance"],  0)
})
