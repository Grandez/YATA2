    # pvl es porcentaje impreso: 23,45%
    # prc es porcentaje real   : 0,2345

WDGTable = R6::R6Class("YATA.WEB.TABLE"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,inherit    = WDGBase
  ,active = list(
      event   = function(value) private$accesor(private$.event,    value)
     ,target  = function(value) private$accessor(private$.target,  value)
     ,rounded = function(value) private$accessor(private$.rounded, value)
     ,scale   = function(value) private$accessor(private$.scale,   value)
   )
  ,public = list(
     initialize = function(table=NULL, columns=NULL) {
        if (!is.null((table))) {
            private$attrTable = list.merge(attrTable, table)
            extractExtraAttributes()
        }
     }
    ,render = function(data) {
        # JGG No se usa
        private$dfWork = data
        colDefs = prepareData(data)
    #         ,.appendButtons = function(df) {
    #     dfNames = colnames(df)
    #     for (i in 1:length(.buttons)) df = cbind(df, NA)
    #     colnames(df) = c(dfNames, names(.buttons))
    #     if (is.null(attrTable$columns))
    #         private$attrTable$columns = .buttons
    #     else
    #         private$attrTable$columns = list.merge(attrTable$columns,.buttons)
    #     df
    # }

        if (length(colDefs) > 0) {
            if (length(attrTable$columns) > 0) {
                private$attrTable$columns  = list.merge(colDefs, private$attrTable$columns)
            } else {
                private$attrTable$columns  = colDefs
            }
        }
        lstAttr = list.clean((attrTable)) # remove NULLS
        obj = do.call(reactable::reactable, list.merge(list(data=private$dfWork), lstAttr))
        reactable::renderReactable({obj})
    }
   ,setColumnHeader = function(style=c("asis", "title", "upper", "lower", "label")) {
       private$columnHeader = match.arg(style)
    }
   ,setColumnsLabel = function(labels) { private$lblCols = labels }
    # ,setTableOptions = function(...) {
    #     args = args2list(...)
    #     if (!is.null(args$replace) && args$replace) {
    #       private$attrTable = args
    #     } else {
    #       private$attrTable = list.merge(attrTable, args)
    #     }
    #     extractExtraAttributes()
    #  }
    # ,setColumnOptions = function(colName, ...) {
    #     args = args2list(...)
    #     if (is.null(private$coldDefs[[colName]])) { # Does not exist
    #         if (is.null(args$replace) || args$replace == FALSE) {
    #             mcolDef = private$attrColDef
    #         } else {
    #           mcolDef = list()
    #         }
    #     } else {
    #       if (!is.null(args$replace) && args$replace) {
    #          mcolDef = list()
    #       }
    #     }
    #     mcolDef    = list.merge(mcolDef, args)
    #     mcolDef    = setColumnAlign(mcolDef)
    #     mcolDef$id = colName
    #
    #     private$attrCols[[colName]] = mcolDef
    #  }
    # ,setColumnsDef = function(...) {
    #   # Establece los datos de columnas como named list
    # }
  )
  ,private = list(
      .rounded = TRUE
     ,.scale = 2
     ,columnHeader = "label" # Tipo de cabecera de columna
     ,col_names = NULL
     ,table_def = NULL
     ,col_attr = list()
     ,current = NULL
     ,super_render = function(df) {
         if (nrow(df) == 0)  return (reactable::renderReactable({df}))

         private$current = table_def
         private$current$data = df
         adjust_values()
         format_columns()
         current$columns = current$columns[names(current$columns) %in% colnames(df)]
         # Remove items used internally
         current$columns = lapply(current$columns, function(column) {
             column$type = NULL
             column
         })
         current = set_column_names(current)
        #  coldDefs = makeColDefs(df)
        # private$dfWork = data
        # colDefs = prepareData(data)
        # if (length(colDefs) > 0) {
        #     if (length(attrTable$columns) > 0) {
        #         private$attrTable$columns  = list.merge(colDefs, private$attrTable$columns)
        #     } else {
        #         private$attrTable$columns  = colDefs
        #     }
        # }
        # lstAttr = list.clean((attrTable)) # remove NULLS

        cols = names(current$columns)
        current$columns = lapply(cols, function(name) do.call(reactable::colDef, current$columns[[name]]))
        names(current$columns) = cols
        obj = do.call(reactable::reactable, current)
        reactable::renderReactable({obj})
    }
     ,set_column_names = function(info) {
         cols = colnames(info$data)
         for (col in cols) {
             if (!is.null(info$columns[[col]])) {
                 info$columns[[col]]$name = col_names[[col]][[columnHeader]]
             }
         }
         info
     }
     ,prepareData = function (df) {
         colDefs = makeColDefs(df)
         browser()
         colDefs = setAlign(df, colDefs)

         df = adjustValues(df)
          setColumnHeader(data)
          private$attrCols = lapply(attrCols, function(col) prepareColumn(col))
          lapply(attrCols, function(item) do.call(reactable::colDef, item))
#         private$attrTable$columns = lapply(attrCols, function(col) prepareColumn(col))

      }

      ,makeColDefs = function(df) {
          cols = lapply(colnames(df), function(name) {
                        header = switch(columnHeader,
                                  asis = name, title = str_to_title(name)
                                 ,upper = toupper(name), lower = tolower(name)
                                 ,label = ifelse(is.na(lblCols[name]), name, lblCols[name]))
                        list(name=header) })
      }
     ,setAlign = function (df, colDefs) {
          cols = lapply(1:length(ncol(df)), function(idx) {
                        algn = "right"
                        if (class(df[,idx]) %in% "type_label") algn = "left"
                        list(align=algn) })
         names(cols) = colnames(df)
         jgg_list_merge(colDefs, cols)
     }
     ,adjust_values = function () {
         df = private$current$data
         names = colnames(df)
         for (idx in 1:ncol(df)) {
             attr = current$columns[[names[idx]]]
             if (is.null(attr)) next
             if (!is.null(attr$type)) df = adjust_value(df, idx, attr$type)
         }
         private$current$data = df
     }
    ,adjust_value = function (df, idx, type) {
        if (type == "prc100") df[,idx] = round(df[,idx] / 100, .scale)
        if (type == "prc")    df[,idx] = round(df[,idx],       .scale)
        if (type == "date")   df[,idx] = as.Date(df[,idx])
        if (type == "time")   df[,idx] = strftime(df[,idx], "%H:%M:%S")
        if (type == "tms")    df[,idx] = strftime(df[,idx], "%Y/%m/%d %H:%M")
        if (type == "price")  df = adjust_price(df, idx)
        df
    }
     ,adjust_price = function(df, col) {
         value = 0
         for (row in 1:nrow(df)) {
              value = df[row,col]
              if (value >   999) { df[row,col] = round(df[row,col], 0); next }
              if (value >    99) { df[row,col] = round(df[row,col], 1); next }
              if (value >     9) { df[row,col] = round(df[row,col], 2); next }
              if (value < 0.001) { df[row,col] = round(df[row,col], 6); next }
              df[row,col] = round(df[row,col], 3)
         }
         df
      }
,format_columns = function() {
    fmt = private$current$columns
    df  = private$current$data

    for (idx in 1:ncol(df)) {
         item = fmt[[colnames(df)[idx]]]
         if (is.null(item)) item = list()
         type = ifelse(is.null(item$type), "", item$type)
         item$align = "right"
         if ( type == "prc100" || type == "prc") {
              item$format = reactable::colFormat(percent=TRUE, separators = TRUE, digits=2,locales = "es-ES")
              item$style = function(value) {
                   if (value > 0) color = "#008000" else if (value < 0) color = "#e00000"  else color <- "#777"
                   bold = ifelse (abs(value) > 0.02, "bold", "normal")
                   list(color = color, fontWeight = bold)
              }

         }
         if ( type == "price" || type == "value") {
              item$format = reactable::colFormat(separators = TRUE, locales = "es-ES")
         }
         if (type == "lbl" || type == "label") item$align = "left"
         fmt[[colnames(df)[idx]]] = item
    }
    private$current$columns= fmt
#    lapply(fmt, function(item) do.call(reactable::colDef, item))
}

      ,attrTable = list(
           bordered            = FALSE     # Add borders around the table and every cell?
          ,borderless          = FALSE     # Remove inner borders from table?
          ,class               = NULL      # Additional CSS classes to apply to the table.
          ,columns             = NULL      # Named list of column definitions
          ,columnGroups        = NULL      # List of column group definitions (ColGroup)
          ,compact             = TRUE      # Make tables more compact?
          ,defaultColDef       = NULL      # Default column definition used by every column
          ,defaultColGroup     = NULL      # Default column group definition used by every column group
          ,defaultExpanded     = FALSE     # Expand all rows by default?
          ,defaultPageSize     = 10
          ,defaultSelected     = NULL      # A numeric vector of default selected row indices
          ,defaultSortOrder    = 'asc'     # Default sort order asc/desc
          ,defaultSorted       = NULL      # vector of column names to sort or named list
          ,details             = NULL      # Additional content to display when expanding a row.
          ,elementId           = NULL      # Element ID for the widget.
          ,filterable          = FALSE     # Enable column filtering?
          ,fullWidth           = TRUE      # Stretch the table to fill the full width of its container?
          ,groupBy             = NULL      # Character vector of column names to group by
          ,height              = 'auto'    # Height of the table in pixels
          ,highlight           = TRUE      # Highlight table rows on hover?
          ,language            = getOption('reactable.language')  # Language specified by reactableLang()
          ,minRows             = 1         # Minimum number of rows to show per page
          ,pageSizeOptions     = c(10, 25, 50, 100) # Page size options for the table
          ,pagination          = FALSE      # Enable pagination?
          ,paginationType      = 'numbers' # numbers/jump/simple
          ,onClick             = NULL      # Action to take when clicking a cell. expand/select/JS()
          ,outlined            = FALSE     # Add borders around the table?
          ,resizable           = FALSE     # Enable column resizing?
          ,rownames            = NULL      # Show row names?
          ,rowClass            = NULL      # Additional CSS classes to apply to rows, string/JS(row info, table state)/R(row number)
          ,rowStyle            = NULL      # Inline styles to apply to rows.
          ,searchable          = FALSE     # Enable global table searching?
          ,selection           = NULL      # Enable row selection? multiple/single
          ,showPageInfo        = TRUE      # Show page info?
          ,showPageSizeOptions = FALSE     # Show page size options?
          ,showPagination      = NULL
          ,showSortIcon        = TRUE      # Show a sort icon when sorting columns?
          ,showSortable        = FALSE     # Show an indicator on sortable columns?
          ,sortable            = TRUE      # Enable sorting?
          ,striped             = TRUE      # Add zebra-striping to table rows?
          ,style               = NULL      # Inline styles to apply to the table. A named list or character string
          ,theme               = getOption('reactable.theme') # Theme for the table, specified by reactableTheme() or a function
          ,width               = 'auto'    # Width of the table in pixels
          ,wrap                = TRUE      # Enable text wrapping?
       )
      ,attrTheme = list(
            color                  = NULL    # Default text color.
           ,backgroundColor        = NULL    # Default background color.
           ,borderColor            = NULL    # Default border color.
           ,borderWidth            = NULL    # Default border width.
           ,stripedColor           = NULL    # Default row stripe color.
           ,highlightColor         = NULL    # Default row highlight color.
           ,cellPadding            = NULL    # Default cell padding.
           ,style                  = NULL    # Additional CSS for the table.
           ,tableStyle             = NULL    # Additional CSS for the table element (excludes the pagination bar and search input).
           ,headerStyle            = NULL    # Additional CSS for header cells.
           ,groupHeaderStyle       = NULL    # Additional CSS for group header cells.
           ,tableBodyStyle         = NULL    # Additional CSS for the table body element.
           ,rowGroupStyle          = NULL    # Additional CSS for row groups.
           ,rowStyle               = NULL    # Additional CSS for rows.
           ,rowStripedStyle        = NULL    # Additional CSS for striped rows.
           ,rowHighlightStyle      = NULL    # Additional CSS for highlighted rows.
           ,rowSelectedStyle       = NULL    # Additional CSS for selected rows.
           ,cellStyle              = NULL    # Additional CSS for cells.
           ,footerStyle            = NULL    # Additional CSS for footer cells.
           ,inputStyle             = NULL    # Additional CSS for inputs.
           ,filterInputStyle       = NULL    # Additional CSS for filter inputs.
           ,searchInputStyle       = NULL    # Additional CSS for the search input.
           ,selectStyle            = NULL    # Additional CSS for table select controls.
           ,paginationStyle        = NULL    # Additional CSS for the pagination bar.
           ,pageButtonStyle        = NULL    # Additional CSS for page buttons
           ,pageButtonHoverStyle   = NULL    # page buttons with hover
           ,pageButtonActiveStyle  = NULL    # or active states
           ,pageButtonCurrentStyle = NULL    # and the current page button.
      )
      ,attrColDef = list(
           name             = NULL     # Column header name.
          ,aggregate        = NULL     # Aggregate function. a built-in function or JS(). mean,sum,max,min,median,count,unique,frequency. To enable row grouping, use the groupBy argument in reactable().
          ,sortable         = NULL     # Enable sorting? Overrides the table option.
          ,resizable        = NULL     # Enable column resizing? Overrides the table option.
          ,filterable       = NULL     # Enable column filtering? Overrides the table option.
          ,show             = TRUE     # Show the column?
          ,defaultSortOrder = NULL     # Default sort order. Either "asc" for ascending order or "desc" for descending order. Overrides the table option.
          ,sortNALast       = FALSE    # Always sort missing values (NA or NaN) last?
          ,format           = NULL     # Column formatting options. A colFormat() object to format all cells, or a named list of colFormat() objects to format standard cells ("cell") and aggregated cells ("aggregated") separately.
          ,cell             = NULL     # Custom cell renderer. An R function that takes the cell value, row index, and column name as arguments, or a JS() function that takes a cell info object and table state object as arguments.
          ,grouped          = NULL     # Custom grouped cell renderer. A JS() function that takes a cell info object and table state object as arguments.
          ,aggregated       = NULL     # Custom aggregated cell renderer. A JS() function that takes a cell info object and table state object as arguments.
          ,header           = NULL     # Custom header renderer. An R function that takes the header value and column name as arguments, or a JS() function that takes a column info object and table state object as arguments.
          ,footer           = NULL     # Footer content or render function. Render functions can be an R function that takes two arguments, the column values and column name, or a JS() function that takes a column info object and table state object as arguments.
          ,details          = NULL     # Additional content to display when expanding a row. An R function that takes a row index argument, or a JS() function that takes a row info object and table state object as arguments. Cannot be used on a groupBy column.
          ,html             = FALSE    # Render content as HTML? Raw HTML strings are escaped by default.
          ,na               = ""       # String to display for missing values (i.e. NA or NaN). By default, missing values are displayed as blank cells.
#          ,rowHeader        = FALSE    # Mark up cells in this column as row headers? Set this to TRUE to help users navigate the table using assistive technologies. When cells are marked up as row headers, assistive technologies will read them aloud while navigating through cells in the table.
          ,minWidth         = 100      # Minimum width of the column in pixels. Defaults to 100.
          ,maxWidth         = NULL     # Maximum width of the column in pixels.
          ,width            = NULL     # Fixed width of the column in pixels. Overrides minWidth and maxWidth.
          ,align            = NULL     # Horizontal alignment. left/right/center
          ,vAlign           = NULL     # Vertical alignment of content in data cells. One of "top" (the default), "center", "bottom".
          ,headerVAlign     = NULL     # Vertical alignment of content in header cells. One of "top" (the default), "center", "bottom".
          ,sticky           = NULL     # Make the column sticky when scrolling horizontally? Either "left" or "right" to make the column stick to the left or right side.
          ,class            = NULL     # Additional CSS classes to apply to cells. Can also be an R function that takes the cell value, row index, and column name as arguments, or a JS() function that takes a row info object, column info object, and table state object as arguments.
          ,style            = NULL     # Inline styles to apply to cells. A named list or character string. Can also be an R function that takes the cell value and row index as arguments, or a JS() function that takes a row info object, column info object, and table state object as arguments.
          ,headerClass      = NULL     # Additional CSS classes to apply to the header.
          ,headerStyle      = NULL     # Inline styles to apply to the header. A named list or character string.
          ,footerClass      = NULL     # Additional CSS classes to apply to the footer.
          ,footerStyle      = NULL     # Inline styles to apply to the footer. A named list or character string.
      )
      ,dataclass = c( pvl = "type_percent_100", prc = "type_percent_1"
                     ,int = "type_integer",     imp = "type_price"
                     ,tms = "type_tms",         dat = "type_date", tim = "type_time"
                     ,lbl = "type_label"
                     ,btn = "type_button")

      # ,.event    = NULL   # Event to trigger and send to shiny
      # ,.target   = NULL   # Target of event
      ,colNames  = "asis" # Column names: asis, title, upper, lower, ...

      # ,dfWork    = NULL
      # ,attrCols  = list() # Full list of attributes
      # ,colDefs   = NULL   # Column attributes for reactable
     #  ,defineClasses = function(types) {
     #      lista = lapply(names(dataclass), function(name) {
     #                     if (is.null(types[[name]])) return (NULL)
     #                     lst1 = as.list(rep(dataclass[name], length(types[[name]])))
     #                     names(lst1) = types[[name]]
     #                     lst1
     #               })
     #      private$colClasses = unlist(lista)
     #  }
     #  ,applyClasses = function(df) {
     #      for (name in colnames(df)) {
     #          cls = colClasses[name]
     #          if (!is.na(cls)) class(df[,name]) = c(class(df[,name]), cls)
     #      }
     #      df
     #  }
     # ,adjustValues = function (df) {
     #     for (idx in 1:ncol(df)) {
     #         if ("type_price" %in% class(df[,idx])) df = .adjustPrice(df, idx)
     #     }
     #     df
     #  }
     # ,adjustPrice = function(df, col) {
     #     value = 0
     #     for (row in 1:nrow(df)) {
     #          value = df[row,col]
     #          if (value >   999) { df[row,col] = round(df[row,col], 0); next }
     #          if (value >    99) { df[row,col] = round(df[row,col], 1); next }
     #          if (value >     9) { df[row,col] = round(df[row,col], 2); next }
     #          if (value < 0.001) { df[row,col] = round(df[row,col], 6); next }
     #          df[row,col] = round(df[row,col], 3)
     #     }
     #     df
     #  }

#       ,extractExtraAttributes = function () {
#         # Remove private attributes. That is attr which is not part of reactable
#         extractEvent()
#         if (!is.null(attrTable$colNames)) {
#             private$colNames = attrTable$colNames
#             private$attrTable$colNames = NULL
#         }
#         # Other attributes not matching call to reactable
#         private$attrTable$replace = NULL
#       }
#       ,extractEvent = function() {
#           if (!is.null(attrTable$event))  private$.event  = attrTable$event
#           if (!is.null(attrTable$target)) private$.target = attrTable$target
#           if (!is.null(.event) && is.null(.target)) private$.target = .event
#
#           click = paste0(       "function(row, col) { ")
#           click = paste0(click, "  window.alert('Clickado');")
#           click = paste0(click, "  if (window.Shiny) {")
#           click = paste0(click, "      Shiny.setInputValue('", .event, "',")
#           click = paste0(click, "            {row: row.index + 1, colName: col.id, target: '", .target, "'});")
#           click = paste0(click, "  }")
#           click = paste0(click, "}")
#
#           private$attrTable$onClick = reactable::JS(click)
#           private$attrTable$event   = NULL
#           private$attrTable$target  = NULL
#       }
#       ,prepareColumn = function(attr) {
#          if (!is.null(attr$scale)) private$dfWork[,attr$id] = round(private$dfWork[,attr$id], digits=attr$scale)
#          attr$id      = NULL
#          attr$replace = NULL
#          attr$scale   = NULL
#          attr$type    = NULL
#          list.clean(attr)
#       }
#       ,setColumnHeader = function(data) {
#            if (is.null(colNames) || colNames == "asis") return
#          # if (private$colNames == "title") colnames(data) = str_to_title(colnames(data))
#          # if (private$colNames == "upper") colnames(data) = toUpper(colnames(data))
#          # if (private$colNames == "lower") colnames(data) = toLower(colnames(data))
# #         private$dfWork
#
#       }
#       ,setColumnAlign = function (mcolDef) {
#          if (is.null(mcolDef$type)) return (mcolDef)
#          if (mcolDef$type == "date") mcolDef$align = "right"
#          if (mcolDef$type == "time") mcolDef$align = "right"
#          mcolDef
#       }
  )
)
WDGTableSimple = R6::R6Class("YATA.WEB.TABLE"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,inherit    = WDGTable
  ,public = list(
    initialize = function(table=NULL, columns=NULL) {
       super$initialize(table=table, columns=columns)
       attrTable$selection = 'single'
    }
   )
)
WDGTableMultiple = R6::R6Class("YATA.WEB.TABLE"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,inherit    = WDGTable
  ,public = list(
    initialize = function(table=NULL, columns=NULL) {
       super$initialize(table=table, columns=columns)
       attrTable$selection = 'multiple'
    }
   )
)
# buttons = list(Button_buy=yuiBtnIconBuy("Comprar"))
WDGTableButtoned = R6::R6Class("YATA.WEB.TABLE"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,inherit    = WDGTable
  ,public = list(
    initialize = function(table=NULL, columns=NULL, ...) {
       super$initialize(table=table, columns=columns)
       attrTable$selection = 'multiple'
       private$.createButtons(args2list(...))
    }
    ,render = function(data) {
       df  = .appendButtons(data)
       super$render(df)
    }
   )

  ,private = list(
      .buttons = NULL
     ,.createButtons = function(btns) {
          private$.buttons = lapply(btns, function(btn) {
                                   do.call(reactable::colDef, list( name = "", sortable = FALSE
                                                ,width = 48
                                                ,style=list(`text-align` = "center")
                                                ,cell = function() btn))
                    })
         if (is.null(names(btns))) {
            btnNames = c(paste0("Button", seq(1, length(btns))))
        } else {
            btnNames = names(btns)
        }
        names(private$.buttons) = btnNames
     }
    ,.appendButtons = function(df) {
        dfNames = colnames(df)
        for (i in 1:length(.buttons)) df = cbind(df, NA)
        colnames(df) = c(dfNames, names(.buttons))
        if (is.null(attrTable$columns))
            private$attrTable$columns = .buttons
        else
            private$attrTable$columns = list.merge(attrTable$columns,.buttons)
        df
    }
  )
)

    #   # Botones
    # if (!is.null(info$buttons) && length(info$buttons) > 0) {
    #     buttons = lapply(info$buttons, function(btn) {
    #                      do.call(colDef, list( name = "", sortable = FALSE
    #                                           ,width = 48
    #                                           ,style=list(`text-align` = "center")
    #                                           ,cell = function() btn))
    #     })
    #     if (is.null(names(info$buttons))) {
    #         btnNames = c(paste0("Button", seq(1, length(info$buttons))))
    #     } else {
    #         btnNames = names(info$buttons)
    #     }
    #     names(buttons) = btnNames
    #     dfNames = colnames(df)
    #     for (i in 1:length(buttons)) df = cbind(df, NA)
    #
    #     colnames(df) = c(dfNames, btnNames)
    # }
    # if (length(cols) >  0 && length(buttons) > 0) cols = list.merge(cols, buttons)
    # if (length(cols) == 0 && length(buttons) > 0) cols = buttons
    # reactable(df, striped = TRUE, compact=TRUE
    #                               , pagination=FALSE
    #                               , selection = selection
    #                               , wrap = FALSE
    #                               , onClick = JS(click)
    #                               , columns = cols
    # )

