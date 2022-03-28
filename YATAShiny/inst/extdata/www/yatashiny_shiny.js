/*  Functions to integrate en shiny */
/* Arguments are passed as array    */

// Se llama cuando la aplicacion es inicializada
shinyjs.init = function(id) {
  Cookies.set('window_width',  window.innerWidth,  { SameSite: "Strict"});
  Cookies.set('window_height', window.innerHeight, { SameSite: "Strict"});
};

shinyjs.yata_set_page    = function(name) { yatashiny.set_page(name); }; // Pagina activa
shinyjs.yata_add_page    = function(name) { yatashiny.add_page(name); }; // Pagina cargada
shinyjs.yata_set_layout  = function(id)   { yatashiny.layout_set(id); }; // Hace layout
shinyjs.request_cookies = function()     { yatashiny.send_cookies(); }; // Envia las cookies
