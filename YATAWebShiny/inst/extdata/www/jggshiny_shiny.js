/*  Functions to integrate en shiny */
/* Arguments are passed as array    */

// Se llama cuando la aplicacion es inicializada
shinyjs.init = function(id) {
//  Cookies.set('window_width',  window.innerWidth,  { SameSite: "Strict"});
//  Cookies.set('window_height', window.innerHeight, { SameSite: "Strict"});

Shiny.addCustomMessageHandler('leftside_close',  function(msg) { jggshiny.sidebar_left  (msg); })
Shiny.addCustomMessageHandler('rightside_close', function(msg) { jggshiny.sidebar_right (msg); })

//  Shiny.addCustomMessageHandler('cookie_set',    function(msg) { yatashiny.cookies_set    (msg); })
//  Shiny.addCustomMessageHandler('cookie_delete', function(msg) { yatashiny.cookies_delete (msg); })
};

shinyjs.jgg_set_page      = function(name) { jggshiny.set_page(name); }; // Pagina activa
shinyjs.jgg_add_page      = function(name) { jggshiny.add_page(name); }; // Pagina cargada
shinyjs.jgg_add_dash      = function(name) { jggshiny.add_dash(name); }; // Pagina cargada
shinyjs.jgg_set_layout    = function(id)   { jggshiny.layout_set(id); }; // Hace layout
shinyjs.jgg_req_cookies   = function()     { jggshiny.cookies_send(); }; // Envia las cookies

$(document).on('shiny:connected', function(evt) { jggshiny.cookies_send(); })
