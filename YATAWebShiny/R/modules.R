JGGModule = function(id, mod=NULL, ...) {
   ns = shiny::NS(id)

   if (is.null(mod)) mod =  paste0(str_to_title(strsplit(id, "-")[[1]]), collapse="")

   uiData = eval(parse(text=paste0("mod", mod, "Input('", id, "')")))

   idForm = paste0(id, "_div_form")
   idErr  = paste0(id, "_div_err")

   divLeft   = tags$div(id=paste0(id, "_container_left"),   class="jgg_page_left   jgg_side_hide")
   divRight  = tags$div(id=paste0(id, "_container_right"),  class="jgg_page_right  jgg_side_hide")
   divHeader = tags$div(id=paste0(id, "_container_header"), class="jgg_page_header jgg_header_hide")

   if (!is.null(uiData$left))  divLeft  = tagAppendChildren(divLeft, uiData$left)
   if (!is.null(uiData$right)) divRight = tagAppendChildren(divRight, uiData$right)

   # El collapse va a nivel contenedor para activar las clases left y principal
   divMain    = tags$div(id=paste0(id, "_container_main"), class="jgg_panel_main", uiData$main)
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

   tagList( left=divLeft, main=divMain, right=divRight #, header=uiData$header
           ,form=shinyjs::hidden(divForm)
           ,err=shinyjs::hidden(divErr)
   )

}
JGGSubModule = function(id, title="",mod=NULL, ...) {
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

    if (!is.null(uiData$left))  divLeft  = tagAppendChildren(divLeft,  tags$div(id=paste0(id, "_left"),  uiData$left))
    if (!is.null(uiData$right)) divRight = tagAppendChildren(divRight, tags$div(id=paste0(id, "_right"), uiData$right))

    # El collapse va a nivel contenedor para activar las clases left y principal
    divMain    = tags$div(id=paste0(id, "_container_main"), class="jgg_panel_main", uiData$main)
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

