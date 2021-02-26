YATAModule = function(id, title="", ...) {
    ns = NS(id)
    modName =  paste0(YATATools::titleCase(strsplit(id, "-")[[1]]), collapse="")
    data = eval(parse(text=paste0("mod", modName, "Input('", id, "')"))) #, title, "')")))

    idForm = paste0(id, "-div-form")
    idErr  = paste0(id, "-div-err")

    divLeft  = tags$div(id=ns("container-left"),  class="yata-panel-left  yata-leftside-closed")
    divRight = tags$div(id=ns("container-right"), class="yata-panel-right")

    if (!is.null(data$left))  divLeft  = tagAppendChildren(divLeft, data$left)
    if (!is.null(data$right)) divRight = tagAppendChildren(divRight, data$right)

    # El collapse va a nivel contenedor para activar las clases left y principal
    divMain    = tags$div(id=ns("container-main"), class="yata-panel-main", data$main)
    divContent = tags$div( id=ns("container"), class="yata-panel-content"
                          ,divLeft, divMain, divRight)
    divForm = tags$div(id=ns("form-panel"), class="yata-panel-form"
                       ,tags$div(id=paste0(idForm, "-container"), class="yata-form-center", uiOutput(ns("form")))
        )
    divErr = tags$div(id=ns("err-panel"), class="yata-panel-err"
                      ,tags$div(id=paste0(idErr, "-container"), class="yata-form-center", uiOutput(ns("err")))
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
    idForm = paste0(id, "-div-form")
    idErr  = paste0(id, "-div-err")

    divleft = NULL
    if (leftside) divleft = YATASidebar(id=ns("left-side"),h2(paste("Barra lateral", name)))
    divContent = tags$div(id=ns("container")
                         , divleft
                         , tags$div(id=ns("container-data"), class="yata-nav-left",data)
    )
    divForm = tags$div(id=ns("form-panel"), class="yata-panel-form"
                       ,tags$div(id=paste0(idForm, "-container"), class="yata-form-center", uiOutput(ns("form")))
        )
    divErr = tags$div(id=ns("err-panel"), class="yata-panel-err"
                      ,tags$div(id=paste0(idErr, "-container"), class="yata-form-center", uiOutput(ns("err")))
        )
    tagList( divContent # data
            ,shinyjs::hidden(divForm)
            ,shinyjs::hidden(divErr)
    )
}
