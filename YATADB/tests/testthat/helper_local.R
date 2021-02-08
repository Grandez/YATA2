localTest <<- TRUE

checkLocal <- function() {
  if (nchar(Sys.getenv("PLANTUMLR_DEV")) == 0) skip("Test available only on local environment")
  #if (!exists("localTest")) skip("Test available only on local environment")
}

localDevelopment <- function() {
  (nchar(Sys.getenv("PLANTUMLR_DEV")) > 0)
}

sf = system.file("extdata", "default.ini", package="YATADB")
cfg = configr::read.config(sf)

