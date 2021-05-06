// Shiny.setInputValue('testing', "This is a test");

function setTile() {

}
function listenerTabClosable() {
  var elements = document.getElementsByClassName("yata_tab_closable");
  Array.from(elements).forEach(function(element) {
      element.addEventListener('click', function (event) { yataTabClose(event) });
    });
}

function listenerButtonInTable(mode) {
  // Aqui añade el listener a la clase de los botones
  var elements = document.getElementsByClassName("yataBtnClickable");
  Array.from(elements).forEach(function(element) {
      element.addEventListener('click', function (event) { yatabtnClickable(event) });
    });
}

function listenerLayout() {
//  alert("Entro en creador de listener");
  // Aqui añade el listener a la clase de los botones
  var elements = document.getElementsByClassName("yata_layout");
  Array.from(elements).forEach(function(element) {
      element.addEventListener('change', function (event) { yataLayoutChanged(event) });
    });
}

function yataTableclick (rowInfo, colInfo, evt, tgt) {
//    window.alert('Details for click: \\n Fila: ' + colInfo.index + '\\n' + "boton: " + colInfo.id);
                                   //if (colInfo.id !== 'details') { return }
//                         window.alert('Details: row ' + rowInfo.index + 'col: ' + colInfo.id);
     if (window.Shiny) {
         Shiny.setInputValue(evt, { row: rowInfo.index + 1, colName: colInfo.id, target: tgt
                                 }, { priority: 'event' });
     }
}
function yatabtnClickable(event) {
  alert("Click en el menu " + event.target.id);
  /*
  id = event.target.id;
  if (id == tabActive) return;
  var tag = "#";
  */
}

function yataMoveChildren(from, to) {
   let   childs   = from.children;
   for (let i = 0; i < childs.length; i++) {
        let hijo =  document.getElementById(childs[i].id);
        to.appendChild(hijo);
    }
}

function yataUpdateLayout(data) {
//JGG   alert("yataUpdataeLayout: \n" + data);
   let id = data[0];
   let tgt = data[1];
   let idParent = id.replace("cboLayout", "block");
   let col = idParent[idParent.length - 1];

   let toks = id.split("-");
   let item = toks.pop();
   const panel = toks.join("-");

   let pat = idParent.substr(0, idParent.length - 1);
   let diva = document.getElementById(pat + "a");
   let divb = document.getElementById(pat + "b");
   let div1 = document.getElementById(pat + "1");
   let div2 = document.getElementById(pat + "2");
   let blocks = document.getElementById(panel + "-blocks");

   diva.style.display = (tgt == "none") ? ""     : "none";
   divb.style.display = (tgt == "none") ? "none" : "";

   if (tgt == "none" || diva.children.length > 0) {
       let div  = (col == "1")    ? div2 : div1;
       let from = (tgt == "none") ? div  : diva;
       let to   = (tgt == "none") ? diva : div;
       yataMoveChildren(from, to);
   }
   if (tgt != "none") {
       let parent = document.getElementById(id.replace("cboLayout", "block"));
       let child  = document.getElementById(panel + "-" + tgt);
       yataMoveChildren(parent, blocks);
       parent.appendChild(child);
   }
   let nfo = id.split("_");
//   let evt = {"value": "JGG", "row": nfo[nfo.length - 2], "col":nfo[nfo.length - 1]};
   let evt = {"value": id, "row": nfo[nfo.length - 2], "col":nfo[nfo.length - 1]};
   Shiny.setInputValue(panel + "-layout", evt);
}
function yataLayoutChanged(event) {
   yataUpdateLayout([event.currentTarget.id, event.target.value]);
}
function yataTabClose(event) {
    Shiny.setInputValue(event.id, { id: event.id}, { priority: 'event' });
}

/*

*/
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
    listenerLayout();
    listenerTabClosable();
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
