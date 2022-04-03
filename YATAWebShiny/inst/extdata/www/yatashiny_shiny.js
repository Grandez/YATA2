/*  Functions to integrate en shiny */
/* Arguments are passed as array    */

// Se llama cuando la aplicacion es inicializada
shinyjs.init = function(id) {
  Cookies.set('window_width',  window.innerWidth,  { SameSite: "Strict"});
  Cookies.set('window_height', window.innerHeight, { SameSite: "Strict"});

//  Shiny.addCustomMessageHandler('cookie_set',    function(msg) { yatashiny.cookies_set    (msg); })
//  Shiny.addCustomMessageHandler('cookie_delete', function(msg) { yatashiny.cookies_delete (msg); })
};

shinyjs.yata_set_page    = function(name) { yatashiny.set_page(name); }; // Pagina activa
shinyjs.yata_add_page    = function(name) { yatashiny.add_page(name); }; // Pagina cargada
shinyjs.yata_set_layout  = function(id)   { yatashiny.layout_set(id); }; // Hace layout
shinyjs.yata_req_cookies = function()     { yatashiny.cookies_send(); }; // Envia las cookies

$(document).on('shiny:connected', function(evt) { yatashiny.cookies_send(); })
