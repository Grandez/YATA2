yataMsgSuccess = function(id, msg) { yataMessage(id,msg, "success") }
yataMsgInfo    = function(id, msg) { yataMessage(id,msg, "info")    }
yataMsgWarn    = function(id, msg) { yataMessage(id,msg, "warning") }
yataMsgError   = function(id, msg) { yataMessage(id,msg, "error")   }
yataMsgReset   = function(id) {
    idVal = paste0("#", id, "-value")
    removeUI(idVal, immediate = TRUE)
}
yataMessage = function(id, msg, type) {
    idVal = paste0("#", id, "-value")
    yataMsgReset(id)
    ui = tags$p(id=idVal, class=paste("yataMsg", paste0("yataMsg", type)), msg)
    insertUI(paste0("#", id), ui, where="afterBegin", immediate=TRUE)
}
yataAlertPanelUI = function(id) {
    bsModal(id, "Error grave", NULL, size = "large", h2("Error que te cagas"))
}
yataAlertPanelServer = function(id, session) {
    browser()
    toggleModal(session, id)
  # alert(
  #       status = "info",
  #       dismissible = TRUE,
  #       tags$b("Dismissable"), "You can close this one."
  #     )
# shinyalert::shinyalert(
#     title = "Hello",
#     text = msg,
#     size = "s",
#     closeOnEsc = TRUE,
#     closeOnClickOutside = FALSE,
#     html = FALSE,
#     type = "success",
#     showConfirmButton = TRUE,
#     showCancelButton = FALSE,
#     confirmButtonText = "OK",
#     confirmButtonCol = "#AEDEF4",
#     timer = 0,
#     imageUrl = "",
#     animation = TRUE
#   )
}
