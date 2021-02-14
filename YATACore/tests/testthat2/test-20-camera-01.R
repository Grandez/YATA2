context("Cameras")

initDB()
cameras  = YATAFactory$getObject(YATACodes$object$cameras)

test_that("Cameras initialize", {
   expect_equal(nrow(cameras$getActiveCameras()), 1)
   expect_equal(nrow(cameras$getInactiveCameras()), 1)
   expect_equal(nrow(cameras$getAllCameras()), 2)
})

test_that("Cameras new", {
   data = list(
      id = "TEST2"
      ,name = "TEST Other camera"
   )
   cameras$add(data)
   expect_equal(nrow(cameras$getActiveCameras()), 2)
   expect_equal(nrow(cameras$getInactiveCameras()), 1)
   expect_equal(nrow(cameras$getAllCameras()), 3)
})

test_that("Cameras new inactive", {
   data = list(
      id = "TEST3"
      ,name = "TEST Other camera2"
      ,active = 0
   )
   cameras$add(data)
   expect_equal(nrow(cameras$getActiveCameras()), 2)
   expect_equal(nrow(cameras$getInactiveCameras()), 2)
   expect_equal(nrow(cameras$getAllCameras()), 4)
})

test_that("Switch status 1", {
   cameras$select(id="TEST3")
   cameras$switchStatus(isolated=TRUE)
   expect_equal(nrow(cameras$getActiveCameras()), 3)
   expect_equal(nrow(cameras$getInactiveCameras()), 1)
   expect_equal(nrow(cameras$getAllCameras()), 4)
})

test_that("Switch status 2", {
   cameras$switchStatus("TEST3", isolated=TRUE)
   expect_equal(nrow(cameras$getActiveCameras()), 2)
   expect_equal(nrow(cameras$getInactiveCameras()), 2)
   expect_equal(nrow(cameras$getAllCameras()), 4)
})

