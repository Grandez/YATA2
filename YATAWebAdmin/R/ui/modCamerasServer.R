modCamerasServer = function(id, full) {
   ns = NS(id)
   
   PNLCameras = R6::R6Class("PNL.CAMERAS"
        ,inherit    = YATAPanel
        ,cloneable  = FALSE
        ,lock_class = TRUE
        ,public = list(
           parms      = NULL
          ,cameras = NULL
          ,dfActive   = NULL
          ,dfInactive   = NULL
          ,initialize     = function(id, session) {
               super$initialize(id, session)
               self$cameras = YATAFactory$getObject(YATACodes$object$cameras)
               self$parms   = YATAFactory$getParms()
           }
        )
       ,private = list(
       )
    )
   
   moduleServer(id, function(input, output, session) {
      pnl = YATAWEB$panel(id)
      if (is.null(pnl)) pnl = YATAWEB$addPanel(PNLCameras$new(id, session))
      
      validate = function() {
          FALSE
      }
      loadPanel = function() {
         df = pnl$cameras$getActiveCameras()
         pnl$dfActive = df

         df = pnl$cameras$getInactiveCameras()
         pnl$dfInactive = df

         opts = list(noSort=c(1), page=15)
         btn1   = c(yataTblButton(full, "active",   "Edit",   yataBtnIconEdit()))
         btn2   = c(yataTblButton(full, "active",   "Edit",   yataBtnIconEdit()))
         btnDel = yataTblButton  (full, "active",   "Remove", yataBtnIconDel())
         btnAdd = yataTblButton  (full, "inactive", "Accept", yataBtnIconOK())
      
         pos = which(colnames(pnl$dfActive) == "active")
         output$tblCamOK = yataRenderTable(pnl$dfActive  [,-pos], buttons=c(btnDel, btn1), opts)
         output$tblCamKO = yataRenderTable(pnl$dfInactive[,-pos], buttons=c(btnAdd, btn2), opts)
         
        pnl$loaded = TRUE
        pnl$valid  = TRUE
      }
      formAdd = function() {
          data = YATAFormUI(ns("add"), "Cameras")
          output$form = renderUI({data})
      }
        
      if (!pnl$loaded) loadPanel()

         # output$tblCamOK = yataRenderTable(pnl$dfActive  [,-pos], buttons=c(btnDel, btn1), opts)  
         # output$tblCamKO = yataRenderTable(pnl$dfInactive[,-pos], buttons=c(btnAdd, btn2), opts)
      
      observeEvent(input$btnOK,  {formAdd()})
      observeEvent(input$btnOK2, {formAdd()})
      
      ########################################################
      ### Form ADD
      ########################################################
      observeEvent(input$addBtnOK, {
          if (validate()) return()
          data = list(
              id     = input$addTxtSymbol
             ,name   = input$addTxtName
             ,active = ifelse(input$addSwActive, YATACodes$flag$active, YATACodes$flag$inactive)
             ,maker  = input$addNumMaker
             ,taker  = input$addNumTaker
             ,token  = input$addTxtToken
             ,usr    = input$addTxtUsr
             ,pwd    = input$addTxtPwd
          )
          pnl$cameras$add(data, isolated=TRUE)
          pnl$valid = FALSE
          YATAFormClose()
          loadPanel()
      })
      observeEvent(input$addBtnKO, { YATAFormClose() })

  })
}

