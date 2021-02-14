localTest <<- TRUE

unloadNamespace("YATACore")
unloadNamespace("YATAProviders")
unloadNamespace("YATADB")
unloadNamespace("YATATools")

library(YATACore)

YATACodes   <<- YATACore::YATACODES$new()
YATAFactory <<- YATACore::YATAFACTORY$new()

initDB = function() {
    parms = YATAFactory$getParms()
    dbConn = parms$getList(5,2) # TEST DataBase
    db     = YATAFactory$setDB(dbConn)
    db$begin()
    db$execute(paste("DELETE FROM ", YATACodes$tables$Position))
    db$execute(paste("DELETE FROM ", YATACodes$tables$Regularization))
    db$execute(paste("DELETE FROM ", YATACodes$tables$Flows))
    db$execute(paste("DELETE FROM ", YATACodes$tables$Operations))
    db$execute(paste("DELETE FROM ", YATACodes$tables$Cameras))
    db$execute(paste("DELETE FROM ", "HIST_POSITION"))
    db$execute(paste("DELETE FROM ", "OPERATIONS_CONTROL"))
    db$execute(paste("DELETE FROM ", "OPERATIONS_LOG"))

    # -- Camaras
    db$execute(paste("DELETE FROM ", YATACodes$tables$Cameras))
    db$execute("INSERT INTO CAMERAS (CAMERA, NAME, MAKER, TAKER, ACTIVE) VALUES (?,?,?,?,?)",
               params=list("CASH"  ,"Cuenta de control"   ,0,     0, 0))
    db$execute("INSERT INTO CAMERAS (CAMERA, NAME, MAKER, TAKER, ACTIVE) VALUES (?,?,?,?,?)",
               params=list("TEST"   ,"Test camera"        ,0,     0, 1))

    db$commit()
}

# checkLocal <- function() {
#   if (nchar(Sys.getenv("PLANTUMLR_DEV")) == 0) skip("Test available only on local environment")
#   #if (!exists("localTest")) skip("Test available only on local environment")
# }
#
# localDevelopment <- function() {
#   (nchar(Sys.getenv("PLANTUMLR_DEV")) > 0)
# }
#
# YATADB = MARIADB$new()
#
# sf = system.file("extdata", "default.ini", package="YATADB")
# cfg = configr::read.config(sf)
# YATADB$connect(cfg$test)
