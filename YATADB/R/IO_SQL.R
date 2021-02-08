
# .getConn      = function() {
#     disc=FALSE
#     vars$tmpConn = conn
#     if (is.null(conn)) {
#         if (!is.null(vars$SQLConn)) {
#             vars$tmpConn = vars$SQLConn
#         }
#         else {
#             vars$tmpConn = .SQLDBConnect()
#             disc = TRUE
#         }
#     }
#     if (is.null(vars$tmpConn)) return (NULL)
#     disc
# }

SQLDBConnect = function (dbName="CTC") {
    browser()
        RMariaDB::dbConnect(
            drv = RMariaDB::MariaDB()
            ,username = "CTC"
            ,password = "ctc"
            ,host = NULL
            ,port = 3306
            ,dbname=dbName
        )
}

.SQLDBConnect = function (dbName="CTC") {
    coreVars$lastErr = NULL
    sqlconn = tryCatch({
        RMariaDB::dbConnect(
            drv = RMariaDB::MariaDB()
            ,username = "CTC"
            ,password = "ctc"
            ,host = NULL
            ,port = 3306
            ,dbname=dbName
        )
    }
    ,error = function(cond) {
        stop(YATAError(getLocaleMessage(ERR_NO_CONNECT)))
        NULL
    })
    sqlconn
}

.SQLDBDisconnect = function (conn = vars$tmpConn) {
    coreVars$lastErr = NULL
    if (is.null(conn)) return(NULL)
    tryCatch({
        RMariaDB::dbDisconnect(conn)
    }
    ,error = function(cond) {
        coreVars$lastErr = cond
    })
}

.SQLMetadata = function(table) {
    conn = .SQLDBConnect()
    res = RMariaDB::dbListFields(conn, table)
    .SQLDBDisconnect(conn)
    res
}
.SQLTran = function(op, newConn) {
    conn = coreVars$getConn()
    if (op == 1 && newConn) conn = coreVars$addConn(.SQLDBConnect())
    if (op == 1) RMariaDB::dbBegin   (conn)
    if (op == 2) RMariaDB::dbCommit  (conn)
    if (op == 3) RMariaDB::dbRollback(conn)
    if (op > 1 && newConn) {
        coreVars$removeConn(newConn)
        return (NULL)
    }
    conn
}
.SQLDataFrame <- function(qry, params=NULL, isolated=F) {
    coreVars$lastErr = NULL
    if (!is.null(params)) names(params) = NULL
    if (isolated) coreVars$addConn()
    conn=coreVars$getConn()
    if (is.null(conn)) {
        isolated=T
        conn = coreVars$addConn()
    }
    df = tryCatch({
        df = RMariaDB::dbGetQuery(conn, qry, param=params)
    }
    ,error = function(cond) {
        vars$lastErr = cond
        NULL
    })

    if (isolated) coreVars$removeConn()
    df
}

.SQLExecute <- function(qry, params=NULL, isolated=F) {

    if (!is.null(params)) names(params) = NULL
    coreVars$lastErr = tryCatch({
         conn = coreVars$getConn()
         if (isolated) conn = coreVars$addConn()
         if (is.null(conn)) {
             isolated = T
             conn = coreVars$addConn()
         }
         res = RMariaDB::dbExecute(conn, qry, params=params)
        NULL
      }
      ,warning = function(cond) { cond }
      ,error   = function(cond) { cond }
    )
    if (isolated) coreVars$removeConn()
    coreVars$lastErr
}

.SQLLoadTable  <- function(table, isolated=F) {
    .SQLDataFrame(paste("SELECT * FROM", table), NULL, isolated)
}
.SQLWriteTable <- function(table, data, isolated=T) {
    coreVars$lastErr = NULL
    if (isolated) coreVars$addConn()
    coreVars$lastErr = tryCatch({
        RMariaDB::dbWriteTable(conn=coreVars$getConn(), table, data, append=T)
        NULL
    }
    ,warning = function(cond) { cond }
    ,error = function(cond)   { cond }
    )
    if (isolated) coreVars$removeConn()
    coreVars$lastErr
}

###################################################################################
###
###################################################################################

.SQLGetMessage = function(code, lang, region) {
    qry = "SELECT * FROM MESSAGES WHERE CODE = ? AND LANG = ? AND REGION = ?"
    df = .SQLDataFrame(qry, list(code, lang,region))
    if (nrow(df) == 0) df = .SQLDataFrame(qry, list(code, lang, "XX"))
    if (nrow(df) == 0) df = .SQLDataFrame(qry, list(code, "XX", "XX"))
    df
}



###################################################################################
###  REVISAR
###################################################################################

.SQLloadParameters <- function() {
    .SQLDataFrame("SELECT * FROM PARMS")
}
.SQLLoadProvider <- function (provider) {
    .SQLDataFrame("SELECT * FROM PROVIDERS WHERE NAME = ?", list(provider))
}

.SQLLoadCTCIndex <- function(shName) {
    fPos   = c(2,3,4,5)
    fNames = c("Name", "Symbol", "Decimals", "Active")

    SQLConn <<- .SQLDBConnect()

    df2 = .SQLDataFrame("SELECT * FROM PORTFOLIO" )
    df  = .SQLDataFrame("SELECT * FROM CURRENCIES")
    .SQLDBDisconnect()

    df  = df[df$SYMBOL %in% df2$CTC,]
    if (nrow(df) == 0) return (df)

    df$ACTIVE = 1
    df$ACTIVE = as.logical(df$ACTIVE)
    df = df[,fPos]
    colnames(df) = fNames
    df
}

