rmdRender = function(data) {
    html <- markdown::markdownToHTML(text=data, fragment.only = TRUE)
    Encoding(html) <- "UTF-8"
    return(HTML(html))
}
