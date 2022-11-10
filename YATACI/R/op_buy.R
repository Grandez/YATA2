
buying = function (factory) {
    xfer_init(factory, "CI1")
#    buy_01(factory)
}
buy_01 = function(factory) {
  print  (1, "Operacion simple")
  tryCatch({
    oper = factory$getObject("Operation")
    data = list(
             type    = YATACODE$oper$buy
            ,amount  = 1
            ,price   = 100
            ,value   = 1 * 100
            ,fee     = 0
            ,gas     = 0
            ,camera  = "CI1"
            ,reason  = 0
            ,base    = 0
            ,counter = 1
            ,ctcIn   = 1
            ,ctcOut  = 1 * 100
         )
    browser()
    id = oper$add(data$type, data)
    result(0)
  }, error = function (cond) {
      result(-1)
      fail(cond)
  })

}
