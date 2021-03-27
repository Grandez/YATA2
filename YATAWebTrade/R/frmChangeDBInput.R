frmChangeDBInput = function() {
    tags$div(class="container"
        ,tags$div(class="col-md-3",
            fluidRow( h2("Cambiar Sistema"))
            , fluidRow(yuiFormTable(yuiFormRow("Actual",   yuiLabelText("lblDBCurrent"))))
            , fluidRow(yuiListBox("lstDB", choices=c("Operacional"=1, "test"=2,"Simulacion"=3)))
            , tags$div(style="display: flex; justify-content: space-around;"
                       ,tags$div(yuiBtnOK("btnDBChanged", "Cambiar"))
                       ,tags$div(yuiBtnKO("btnKO", "Cerrar"))
              )
        )
    )    
    
}


# <div id="yata-main-err-container" class="yata-form-center container col-lg-4">
#         <div id="form" aria-live="polite" class="shiny-html-output shiny-bound-output"><div class="">
#     <div class="row">
#       <h2>Cambiar Sistema</h2>
#     </div>
#     <div class="row">
#       <div class="yataCentered">
#         <table class="yataForm">
#           <tbody><tr>
#             <td>Actual</td>
#             <td>
#               <span id="lblDBCurrent" class="shiny-text-output shiny-bound-output" aria-live="polite">Test</span>
#             </td>
#           </tr>
#         </tbody></table>
#       </div>
#     </div>
#     <div class="row">
#       <div class="form-group shiny-input-container">
#         <label class="control-label shiny-label-null" for="lstDB" id="lstDB-label"></label>
#         <div>
#           <select id="lstDB" class="form-control shiny-bound-input shinyjs-resettable" data-shinyjs-resettable-id="lstDB" data-shinyjs-resettable-type="Select" data-shinyjs-resettable-value="&quot;1&quot;"><option value="1">Operacional</option>
# <option value="2">test</option>
# <option value="3">Simulaccion</option></select>
#         </div>
#       </div>
#     </div>
#     <div style="display: flex; justify-content: space-around;">
#       <div>
#         <button id="btnOK" type="button" class="btn action-button btn-success shiny-bound-input">Cambiar</button>
#       </div>
#       <div>
#         <button id="btnKO" type="button" class="btn action-button btn-danger shiny-bound-input">Cerrar</button>
#       </div>
#     </div>
#   </div></div>
#       </div>