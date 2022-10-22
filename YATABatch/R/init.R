init = function() {
   unloadNamespace("YATABatch")
   unloadNamespace("YATABatchCore")
   unloadNamespace("YATADB")
   unloadNamespace("YATAProviders")
   unloadNamespace("YATABase")
   library(YATABatch)
   message("Ready")
}
