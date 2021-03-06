yataMsgSuccess = function(id, msg) { yataMessage(id,msg, "success") }
yataMsgInfo    = function(id, msg) { yataMessage(id,msg, "info")    }
yataMsgWarn    = function(id, msg) { yataMessage(id,msg, "warning") }
yataMsgError   = function(id, msg) { yataMessage(id,msg, "error")   }
yataMsgReset   = function(id) {
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

yataErrGeneral = function(type, data, input, output, session) {
    sf = system.file('extdata/www/img/error.png', package=packageName())
    output$yata_main_img_err = renderImage({
                    list(src = sf, contentType = 'image/png', width = 400, height = 300, alt = "Error image")
                    }, deleteFile = FALSE)
    output$yata_main_text_err = renderText({data})
    shinyjs::show("yata_main_err")
}
