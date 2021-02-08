# Codigo modificado de otros paquetes

# Source: shinyWidgets
# Function: actionBttn
# Action: Removed match.arg color control
#         Removed id and label
#         Removed attach
yataActionBtn = function (title=NULL, icon = NULL, style = "unite",
#JGG yataActionBttn = function (inputId, label = NULL, icon = NULL, style = "unite",
    color = "default", size = "md", block = FALSE,
    no_outline = TRUE)
{
    label = NULL
    #JGG value <- shiny::restoreInput(id = inputId, default = NULL)
    style <- match.arg(arg = style, choices = c("simple",
        "bordered", "minimal", "stretch", "jelly",
        "gradient", "fill", "material-circle",
        "material-flat", "pill", "float", "unite"))
    size <- match.arg(arg = size, choices = c("xs", "sm", "md", "lg"))
    tagBttn <- tags$button( type = "button"
                           ,title=title
                           ,class = "action-button bttn"
                           ,class = paste0("bttn-", style)
                           ,class = paste0("bttn-",size)
                           ,list(icon,label)
                           ,class = if (block) "bttn-block"
                           ,class = if (no_outline) "bttn-no-outline"
                           ,style = paste("background:", color)
    )
    tagBttn
}

