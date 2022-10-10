# Update first and last history on currencies from history

correct_history = function() {
   message("BEG: Actualizando las marcas de control de history")
   dbfactory   = DBFactory$new()
   tblHist  = dbfactory$getTable("History")
   tblCtc   = dbfactory$getTable("Currencies")
   dfHist = tblHist$getRange()
   dfCtc  = tblCtc$table()
   df = dplyr::left_join(dfCtc, dfHist, by="id")
   tblCtc$db$begin()
   for (row in 1:nrow(df)) {
      mID = as.integer(df[row, "id"])
      # if (mID == 3DC) {
      #    browser()
      # }
      tblCtc$select(id = mID)
      if (!is.na(df[row,"min"])) tblCtc$setField("first", as.character(df[row,"min"]))
      if (!is.na(df[row,"max"])) tblCtc$setField("last", as.character(df[row,"max"]))
      tblCtc$apply()
   }
   tblCtc$db$commit()
   dbfactory$destroy()
   message("END: Actualizando las marcas de control de history")
}
