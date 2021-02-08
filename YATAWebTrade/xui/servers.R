panel1server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
          output$plot <- renderPlot({
                        plot(cars, type=input$plotType)
          })
    })
}
panel2server <- function(id) {
  moduleServer(id,  function(input, output, session) {
       output$summary <- renderPrint({
       summary(cars)
       })
  })
}

panel3server <- function(id) {
  moduleServer(id,  function(input, output, session) {

  output$table <- DT::renderDataTable({
    DT::datatable(cars)
  })
  })
}

panel4server <- function(id) {
  moduleServer(id,  function(input, output, session) {

  })
}
panel5server <- function(id) {
  moduleServer(id,  function(input, output, session) {
      observeEvent(input$chkGroup, {
          browser()
          output$value <- renderPrint({ input$chkGroup })
      })
  })
}
      