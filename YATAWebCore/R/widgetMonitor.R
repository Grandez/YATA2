yuiYataMonitor = function(id, size=3) {
    column(size, .yuiMonitorTable(id))
}

###########################################
### Widget para sacar la contizacion en tiempo real de las monedas
### Crea los tags: id - fila
###                id - fila - value
###########################################
.yuiMonitorTable = function(id) {
  ns = strsplit(id, "-")[[1]]
  code = ns[length(ns)]
  base = paste(ns[1:length(ns)-1], sep = "-")
      tags$table(class="yataTblMonitor"
        ,tags$tr(
           tags$td(rowspan="3", class="yataCellIcon", img(src=paste0("icons/", code, ".png"),width="48px", height="48px"))
          ,tags$td(class="yataCellLabel", "Precio")
          ,tags$td(class="yataCellData",  id=paste0(id,"-price"))
          ,tags$td(class="yataCellData",  id=paste0(id,"-price-delta"))
        )
        ,tags$tr(
           tags$td(class="yataCellLabel", "Sesion")
          ,tags$td(class="yataCellData",  id=paste0(id,"-session"))
          ,tags$td(class="yataCellData",  id=paste0(id,"-session-delta"))
        )
        ,tags$tr(
           tags$td(class="yataCellLabel", "Dia")
          ,tags$td(class="yataCellData",  id=paste0(id,"-day"))
          ,tags$td(class="yataCellData",  id=paste0(id,"-day-delta"))
        )
        ,tags$tr(
           tags$td(rowspan="2", tags$span(class="yataCellCTC", code))
          ,tags$td(class="yataCellLabel yataCellGroup", "Semana")
          ,tags$td(class="yataCellData  yataCellGroup",  id=paste0(id,"-week"))
          ,tags$td(class="yataCellData"               ,  id=paste0(id,"-week-delta"))
        )
        ,tags$tr(
            tags$td(class="yataCellLabel", "Ultimo")
           ,tags$td(class="yataCellData yataCellGroup", id=paste0(id,"-last"))
           ,tags$td(class="yataCellData yataCellGroup", id=paste0(id,"-last-delta"))
        )
      )
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
   for (idx in c("price", "session","day","week","last")) {
       cls = "yataDeltaNone"
       value = 0
       if (monitor[[idx]] != 0) value = (last / monitor[[idx]]) - 1
       if (value != 0) cls = ifelse(value > 0, "yataDeltaUp", "yataDeltaDown")
       id0   =  paste0(id, "-", idx, "-delta")
       id1   =  paste0(id0, "-value")
       repDiv(id0, id1, tags$span(class=cls, id=id1, number2percentage(value, 2)))
   }
  #  delta = (monitor$current / monitor$price) - 1
  #  ic = tags$span(yataIconDown())
  #  if (delta > 0) ic = tags$span(yataIconUp())
  #  if (delta < 0) ic = tags$span(yataIconDown())
  #
  #  repDiv(id2, id1, ic, tags$span(tags$p(id=paste0(id2, id1), class=getClass(delta), number2percentage(delta))))
  #
   # Session
   # id0 =  paste0(id, "-session")
   # # if (init) repDiv(id0, id1, ic, tags$p(id=paste0(id0, id1), number2string(monitor$session, 2)))
   # id0 =  paste0(id, "-session")
   # id1 =  paste(id0, "-value")
   # repDiv(id0, id1, tags$span(class=cls, id=id1, number2string(monitor$last, 2)))

  #  delta =  (monitor$current / monitor$session) - 1
  #  repDiv(id0, id1, ic, tags$span(tags$p(id=paste0(id0, id3), class=getClass(delta), number2percentage(delta))))
  #

   # Dia

   # Semana


   # Last
   id0 =  paste0(id, "-last")
   id1 =  paste0(id0, "-value")
   repDiv(id0, id1, tags$span(class=cls, id=id1, number2string(monitor$last, 2)))

  #  delta = monitor$last - monitor$current
  #  repDiv(id0, id1, ic, tags$span(tags$p(id=paste0(id0, id1), class=getClass(delta), number2string(monitor$current))))
}
