
yuiBtn          = function(id, label, style) { shinyBS::bsButton(id, label, style=style       ) }
yuiBtnOK        = function(id, label)        { shinyBS::bsButton(id, label, style="success"   ) }
yuiBtnKO        = function(id, label)        { shinyBS::bsButton(id, label, style="danger"    ) }
yuiBtnMain      = function(id, label)        { shinyBS::bsButton(id, label, style="primary"   ) }
yuiBtnSecondary = function(id, label)        { shinyBS::bsButton(id, label, style="secondary" ) }
yuiBtnDanger    = function(id, label)        { shinyBS::bsButton(id, label, style="danger"    ) }
yuiBtnWarning   = function(id, label)        { shinyBS::bsButton(id, label, style="warning"   ) }
yuiBtnInfo      = function(id, label)        { shinyBS::bsButton(id, label, style="info"      ) }
yuiBtnLight     = function(id, label)        { shinyBS::bsButton(id, label, style="light"     ) }
yuiBtnDark      = function(id, label)        { shinyBS::bsButton(id, label, style="dark"      ) }
yuiBtnLink      = function(id, label)        { shinyBS::bsButton(id, label, style="link"      ) }
yuiBtnEdit      = function(id, label)        { shinyBS::bsButton(id, label, style="navy"      ) }


.btnIcon = function(color, ico, title) {
   yuiActionBtn(title=title, style = "simple", color = color, icon = icon(ico, class="yuiBtnIcon"))
}
yuiBtnIconAlert    = function(title) {.btnIcon("yellow"    , "bell"             ,ifelse(missing(title), "Alert" ,title)) }
yuiBtnIconCancel   = function(title) {.btnIcon("red"       , "times"            ,ifelse(missing(title), "Cancel",title)) }
yuiBtnIconOK       = function(title) {.btnIcon("green"     , "check"            ,ifelse(missing(title), "Accept",title)) }
yuiBtnIconDel      = function(title) {.btnIcon("orange"    , "trash"            ,ifelse(missing(title), "Delete",title)) }
yuiBtnIconRefuse   = function(title) {.btnIcon("navy"      , "thumbs-down"      ,ifelse(missing(title), "Refuse",title)) }
yuiBtnIconCloud    = function(title) {.btnIcon("aqua"      , "cloud-upload-alt" ,ifelse(missing(title), "Cloud" ,title)) }
yuiBtnIconEdit     = function(title) {.btnIcon("darkgreen" , "pen"              ,ifelse(missing(title), "Edit"  ,title)) }
yuiBtnIconCash     = function(title) {.btnIcon("purple"    , "cash-register"    ,ifelse(missing(title), "Close" ,title)) }
yuiBtnIconView     = function(title) {.btnIcon("mediumblue", "search-dollar"    ,ifelse(missing(title), "View"  ,title)) }
yuiBtnIconActive   = function(title) {.btnIcon("limegreen" , "plus-circle"      ,ifelse(missing(title), "Activar"  ,title)) }
yuiBtnIconInactive = function(title) {.btnIcon("maroon"    , "minus-circle"     ,ifelse(missing(title), "Desactivar"  ,title)) }

# Source: shinyWidgets
# Function: actionBttn
# Action: Removed match.arg color control
#         Removed id and label
#         Removed attach
yuiActionBtn = function (title=NULL, icon = NULL, style = "unite",
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

