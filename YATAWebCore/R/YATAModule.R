YATAModule = function(id, title="",mod=NULL, ...) {
    message("Ejecutando YATAModule para ", id)
    ns = NS(id)
    if (is.null(mod)) {
        modName =  paste0(YATATools::titleCase(strsplit(id, "-")[[1]]), collapse="")
        data = eval(parse(text=paste0("mod", modName, "Input('", id, "')"))) #, title, "')")))
    } else {
        data = eval(parse(text=paste0("mod", mod, "Input('", id, "')")))
    }

    idForm = paste0(id, "_div_form")
    idErr  = paste0(id, "_div_err")

    divLeft  = tags$div(id=ns("container_left"),  class="yata_panel_left  yata_leftside_closed")
    divRight = tags$div(id=ns("container_right"), class="yata_panel_right")

    if (!is.null(data$left))  divLeft  = tagAppendChildren(divLeft, data$left)
    if (!is.null(data$right)) divRight = tagAppendChildren(divRight, data$right)

    # El collapse va a nivel contenedor para activar las clases left y principal
    divMain    = tags$div(id=ns("container_main"), class="yata_panel_main", data$main)
    divContent = tags$div( id=ns("container"), class="yata_panel_content"
                          ,divLeft, divMain, divRight)
    divForm = tags$div(id=ns("form_panel"), class="yata_panel_form"
                       ,tags$div(id=paste0(idForm, "-container"), class="yata_form_center", uiOutput(ns("form")))
        )
    divErr = tags$div(id=ns("err_panel"), class="yata_panel_err"
                      ,tags$div(id=paste0(idErr, "-container"), class="yata_form_center", uiOutput(ns("err")))
        )
    tagList( divContent # data
            ,shinyjs::hidden(divForm)
            ,shinyjs::hidden(divErr)
    )
}

# Una pagina que tiene menu o entra en otros modulos
YATASubModule = function(name, id, title="", leftside=FALSE, ...) {
    ns = NS(id)
    browser()
    data = eval(parse(text=paste0("mod", name, "Input('", id, "','", title, "')")))
    idForm = paste0(id, "_div_form")
    idErr  = paste0(id, "_div_err")

    divleft = NULL
    if (leftside) divleft = YATASidebar(id=ns("left_side"),h2(paste("Barra lateral", name)))
    divContent = tags$div(id=ns("container")
                         , divleft
                         , tags$div(id=ns("container_data"), class="yata_nav_left",data)
    )
    divForm = tags$div(id=ns("form_panel"), class="yata_panel_form"
                       ,tags$div(id=paste0(idForm, "-container"), class="yata_form_center", uiOutput(ns("form")))
        )
    divErr = tags$div(id=ns("err_panel"), class="yata_panel_err"
                      ,tags$div(id=paste0(idErr, "-container"), class="yata_form_center", uiOutput(ns("err")))
        )
    tagList( divContent # data
            ,shinyjs::hidden(divForm)
            ,shinyjs::hidden(divErr)
    )
}
