/*  Functions to integrate en shiny */
/* Arguments are passed as array    */

// Se llama cuando la aplicacion es inicializada
shinyjs.init = function(id) {
  Cookies.set('window_width',  window.innerWidth,  { SameSite: "Strict"});
  Cookies.set('window_height', window.innerHeight, { SameSite: "Strict"});
};

shinyjs.jgg_set_page    = function(name) { jggshiny.set_page(name); }; // Pagina activa
shinyjs.jgg_add_page    = function(name) { jggshiny.add_page(name); }; // Pagina cargada
shinyjs.jgg_set_layout  = function(id)   { jggshiny.layout_set(id); }; // Hace layout
shinyjs.request_cookies = function()     { jggshiny.send_cookies(); }; // Envia las cookies
