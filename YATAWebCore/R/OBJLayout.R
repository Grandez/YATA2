# Objeto para crear las paginas con layout
OBJLayout = R6::R6Class("YATA.WEB.LAYOUT"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,public = list(
      initialize = function(ns, layout, options, values=NULL, top=NULL,full=TRUE) {
         if (!missing(ns)) private$ns = ns
         # full indica si se hace la gestion completa o solo se notifica
         private$full = full
         if (!missing(layout)) {
              private$layout = layout
              makeConfig(ns, layout, options, values, top)
              makeLayout()
          }
      }
     ,getConfig = function()    { private$config  }
     ,getBody   = function(...) {
       private$full = TRUE
       makeLayout(...)
      }
     ,update    = function(session, layout, ns) {
         if (missing(ns)) ns = private$ns
         for (r in 1:nrow(layout)) {
             for (c in 1:ncol(layout)) {
                 cbo = paste("cboLayout",r,c, sep="_")
                 tgt = layout[r,c]
                 updateSelectInput(session, cbo, selected = tgt)
                 shinyjs::js$yataUpdateLayout(ns(cbo), tgt)
             }
         }
     }
   )
  ,private = list(
      ns     = NULL
     ,config = NULL
     ,layout = NULL
     ,full   = FALSE # si TRUE gestiona todo, si false notifica
    ,yuiLayout = function(id, choices, selected=NULL) {
       cls = ifelse(full, "yata_layout", "yata_layout_notify")
       yataSelectInput(id, label=NULL, choices=choices, selected = selected, width="auto", class=cls)
    }
     ,makeConfig = function(ns, layout, options, values, top) {
         opts = c("Hide"="none")
         if (!missing(options)) opts = options
         tbl = tags$table(class="yata_layout_table")
         iVal = 1
         for (idx in 1:length(layout)) {
              cbo = paste0("cboLayout_", idx)
              if (layout[idx] == 1) {
                  td = tags$td(colspan="2", yuiLayout(ns(paste0(cbo, "_0")), choices=opts, selected=values[iVal]))
                  tr = tags$tr(class="yata_layout_row", td)
              } else {
                  td1 = tags$td(class="yata_layout_left", yuiLayout(ns(paste0(cbo, "_1")), choices=opts, selected=values[iVal]))
                  iVal = iVal + 1
                  td2 = tags$td(                          yuiLayout(ns(paste0(cbo, "_2")), choices=opts, selected=values[iVal]))
                  tr  = tags$tr(class="yata_layout_row", td1, td2)
              }
              iVal = iVal + 1
              tbl = htmltools::tagAppendChild(tbl, tr)
         }
        private$config = tagList(yuiTitle(5, "Layout"), top, tbl, htmltools::hr())
     }
     ,makeLayout = function(...) {
         tl = tagList()
         for (idx in 1:length(layout)) {
              item = fluidRow(id=ns(paste0("block_", idx, "_a")), style="display: none;")
              tl = htmltools::tagAppendChild(tl, item)
              if (layout[idx] == 2) {
                  idb = paste0("block_", idx)
                  idd = paste0(idb, "_b")
                  item = fluidRow( id=ns(idd), style="display: none;"
                                         ,column(6, fluidRow(id=ns(paste0(idb, "_1"))))
                                         ,column(6, fluidRow(id=ns(paste0(idb, "_2"))))
                                )
                  tl = htmltools::tagAppendChild(tl, item)
              }
         }
         htmltools::tagAppendChild(tl, tags$div(id=ns("blocks"), class="yata_blocks", ...))
    }

  )
)
