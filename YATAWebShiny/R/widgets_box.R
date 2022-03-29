guiBoxClosable     = function(id, title="", ...) { .guiBox(id, title, closable=TRUE,  collapsible=TRUE, ...)  }
guiBoxClosableOnly = function(id, title="", ...) { .guiBox(id, title, closable=TRUE,  collapsible=FALSE, ...) }
guiBox             = function(id, title="", ...) { .guiBox(id, title, closable=FALSE, collapsible=TRUE, ...)  }

.guiBox = function(id, title="", closable, collapsible, ...) {
   shinydashboard::box( ..., title = title, width = 12, status = "primary",solidHeader = TRUE
           ,closable = closable, collapsible = collapsible,id=id
    )
}
