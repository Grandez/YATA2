// Shiny.setInputValue('testing', "This is a test");

function setTile() {

}
function listenerButtonInTable(mode) {
  // Aqui añade el listener a la clase de los botones
  var elements = document.getElementsByClassName("yataBtnClickable");
  Array.from(elements).forEach(function(element) {
      element.addEventListener('click', function (event) { yatabtnClickable(event) });
    });
}

function yatabtnClickable(event) {
  alert("Click en el menu " + event.target.id);
  /*
  id = event.target.id;
  if (id == tabActive) return;
  var tag = "#";
  */
}
/*
var tabActive = null;

function changePage(old, act) {
  // Oculta la pagina old y muestra la act


  if (act !== null) {
     tab = mapTabs.get(act);
     if (tab.left  !== 0) $(tag.concat(id, "-left") ).show();
     if (tab.right !== 0) $(tag.concat(id, "-right")).show();
     if (tab.main  !== 0) $(tag.concat(id, "-main") ).show();

  }
}
function mnuClick(event) {
  // alert("Click en el menu " + event.target.id);
  id = event.target.id;
  if (id == tabActive) return;
  var tag = "#";
  if (tabActive !== null) {
     $(tag.concat(tabActive, "-left") ).hide();
     $(tag.concat(tabActive, "-right")).hide();
     $(tag.concat(tabActive, "-main") ).hide();
  }

  $(tag.concat(id, "-left") ).show();
  $(tag.concat(id, "-right")).show();
  $(tag.concat(id, "-main") ).show();

  tabActive = id;
  Shiny.onInputChange("mainbar", id);
}

function btnLeft_click() {
  $("#yataLeftSide").toggleClass("yataCollapsed yataExpanded");
}
*/
// Funcion que se ejecuta on document.ready
$(function() {
    console.log( "Ha ocurrido document.ready: documento listo" );
    Shiny.addCustomMessageHandler('buttonInTable', listenerButtonInTable);
    Shiny.addCustomMessageHandler('setTitle', function(text) {document.title = "YATA - " + text;});

    /*
        document.body.style.backgroundColor = color;
        document.body.innerText = color;
      });
    yataMenu.addEventListener("click", function (event) { mnuClick(event) } );
    Shiny.addCustomMessageHandler("showModal",   function(message) {$("#yataModal").toggle();});
    Shiny.addCustomMessageHandler("hideModal",   function(message) {$("#yataModal").toggle();});
    Shiny.addCustomMessageHandler("toggleModal", function(message) {$("#yataModal").toggle();});
    initDOM(); // Inline al pie del documento
    // Controlar si hay seleccionada una pagina
    if (tabActive !== null) document.getElementById(tabActive).click();
    */
  });

            /* PushMenu()
            * ==========
              * Adds the push menu functionality to the sidebar.
            *
              * @type Function
            * @usage: $.AdminLTE.pushMenu("[data-toggle='offcanvas']")
            */
            /*
              $.AdminLTE.pushMenu = {
                activate: function (toggleBtn) {
                  //Get the screen sizes
                  var screenSizes = $.AdminLTE.options.screenSizes;

                  //Enable sidebar toggle
                  $(document).on('click', toggleBtn, function (e) {
                    e.preventDefault();

                    //Enable sidebar push menu
                    if ($(window).width() > (screenSizes.sm - 1)) {
                      if ($("body").hasClass('sidebar-collapse')) {
                        $("body").removeClass('sidebar-collapse').trigger('expanded.pushMenu');
                      } else {
                        $("body").addClass('sidebar-collapse').trigger('collapsed.pushMenu');
                      }
                    }
                    //Handle sidebar push menu for small screens
                    else {
                      if ($("body").hasClass('sidebar-open')) {
                        $("body").removeClass('sidebar-open').removeClass('sidebar-collapse').trigger('collapsed.pushMenu');
                      } else {
                        $("body").addClass('sidebar-open').trigger('expanded.pushMenu');
                      }
                    }
                  });
*/
