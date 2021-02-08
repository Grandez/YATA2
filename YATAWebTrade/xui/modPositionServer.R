# Cada modulo lleva asociado un objeto
# es el que gestiona la creacion del objeto y guarda sus variables

modPositionServer <- function(id, full) {
   ns = NS(id)
   PNLPos = R6::R6Class("PNL.OPER"
        ,inherit = YATAPanel
        ,cloneable  = FALSE
        ,lock_class = TRUE
        ,public = list(
            position     = NULL
           ,cameras      = NULL
           ,providers    = NULL
           ,data         = NULL
           ,lastMonitors = NULL
           ,monitors = NULL            
           ,fiats = c("EUR", "USD", "USDC", "USDT")
           ,initialize     = function(id) {
               super$initialize(id)
               self$position  = YATAFactory$getObject("Position")
               self$cameras   = YATAFactory$getObject("Cameras")
               self$providers = YATAFactory$getObject("Providers")
               self$monitors  = HashMap$new()
           }
        )
       ,private = list(
           opIdx     = list()
           ,selected = NULL

       )
    )
    moduleServer(id, function(input, output, session) {
        pnl = YATAWEB$panel(id)
        if (is.null(pnl)) pnl = YATAWEB$addPanel(PNLPos$new(id))
        insertMonitors       = function(act) {
            toDel = !pnl$lastMonitors %in% act
            # Quitar los viejos
            if (length(toDel) > 0) {
                toDel = pnl$lastMonitors[toDel]
                for (old in toDel) pnl$monitors$remove(old)
            }
            act = act[!act %in% pnl$fiats]
            # Poner los nuevos
            if (length(act) < 6 && ! ("BTC" %in% act)) act = c("BTC", act)
            if (length(act) < 6 && ! ("ETH" %in% act)) act = c("ETH", act)
            lapply(act, function(item) if (is.null(pnl$monitors$get(item))) pnl$monitors$put(item, list()))

            idDiv = paste0("#", ns("monitor"))
            lapply(act, function(x) {
                if (!(x %in% pnl$lastMonitors)) 
                    insertUI(selector = idDiv, where = "beforeEnd", immediate=TRUE,
                             ui=tagList(column(2,yataCtcUI(ns(paste0("monitor-",x))))))
            })
            pnl$lastMonitors = act
        }
        loadCameraUI = function(camera) {
            suffix = titleCase(camera)
            camera = pnl$cameras$getCameraName(camera)
            nstable = paste0("tblPos", suffix)
            tags$div(id=paste0("divPos", suffix), yataBox(ns(nstable), paste("Posicion", camera)
                                                                     , DT::dataTableOutput(ns(nstable))))
        }
        initMonitor = function() {
            # Aqui ponemos los valores medio, dia, semana y session
            data = pnl$providers$getOnlineExchange(pnl$lastMonitors, "EUR")
            for (idx in 1:length(data)) {
                ctc = names(data)[idx]
                monitor = pnl$monitors$get(ctc)
                monitor$session = data[[idx]]
                monitor$last    = data[[idx]]
                monitor$current = data[[idx]]
                row = pnl$data[pnl$data$currency == ctc,]
                monitor$price = ifelse(nrow(row) > 0, row[1,"price"],monitor$last)
                
                
                pnl$monitors$put(ctc, monitor)
                yataCtcServer(ns(paste0("monitor-",ctc)), pnl$monitors$get(ctc))
            }
        }
        updateMonitor = function(actives) {
            monitors = pnl$monitors$keys()
            data = pnl$providers$getOnlineExchange(monitors, "EUR")
            # Actualizamos last
            yataCtcServer(pnl$monitors) # Calculamos las diferencias
            actives = actives[!actives %in% pnl$fiats]
            if (length(actives) < 6 && ! ("BTC" %in% actives)) actives = c("BTC", actives)
            if (length(actives) < 6 && ! ("ETH" %in% actives)) actives = c("ETH", actives)
            data = pnl$providers$getOnlineExchange(actives, "EUR")
            lbl = lapply(names(data), function(x) ns(paste0("monitor-", x)))
            browser()
            for (idx in 1:length(data)) {
                 removeUI(selector = paste0("#", lbl[idx], "-last-value"), immediate=TRUE)
                 insertUI(selector = paste0("#", lbl[idx], "-last"), where = "beforeEnd", immediate=TRUE,
                           ui=tagList(tags$p(id=paste0(lbl[idx], "-last-value"), data[idx])))
            }
         #   output$pos-BTC-last = renderText({"1234"})
        }
        loadPosition = function() {
           pnl$data = pnl$position$getGlobalPosition()
           output$tblPosGlobal = yataRenderTable(id=ns("posGlobal"),   pnl$data)
           cameras = pnl$position$getCameras()
           divs = lapply(cameras, function(camera) loadCameraUI(camera))
           
           insertUI(selector = "#divPosLast", where = "beforeBegin", ui=tagList(divs), immediate=TRUE)
           dfs = lapply(cameras, function(camera) {
                        sfx = titleCase(camera)
                        df  = pnl$position$getCameraPosition(camera)
                        tbl = paste0("tblPos", sfx) 
                        eval(parse(text=paste0( "output$tblPos", sfx
                                               ," = yataRenderTable(id=ns('"
                                               ,paste0("pos", sfx), "'),   df)")))
           })
           insertMonitors(unique(pnl$data$currency))
           pnl$valid = TRUE
         }
         
        
        # observeEvent(input$cboCamera,{
        #     pnl$cameras$select(input$cboCamera)
        #     updateSelectInput(session, "cboBase",  choices=pnl$cboBase(input$cboCamera, input$opBuy))
        #     updateSelectInput(session, "cboCounter",  choices=pnl$cboBase(input$cboCamera))
        # }, ignoreInit = TRUE)
        observeEvent(input$pnlOpType, {
            mod = strsplit(input$pnlOpType, "-")[[1]][2]
            module = paste0("modOper", mod,"Server")
            eval(parse(text=paste0(module, "(mod, id, pnl)")))
        })

        autoInvalidate <- reactiveTimer(30000)

  observe({
    # Invalidate and re-execute this reactive expression every time the
    # timer fires.
    autoInvalidate()
    output$lastUpdate = renderText({paste("Last update: ", format.POSIXct(Sys.time(), format="%H:%M:%S"))})
    # Do something each time this is invalidated.
    # The isolate() makes this observer _not_ get invalidated and re-executed
    # when input$n changes.
    #print(paste("The value of input$n is", isolate(input$n)))
  })        
        if (!pnl$valid)  loadPosition()
        if (!pnl$loaded) {
            initMonitor()
#            updateMonitor()
            pnl$loaded = TRUE
        }
    })
}    
