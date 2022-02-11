yuiYataMonitor = function(id, data, size=2) {
#    column(size, .yuiMonitorTable(id))
   tags$div(column(size,.yuiMonitorTable(id,data)))
}

###########################################
### Widget para sacar la contizacion en tiempo real de las monedas
### Crea los tags: id - fila
###                id - fila - value
###########################################
.yuiMonitorTable = function(id,data) {
   browser()
  ns = strsplit(id, "-")[[1]]
  code = ns[length(ns)]
  base = paste(ns[1:length(ns)-1], sep = "-")
#  tags$div(
      tags$table(class="yata-tbl-monitor"
        ,tags$tr(
           tags$td(rowspan="3", class="yataCellIcon",
              img(src=paste0("icons/", code, ".png"),width="48px", height="48px",
                  onerror="this.onerror=null;this.src='icons/YATA.png';"))
          ,tags$td(class="yata-cell-label", "Coste")
          ,tags$td(class="yata-cell-data",  id=paste0(id,"-price"))
          ,tags$td(class="yata-cell-data",  id=paste0(id,"-price-delta"))
        )
        ,tags$tr(
           tags$td(rowspan="2", tags$span(class="yataCellCTC", code))
          ,tags$td(class="yata-cell-label yataCellGroup", "Semana")
          ,tags$td(class="yata-cell-data  yataCellGroup",  id=paste0(id,"-week"))
          ,tags$td(class="yata-cell-data"               ,  id=paste0(id,"-week-delta"))
        )
        ,tags$tr(
           tags$td(class="yata-cell-label", "Dia")
          ,tags$td(class="yata-cell-data",  id=paste0(id,"-day"))
          ,tags$td(class="yata-cell-data",  id=paste0(id,"-day-delta"))
        )
        ,tags$tr(
           tags$td(class="yata-cell-label", "Sesion")
          ,tags$td(class="yata-cell-data",  id=paste0(id,"-session"))
          ,tags$td(class="yata-cell-data",  id=paste0(id,"-session-delta"))
        )
        ,tags$tr(
            tags$td(class="yata-cell-label", "Ultimo")
           ,tags$td(class="yata-cell-data yataCellGroup", id=paste0(id,"-last"))
           ,tags$td(class="yata-cell-data yataCellGroup", id=paste0(id,"-last-delta"))
        )
      )
#  )
}

updYataMonitor = function(id, monitor, last) {
   repDiv = function (parent, child, ...) {
      removeUI(selector = paste0("#", child), immediate=TRUE)
      insertUI(selector = paste0("#", parent), where = "beforeEnd", immediate=TRUE, ui=tagList(...))
   }
   getClass = function(value) {
      cls = "yataDeltaNone"
      if (value > 0) cls = "yataDeltaUp"
      if (value < 0) cls =" yataDeltaDown"
      cls
   }

   cls = "yataDeltaNone"

  # Precio
   id0 =  paste0(id, "-price")
   id1 = "-value"
   id2 = paste0(id0, "-delta")
   id3 = "-delta-value"

   if (missing(last)) {
       insertUI(selector = paste0("#", id, "-price"), where = "beforeEnd", immediate=TRUE
                ,ui=tags$span(class=cls, number2string(monitor$price, 2)))
       insertUI(selector = paste0("#", id, "-session"), where = "beforeEnd", immediate=TRUE
                ,ui=tags$span(class=cls, number2string(monitor$last, 2)))
       insertUI(selector = paste0("#", id, "-day"), where = "beforeEnd", immediate=TRUE
                ,ui=tags$span(class=cls, number2string(monitor$day, 2)))
       insertUI(selector = paste0("#", id, "-week"), where = "beforeEnd", immediate=TRUE
                ,ui=tags$span(class=cls, number2string(monitor$week, 2)))
       last = monitor$last
       insertUI(selector = paste0("#", id,"-price-delta"), where = "beforeEnd", immediate=TRUE
                ,ui=tags$span(class=cls, id= paste0(id,"-price-delta-value"), "0"))
       insertUI(selector = paste0("#", id,"-session-delta"), where = "beforeEnd", immediate=TRUE
                ,ui=tags$span(class=cls, id= paste0(id,"-session-delta-value"), "0"))
       insertUI(selector = paste0("#", id,"-day-delta"), where = "beforeEnd", immediate=TRUE
                ,ui=tags$span(class=cls, id= paste0(id,"-day-delta-value"), "0"))
       insertUI(selector = paste0("#", id,"-week-delta"), where = "beforeEnd", immediate=TRUE
                ,ui=tags$span(class=cls, id= paste0(id,"-week-delta-value"), "0"))

   }
   # for (idx in c("price", "session","day","week","last")) {
   #     cls = "yataDeltaNone"
   #     value = 0
   #     if (monitor[[idx]] != 0) value = (last / monitor[[idx]]) - 1
   #     if (value != 0) cls = ifelse(value > 0, "yataDeltaUp", "yataDeltaDown")
   #     id0   =  paste0(id, "-", idx, "-delta")
   #     id1   =  paste0(id0, "-value")
   #     repDiv(id0, id1, tags$span(class=cls, id=id1, number2percentage(value, 2)))
   # }

   # Last
   # id0 =  paste0(id, "-last")
   # id1 =  paste0(id0, "-value")
   # repDiv(id0, id1, tags$span(class=cls, id=id1, number2string(monitor$last, 2)))
}
yuiRank = function(id1, id2, n=5) {
   parent = tags$div(class="yata-ranks")
   if (!missing(id1)) parent = tagAppendChild(parent, yuiTableRank(id1, n))
   if (!missing(id2)) parent = tagAppendChild(parent, yuiTableRank(id2, n))
   parent
}

yuiTableRank = function(id, n) {
  tbl = tags$table( class="yata-tbl-monitor")
  for (idx in 1:n) {
      id1 = paste0(id, "lbl", idx)
      id2 = paste0(id, "val", idx)
      tbl = tagAppendChild(tbl, tags$tr( tags$td(yuiLabelText(id=id1)),tags$td(yuiLabelPercentage(id=id2))))
  }
  tbl
}
