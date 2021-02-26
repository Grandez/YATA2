###############################################
# Bloque para gestionar el ranking
# UN bloque web tiene:
# La interfaz:                              blkAlgo
# Una posible inicializacion si lo necesita iniAlgo
# Una actualizacion si lo necesita:         updAlgo
# Cada componente tiene que indicar que necesita

###############################################

blkRank = function(id, n=5) {
   parent = tags$div(class="yata-ranks")
   parent = tagAppendChild(parent, .yuiTableRank(id, 1, n))
   parent = tagAppendChild(parent, .yuiTableRank(id, 7, n))
   parent
}

.yuiTableRank = function(id, id2, n) {
  tbl = tags$table( class="yata-tbl-monitor")
  tbl = tagAppendChild(tbl, tags$caption(class="yata-rank-title", ifelse(id2 == 1, "Top Day", "Top Week")))
  ids = .blkRankMakeIdBase(id2)
  ids = paste0(id, "_", ids)
  for (idx in 1:n) {
      idr = paste0(ids, idx)
      tbl = tagAppendChild(tbl, tags$tr( tags$td(class="yata-cell-label", yuiLabelText(id=idr[1]))
                                        ,tags$td(class="yata-cell-data",  yuiLabelNumber(id=idr[2]))
                                        ,tags$td(class="yata-cell-data",  yuiLabelNumber(id=idr[3])) ))
  }
  tbl
}

.blkRankMakeIdBase = function(id2) {
    paste0("rank", id2, "_", c("lbl", "val", "var"), "_")
    # ids = NULL
    #     ids = c(ids, paste0("rank", id2, "_", c("lbl", "val", "var"), "_"))
    # }
    # ids
}
updRank = function(info, input, output, session) {
   # A ampliar bien
   # Ahora solo 1 y 7
   prov = YATAFactory$getObject(YATACodes$object$providers)
   for (interval in c(1,7)) {
        data = prov$getBest(interval, info$n)
        for (tops in 1:nrow(data)) {
             outs = paste0("output$", info$id, "_", .blkRankMakeIdBase(interval), tops)
             for (col in 1:3) {
                   eval(parse(text=paste0(outs[col], " = renderText({'", data[tops, col], "'})")))
             }
        }
  }
}
