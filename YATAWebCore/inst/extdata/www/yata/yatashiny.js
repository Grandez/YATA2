/*  Functions to integrate en shiny */

function yata_show_block (data) { yata.show_block(data); }

shinyjs.yata_layout = function (data) { yata.layout_update(data); }

// ////////////////////////////////////////
//  Eventos Shiny
 // ////////////////////////////////////////
/*
function yataTableclick (rowInfo, colInfo, evt, tgt) {
  //CHECKED
*/
  /* Botones en reactable

    window.alert('YATATableClick Details for click: \\n Fila: ' + colInfo.index + '\\n' + "boton: " + colInfo.id);
                                   //if (colInfo.id !== 'details') { return }
*/
//window.alert('Details: row ' + rowInfo.index + 'col: ' +
/*
colInfo.id);
     if (window.Shiny) {
         Shiny.setInputValue(evt, { row: rowInfo.index + 1
                                   ,colName: colInfo.id
                                   ,target: tgt
                                  }, { priority: 'event' });
     }
}

///////////////////////////////////////////////////////////////////////////////////////////
function setTile() {
alert("setTile");
}
function listenerTabClosable() {
  alert("yatashiny listenerTabClosable");
  var elements = document.getElementsByClassName("yata_tab_closable");
  Array.from(elements).forEach(function(element) {
      element.addEventListener('click', function (event) { yataTabClose(event) });
    });
}


/////////////////////////////////////////////

function yataLayoutChanged(event) {
   $.yata.shinyUpdateLayout([event.currentTarget.id, event.target.value]);
}
function yataShowBlock(data) {
    // Pone y quita bloques
    var idParent    = data.ns + "-block_" + data.row;
    if (data.col !== 0) idParent = idParent + "_" + data.col;
    const parent = document.getElementById(idParent);
    const child  = document.getElementById(data.ns + "-" + data.block);
    const blocks = document.getElementById(data.ns + "-blocks");
    var childs   = parent.children;

    if (data.block == "none") {
        parent.style.display = "none";
    } else {
        parent.appendChild(child);
        parent.style.display = "";
        for (var i = 0; i < childs.length - 1; i++) {
             const hijo =  document.getElementById(childs[i].id);
             blocks.appendChild(hijo);
        }
    }
}
function yataMovePanel(data) {
   // Pone y quita bloques
   //alert("MovePanel");
   const source = document.getElementById(data.from);
   const target = document.getElementById(data.to);
   target.appendChild(source);
}

// ////////////////////////////////////////
//  Eventos Shiny
 // ////////////////////////////////////////

function yataTableclick (rowInfo, colInfo, evt, tgt) {
  //CHECKED
  // Botones en reactable

//    window.alert('Details for click: \\n Fila: ' + colInfo.index + '\\n' + "boton: " + colInfo.id//);
                                   //if (colInfo.id !== 'details') { return }
//                         window.alert('Details: row ' + rowInfo.index + 'col: ' + colInfo.id);
//     if (window.Shiny) {
         Shiny.setInputValue(evt, { row: rowInfo.index + 1, colName: colInfo.id, target: tgt
                                 }, { priority: 'event' });
//     }
}

///////////////////////////////////////////////////////////////////////////////////////////

function listenerButtonInTable(mode) {
  alert("yatashiny listenerButtonInTable");
  // Aqui añade el listener a la clase de los botones
  var elements = document.getElementsByClassName("yataBtnClickable");
  Array.from(elements).forEach(function(element) {
      element.addEventListener('click', function (event) { yatabtnClickable(event) });
    });
}
*/
/*
function listenerLayout() {
  alert("yatashiny listenerLayout");
//  alert("Entro en creador de listener");
  // Aqui añade el listener a la clase de los botones
  var elements = document.getElementsByClassName("yata_layout");
  Array.from(elements).forEach(function(element) {
      element.addEventListener('change', function (event) { yataLayoutChanged(event) });
    });
}
*/
/*
function yatabtnClickable(event) {
  alert("yatashiny yatabtnClickable");
  alert("Click en el menu " + event.target.id);
}

function _yataMoveChildren(from, to) {
   //CHECKED
   // Called from yataUpdateLayout
   let   childs   = from.children;
   for (let i = 0; i < childs.length; i++) {
        let hijo =  document.getElementById(childs[i].id);
        to.appendChild(hijo);
    }
}

function yataTabClose(event) {
  alert("yatashiny yataTabClose");
    Shiny.setInputValue(event.id, { id: event.id}, { priority: 'event' });
}


// Funcion que se ejecuta on document.ready
jQuery(document).ready(function() {
  //CHECKED alert( "JQuery Documento listo" );
	$.yata.init();
});
*/
/*
jQuery(document).on('shiny:connected', function(event) {
    alert("Connected");
  Shiny.setInputValue("connected", new Date(), { priority: 'event' });
});

jQuery(document).on('shiny:sessioninitialized', function(event) {
    alert("sessioninitialized");
  Shiny.setInputValue("initialized", new Date(), { priority: 'event' });
});

jQuery(document).on('shiny:disconnected', function(event) {
    alert("disconnected");
  Shiny.setInputValue("disconnected", new Date(), { priority: 'event' });
});
*/
