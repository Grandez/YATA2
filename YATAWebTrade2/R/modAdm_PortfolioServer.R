# Cada modulo lleva asociado un objeto
# es el que gestiona la creacion del objeto y guarda sus variables

modAdminPortfolioServer <- function(id, full, parent, session) {
ns = NS(id)
PNLPortfolio = R6::R6Class("PNL.ADMIN.PORTFOLIO"
   ,inherit = WEBPanel
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,public = list(
       portfolios = NULL
      ,current = NULL
      ,act     = NULL
      ,scopes  = NULL
      ,targets = NULL
      ,update  = TRUE
      ,edit    = list()
      ,db_info = NULL
      ,initialize    = function(id, parent, session) {
          super$initialize(id, parent, session)
          self$scopes  = WEB$combo$scopes()
          self$targets = WEB$combo$targets()
             private$objPortfolio = self$factory$getObject(self$factory$codes$object$portfolio)
       }
       ,loadData = function() {
           self$portfolios = private$objPortfolio$getPortfolios()
       }
       ,loadPortfolio = function (id) {
           self$current = private$objPortfolio$getportfolio(id)
           self$act     = self$current
           self$current
       }
      )
      ,private = list(
         objPortfolio = NULL
      )

 )
moduleServer(id, function(input, output, session) {
   message("Ejecutando server para Admin")
   pnl = WEB$getPanel(PNLPortfolio, id, parent, session)

   initPanel = function() {
       portfolios = WEB$combo$portfolios()
       updListbox("lstPortfolios", choices=portfolios)

   }
   load_portfolio = function(id) {
       data = pnl$loadPortfolio(id)

       output$lbl_name    = updLabel(data$name)
       output$lbl_title   = updLabel(data$title)
       output$lbl_comment = updLabel(data$comment)
       output$lbl_scope   = updLabel(names(pnl$scopes) [which(pnl$scopes == data$scope)])
       output$lbl_target  = updLabel(names(pnl$targets)[which(pnl$targets == data$target)])
       output$lbl_since   = updLabel(data$since)
       output$lblDB      = updLabel(data$db$name)

       txt = ifelse (data$selective_ctc == 0, "All", as.character(data$selective_ctc))
       output$lbl_ctc      = updLabel(txt)
       txt = ifelse (data$selective_tok == 0, "All", as.character(data$selective_tok))
       output$lbl_tok      = updLabel(txt)

       # updSwitch("swActive", data$active)
       # updCombo("cboScope",  selected=data$scope)
       # updCombo("cboTarget", selected=data$target)
       # updIntegerInput("selCTC", data$selective_ctc)
       # updIntegerInput("selTok", data$selective_tok)

   }
   toggleFieldText = function(name) {
       item = pnl$edit[[name]]
       mode = ifelse (is.null(item) || item == FALSE, TRUE, FALSE)

       if (mode) {
           tags = c("lbl", "txt", "times")
       } else {
           tags = c("txt", "lbl", "pencil-alt")
       }
       eval(parse(text=paste0("hide('", tags[1], "_", name, "')")))
       eval(parse(text=paste0("show('", tags[2], "_", name, "')")))
       eval(parse(text=paste0("updButtonIcon('btn_", name, "','", tags[3], "')")))
       if (mode) {
           txt = eval(parse(text=paste0("input$txt_", name)))
           if (is.null(txt) || nchar(trimws(txt)) == 0) {
               eval(parse(text=paste0("updText('txt_", name, "', pnl$current$", name, ")")))
           }
       }

       pnl$edit[[name]] = mode
   }
   prepareNew = function(cancel = FALSE) {
       # Reset posibles campos activos
       items = c( "lbl_name"   , "txt_name"  , "lbl_title"  , "txt_title", "lbl_scope", "cbo_scope"
                 ,"lbl_target" , "cbo_target", "lbl_ctc"    , "txt_ctc"  , "lbl_tok"  , "txt_tok"
                 ,"lbl_comment", "txt_comment")
       lapply(items, function(x) toggle(x))
       btns = unlist(stringr::str_match_all(names(input), "btn_[a-zA-Z]+"))
       lapply(btns, function(x) hide(x))
       show("new_buttons")
   }
   observeEvent(input$lstPortfolios, {
       load_portfolio(as.integer(input$lstPortfolios))
   }, ignoreInit = TRUE)

   observeEvent(input$btn_new, {
       browser()
       pnl$update = FALSE
       prepareNew()
   }, ignoreInit = TRUE)

   observeEvent(input$btn_name,    { toggleFieldText("name")    })
   observeEvent(input$btn_title,   { toggleFieldText("title")   })
   observeEvent(input$btn_comment, { toggleFieldText("comment") })

   if (!pnl$loaded) {
       pnl$loadData()
       initPanel()
       pnl$loaded = TRUE
   }


})  # END ModuleServer
} # END source