# function yataTableclick (rowInfo, colInfo, evt, tgt) {
#   //CHECKED
#   // Botones en reactable
#
# //    window.alert('Details for click: \\n Fila: ' + colInfo.index + '\\n' + "boton: " + colInfo.id//);
#                                    //if (colInfo.id !== 'details') { return }
# //                         window.alert('Details: row ' + rowInfo.index + 'col: ' + colInfo.id);
# //     if (window.Shiny) {
#          Shiny.setInputValue(evt, { row: rowInfo.index + 1, colName: colInfo.id, target: tgt
#                                  }, { priority: 'event' });
# //     }
# }

yuiTable          = function(id)   { reactable::reactableOutput(id) }
updTable          = function(data) { reactable::renderReactable({ .updTable(data, NULL)       })}
updTableSingle    = function(data) { reactable::renderReactable({ .updTable(data, "single")   })}
updTableMultiple  = function(data) {
    .updTable(data,"multiple")
    reactable::renderReactable({ .updTable(data, "multiple")})
}

updTbl            = function(data) { .updTable(data, "multiple") }
updTableSelection = function(table, sel) { reactable::updateReactable(table, selected = sel) }
.updTable = function(data, selection) {
   click = NULL
   .makeScript = function(info) {
       if (is.null(info$event)) return (NULL)
       tgt = info$event
       if (!is.null(info$target)) tgt = info$target
       click = paste0("function(rowInfo, colInfo) {"
#                      ,"window.alert('Details for row ' + rowInfo.index + ':\\n' + JSON.stringify(rowInfo.row, null, 2));"
                      ,"yataTableclick (rowInfo, colInfo, '", info$event, "', '", tgt, "');"
                      ,"}")

       click
   }
   df      = data$df
   info    = data$info
   columns = df$columns

    if (!is.null(info)) click = .makeScript(info)
    df  = .yataSetClasses(df, info$types)
    df  = .adjustValues(df)
    colnames(df) = str_to_title(colnames(df))
    cols = .formatColumns(df, columns)

    buttons = NULL
    # Botones
    if (!is.null(info$buttons) && length(info$buttons) > 0) {
        buttons = lapply(info$buttons, function(btn) {
                         do.call(reactable::colDef, list( name = "", sortable = FALSE
                                              ,width = 48
                                              ,style=list(`text-align` = "center")
                                              ,cell = function() btn))
        })
        if (is.null(names(info$buttons))) {
            btnNames = c(paste0("Button", seq(1, length(info$buttons))))
        } else {
            btnNames = names(info$buttons)
        }
        names(buttons) = btnNames
        dfNames = colnames(df)
        for (i in 1:length(buttons)) df = cbind(df, NA)

        colnames(df) = c(dfNames, btnNames)
    }
    if (length(cols) >  0 && length(buttons) > 0) cols = list.merge(cols, buttons)
    if (length(cols) == 0 && length(buttons) > 0) cols = buttons

    reactable::reactable(df, striped = TRUE, compact=TRUE
                                  , pagination=FALSE
                                  , selection = selection
                                  , wrap = FALSE
                                  , onClick = reactable::JS(click)
                                  , columns = cols
    )
}


