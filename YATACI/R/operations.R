    # ,oper = list( bid   = 10, ask   = 11
    #              ,buy   = 20, sell  = 21
    #              ,open  = 30, close = 31
    #              ,xfer  = 40, reg   = 41
    #              ,split = 50, net   = 51
    #              )

testOperations = function() {
    banner("OPERATIONS")
    rc = testTransfers()
    rc = testBuyCall()
    # println(0, crayon::bold("Ejecutando compras"))
    # buying(factory)
    # rc
}

