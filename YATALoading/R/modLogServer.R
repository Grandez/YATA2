modLogServer <- function(id, full, pnlParent, parent=NULL) {
   ns = NS(id)
   PNLBlog = R6::R6Class("PNL.BLOG"
        ,inherit    = WEBPanel
        ,cloneable  = FALSE
        ,lock_class = TRUE
        ,public = list(
            blog       = NULL
           ,currencies = NULL
           ,data       = NULL
           ,initialize = function(id, pnlParent, session, ns) {
               super$initialize(id, pnlParent, session, ns)
               self$blog  = self$factory$getObject("Blog")
               self$currencies = self$factory$getObject("Currencies")
           }
          ,getCurrencies = function() {
              self$makeCombo(self$currencies$getCurrencyNames())
           }
          ,createPost = function(input) {
             data = list()
             data$type    = input$cboApply
             data$target  = input$cboTarget
             data$title   = input$title
             data$summary = input$summary
             data$data    = input$data
             self$blog$add(data)
          }
          ,getCurrentPost = function() {
              self$blog$select(self$vars$id)
              self$data$current = self$blog$current
              self$data$current
          }
         ,getCurrencyIcon = function(symbol) {
             self$currencies$select(symbol = symbol)$current$icon
         }
        )
       ,private = list(
          definition = list(id = "",left = -1, right=-1)
        )
   )
moduleServer(id, function(input, output, session) {
   pnl = WEB$getPanel(id)

   if (is.null(pnl) || pnl$DBID != WEB$DBID) { # first time or DB Changed
       pnl = WEB$addPanel(PNLBlog$new(id, pnlParent, session, NS(id)))
   }

       reset = function() {
          output$msg = renderText({""})
#JGG Revisar not found          updTextInput(ns("title"), "")
          #updTextArea(ns("summary"), "")
          updTextArea(ns("comment"), "")
       }
       validate = function() {
          if (nchar(trimws(input$title)) == 0) {
              output$msg = renderText({"Titulo es oblogatorio"})
              return (TRUE)
          }
         FALSE
       }
       hasToPrint = function() {
         TRUE
       }
       updateCboTarget = function(target) {
         data = c("")
          if (target == "currency") data = pnl$getCurrencies()
          updCombo("cboTarget", choices=data)
          if (length(data) == 0) shinyjs::disable(ns("cboTarget"))
       }
       addPost = function() {
           data = pnl$getCurrentPost()
           data$ico = "img/YATA.png"
           if (data$type == "currency") data$ico = paste0("icons/", pnl$getCurrencyIcon(data$target))
           if (data$type == "all")      data$ico = "img/notepad.png"
           if (data$type == "note")     data$ico = "img/postit.png"

           insertUI(paste0("#", ns("posts")), where="afterBegin", yuiPost(data), immediate=TRUE)
              # tags$td(rowspan="6", class="yata_cell_icon",
              #        img( src=paste0("icons/", data$id, ".png")
              #            ,width  = YATAWEBDEF$iconSize
              #            ,height = YATAWEBDEF$iconSize,
              #        onerror=paste0("this.onerror=null;this.src=", YATAWEBDEF$icon, ";")))

           # Aqui definimos si debe ser con boton o sin boton
#   userPost(
#     id = 2, image=NULL,
# #    src = "https://adminlte.io/themes/AdminLTE/dist/img/user6-128x128.jpg",
#     author = "Adam Jones",
#     description = "Shared publicly - 5 days ago",
#     # userPostMedia(src = "https://adminlte.io/themes/AdminLTE/dist/img/photo2.png"),
#     userPostTagItems(
#       userPostTagItem(dashboardLabel("item 1", status = "danger")),
#       userPostTagItem(dashboardLabel("item 2", status = "danger"), side = "right")
#     )
#   )

       }
#JGG FALTA EL PAQUETE
    # item = accordionItem(
    #   id = 1,
    #   title = "Creado",
    #   color = "danger",
    #   collapsed = FALSE,
    #   "Creo un item"
    # )

    observeEvent(input$cboApply, ignoreNULL = TRUE, {
      updateCboTarget(input$cboApply) })
    observeEvent(input$btnOK, {
       if (validate()) return()
       pnl$vars$id = pnl$createPost(input)
       if (hasToPrint()) addPost()
       reset()
    })
    observeEvent(input$btnKO, { reset() })
    observeEvent(input$btnView, {
       # browser()
          insertUI(paste0("#", ns("data")), where="afterBegin", item, immediate=TRUE)
    })

    observeEvent(input$cboFilter, {
      #browser()
    })
        observeEvent(input$swTarget, {
            #browser()
        })
    })
}
#
# box(
#   title = "Accordion Demo",
#   width = NULL,
#   accordion(
#     accordionItem(
#       id = 1,
#       title = "Accordion Item 1",
#       color = "danger",
#       collapsed = TRUE,
#       "This is some text!"
#     ),
#     accordionItem(
#       id = 2,
#       title = "Accordion Item 2",
#       color = "warning",
#       collapsed = FALSE,
#       "This is some text!"
#     ),
#     accordionItem(
#       id = 3,
#       title = "Accordion Item 3",
#       color = "info",
#       collapsed = FALSE,
#       "This is some text!"
#     )
#   )
# )