###############################################################
# REVISAR

.updTableButtons = function(df, buttons) {
     data = df
     cols = ncol(df)
     code = lapply(strsplit(buttons, "__"), function(x) paste0(x[[1]], seq(1,nrow(df)), x[[2]]))
     dfb = as.data.frame(code)
     colnames(dfb) = paste0("col", seq(1,ncol(dfb)))
     dfb = tidyr::unite(dfb, "btn", colnames(dfb), sep=" ", remove=TRUE)
     data = cbind(df, dfb)
     cols = colnames(data)
     cols[length(cols)] = ""
     #colnames(data) = YATABase$str$titleCase(cols)
     colnames(data) = cols
     data
}
.getOptions = function(df, ...) {
    args = list(...)
    opts = list(
       searching = FALSE
      ,paging = FALSE
    )

    if (length(args) == 0) return (opts)
    if (length(args) == 1 && is.list(args[[1]])) args = args[[1]]

    if (!is.null(args$page)) {
        opts$pageLength = args$page[[1]]
        opts$paging = TRUE
    }
    # opts$searching = args$search # ifelse(is.null(args$search), FALSE, TRUE)

    if (!is.null(args$noSort)) {
        colDefs = lapply(seq(1:ncol(df)), function(x) NULL)
        for (col in args$noSort) colDefs[[col]] = list(orderable=FALSE)
        opts$columns=colDefs
    }
    opts
}

