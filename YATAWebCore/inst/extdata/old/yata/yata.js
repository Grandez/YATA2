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
//    window.alert('Details for click: \\n Fila: ' + colInfo.index + '\\n' + "boton: " + colInfo.id//);
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

function yataTabClose(event) {
    Shiny.setInputValue(event.id, { id: event.id}, { priority: 'event' });
}

