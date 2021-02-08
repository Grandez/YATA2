context("Parameters Object")


test_that("Friendly names", {
   parms = YATAFactory$getParms()

   expect_equal(parms$autoConnect(), TRUE)
   expect_true (is.list(parms$lastOpen()))
   expect_equal(parms$getOnlineProvider(), "POL")
   expect_equal(parms$getOnlineInterval(),     5)
   expect_equal(parms$getBaseCurrency(),   "EUR")
   expect_equal(parms$getCloseTime(),         22)
   expect_equal(parms$getAlertDays(),          1)

   # parms$currencies = function(codes) {
   # parms$getCurrencyNames = function(codes, full) {

})

