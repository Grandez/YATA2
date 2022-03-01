if (typeof jQuery === "undefined") { throw new Error("YATA requires jQuery"); }
// En general, si el parametro es data
// Viene de shinyjs en un array; es decir, el objeto es data[0]

$.yata = {
    page: undefined
   ,panels: new Map()
   ,options: {
       leftSideTag: "[data-toggle='yataoffcanvas']"
      ,menuTag:     "[data-toggle='tab']"
   }
   ,init: function() {
      $(document).on('click', this.options.leftSideTag, {yata: this}, this._listenerSidebarLeft);
      $(document).on('click', this.options.menuTag,     {yata: this}, this._listenerMenuTabs);
      this._listenerLayout();
   }
   ,layout: function() {
       var _this = this;
       _this.fix();
       _this.fixSidebar();
       $('body, html, .wrapper').css('height', 'auto');
       $(window, ".wrapper").resize(function () {
              _this.fix();
              _this.fixSidebar();
         });
  }
   ,addPage: function(data) {
     //CHECKED
     nfo = data[0];
     res = this.panels.get(nfo.id);
     if (res === undefined) {
         this.panels.set(nfo.id, nfo);
         this.setPage(data);
     }
  }
   ,setPage: function (data) {
      // Activa la pagina actual
      // Se ejecuta antes de addPage. Controlamos que no este todavia
      let name = data[0].name;
      let p = this.panels.get(data[0].name);
      if (p === undefined) return;
      if (this.page !== undefined) this.panels.set(this.page.id, this.page);
      this.page = p;
      this._checkSidebars();
  }
   ,sidebarLeft: function(evt) {
       // Se ha hecho click en el menu de abrir/cerrar panel
       // Icono del panel lateral clickado
       let page = evt.data.yata.page.id;

       // Se ha activado la pagina antes de insertarla
       if (this.page.left === undefined) this.page = this.panels.get(page);
       if (page === null) return;
       // Cuando son hijos
       page = page.split('-');
       page = page[0];
       let id = "#" + page + "-container_left";
       if ($(id).hasClass('yata_side_closed')) {
           $(id).removeClass('yata_side_closed').trigger('expanded.pushMenu');
           $("#left_side_closed").addClass("yata_side_closed");
           $("#left_side_open").removeClass("yata_side_closed");
           this.page.left = 1; // Open
       } else {
           $(id).addClass('yata_side_closed').trigger('collapsed.pushMenu');
           $("#left_side_closed").removeClass("yata_side_closed");
           $("#left_side_open").addClass("yata_side_closed");
           this.page.left = -1; // Closed
       }

  }
  ,shinyUpdateLayout: function (data) {
    //CHECKED
   alert("yataUpdataeLayout: \n" + data);
   let id = data[0];
   let tgt = data[1];

//      let id = event.currentTarget.id;
//      let tgt = event.target.value;

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
         this._moveChildren(from, to);
     }
     if (tgt != "none") {
         let parent = document.getElementById(id.replace("cboLayout", "block"));
         let child  = document.getElementById(panel + "-" + tgt);
         this._moveChildren(parent, blocks);
         parent.appendChild(child);
     }
     let nfo = id.split("_");
     let evt = {"value": id, "row": nfo[nfo.length - 2], "col":nfo[nfo.length - 1]};
     Shiny.setInputValue(panel + "-layout", evt);
  }
  ,layoutChanged:function (event) {
      this.shinyUpdateLayout([event.currentTarget.id, event.target.value]);
   }
  ,layoutNotify: function (evt) {
    //CHECKED
      toks = evt.target.id.split("_");
      let data = {"value": evt.target.value, "row": toks[1]};
      if (toks.length > 2) {
          data.col = toks[2];
          if (toks.length > 3) data.colZ = toks[3];
      }
      Shiny.setInputValue(toks[0], data);

   }
   ,_listenerMenuTabs: function (evt) {
      //Checked: Crea el listener para los tabs
      evt.preventDefault();
      evt.data.yata.page = evt.target.dataset.value;
      // Obtener la info del panel
      //JGG                 var pnl = $.YATA.panels.get(e.target.dataset.value);
  }
   ,_listenerSidebarLeft: function(evt) {
      evt.preventDefault();
      $.yata.sidebarLeft(evt);
  }

   ,_listenerLayout: function () {
       // Aqui añade el listener a los combos del layout
       let elements = document.getElementsByClassName("yata_layout");
       Array.from(elements).forEach(function(element) {
             element.addEventListener('change', function (event) { $.yata.layoutChanged(event) });
       });
       elements = document.getElementsByClassName("yata_layout_notify");
       Array.from(elements).forEach(function(element) {
             element.addEventListener('change', function (event) { $.yata.layoutNotify(event) });
       });
  }
  /*
     La pagina es del modo mod1-mod2- ... - modn
     La raiz esta en el padre y es raiz-container_left
     Vamos recorriendo cada hijo
        si padre.son == hijo no se hace nada
        si no                se quita hijo (salvo null) hijo-left a hijo-container_left
        insertar panel y actualizar padre hijo-left a root-container_left
  */
   ,_checkSidebars: function() {
      if (this.page.left == 0) {
          $("#left_side").addClass("yata_side_none");
      } else {
         $("#left_side").removeClass("yata_side_none");
         this._checkSidebar("left");
      }
      if (this.page.right == 0) {
          $("#right_side").addClass("yata_side_none");
      } else {
         $("#right_side").removeClass("yata_side_none");
         this._checkSidebar("right");
      }
   }
   ,_checkSidebar: function (sfx) {
      let toks = this.page.id.split("-");
      let root = toks[0];
      if (toks.length == 1) return; // Es pagina raiz
      let base = toks[0];
      let prev = this.panels.get(base);

      for (var i = 1; i < toks.length; i++) {
        base = base + "-" + toks[i];
        if (prev.son == base) continue;
        if (prev.son != base && prev.son !== null) {
          this._movePanel(prev.son + "-" + sfx,  prev.son + "-container_" + sfx);
        }
        prev.son = base;
        this.panels.set(prev.id, prev);
        this._movePanel(prev.son + "-" + sfx,  root + "-container_" + sfx);
        prev = this.panels.get(base);
      }
  }
   ,_movePanel: function (from, to) {
      const source = document.getElementById(from);
      if (source !== undefined && source !== null) {
          const target = document.getElementById(to);
          // append as last
          target.appendChild(source);
      }
    }
   ,_moveChildren: function(from, to) {
   //CHECKED
   let   childs   = from.children;
   for (let i = 0; i < childs.length; i++) {
        let hijo =  document.getElementById(childs[i].id);
        to.appendChild(hijo);
    }
}

}; // END yata

