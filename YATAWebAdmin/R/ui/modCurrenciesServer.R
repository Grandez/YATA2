modCurrenciesServer = function(id, full) {
   ns = NS(id)
   ns2 = NS(full)
   PNLCurrencies = R6::R6Class("PNL.CURRENCIES"
        ,inherit    = YATAPanel
        ,cloneable  = FALSE
        ,lock_class = TRUE
        ,public = list(
           parms      = NULL
          ,currencies = NULL
          ,cameras    = NULL
          ,dfActive   = NULL
          ,dfInactive = NULL
          ,dfIcons    = NULL
          ,initialize     = function(id, session) {
               super$initialize(id, session)
               self$currencies = YATAFactory$getObject(YATACodes$object$currencies)
               self$cameras    = YATAFactory$getObject(YATACodes$object$cameras)
               
               self$parms    = YATAFactory$getParms()
          }
        )
       ,private = list(
           
       )
    )
   
   moduleServer(id, function(input, output, session) {
      pnl = YATAWEB$panel(id)
      if (is.null(pnl)) pnl = YATAWEB$addPanel(PNLCurrencies$new(id, session))
      validate = function() {
          FALSE
      }
      loadPage = function() {
         pnl$dfIcons = data.frame(id=character(), icon=character(), stringsAsFactors=FALSE)

         df = pnl$currencies$getActiveCurrencies()
         pnl$dfActive = select(df, icon, id, name)
         if (nrow(df) > 0) {
             pnl$dfIcons =  rbind(pnl$dfIcons, df[,c("id", "icon")])
             pnl$dfActive$icon = paste0("<img src='",df$icon,"', width='12px', height='12px'></img>")
         }
         
         df = pnl$currencies$getInactiveCurrencies()
         pnl$dfInactive = select(df, icon, id, name)
         if (nrow(df) > 0) {             
             pnl$dfIcons =  rbind(pnl$dfIcons, df[,c("id", "icon")])
             pnl$dfInactive$icon = paste0("<img src='icons/",df$icon,"', width='12px', height='12px'></img>")
         }
         pnl$loaded = TRUE
      }
      updateLstCameras = function(add, rem) {
          if (!is.null(add)) {
              sel = which(pnl$data$camerasOut == input$formLstCamerasKO)
              pnl$data$camerasIn = list.merge(pnl$data$camerasIn, pnl$data$camerasOut[sel])
              pnl$data$camerasOut = pnl$data$camerasOut[-sel]
          }
          if (!is.null(rem)) {
              sel = which(pnl$data$camerasIn == input$formLstCamerasOK)
              pnl$data$camerasOut = list.merge(pnl$data$camerasOut, pnl$data$camerasIn[sel])
              pnl$data$camerasIn  = pnl$data$camerasIn[-sel]
          }
          updateSelectInput(session, "formLstCamerasKO", choices = pnl$data$camerasOut)
          updateSelectInput(session, "formLstCamerasOK", choices = pnl$data$camerasIn)
      }
      if (!pnl$loaded) loadPage()
#      opts = list(noSort=c(1), page=15)
      btn1   = c(yataTblButton(id, "active", "Edit",   yataBtnIconEdit()))
      btn2   = c(yataTblButton(id, "inactive", "Edit",   yataBtnIconEdit()))
      btnDel = yataTblButton(id, "active", "Remove", yataBtnIconInactive())
      btnAdd = yataTblButton(id, "inactive", "Accept", yataBtnIconActive())

#      output$tblCtcOK = yataRenderTablePaged(pnl$dfActive,   page=20, buttons=c(btn1, btnDel))
      res = yataRenderTablePaged(pnl$dfInactive, page=20, buttons=c(btn2, btnAdd))
      output$tblCtcKO = yataRenderTablePaged(pnl$dfInactive, page=20, buttons=c(btn2, btnAdd))
      observeEvent(input$btnAddL | input$btnAddR,{
          data       = list(action=0)
          data$camerasOut = pnl$makeCombo(pnl$cameras$getAllCameras())
          subm = "Currencies"
          form = YATAFormUI(ns("form"), subm, data=data)
          output$form = renderUI({form})
      }, ignoreInit = TRUE)
      observeEvent(input$btnTableActive, {
          txt = strsplit(input$btnTableActive, "-")[[1]]
          action = txt[1]
          idx    = as.integer(txt[2])
          pnl$currencies$select(id = pnl$dfActive[idx,"id"])
          id = pnl$currencies$current$id
          df = pnl$currencies$getCurrencyCameras(id)
          camerasIn = pnl$makeCombo(df)
          dfc = pnl$cameras$getAllCameras()
          camerasOut = pnl$makeCombo(dfc[dfc$id != df$id,])

          if (action == "Edit") {
              pnl$data = pnl$currencies$current
              pnl$data$camerasIn = camerasIn
              pnl$data$camerasOut = camerasOut
              pnl$data$icon = pnl$dfIcons[pnl$dfIcons$id == id, "icon"]
              data = YATAFormUI(ns("form"), "Currencies", data=pnl$data)
              output$form = renderUI({data})
          }

      })
      ########################################################
      ### Form ADD
      ########################################################
      observeEvent(input$formBtnOK,  { updateLstCameras(input$formLstCamerasKO, NULL) })
      observeEvent(input$formBtnKO,  { updateLstCameras(NULL, input$formLstCamerasOK) })
      observeEvent(input$formBtnEsc, { YATAFormClose() })

  })
}

