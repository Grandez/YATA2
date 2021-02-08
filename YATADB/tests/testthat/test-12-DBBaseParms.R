context("Tabla de Parametros")

DBfact = YATADBFactory$new(cfg$base)
db     = DBfact$getDB(cfg$base)
parms  = DBfact$getTable("Parameters")

initDB = function() {
    db$begin()
    db$execute("INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (?,?,?,?,?,?)",
               params=list(900,  1,  1,  1, "Cadena", "valor"))

    db$execute("INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (?,?,?,?,?,?)",
               params=list(900,  2,  1, 10, "Entero", "10"))

    db$execute("INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (?,?,?,?,?,?)",
               params=list(900,  3,  1, 11, "Numero", "11"))
    db$execute("INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (?,?,?,?,?,?)",
               params=list(900,  3,  2, 11, "Numero", "12.3"))
    db$execute("INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (?,?,?,?,?,?)",
               params=list(900,  3,  3, 11, "Numero", "-3.45"))

    db$execute("INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (?,?,?,?,?,?)",
               params=list(900,  4,  1, 20, "Logico", "0"))
    db$execute("INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (?,?,?,?,?,?)",
               params=list(900,  4,  2, 20, "Logico", "1"))
    db$execute("INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (?,?,?,?,?,?)",
               params=list(900,  4,  3, 20, "Logico", "9"))
    db$commit()
}

resetDB = function() {
    db$begin()
    db$execute("DELETE FROM PARMS WHERE GRUPO = ?",params=list(900))
    db$commit()
}

initDB()
test_that("Data Types by Raw", {
    expect_equal(parms$getRaw(900,  1,  1), "valor")
    expect_equal(parms$getRaw(900,  2,  1),    "10")
    expect_equal(parms$getRaw(900,  3,  1),    "11")
    expect_equal(parms$getRaw(900,  3,  2),  "12.3")
    expect_equal(parms$getRaw(900,  3,  3), "-3.45")
    expect_equal(parms$getRaw(900,  4,  1),     "0")
    expect_equal(parms$getRaw(900,  4,  2),     "1")
    expect_equal(parms$getRaw(900,  4,  3),     "9")
})

test_that("Data Types by Value", {
    expect_equal(parms$getValue  (900,  1,  1), "valor")
    expect_equal(parms$getValue  (900,  2,  1),      10)
    expect_equal(parms$getValue  (900,  3,  1),      11)
    expect_equal(parms$getValue  (900,  3,  2),    12.3)
    expect_equal(parms$getValue  (900,  3,  3),   -3.45)
    expect_equal(parms$getValue  (900,  4,  1),   FALSE)
    expect_equal(parms$getValue  (900,  4,  2),    TRUE)
    expect_equal(parms$getValue  (900,  4,  3),    TRUE)
})

test_that("Errors in parameters", {
    expect_null(parms$getRaw      (999, 999, 999))
    expect_null(parms$getValue    (999, 999, 999))
    expect_null(parms$getString   (999, 999, 999))
    expect_equal(parms$getInteger (999, 999, 999),  0)
    expect_equal(parms$getNumber  (999, 999, 999),  0)
    expect_false(parms$getBoolean (999, 999, 999))
})

test_that("Default values", {
    expect_equal(parms$getString  (999, 999, 999, "pepe"), "pepe")
    expect_equal(parms$getInteger (999, 999, 999,      1),      1)
    expect_equal(parms$getNumber  (999, 999, 999,    2.3),    2.3)
    expect_equal(parms$getBoolean (999, 999, 999,   TRUE),   TRUE)
})

resetDB()
