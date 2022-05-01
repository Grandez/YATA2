JGGWEBROOT = R6::R6Class("JGG.INFO.APP"
  ,portable   = TRUE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,public = list(
      session = NULL
     ,root    = NULL
     ,print      = function() { message("WEB Singleton") }
     ,initialize = function() {
#         self$session = session
         private$panels = HashMap()
     }
     ,setSession = function(session) {
         self$session = session
         invisible(self)
      }
     ,getPanel   = function(object, id, parent, session, ...) {
         panel = private$panels$get(id)
         if (is.null(panel)) {
             args = list(...)
             panel = object$new(id, parent, session, ...)
             private$panels$put(id, panel)
             self$subscribe(id, panel$events$listen)
             if (is.null(args$dashboard))  shinyjs::js$jgg_add_page(id)
             if (!is.null(args$dashboard)) shinyjs::js$jgg_add_dash(paste(id, args$dashboard, sep="_"))
         }
         lapply(panel$events$events, function(evt) self$unnotify(evt))
         shinyjs::js$jgg_set_page(id)
         panel
     }
    ,addPanel = function(panel) { private$panels$put(panel$name, panel) }
     ##########################################################################
     ### Coherencia de datos
     ##########################################################################
    ,subscribe = function(id, events) {
        lapply(events, function(evt){
            private$changes[[evt]] = c(private$changes[[evt]], id)
        })
     }
    ,notify = function(evt) {
         block = paste0(change,"_changed")
         private$changes$events[[evt]] = TRUE

         lst = lapply(private$changes[[change]], function() TRUE)
         names(lst) = private$changes[[change]]
         private$changes$pending = jgg_list_merge( private$changes$pending, lst)
     }
     ,unnotify = function(evt) {
         private$changes[[evt]] = FALSE
     }
    ,notified = function(id) {
        private$changespending = NULL
    }
      # common commarea across panels
      ,getCommarea       = function(item=NULL, default=NULL)     {
          if (is.null(item)) return (private$commarea)
          val = private$commarea[[item]]
          if (is.null(val)) val = default
          val
      }
      ,setCommarea      = function(..., block=NULL) {
          data = list()
          items = list(...)
          if (is.list(items[[1]])) {
              data = items[[1]]
          } else {
             for (idx in 1:length(items)) data[[names(items)[idx]]] = items[[idx]]
          }
          if (is.null(block)) {
              private$commarea = jgg_list_merge(private$commarea, data)
          } else {
              private$commarea[[block]] = jgg_list_merge(private$commarea[[block]], data)
          }
          invisible(self)
      }
      ,getCommareaBlock       = function(block, item=NULL, default=NULL)     {
          if (is.null(item)) return (private$commarea[[block]])
          val = private$commarea[[item]]
          if (is.null(val)) val = default
          val
      }
      ,setCommareaBlock      = function(block, ...) {
          items = list(...)
          if (is.list(items[[1]])) items = items[[1]]
          if (is.null(block)) {
              private$commarea = jgg_list_merge(private$commarea, items)
          } else {
              private$commarea[[block]] = jgg_list_merge(private$commarea[[block]], items)
          }
          invisible(self)
      }

     ##########################################################################
     ### Coherencia de sesiones
     ##########################################################################

     ,loadCookies = function(data)    {
         private$cookies = jsonlite::fromJSON(data)
      }
     ,setCookies  = function(name, values) {
        private$cookies[[name]] = values
        updateCookie(self$session, yata=private$cookies)
        invisible(self)
     }

     ,getCookies = function(block)    {
        if (missing(block))
            private$cookies
        else
            private$cookies[[block]]
     }
     ,getCookie = function(id) { private$cookies[[id]] }
     ,setCookie = function(id, data) {
       private$cookies[[id]] = data
       updateCookie(self$session, YATA=private$cookies)
     }
  )
  ,private = list(
      panels   = NULL
     ,cookies  = NULL
     ,commarea = NULL
     ,changes = list(events=list(), pending = list())
  )
)
