JGGModule = function(id, title="",mod=NULL, ...) {
   ns = shiny::NS(id)
   if (is.null(mod)) {
       modName =  paste0(stringr::str_to_title(strsplit(id, "-")[[1]]), collapse="")
       data = eval(parse(text=paste0("mod", modName, "Input('", id, "')"))) #, title, "')")))
   } else {
       data = eval(parse(text=paste0("mod", mod, "Input('", id, "')")))
   }

   idForm = paste0(id, "_div_form")
   idErr  = paste0(id, "_div_err")

   divLeft  = tags$div(id=paste0(id, "_container_left"),  class="jgg_page_left  jgg_side_hide")
   divRight = tags$div(id=paste0(id, "_container_right"), class="jgg_page_right jgg_side_hide")

   if (!is.null(data$left))  divLeft  = tagAppendChildren(divLeft, data$left)
   if (!is.null(data$right)) divRight = tagAppendChildren(divRight, data$right)

   # El collapse va a nivel contenedor para activar las clases left y principal
   divMain    = tags$div(id=paste0(id, "_container_main"), class="jgg_panel_main", data$main)
   divContent = tags$div( id=paste0(id, "_container"), class="jgg_panel_content"
                         ,divLeft, divMain, divRight)
   divForm = tags$div(id=paste0(id, "_form_panel"), class="jgg_panel_form"
                      ,tags$div(id=paste0( idForm, "-container")
                                          ,class="jgg_form_center"
                                          ,uiOutput(ns("form")))
                     )
   divErr = tags$div(id=paste0(id, "_err_panel"), class="jgg_panel_err"
                      ,tags$div(id=paste0(idErr, "_container"), class="jgg_form_center", uiOutput(ns("err")))
                     )

   tagList( left=divLeft, main=divMain, right=divRight
           ,form=shinyjs::hidden(divForm)
           ,err=shinyjs::hidden(divErr)
   )

}
JGGSubModule = function(id, title="",mod=NULL, ...) {
#    message("Ejecutando YATAModule para ", id)
    ns = NS(id)
    if (is.null(mod)) {
        modName =  paste0(stringr::str_to_title(strsplit(id, "-")[[1]]), collapse="")
        data = eval(parse(text=paste0("mod", modName, "Input('", id, "')"))) #, title, "')")))
    } else {
        data = eval(parse(text=paste0("mod", mod, "Input('", id, "')")))
    }

    idForm = paste0(id, "_div_form")
    idErr  = paste0(id, "_div_err")

    divLeft  = tags$div(id=paste0(id, "_container_left"),  class="jgg_panel_left  jgg_side_closed")
    divRight = tags$div(id=paste0(id, "_container_right"), class="jgg_panel_right jgg_side_closed")

    if (!is.null(data$left))  divLeft  = tagAppendChildren(divLeft,  tags$div(id=paste0(id, "_left"),  data$left))
    if (!is.null(data$right)) divRight = tagAppendChildren(divRight, tags$div(id=paste0(id, "_right"), data$right))

    # El collapse va a nivel contenedor para activar las clases left y principal
    divMain    = tags$div(id=paste0(id, "_container_main"), class="jgg_panel_main", data$main)
    divContent = tags$div( id=paste0(id, "_container"), class="jgg_panel_content"
                          ,divLeft, divMain, divRight)
    divForm = tags$div(id=paste0(id, "_form_panel"), class="jgg_panel_form"
                       ,tags$div(id=paste0(idForm, "-container"), class="jgg_form_center", uiOutput(ns("form")))
        )
    divErr = tags$div(id=paste0(id, "_err_panel"), class="jgg_panel_err"
                      ,tags$div(id=paste0(idErr, "-container"), class="jgg_form_center", uiOutput(ns("err")))
        )
    tagList( divContent # data
            ,shinyjs::hidden(divForm)
            ,shinyjs::hidden(divErr)
    )
}