#################################################################
yuiTablePosition = function(id, dfbase, dfAux, ...) {
    df = dfbase
    df$value = dfbase$price * dfbase$balance
    yataDataTableFormat({df}, style='auto', type="position")
}


yuiRenderTable = function(df, type, buttons=NULL, ...) {
    data = .yuiRenderTableBase(df, buttons)
    if (is.null(data)) return (NULL)

    opts = .getOptions(data, ...)
    #DT::renderDataTable({data}, rownames=FALSE, escape=FALSE, style='auto', options=opts)
    yataDataTable({data}, rownames=FALSE, escape=FALSE, style='auto', type="gral", options=opts)
}
yuiRenderTablePaged = function(df, type, page=15, buttons=NULL, ...) {
    data = .yataRenderTableBase(df, buttons)
    if (is.null(data)) return (NULL)
    opts = .getOptions(data, ...)
    opts$paging = TRUE
    opts$pageLength = page
#    renderDataTable({data}, rownames=FALSE, escape=FALSE, style='auto', options=opts)
#    .yatarenderDataTable({data}, rownames=FALSE, escape=FALSE, style='auto', type="juan", options=opts)
    yataDataTable({data}, rownames=FALSE, escape=FALSE, style='auto', type="gral", options=opts)
}
.yuiRenderTableBase = function(df, buttons=NULL) {
    if (is.null(df)) return (NULL)
    data = df

    if (!is.null(buttons) && nrow(df) > 0) {
        cols = ncol(df)
        code = lapply(strsplit(buttons, "__"), function(x) paste0(x[[1]], seq(1,nrow(df)), x[[2]]))
        dfb = as.data.frame(code)
        colnames(dfb) = paste0("col", seq(1,ncol(dfb)))
        dfb = tidyr::unite(dfb, "btn", colnames(dfb), sep=" ", remove=TRUE)
        colnames(dfb) = ""
        data = cbind(df, dfb)
    }
    #colnames(data) = YATABase$str$titleCase(colnames(data))
    data
}
.getOptions = function(df, ...) {
    args = list(...)
    opts = list(
       searching = FALSE
      ,paging = FALSE
    )

    if (length(args) == 0) return (opts)
    if (length(args) == 1 && is.list(args[[1]])) args = args[[1]]

    if (!is.null(args$page)) {
        opts$pageLength = args$page[[1]]
        opts$paging = TRUE
    }
    # opts$searching = args$search # ifelse(is.null(args$search), FALSE, TRUE)

    if (!is.null(args$noSort)) {
        colDefs = lapply(seq(1:ncol(df)), function(x) NULL)
        for (col in args$noSort) colDefs[[col]] = list(orderable=FALSE)
        opts$columns=colDefs
    }
    opts
}

