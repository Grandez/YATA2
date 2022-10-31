
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
.btnIcon = function(id, color, ico, title) {
   yuiActionBtn( id=id, title=title, style = "simple", back=color
                ,class="yata_btn_icon"
                ,icon = icon(ico, class="yata_btn_icon"))
}
.btnIconWhite = function(id, color, ico, title) {
   sty = paste("simple; background-color:", color, ";color: snow;")
   yuiActionBtn( id=id, title=title, style = "simple", back=color, front="snow"
                ,class="yata_btn_icon"
                ,icon = icon(ico, class="yata_btn_icon"))
}

yuiBtnIconAlert    = function(title,id=NULL) {.btnIcon(id, "yellow"      , "bell"               ,ifelse(missing(title), "Alert"      ,title)) }
yuiBtnIconCancel   = function(title,id=NULL) {.btnIcon(id, "red"         , "times"              ,ifelse(missing(title), "Cancel"     ,title)) }
yuiBtnIconOK       = function(title,id=NULL) {.btnIcon(id, "green"       , "check"              ,ifelse(missing(title), "Accept"     ,title)) }
yuiBtnIconDel      = function(title,id=NULL) {.btnIcon(id, "orange"      , "trash"              ,ifelse(missing(title), "Delete"     ,title)) }
yuiBtnIconRefuse   = function(title,id=NULL) {.btnIcon(id, "navy"        , "thumbs-down"        ,ifelse(missing(title), "Refuse"     ,title)) }
yuiBtnIconCloud    = function(title,id=NULL) {.btnIcon(id, "aqua"        , "cloud-upload-alt"   ,ifelse(missing(title), "Cloud"      ,title)) }
yuiBtnIconEdit     = function(title,id=NULL) {.btnIcon(id, "darkgreen"   , "pen"                ,ifelse(missing(title), "Edit"       ,title)) }
yuiBtnIconCash     = function(title,id=NULL) {.btnIconWhite(id, "darkgreen"   , "wallet"             ,ifelse(missing(title), "Close"      ,title)) }
yuiBtnIconView     = function(title,id=NULL) {.btnIconWhite(id, "mediumblue"  , "search-dollar"      ,ifelse(missing(title), "View"       ,title)) }
yuiBtnIconActive   = function(title,id=NULL) {.btnIcon(id, "limegreen"   , "plus-circle"        ,ifelse(missing(title), "Activate"   ,title)) }
yuiBtnIconInactive = function(title,id=NULL) {.btnIcon(id, "maroon"      , "minus-circle"       ,ifelse(missing(title), "Deactivate" ,title)) }
yuiBtnIconBuy      = function(title,id=NULL) {.btnIcon(id, "green"       , "shopping-cart"      ,ifelse(missing(title), "Buy"        ,title)) }
yuiBtnIconUp       = function(title,id=NULL) {.btnIcon(id, "green"       , "sort-up"            ,ifelse(missing(title), "Up"         ,title)) }
yuiBtnIconDown     = function(title,id=NULL) {.btnIcon(id, "green"       , "sort-down"          ,ifelse(missing(title), "Down"       ,title)) }
yuiBtnIconCalc     = function(title,id=NULL) {.btnIcon(id, "green"       , "calculator"         ,ifelse(missing(title), "Calculate"  ,title)) }
yuiBtnIconFavAdd   = function(title,id=NULL) {.btnIcon(id, "ForestGrenn" , "star"               ,ifelse(missing(title), "Add"        ,title)) }
yuiBtnIconFavDel   = function(title,id=NULL) {.btnIcon(id, "FireBrick"   , "heart-broken" ,ifelse(missing(title), "Remove"     ,title)) }

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
yuiActionBtn = function (id=NULL, title=NULL, icon = NULL, style = "unite", class=NULL,
#JGG yataActionBttn = function (inputId, label = NULL, icon = NULL, style = "unite",
    back = "default", front="black", size = "md", block = FALSE,
    no_outline = TRUE)
{
    label = NULL
    #JGG value <- shiny::restoreInput(id = inputId, default = NULL)
    style <- match.arg(arg = style, choices = c("simple",
        "bordered", "minimal", "stretch", "jelly",
        "gradient", "fill", "material-circle",
        "material-flat", "pill", "float", "unite"))
    size <- match.arg(arg = size, choices = c("xs", "sm", "md", "lg"))
    tagBttn <- tags$button( id=id, type = "button"
                           ,title=title
                           ,class = paste("action-button bttn", class)
                           ,class = paste0("bttn-", style)
                           ,class = paste0("bttn-",size)
                           ,class = if (block) "bttn-block"
                           ,class = if (no_outline) "bttn-no-outline"
                           ,list(icon,label)
                           ,style = paste("background:", back, ";color: ", front, ";")
    )
    tagBttn
}

