
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
yuiBtnEdit      = function(id, label)        { shinyBS::bsButton(id, label, style="silver"    ) }

updBtn          = function(id, session=getDefaultReactiveDomain(), ...) {
   args = list(...)
   args$session = session
   args$inputId = id
   shinyBS::updateButton(session, id, label = args$label)
   #do.call(shinyBS::updateButton, args)
}
.btnIcon = function(color, ico, title) {
    sty = paste("simple; background-color:", color, ";")
   yuiActionBtn(title=title, style = "simple", color=color, class="yata_btn_icon", icon = icon(ico, class="yata_btn_icon"))
}
yuiBtnIconAlert    = function(title) {.btnIcon("yellow"    , "bell"             ,ifelse(missing(title), "Alert" ,title)) }
yuiBtnIconCancel   = function(title) {.btnIcon("red"       , "times"            ,ifelse(missing(title), "Cancel",title)) }
yuiBtnIconOK       = function(title) {.btnIcon("green"     , "check"            ,ifelse(missing(title), "Accept",title)) }
yuiBtnIconDel      = function(title) {.btnIcon("orange"    , "trash"            ,ifelse(missing(title), "Delete",title)) }
yuiBtnIconRefuse   = function(title) {.btnIcon("navy"      , "thumbs-down"      ,ifelse(missing(title), "Refuse",title)) }
yuiBtnIconCloud    = function(title) {.btnIcon("aqua"      , "cloud-upload-alt" ,ifelse(missing(title), "Cloud" ,title)) }
yuiBtnIconEdit     = function(title) {.btnIcon("darkgreen" , "pen"              ,ifelse(missing(title), "Edit"  ,title)) }
yuiBtnIconCash     = function(title) {.btnIcon("violet"    , "wallet"           ,ifelse(missing(title), "Close" ,title)) }
yuiBtnIconView     = function(title) {.btnIcon("mediumblue", "search-dollar"    ,ifelse(missing(title), "View"  ,title)) }
yuiBtnIconActive   = function(title) {.btnIcon("limegreen" , "plus-circle"      ,ifelse(missing(title), "Activar"  ,title)) }
yuiBtnIconInactive = function(title) {.btnIcon("maroon"    , "minus-circle"     ,ifelse(missing(title), "Desactivar"  ,title)) }
yuiBtnIconBuy      = function(title) {.btnIcon("green"     , "shopping-cart"    ,ifelse(missing(title), "Buy",title)) }
yuiBtnIconUp       = function(title) {.btnIcon("green"     , "sort-up"          ,ifelse(missing(title), "Up",title)) }
yuiBtnIconDown     = function(title) {.btnIcon("green"     , "sort-down"        ,ifelse(missing(title), "Down",title)) }

yuiTblButton = function(id, table, label, btn) {
   clk = paste0("onclick='Shiny.setInputValue(\"", id, "-btnTable", titleCase(table), "\","
                                              ,"\"", label, "-__\")'")
   data = as.character(btn)
   res = regexpr(">", data, fixed=TRUE)
   base = substr(data, 1, res[1] - 1)
   HTML(paste(base, clk, substr(data, res[1], 10000L)))
}

yuiCustomButton = function(btn, event, value) {
   clk = paste0("onclick='Shiny.setInputValue(\"", event, "\","
                                              ,"\"", value, "-__\")'")
   data = as.character(btn)
   res = regexpr(">", data, fixed=TRUE)
   base = substr(data, 1, res[1] - 1)
   htmltools::HTML(paste(base, clk, substr(data, res[1], 10000L)))
}
yuiCustomIcon = function(icon, event, value) {
    browser()
   clk = paste0("onclick='Shiny.setInputValue(\"", event, "\","
                                              ,"\"", value, "\")'")
   clk = "onclick=\"alert(\'Pulsado\')\""
   data = as.character(icon)
   res = regexpr(">", data, fixed=TRUE)
   base = substr(data, 1, res[1] - 1)
   htmltools::HTML(paste(base, clk, substr(data, res[1], 10000L)))
}
# Source: shinyWidgets
# Function: actionBttn
# Action: Removed match.arg color control
#         Removed id and label
#         Removed attach
yuiActionBtn = function (title=NULL, icon = NULL, style = "unite", class=NULL,
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
                           ,class = paste("action-button bttn", class)
                           ,class = paste0("bttn-", style)
                           ,class = paste0("bttn-",size)
                           ,list(icon,label)
                           ,class = if (block) "bttn-block"
                           ,class = if (no_outline) "bttn-no-outline"
                           ,style = paste("background:", color)
    )
    tagBttn
}

