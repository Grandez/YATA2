yuiBoxClosable     = function(id, title="", ...) { .yuiBox(id, title, closable=TRUE,  collapsible=TRUE, ...)  }
yuiBoxClosableOnly = function(id, title="", ...) { .yuiBox(id, title, closable=TRUE,  collapsible=FALSE, ...) }
yuiBox             = function(id, title="", ...) { .yuiBox(id, title, closable=FALSE, collapsible=TRUE, ...)  }

.yuiBox = function(id, title="", closable, collapsible, ...) {
   box( ..., title = title, width = 12, status = "primary",solidHeader = TRUE
           ,closable = closable, collapsible = collapsible,id=id
    )
}