/* *****************************************
 * Funciones extendiendo shinyjs
 * ****************************************/
/*
function yataUpdateLayout(data) {
  //CHECKED
   alert("yataUpdataeLayout: \n" + data);
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
       this._moveChildren(from, to);
   }
   if (tgt != "none") {
       let parent = document.getElementById(id.replace("cboLayout", "block"));
       let child  = document.getElementById(panel + "-" + tgt);
       this._moveChildren(parent, blocks);
       parent.appendChild(child);
   }
   let nfo = id.split("_");
   let evt = {"value": id, "row": nfo[nfo.length - 2], "col":nfo[nfo.length - 1]};
   Shiny.setInputValue(panel + "-layout", evt);
}
*/

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

// ////////////////////////////////////////
//  Eventos Shiny
 // ////////////////////////////////////////

function yataTableclick (rowInfo, colInfo, evt, tgt) {
  //CHECKED
  /* Botones en reactable

    window.alert('YATATableClick Details for click: \\n Fila: ' + colInfo.index + '\\n' + "boton: " + colInfo.id);
                                   //if (colInfo.id !== 'details') { return }
*/                         window.alert('Details: row ' + rowInfo.index + 'col: ' + colInfo.id);
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

function yataUpdateLayout(data) {
  //CHECKED
   //alert("yataUpdataeLayout: \n" + data);
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
       _yataMoveChildren(from, to);
   }
   if (tgt != "none") {
       let parent = document.getElementById(id.replace("cboLayout", "block"));
       let child  = document.getElementById(panel + "-" + tgt);
       _yataMoveChildren(parent, blocks);
       parent.appendChild(child);
   }
   let nfo = id.split("_");
   let evt = {"value": id, "row": nfo[nfo.length - 2], "col":nfo[nfo.length - 1]};
   Shiny.setInputValue(panel + "-layout", evt);
}
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
function yatabtnClickable(event) {
  alert("yatashiny yatabtnClickable");
  alert("Click en el menu " + event.target.id);
  /*
  id = event.target.id;
  if (id == tabActive) return;
  var tag = "#";
  */
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

jQuery(document).on('shiny:connected', function(event) {
  Shiny.setInputValue("connected", new Date(), { priority: 'event' });
});

jQuery(document).on('shiny:sessioninitialized', function(event) {
  Shiny.setInputValue("initialized", new Date(), { priority: 'event' });
});

jQuery(document).on('shiny:disconnected', function(event) {
  Shiny.setInputValue("disconnected", new Date(), { priority: 'event' });
});