#####################################################
### Tables                                        ###
#####################################################

# updTablePosition = function(df, ...) {
#     if (is.null(df)) return (NULL)
#     colnames(df) = YATABase$str$titleCase(colnames(df))
#     yataDataTable({df}, type="position")
# }

# updTableOperations = function(df, buttons=NULL, ...) {
#   yataDTButtons
#    if (!is.null(buttons)) df = .updTableButtons(df, buttons)
#    colnames(df) = YATABase$str$titleCase(colnames(df))
#
#    dt =  yataDT({df}, type="operation")
#    # dt = dt %>%  YATADT::formatStyle("Value", color = DT::styleInterval(cuts=c(-Inf,0,+Inf)
#    #                         , values=c("red","black","green","green")))
#
#    if ("Balance" %in% colnames(df)) {
#         dt = dt %>%  YATADT::formatStyle("Balance",
#                              color = DT::styleInterval( cuts=c(-Inf,0,+Inf)
#                                                        ,values=c("red","red","green","green")))
#    }
#
#    yataDTRender(dt)
# }
updTableBest = function(df) {
    #colnames(df) = YATABase$str$titleCase(colnames(df))
    dt = yataDT({df}, type="best", selection="single")
    dt = YATADT::formatStyle(dt, colnames(df)[3:6], color = DT::styleInterval(cuts=c(-Inf,0,+Inf)
                            , values=c("red","darkred","darkgreen","green")))
    yataDTRender(dt)
  #  yataDataTable({df}, type="best", selection="single")
}


