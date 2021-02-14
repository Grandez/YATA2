yuiYesNo = function(lblOK, lblKO, id=ns("tag")) {
    toks = strsplit(id, "-")[[1]]
    toks = paste(toks[1:(length(toks)- 1)], collapse="-")
    tagList(tags$div(style="display: flex; justify-content: space-around;"
                     ,tags$div(yuiBtnOK(paste(toks, "btnOK", sep="-"), lblOK))
                     ,tags$div(yuiBtnKO(paste(toks, "btnKO", sep="-"), lblKO))
            )
    )
}

