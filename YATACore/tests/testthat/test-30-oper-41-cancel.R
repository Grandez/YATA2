context("Cancel Operation")

# Ciclo de vida de una operacion simple
# Abrir / Aceptar / Ejecutar / Vender / Aceptar / Ejecutar

initDB()

oper     = YATAFactory$getObject(YATACodes$object$operation)
cameras  = YATAFactory$getObject(YATACodes$object$cameras)
position = YATAFactory$getObject(YATACodes$object$position)

test_that("Environment correct", {
   oper$xfer(from="EXT"
            ,to="CASH"
            ,amount=2000
            ,currency="EUR")
   oper$xfer(from="CASH"
            ,to="TEST"
            ,amount=2000
            ,currency="EUR")
   cam1 = position$getCameraPosition("TEST")
   expect_equal(cam1[1,"available"],  2000)
   expect_equal(cam1[1,"balance"],    2000)

})

test_that("Open and Delete operation", {
   idOper <<- oper$open(camera  = "TEST"
                       ,base    = "EUR"
                       ,counter = "BTC"
                       ,amount  = 10
                       ,price   = 100
   )
   expect_true(idOper > 0, label = "Buying BTC")

   oper$cancel(idOper, delete=TRUE)

   df = oper$getOperationsExt()
   expect_equal(nrow(df),  2, label="La operacion no ha sido borrada")

   cam1 = position$getCameraPosition("TEST")
   expect_equal(cam1[1,"available"],  2000)
   expect_equal(cam1[1,"balance"],    2000)

})

test_that("Open and Cancel operation", {
   idOper <<- oper$open(camera  = "TEST"
                       ,base    = "EUR"
                       ,counter = "BTC"
                       ,amount  = 10
                       ,price   = 100
   )
   expect_true(idOper > 0, label = "Buying BTC")

   oper$cancel(id=idOper)

   df = oper$getOperationsExt()
   expect_equal(nrow(df),  3, label="La operacion ha sido borrada")

   df = oper$getActive()
   expect_equal(nrow(df),  0, label="Operaciones activas")

   cam1 = position$getCameraPosition("TEST")
   expect_equal(cam1[1,"available"],  2000)
   expect_equal(cam1[1,"balance"],    2000)

})

