# Funciones de Shiny Tuneadas

YATAModalDialog = function (..., title = NULL, footer = modalButton("Dismiss"),
    size     = c("m", "s", "l", "xl"), easyClose = FALSE, fade = TRUE) {
    size     = match.arg(size)
    backdrop = if (!easyClose) "static"
    keyboard = if (!easyClose) "false"

    div(id = "shiny-modal", class = "modal", class = if (fade)
        "fade", tabindex = "-1", `data-backdrop` = backdrop,
        `data-bs-backdrop` = backdrop, `data-keyboard` = keyboard,
        `data-bs-keyboard` = keyboard, div(class = "modal-dialog",
            class = switch(size, s = "modal-sm", m = NULL,
                l = "modal-lg", xl = "modal-xl"),
            div(class = "modal-content", if (!is.null(title))
                div(class = "modal-header yata_modal_severe_header", tags$h4(class = "modal-title",
                  title)), div(class = "modal-body",
                      #JGG BEG
                           fluidRow( column( 4, div( class="yata_modal_severe_icon_container"
                                    ,img(src="img/error.png", width="128px")
                                   ))
                                   ,column(8, fluidRow(...))
                           )),
                      #JGG END
                      # ...),
                if (!is.null(footer)) div(class = "modal-footer", footer))),
 tags$script(HTML("if (window.bootstrap && !window.bootstrap.Modal.VERSION.match(/^4\\./)) {\n         var modal = new bootstrap.Modal(document.getElementById('shiny-modal'));\n         modal.show();\n      } else {\n         $('#shiny-modal').modal().focus();\n      }")))
}