.yataGetClasses = function() {
   c( "text"  , "label"
     ,"number", "integer", "percentage", "amount"
     ,"date"  , "time"   , "tms" )
}
.yataSetClasses = function(df, types) {

    # pvl es porcentaje impreso: 23,45%
    # prc es porcentaje real   : 0,2345
    cc = list(imp=c(), pvl = c(), prc = c(), tms=c(), int=c(), lbl=c(), dat=c(), tim=c(), btn=c())
    if (!is.null(types)) cc = list.merge(cc, types)

    if (is.character(cc$imp)) cc$imp = which(colnames(df) %in% cc$imp)
    if (is.character(cc$prc)) cc$prc = which(colnames(df) %in% cc$prc)
    if (is.character(cc$pvl)) cc$pvl = which(colnames(df) %in% cc$pvl)
    if (is.character(cc$tms)) cc$tms = which(colnames(df) %in% cc$tms)
    if (is.character(cc$int)) cc$int = which(colnames(df) %in% cc$int)
    if (is.character(cc$lbl)) cc$lbl = which(colnames(df) %in% cc$lbl)
    if (is.character(cc$dat)) cc$dat = which(colnames(df) %in% cc$dat)
    if (is.character(cc$tim)) cc$tim = which(colnames(df) %in% cc$tim)
    if (is.character(cc$btn)) cc$btn = which(colnames(df) %in% cc$btn)
    for (idx in 1:ncol(df)) {
        cls = class(df[,idx])
        if (idx %in% cc$pvl)      { class(df[,idx]) = c(cls, "type_percentage"); df[,idx] = df[,idx] / 100; next}
        if (idx %in% cc$prc)      { class(df[,idx]) = c(cls, "type_percentage"); next}
        if (idx %in% cc$tms)      { class(df[,idx]) = c(cls, "type_tms");        next}
        if (idx %in% cc$int)      { class(df[,idx]) = c(cls, "type_integer");    next}
        if (idx %in% cc$imp)      { class(df[,idx]) = c(cls, "type_price");      next}
        if (idx %in% cc$lbl)      { class(df[,idx]) = c(cls, "type_label");      next}
        if (idx %in% cc$dat)      { class(df[,idx]) = c(cls, "type_date");       next}
        if (idx %in% cc$tim)      { class(df[,idx]) = c(cls, "type_time");       next}
        if (idx %in% cc$btn)      { class(df[,idx]) = c(cls, "type_button");     next}
        if ("numeric"   %in% cls) { class(df[,idx]) = c(cls, "type_number");     next}
        if ("character" %in% cls)   class(df[,idx]) = c(cls, "type_text")
    }
    df
}

