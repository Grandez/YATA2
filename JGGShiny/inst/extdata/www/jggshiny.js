/*  Functions to integrate en shiny */

// Se llama cuando la aplicacion es inicializada
shinyjs.init = function() {
  // $(document).keypress(function(e) { alert('Key pressed: ' + e.which); });
};

// Marca la pagina como activa
shinyjs.jgg_set_page = function(data) { $.jggshiny.set_page(data); };
