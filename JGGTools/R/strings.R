jgg_to_title = function(text) {
    text = gsub("_", " ", text)
    stringr::str_to_title(text)
}