.colorize = function(df, columns) {

    for (idx in 1:ncol(df)) {
         if (class(df[,idx]) %in% "type_percentage") {

         }
    }
}

.formatColumns = function(df, columns) {
   fmt = list()
   if (!is.null(columns)) fmt = columns

    for (idx in 1:ncol(df)) {
         item = list()
         if ( "type_percentage" %in% class(df[,idx])) {
              item$format = reactable::colFormat(percent=TRUE, separators = TRUE, digits=YATAWEBDEF$scale,locales = "es-ES")
              item$style = function(value) {
                   if (value > 0) color = "#008000" else if (value < 0) color = "#e00000"  else color <- "#777"
                   bold = ifelse (abs(value) > 0.02, "bold", "normal")
                   list(color = color, fontWeight = bold)
              }

         }
         if ( "type_price" %in% class(df[,idx])) {
              item$format = reactable::colFormat(separators = TRUE, locales = "es-ES")
         }
         colname = colnames(df)[idx]
         if (!is.null(fmt[[colname]]) && length(fmt[[colname]]) > 0) {
             if (length(item) > 0) fmt[[colname]] = list.merge(item, fmt[[colname]])
         } else {
             if (length(item) > 0) {
                 item$name = colname
                 fmt[[colname]] = item
             }
         }
    }
    lapply(fmt, function(item) do.call(reactable::colDef, item))
}
.adjustValues = function (df) {
    if (nrow(df) == 0) return (df)
    for (idx in 1:ncol(df)) {
      if ("type_price" %in% class(df[,idx])) df = .adjustPrice(df, idx)
    }
    df
}
.adjustPrice = function(df, col) {
    value = 0
    for (row in 1:nrow(df)) {
        value = df[row,col]
        if (value >   999) { df[row,col] = round(df[row,col], 0); next }
        if (value >    99) { df[row,col] = round(df[row,col], 1); next }
        if (value >     9) { df[row,col] = round(df[row,col], 2); next }
        if (value < 0.001) { df[row,col] = round(df[row,col], 6); next }
        df[row,col] = round(df[row,col], 3)
    }
    df
}
