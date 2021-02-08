context("Sell Operation simple")

initDB()

oper     = YATAFactory$getObject(YATACodes$object$operation)
cameras  = YATAFactory$getObject(YATACodes$object$cameras)
position = YATAFactory$getObject(YATACodes$object$position)

test_that("Environment correct", {
   oper$xfer(from="EXT" ,to="CASH",amount=2000,currency="EUR")
   oper$xfer(from="CASH",to="TEST",amount=2000,currency="EUR")
   idOper = oper$buy(camera="TEST",base="EUR",counter="BTC",amount=10,price=100)
   oper$accept   (id=idOper)
   oper$execute  (id=idOper)
expect_true(idOper > 0, label = "Buying BTC")

})

test_that("Sell 10 BTC", {
   idOper <<- oper$sell(camera="TEST",base="EUR",counter="BTC",amount=10,price=100)
   expect_true(idOper > 0, label = "Buying BTC")
   expect_equal(nrow(oper$getOperations()), 1, label="Unica operacion activa")
   oper$select(idOper)

   expect_equal(oper$current$amount, -10, label="Amount must be -10")
   expect_equal(oper$current$price,  100,  label="Price must be 100")
})

test_that("Accept Operation default", {
   oper$accept(id=idOper)

   lstOper = oper$getOperation(idOper)
   expect_equal(lstOper$status, YATACodes$status$accepted, label="Estado es aceptada")
   expect_equal(lstOper$active, YATACodes$flag$active,     label="Operacion activa")

   cam1 = position$getCameraPosition("TEST")
   expect_equal(cam1[cam1$currency == "EUR","available"],  1000)
   expect_equal(cam1[cam1$currency == "EUR","balance"],    1000)
   expect_equal(cam1[cam1$currency == "BTC","available"],     0)
   expect_equal(cam1[cam1$currency == "BTC","balance"],       0)

   flows = YATAFactory$getTable(YATACodes$tables$Flows, force=TRUE)
   expect_equal(flows$rows(),    7)
})

test_that("Execute Operation default", {
   oper$select(idOper)
   oper$execute()

   lstOper = oper$getOperation(idOper)
   expect_equal(lstOper$status, YATACodes$status$executed, label="Estado es aceptada")
   expect_equal(lstOper$active, YATACodes$flag$inactive,   label="Operacion acabada")

   cam1 = position$getCameraPosition("TEST")
   expect_equal(cam1[cam1$currency == "EUR","balance"],   2000)
   expect_equal(cam1[cam1$currency == "EUR","available"], 2000)
   expect_equal(cam1[cam1$currency == "BTC","balance"],      0)
   expect_equal(cam1[cam1$currency == "BTC","available"],    0)

   flows = YATAFactory$getTable(YATACodes$tables$Flows, force=TRUE)
   expect_equal(flows$rows(),    7)
})
