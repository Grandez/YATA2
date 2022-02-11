# Entrada a CI
library(YATACore)

init = function() {
DBCI=list(name="CI", dbname="YATACI")
browser()
Fact = YATAFACTORY$new(auto=FALSE)
browser()
Fact$setDB(DBCI)
}
