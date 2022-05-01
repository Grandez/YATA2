JGGLayout2 = R6::R6Class("JGG.LAYOUT"
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = FALSE
    ,public = list(
          initialize    = function(id, blocks=NULL, items=NULL, selected=NULL, widgets=NULL) {
              if (is.null(blocks) && is.null(items)) stop("A list of blocks or items must be specified")
              private$divBase = gsub("-", "_", id)
              private$id = id
              # toks = strsplit(id, "-")
              # toks = toks[[1]]
              #
              # private$id     = toks[length(toks)]
              # if (length(toks) > 1) {
              #     toks[1:(length(toks) - 1)]
              #     private$base = paste(toks,sep="-")
              # }
              if (is.null(blocks)) {
                  private$items = items
              } else {
                  if (!is.null(blocks$items))    private$items    = blocks$items
                  if (!is.null(blocks$selected)) private$selected = blocks$selected
                  if (!is.null(blocks$items))    private$widgets  = blocks$widgets
                  if (!is.null(items))           private$items    = lsit.merge(private$items, items)
              }
              if (!is.null(selected)) private$selected = c(private$selected, selected)
              if (!is.null(widgets))  private$widgets  = list.merge(private$widgets, widgets)
          }
        ,config = function() { makeCombos() }
        ,body = function()   {
            tagList(makeDivs(), tags$div(style="display: hidden;", uiOutput(paste(id, "table", sep="_"))))
        }
    )
    ,private = list(
         base     = NULL
        ,id       = NULL
        ,divBase   = NULL # preffix div
        ,full     = NULL
        ,items    = NULL
        ,selected = NULL
        ,widgets  = NULL
        ,makeCombos = function () {
            items = expandItems()
            names(items) = lapply(items, function(x) x$label)
            items = items[order(names(items))]
            items$`expand row` = list(label="expand row", value="rows")
            items$`expand col` = list(label="expand col", value="cols")

            cbos = lapply(1:4, function(idx) makeCombo(idx, items))

            widget = "<table>\n"
            widget = paste0(widget, "   <tr>\n")
            widget = paste0(widget, "       <td>", cbos[[1]], "</td>\n")
            widget = paste0(widget, "       <td>", cbos[[2]], "</td>\n")
            widget = paste0(widget, "   </tr>\n")
            widget = paste0(widget, "   <tr>\n")
            widget = paste0(widget, "       <td>", cbos[[3]], "</td>\n")
            widget = paste0(widget, "       <td>", cbos[[4]], "</td>\n")
            widget = paste0(widget, "   </tr>\n")
            widget = paste0(widget, "</table>\n")
            HTML(widget)
        }
        ,makeCombo = function(idx, items) {
             cbo = paste0("<select id='", id, "-combo-", idx, "' class='form-control'")
            #cbo = paste0("<select  class='form-control'")
            cbo = paste0(cbo," onchange='jggshiny.layout_changed(&apos;", id, "&apos;,", idx, ")'>")
            options = lapply(items, function(item) {
                end = ifelse(item$value == selected[idx], "' selected>", "'>")
                paste0("<option value='", item$value, end,item$label,"</option><br>")
            })
            cbo = paste(cbo, paste(options, collapse="\n"))
            cbo = paste(cbo,"</select>", sep="<br>")
        }
       ,makeDivs = function() {
           divContainer = tags$div( id=paste(divBase,"container", sep="_")) # ,class="jgg_layout_block_hidden")
           divContainer = tagAppendChildren(divContainer, makeFramework())
           divContainer = tagAppendChildren(divContainer, makeDivData()
           # No se porque, si no la tabla no se muestra
           #,uiOutput(paste(id, "table", sep="_"))

           )
           divContainer
       }

      ,expandItems = function() {
          data = lapply(1:length(items), function(idx) expandItem(idx))
          unlist(data, recursive=FALSE)
      }
      ,expandItem = function(idx) {
          widgets = private$widgets
          value = names(private$items)[idx]
          item = private$items[[idx]]
          if (!is.null(item$widgets)) widgets = item$widgets
          data = sapply(1:length(widgets), function(idw) {
              x = widgets[[idw]]
              prf = ifelse(is.null(x$lblPreffix), "", x$lblPreffix)
              sfx = ifelse(is.null(x$lblSuffix), "", x$lblSuffix)
              label = paste(prf, item$label, sfx)
              # label = gsub("$", "", label, fixed=TRUE)
              # label = trimws(label)
              value = paste(names(widgets)[idw], value, sep="_")
              list("label" = label, "value"=value)
          }, simplify=FALSE)
          data
      }

      ,widgetsPattern = function() {
          widgets = blocks$widgets
          data = lapply(1:length(widgets), function(idx) {
              paste0(widgets[[idx]]$widget,'("', id, '_', names(widgets)[idx], '_$")')
          })
          unlist(data)
      }
     ,makeFramework = function() {

            divFull      = tags$div(id=paste0(divBase,"_full"),   class="jgg_layout_block_container")
            divDetail    = tags$div(id=paste0(divBase,"_detail"), class="jgg_layout_block_container")
            divRows      = tags$div(id=paste0(divBase,"_rows"),   class="jgg_layout_block_container")
            divCols      = tags$div(id=paste0(divBase,"_cols"),   class="jgg_layout_block_container")

            # Bloque de 4
            divDetail_1      = tags$div(id=paste0(divBase,"_detail_1"),   class="row jgg_layout_row")
            divDetail_1_1    = tags$div(id=paste0(divBase,"_detail_1_1"), class="jgg_layout_block")
            divDetail_1_2    = tags$div(id=paste0(divBase,"_detail_1_2"), class="jgg_layout_block")
            divDetail_1      = tagAppendChildren(divDetail_1, column(6, divDetail_1_1), column(6,divDetail_1_2))

            divDetail_2      = tags$div(id=paste0(divBase,"_detail_2"),   class="row jgg_layout_row")
            divDetail_2_1    = tags$div(id=paste0(divBase,"_detail_2_1"), class="jgg_layout_block")
            divDetail_2_2    = tags$div(id=paste0(divBase,"_detail_2_2"), class="jgg_layout_block")
            divDetail_2      = tagAppendChildren(divDetail_2, column(6, divDetail_2_1), column(6, divDetail_2_2))

            divDetail = tagAppendChildren(divDetail, divDetail_1, divDetail_2)

            # Bloque de 4
            divRow1   = tags$div(id=paste0(divBase,"_rows_1"))
            divRow_1_0 = tags$div(id=paste0(divBase,"_rows_1_0"),   class="row jgg_layout_row")
            divRow_1_3      = tags$div(id=paste0(divBase,"_rows_1_3"),   class="row jgg_layout_row")
            divRow_1_1    = tags$div(id=paste0(divBase,"_rows_1_1"), class="jgg_layout_block")
            divRow_1_2    = tags$div(id=paste0(divBase,"_rows_1_2"), class="jgg_layout_block")
            divRow_1_3      = tagAppendChildren(divRow_1_3, column(6, divRow_1_1), column(6,divRow_1_2))
            divRow1    = tagAppendChildren(divRow1, divRow_1_0, divRow_1_3)

            divRow2   = tags$div(id=paste0(divBase,"_rows_2"))
            divRow_2_0 = tags$div(id=paste0(divBase,"_rows_2_0"),   class="row jgg_layout_row")
            divRow_2_3    = tags$div(id=paste0(divBase,"_rows_2_3"),   class="row jgg_layout_row")
            divRow_2_1    = tags$div(id=paste0(divBase,"_rows_2_1"), class="jgg_layout_block")
            divRow_2_2    = tags$div(id=paste0(divBase,"_rows_2_2"), class="jgg_layout_block")
            divRow_2_3      = tagAppendChildren(divRow_2_3, column(6, divRow_2_1), column(6, divRow_2_2))
            divRow2    = tagAppendChildren(divRow2, divRow_2_0, divRow_2_3)
            divRows = tagAppendChildren(divRows, divRow1, divRow2)

            # divRow1   = tags$div(id=paste0(divBase,"_rows_1"),   class="row jgg_layout_row")
            # divRow1_0 = tags$div(id=paste0(divBase,"_rows_1_0"))
            # divRow1_3 = tags$div(id=paste0(divBase,"_rows_1_3"),   class="row jgg_layout_row")
            # divRow1_1 = tags$div(id=paste0(divBase,"_rows_1_1"), class="jgg_layout_block")
            # divRow1_2 = tags$div(id=paste0(divBase,"_rows_1_2"), class="jgg_layout_block")
            # divRow1_3 = tagAppendChildren(divRow1_3, column(6, divRow1_1), column(6,divRow1_2))
            # divRow1   = tagAppendChildren(divRow1, divRow1_0, divRow1_3)
            #
            # divRow2   = tags$div(id=paste0(divBase,"_rows_2"),   class="row jgg_layout_row")
            # divRow2_0 = tags$div(id=paste0(divBase,"_rows_2_0"))
            # divRow2_3 = tags$div(id=paste0(divBase,"_rows_2_3"),   class="row jgg_layout_row")
            # divRow2_1 = tags$div(id=paste0(divBase,"_rows_2_1"), class="jgg_layout_block")
            # divRow2_2 = tags$div(id=paste0(divBase,"_rows_2_2"), class="jgg_layout_block")
            # divRow2_3 = tagAppendChildren(divRow2_3, column(6, divRow2_1), column(6,divRow2_2))
            # divRow2   = tagAppendChildren(divRow2, divRow2_0, divRow2_3)
            #
            # divRows = tagAppendChildren(divRows, divRow1, divRow2)

            divCol1   = tags$div(id=paste0(divBase,"_cols_1"),   class="jgg_layout jgg_layout_col")
            divCol1_0 = tags$div(id=paste0(divBase,"_cols_1_0"))
            divCol1_1 = tags$div(id=paste0(divBase,"_cols_1_1"), class="jgg_layout layout_cols_1_1")
            divCol1_2 = tags$div(id=paste0(divBase,"_cols_1_2"), class="jgg_layout layout_cols_1_2")
            divCol1_3 = tags$div(id=paste0(divBase,"_cols_1_3"))
            divCol1_3 = tagAppendChildren(divCol1_3, divCol1_1, divCol1_2)
            divCol1   = tagAppendChildren(divCol1, divCol1_0, divCol1_3)

            divCol2   = tags$div(id=paste0(divBase,"_cols_2"),   class="jgg_layout jgg_layout_col")
            divCol2_0 = tags$div(id=paste0(divBase,"_cols_2_0"))
            divCol2_1 = tags$div(id=paste0(divBase,"_cols_2_1"), class="jgg_layout layout_cols_2_1")
            divCol2_2 = tags$div(id=paste0(divBase,"_cols_2_2"), class="jgg_layout layout_cols_2_2")
            divCol2_3 = tags$div(id=paste0(divBase,"_cols_2_3"))
            divCol2_3 = tagAppendChildren(divCol2_3, divCol2_1, divCol2_2)
            divCol2   = tagAppendChildren(divCol2, divCol2_0, divCol2_3)

            divCols = tagAppendChildren(divCols, column(6, divCol1), column(6, divCol2))
            tagList(divFull, divDetail, divRows, divCols)
     }
    ,makeDivData = function() {
        divData = tags$div(id=paste0(divBase, "_data_container"),class="jgg_layout_data_container")
        idDiv = paste0(divBase, "_data_")
        idUI  = paste0(id,"_data_")
        for (i in 1:4) {
             divObj  = tags$div( id=paste0(idDiv, i), class="jgg_layout_object jgg_layout_data_1"
                                ,uiOutput(outputId=paste0(idUI, i)))
             divData = tagAppendChild(divData, divObj)
        }
        divData
    }
  )
)

