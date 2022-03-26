# Esto lo hacemos a partir del JSON congido a mano de la pagina
library(jsonlite)
updateExchanges = function(console=1, log=1) {
   browser()
   file = "P:/R/YATA2/YATASetup/inst/data/SQL/exchanges.json"
   fact  = YATACore::YATAFactory$new()
   tbl   = fact$getTable(fact$CODES$tables$exchanges)

   result = fromJSON(file)
   result = result[[1]]
   lst = result[c("id", "name", "slug", "rank", "makerFee", "takerFee")]
   df = as.data.frame(lst)
   colnames(df) = c("id", "name", "slug", "rank", "maker", "taker")
   df$symbol = toupper(df$name)
   tbl$bulkAdd(df,isolated=TRUE)
   begin = as.numeric(Sys.time())
}
updateIconsExchanges = function(maximum, force=FALSE, console=1, log=1) {
    browser()
   fact  = YATACore::YATAFactory$new()
   tbl   = fact$getTable(fact$CODES$tables$exchanges)
   df = tbl$table()

   # .updateIconsTable(batch)
   # browser()
    url = "https://s2.coinmarketcap.com/static/img/exchanges/200x200/"
    f   = paste0(Sys.getenv("HOME"), "/icons_exchanges.txt")
    suppressWarnings(file.remove(f))
    root = paste0(Sys.getenv("YATA_SITE"), "/YATAExt/icons")
    if(.Platform$OS.type == "windows") root = "P:/R/YATA2/YATAExt/providers"
    for (row in 1:nrow(df)) {
        # nfo = file.info(paste0(root, "/", df[row,"icon"]))
        # if (is.na(nfo[1,"size"])) { # No existe
            cat(paste0(url,df[row,"id"], ".png\n"), file=f, append=TRUE)
        #     next
        # }
        # if (nfo[1,"size"] < 1000) { # Malo
        #     cat(paste0(url,df[row,"icon"], "\n"), file=f, append=TRUE)
        # }
    }

   # logger$executed(rc, elapsed=as.numeric(Sys.time()) - begin, "Executed")
}

# .createURLList = function (batch) {
#     batch$log$process(2, "Generating URL List")
#     url = "https://s2.coinmarketcap.com/static/img/coins/200x200/"
#     f   = paste0(Sys.getenv("HOME"), "/icons_url.txt")
#     suppressWarnings(file.remove(f))
#     root = paste0(Sys.getenv("YATA_SITE"), "/YATAExt/icons")
#     if(.Platform$OS.type == "windows") root = "P:/R/YATA2/YATAExt/icons"
#     tbl = batch$fact$getTable(batch$codes$tables$currencies)
#     df  = tbl$table()
#     for (row in 1:nrow(df)) {
#         nfo = file.info(paste0(root, "/", df[row,"icon"]))
#         if (is.na(nfo[1,"size"])) { # No existe
#             cat(paste0(url,df[row,"icon"], "\n"), file=f, append=TRUE)
#             next
#         }
#         if (nfo[1,"size"] < 1000) { # Malo
#             cat(paste0(url,df[row,"icon"], "\n"), file=f, append=TRUE)
#         }
#     }
# }
#
# .updateIconsTable = function(batch) {
#    begin  = as.numeric(Sys.time())
#    tbl    = batch$fact$getTable(batch$codes$tables$currencies)
#
#    df     = tbl$table()
#    count  = 0  # Hacemos commit cada 50
#    tbl$db$begin()
#    batch$log$process(2, "Updating icons field on %d currencies", nrow(df))
#    for (row in 1:nrow(df)) {
#        batch$log$process(5, "Parsing currency", df[nrow, "name"])
#        if (!is.na(df[row, "icon"]) && difftime(df[row,"tms"], Sys.time(), unit="days") < 7) next
#        resp = YATABase$http$get(paste0("https://coinmarketcap.com/currencies/", df[row,"slug"]))
#        if (resp$status_code != 200) {
#             YATABase$cond$HTTP(paste("Retrieving currency", df[row,"slug"]),
#                                action="GET", origin=resp$status_code)
#        }
#        content = YATABase$http$content(resp)
#        g = regexpr("200x200/[0-9a-zA-Z]+\\.png", content)
#        if (g != -1) {
#            tbl$select(id = df[row,"id"]) # Existe
#            tbl$setField("icon", substr(content, g[1] + 8, g[1] + attr(g, "match.length")[1] - 1))
#            tbl$apply()
#            count = count + 1
#        }
#        if ((count %% 50) == 0) {
#            tbl$db$commit()
#            tbl$db$begin()
#        }
#     }
#     tbl$db$commit()
# }
