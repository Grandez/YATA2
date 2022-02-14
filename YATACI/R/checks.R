checkFail = function(object, expected, result) {
    if (CI$mode == "console") {
        CI$logical(object, expected, result)
        CI$case = FALSE
    }
}

checkNumRows = function(data) {
    rc = FALSE
    db      = Factory$getDB()
    res = lapply(data, function(item) {
                 tbl = Factory$getTable(item$table)
                 res = tbl$rows(item$filter)
                 if (res != item$rows) {
                     checkFail(paste("Table",item$table), item$rows, res)
                     stop("checkNumRows")
                 }
         })
}
checkRowValues = function(table, filter, values) {
    rc = FALSE
    db      = Factory$getDB()
    tbl = Factory$getTable(table)
    df = tbl$table(filter)
    if (nrow(df) != 1) {
        checkFail(paste("Rows of table",table), 1, nrow(df))
        stop("checkNumRows - nrows")
    }
    res = lapply(names(values), function(col) {
                 if (df[1,col] != values[[col]]) {
                     checkFail(paste0("Table ", table, "(", col, ")"), values[[col]], df[1,col])
                     stop("checkNumRows")
                 }
          })

}
