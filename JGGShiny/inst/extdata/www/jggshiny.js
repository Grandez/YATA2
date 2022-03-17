/*  Functions to integrate en shiny */
/* Arguments are passed as array    */

// Se llama cuando la aplicacion es inicializada
shinyjs.init = function() {
  // $(document).keypress(function(e) { alert('Key pressed: ' + e.which); });
};

// Marca la pagina como activa
shinyjs.jgg_set_page = function(name) { jggshiny.set_page(name); };
// Pagina cargada
shinyjs.jgg_add_page = function(name) { jggshiny.add_page(name); };
