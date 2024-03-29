yuiLoading = function() { show_modal_spinner(spin="dots") }
yuiLoaded  = function() { remove_modal_spinner()          }


yuiRank = function(id,lbl=NULL) { sliderInput(id, lbl, min=-2,max=2,step=1,value=0, ticks=FALSE) }

#yuiFlex = function(...) { tags$div(class="yata_flex_row", ...) }
# yuiRow  = function(...) {
#   tags$div(class="yata_row", ...)
# }
yuiDiv = function(..., id, class) {
    browser()
   cls = ifelse(missing(class), "row", class)
   if (missing(id)) {
      res = tags$div(class=cls, ...)
   }
   else {
      res = tags$div(id = id, class=cls, ...)
   }
   res
}

# userPost <- function(..., id = NULL, image, author,
#                      description = NULL, collapsible = TRUE,
#                      collapsed = FALSE) {

yuiPost = function(data, nchars=255) {
    collapsed = TRUE
   cl <- "collapse"
   id <- paste0("post-", data$id)

   if (!isTRUE(collapsed)) cl <- paste0(cl, " in")
   if (collapsed) collapsed <- "false" else collapsed <- "true"

   text = data$data
   if (nchar(text) > nchars) {
      text = paste(substr(text,1, nchars), "\n...")
   }
   btnExpand =  shiny::tags$button(
            class = "pull-right btn btn-default btn-xs yata_post_button",
            `data-toggle` = "collapse",
            `data-target` = paste0("#", id),
            `aria-expanded` = collapsed,
            type = "button",
            shiny::tags$i(class = "fa fa-pencil")
          )

   btnEdit = shiny::tags$button(
            class = "pull-right btn btn-default btn-xs yata_post_button",
            `data-toggle` = "collapse",
            `data-target` = paste0("#", id),
            `aria-expanded` = collapsed,
            type = "button",
            shiny::tags$i(class = "fa fa-eye")
          )

  shiny::tags$div(
     class = "yata_post",

     shiny::tags$div(
        class = "yata_post_item",
        shiny::img( class = "img-circle img-bordered-sm yata_post_icon", src = data$ico
                   ,width=YATAWEBDEF$iconSizeMedium, height=YATAWEBDEF$iconSizeMedium),
      shiny::tags$span(class = "yata_post_title", data$title, btnEdit, btnExpand),
      shiny::tags$span(class = "yata_post_date", data$tms)
    ),
    shiny::tags$p(class = cl,id = id,`aria-expanded` = collapsed, rmdRender(text))
  )

}