.SQLLoadSessions <- function(symbol, source, fiat) {
    prfx = YATAENV$getProviderPrefix()
    fPos   = c(3,4,5,6,7,8)
    fNames = c("Date","Open","Close","High","Low","Volume")
    sql    = paste0("SELECT * FROM " , prfx, "_", source, " WHERE CTC = ? AND BASE = ? ORDER BY TMS")
    df     = .SQLDataFrame(sql, list(symbol, fiat))
    df     = df[,fPos]
    colnames(df) = fNames
    df
}

.SQLLoadModels <- function(scope) {
    df = .SQLDataFrame("SELECT * FROM MODELS WHERE ACTIVE = 1")
    df$ACTIVE = as.logical(df$ACTIVE)
    df
}

.SQLGetModel <- function(idModel) {
    .SQLDataFrame("SELECT * FROM MODELS WHERE ID_MODEL = ?", list(idModel))
}

.SQLGetModelIndicators <- function(idModel) {
    sql   = "SELECT * FROM MODEL_INDICATORS WHERE ID_MODEL = ?"
    parms = list(idModel)
    .SQLDataFrame(sql, parms)
}

.SQLLoadProfile <- function() {
    sql   = "SELECT * FROM PROFILES WHERE ACTIVE = 1"
    .SQLDataFrame(sql)
}
.SQLGetIndicator <- function(idIndicator) {
    sql   = "SELECT * FROM IND_INDS WHERE ID_IND = ?"
    parms = list(idIndicator)
    .SQLDataFrame(sql, parms)
}

.SQLGetIndicatorParameters <- function(idInd, scope, term) {
    sql   = "SELECT * FROM IND_PARMS WHERE ID_IND = ?"
    parms = list(idInd)
    df = .SQLDataFrame(sql, parms)
    df %>% filter(AND(FLG_SCOPE, scope), AND(FLG_TERM, term))
}

.SQLGetCurrencyPairs <- function(src=NA,tgt=NA) {
    qryBase = "SELECT * FROM PAIRS"

    if (is.null(SQLConn)) DBConnect()
    if (is.na(src)) {
        return (dbGetQuery(SQLCon, qryBase))
    }
    if (is.na(tgt)) {
        return (dbGetQuery(SQLCon, paste0(qryBase, " WHERE src = ?"), param=list(src)))
    }
    dbGetQuery(SQLCon, paste0(qryBase, " WHERE src = ? AND tgt = ?"), param=list(src, tgt))
}

.SQLLoadModelGroups <- function(shName) {
    wbName = filePath(YATAENV$modelsDBDir, name=YATAENV$modelsDBName, ext="xlsx")
    XLSLoadSheet(wbName, shName)
}
.SQLLoadModelModels <- function(shName) {
    wbName = filePath(YATAENV$modelsDBDir, name=YATAENV$modelsDBName, ext="xlsx")
    XLSLoadSheet(wbName, shName)
}

.SQLloadCases <- function() {
    xlcFreeMemory()
    xx = filePath(YATAENV$dataSourceDir, name=DB_CASES, ext="xlsx")
    sh = XLConnect::readWorksheetFromFile(xx, TCASES_CASES, startRow=2)
    sh
}

SQLLoadSheet <- function(file,sheet,start=1) {
    XLConnect::readWorksheetFromFile(file, sheet)
}

.SQLUpdateParameters <- function(key, value) {
    type = getDataType()
    v    = as.character(value)
    df = .SQLDataFrame("SELECT * FROM PARMS WHERE KEY = ?", list(key))
    if (nrow(df) > 0) {
        if (df[1,"VALUE"] != v) {
            sql = "UPDATE PARMS SET VALUE = ? WHERE NAME = ?"
            parms = list(v, key)
            .SQLExecute(sql, parms)
        }
    }
    else {
        sql = "INSERT INTO PARMS (NAME, TYPE, VALUE) VALUES (?, ?, ?)"
        parms = list(key, type, v)
       .SQLExecute(sql, parms)
    }
}

.SQLGetLastSessions <- function() {
    table = paste("SESSION", YATAENV$provider, YATAENV$period, sep="_")
    sql0 = paste("SELECT A.* FROM", table, "AS A, ")
    sql1 = paste("(SELECT BASE, COUNTER, MAX(TMS) AS TMS FROM ", table, "GROUP BY BASE, COUNTER) AS B")
    sql2 = "WHERE A.BASE = B.BASE AND A.COUNTER = B.COUNTER AND A.TMS = B.TMS"

    .SQLDataFrame(paste(sql0, sql1, sql2))
}

# .SQLGetLastSession <- function(counter, base, pr) {
#     sql = "SELECT * FROM POL_TICKERSD1 WHERE BASE = ? AND CTC = ? ORDER BY TMS DESC LIMIT 1"
#     .SQLDataFrame(sql, list(base, counter))
# }

############################################################################3












.SQLsetSummaryFileName <- function(case) {
    fileName = .translateText(YATAENV$templateSummaryFile, case)
    file.path(YATAENV$outDir, paste(fileName, "xlsx", sep="."))
}
.SQLsetSummaryFileData <- function(case) {
    .translateText(YATAENV$templateSummaryData, case)
}

