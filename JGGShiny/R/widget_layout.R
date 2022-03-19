# Objeto para crear las paginas con layout
WDGLayout = R6::R6Class("JGG.WEB.LAYOUT"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,public = list(
      initialize = function(ns, layout, options, values=NULL, full=TRUE) {
         if (!missing(ns)) private$ns = ns
         # full indica si se hace la gestion completa o solo se notifica
         private$full = full
         if (!missing(layout)) {
              private$layout = layout
              makeConfig(ns, layout, options, values)
              makeLayout()
          }
      }
     ,getConfig = function()    { private$config  }
     ,getBody   = function(...) { makeLayout(...) }
     ,update    = function(session, layout, ns) {
         browser()
         if (missing(ns)) ns = private$ns
         for (r in 1:nrow(layout)) {
             for (c in 1:ncol(layout)) {
                 cbo = paste("cbolayout",r,c, sep="_")
                 tgt = layout[r,c]
                 updateSelectInput(session, cbo, selected = tgt)
                 shinyjs::js$jgg_layout(ns(cbo), tgt)
             }
         }
     }
   )
  ,private = list(
      ns     = NULL
     ,config = NULL
     ,layout = NULL
     ,full   = FALSE # si TRUE gestiona todo, si false notifica
     ,makeConfig = function(ns, layout, options, values) {
         opts = c("Hide"="none")
         if (!missing(options)) opts = c(opts,options)
         tbl = tags$table(class="jgg_layout_table")
         iVal = 1
         for (idx in 1:length(layout)) {
              cbo = paste0("cbolayout_", idx)
              if (layout[idx] == 1) {
                  td = tags$td( colspan="2"
                               ,guiLayoutSelect(ns(paste0(cbo, "_0")), opts, values[iVal], full))
                  tr = tags$tr(class="jgg_layout_row", td)
              } else {
                  td1 = tags$td( class="jgg_layout_left"
                                ,guiLayoutSelect(ns(paste0(cbo, "_1")), opts, values[iVal], full))
                  iVal = iVal + 1
                  td2 = tags$td(guiLayoutSelect(ns(paste0(cbo, "_2")), opts, values[iVal], full))
                  tr  = tags$tr(class="jgg_layout_row", td1, td2)
              }
              iVal = iVal + 1
              tbl = htmltools::tagAppendChild(tbl, tr)
         }
        private$config = tagList(guiTitle(5, "Layout"), tbl, htmltools::hr())
     }
    ,makeLayout = function(...) {
        # We use style instead of class cause it is easier on javascript
        tl = tagList()
        # blocks
        #   blocks_ui
        #      blocks_1x1x0x0
        #      blocks_2x2x0x0
        #        blocks_2x1x1
        #        blocks_2x1x2
        #           column6 / column6
        #        blocks_2x2x1
        #        blocks_2x2x2
        #           column6 / column6
        #   blocks_container
        blocks   = tags$div(id=ns("blocks"))
        blocksui = tags$div(id=ns("blocks_ui"))
        blocksui = tagAppendChild(blocksui, tags$div(id=ns("blocks_1"), class="h-100"))
        block2   = tags$div(id=ns("blocks_2"))
        block2   = tagAppendChild(block2, tags$div(id=ns("blocks_2x1x1"), class="h-50 row"))
        block2   = tagAppendChild(block2, tags$div(id=ns("blocks_2x1x2"), class="h-50 row"
                                  ,column(6, fluidRow(id=ns("blocks_2x1x2x1")))
                                  ,column(6, fluidRow(id=ns("blocks_2x1x2x2"))))
                   )
        block2  = tagAppendChild(block2, tags$div(id=ns("blocks_2x2x1"), class="h-50 row"))
        block2  = tagAppendChild(block2, tags$div(id=ns("blocks_2x2x2"), class="h-50 row"
                                  ,column(6, fluidRow(id=ns("blocks_2x2x2x1")))
                                  ,column(6, fluidRow(id=ns("blocks_2x2x2x2"))))
                   )
        blocksui = tagAppendChild(blocksui, block2)
        blocks = tagAppendChild(blocks, blocksui)
        tagAppendChild(blocks, tags$div(id=ns("blocks_container"), class="jgg_blocks_container", ...))
    }

  )
)
