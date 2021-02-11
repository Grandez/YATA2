yuiBoxClosable = function(id, title, style="primary", ...) {
  boxPlus(..., title=title, status=style, solidHeader=TRUE)
}
yuiBox = function(id, title, ...) {

res =        boxPlus( ..., title = title
                   ,closable = FALSE
                   ,width = 12
                   ,status = "primary"
                   ,solidHeader = TRUE
                   ,collapsible = TRUE
             )
res
}
yuiBox2 = function(text) {
    boxPlus(
  title = text,
  closable = TRUE,
  width = NULL,
  status = "warning",
  solidHeader = TRUE,
  collapsible = TRUE,
  enable_dropdown = TRUE,
  dropdown_icon = "wrench",
  dropdown_menu = dropdownItemList(
    dropdownItem(url = "http://www.google.com", name = "Link to google"),
    dropdownItem(url = "#", name = "item 2"),
    dropdownDivider(),
    dropdownItem(url = "#", name = "item 3")
  ),
  p("Box Content")
)
}
