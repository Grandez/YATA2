yataMsgSuccess = function(id, msg) { yataMessage(id,msg, "success") }
yataMsgInfo    = function(id, msg) { yataMessage(id,msg, "info")    }
yataMsgWarn    = function(id, msg) { yataMessage(id,msg, "warning") }
yataMsgError   = function(id, msg) { yataMessage(id,msg, "error"); TRUE   }
yataMsgReset   = function(id)      { #yataMessage(id,"" , "info")    }
    idVal = paste0("#", id, "_value")
    removeUI(idVal, immediate = TRUE)
}
yataMessage = function(id, msg, type) {
    idVal = paste0("#", id, "_value")
    yataMsgReset(id)
    ui = tags$p(id=idVal, class=paste("yataMsg", paste0("yata_msg_", type)), msg)
    insertUI(paste0("#", id), ui, where="afterBegin", immediate=TRUE)
}
yataAlertPanelUI = function(id) {
    bsModal(id, "Error grave", NULL, size = "large", h2("Error que te cagas"))
}
yataNotify = function(txt) {
    showNotification(txt, duration = NULL)
}
# yataAlertPanelServer = function(id, session) {
#     browser()
#     toggleModal(session, id)
#   # alert(
#   #       status = "info",
#   #       dismissible = TRUE,
#   #       tags$b("Dismissable"), "You can close this one."
#   #     )
# # shinyalert::shinyalert(
# #     title = "Hello",
# #     text = msg,
# #     size = "s",
# #     closeOnEsc = TRUE,
# #     closeOnClickOutside = FALSE,
# #     html = FALSE,
# #     type = "success",
# #     showConfirmButton = TRUE,
# #     showCancelButton = FALSE,
# #     confirmButtonText = "OK",
# #     confirmButtonCol = "#AEDEF4",
# #     timer = 0,
# #     imageUrl = "",
# #     animation = TRUE
# #   )
# }

yataErrSevere = function(WEB, objErr) {
   lbl = WEB$getLabelsPanelErr()
   dlg = YATAModalDialog(tags$table(
            tags$tr( tags$td(class="yata_modal_severe_labels", lbl$MESSAGE)
                    ,tags$td(objErr$message))
           ,tags$tr( tags$td(class="yata_modal_severe_labels", lbl$CLASS)
                    ,tags$td(objErr$subClass))
           ,tags$tr( tags$td(class="yata_modal_severe_labels", lbl$ACTION)
                    ,tags$td(objErr$action))
           ,tags$tr( tags$td(class="yata_modal_severe_labels", lbl$CODE)
                    ,tags$td(objErr$rc))
           ,tags$tr( tags$td(class="yata_modal_severe_labels", lbl$SOURCE)
                    ,tags$td(objErr$origin))
            )
          ,title =  span(WEB$MSG$get("TITLE.ERR.SEVERE"), style = "background-color: red; width: '100%'")
          ,size = "l"
          ,footer = tagList(actionButton(inputId="btnErrorsevere", WEB$MSG$get("LABEL.BTN.CHANGE")))
      )
      showModal(dlg)
      TRUE
}
yataErrGeneral = function(type, data, objErr, input, output, session, web=NULL) {

    if (type == 10) return (yataErrSevere(web, objErr))

    if (type == 0) {
        stop(cat(paste("ERROR yataMsgErr\n",data,"\n")))
    }
    sf = system.file('extdata/www/img/error.png', package=packageName())
    output$jgg_main_img_err = renderImage({
                    list(src = sf, contentType = 'image/png', width = 400, height = 400, alt = "Fatal Error")
                    }, deleteFile = FALSE)
    output$jgg_main_text_err = renderText({data[1]})
    shinyjs::show("jgg_main_err")
}
