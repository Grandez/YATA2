init = function() {
   unloadNamespace("YATABatch")
   unloadNamespace("YATABatchCore")
   unloadNamespace("YATADB")
   unloadNamespace("YATAProviders")
   unloadNamespace("YATATools")
   library(YATABatch)
   message("Ready")
}
