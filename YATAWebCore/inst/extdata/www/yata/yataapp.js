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
         this.page = nfo;
         this._checkSidebars();
     }
  }
   ,setPage: function (data) {
    //CHECKED
    // Se ejecuta antes de addPage. Controlamos que no este todavia
    // Activa la pagina actual
    let name = data[0].name;
    // Pendiente de ver si es util
//JGG_alert("JGG Activando Panel " + name);
    if (this.page !== undefined) this.panels.set(this.page.id, this.page);
    this.page = this.panels.get(name);
    if (this.page === undefined) this.page = {id: name, left: -1, right: -1};
    this._checkSidebars();
  }
   ,sidebarLeft: function(evt) {
       // Icono del panel lateral clickado
       let page = evt.data.yata.page.id;

       // Se ha activado la pagina antes de insertarla
       if (this.page.left === undefined) this.page = this.panels.get(page);
       if (page === null) return;
       // Cuando son hijos
       page = page.split('-');
       page = page[0];
       let id = "#" + page + "-container_left";
       if ($(id).hasClass('yata_leftside_closed')) {
           $(id).removeClass('yata_leftside_closed').trigger('expanded.pushMenu');
           $("#left_side_closed").addClass("yata_side_closed");
           $("#left_side_open").removeClass("yata_side_closed");
           this.page.left = 1; // Open
       } else {
           $(id).addClass('yata_leftside_closed').trigger('collapsed.pushMenu');
           $("#left_side_closed").removeClass("yata_side_closed");
           $("#left_side_open").addClass("yata_side_closed");
           this.page.left = -1; // Closed
       }

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
       //  alert("Entro en creador de listener");
       // Aqui añade el listener a la clase de los botones
       var elements = document.getElementsByClassName("yata_layout");
       Array.from(elements).forEach(function(element) {
             element.addEventListener('change', function (event) { yataLayoutChanged(event) });
       });
  }
   ,_checkSidebars: function () {
      this._checkSidebar(this.page.left,  "#left_side" );
      this._checkSidebar(this.page.right, "#right_side");
  }
   ,_checkSidebar: function (value, prfx) {
      if (value === undefined) return;
      //alert("Checking sidebars: " + value);
      switch (value) {
        case -1: // cerrado
             $(prfx).removeClass("yata_side_none");
             $(prfx + "_closed").removeClass("yata_side_closed");
             $(prfx + "_open").addClass("yata_side_closed");
             break;
        case  0: // No hay
             $(prfx).addClass("yata_side_none");
             break;
        case 1:
             $(prfx).removeClass("yata_side_noside");
             $(prfx + "_closed").addClass("yata_side_closed");
             $(prfx + "_open").removeClass("yata_side_closed");
      }
  }

}; // END yata

/*
  $.YATA = {
     page: null
    ,panels: new Map()
  };

    $.YATA.options = {
      navbarMenuSlimscroll: true,
      navbarMenuSlimscrollWidth: "3px", //The width of the scroll bar
      navbarMenuHeight: "200px", //The height of the inner menu
      animationSpeed: 500,
      // sidebarToggleSelector: "[data-toggle='yataoffcanvas']",
      // sidebarPushMenu: true,
      // JGG Activate menu
      yataTraceMenu: true,
      yataTraceMenuSelector: "[data-toggle='tab']",
      sidebarSlimScroll: true,
      sidebarExpandOnHover: false,
      enableBoxRefresh: true,
      enableBSToppltip: true,
      BSTooltipSelector: "[data-toggle='tooltip']",
      enableFastclick: false,
      enableControlTreeView: true,
      enableControlSidebar: true,
      controlSidebarOptions: {
         toggleBtnSelector: "[data-toggle='control-sidebar']",
         selector: ".control-sidebar",
         slide: false
      },
      enableBoxWidget: true,
      boxWidgetOptions: {
         boxWidgetIcons: {
            collapse: 'fa-minus',
            open: 'fa-plus',
            remove: 'fa-times'
         },
         boxWidgetSelectors: {
            remove: '[data-widget="remove"]',
            collapse: '[data-widget="collapse"]'
         }
      }
    };

        $(function () {
          "use strict";

          //Fix for IE page transitions
          $("body").removeClass("hold-transition");

          //Extend options if external options exist
          if (typeof YATAOptions !== "undefined") {
            $.extend(true,
                     $.YATA.options,
                     YATAOptions);
          }

          //Easy access to options
          var o = $.YATA.options;

          //Set up the object
          _init();


        });

        function _init() {
          $.YATA.showBlock = function(data) {
            alert("showBlock de _init");
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
          };
          $.YATA.movePanel = function(data) {
            // Pone y quita bloques
//JGGALERT_alert("MovePanel");
            const source = document.getElementById(data.from);
            const target = document.getElementById(data.to);
            target.appendChild(source);
          };

}

*/
/* *****************************************
 * Funciones extendiendo shinyjs
 * ****************************************/

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
   yataUpdateLayout([event.currentTarget.id, event.target.value]);
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

function listenerButtonInTable(mode) {
  alert("yatashiny listenerButtonInTable");
  // Aqui añade el listener a la clase de los botones
  var elements = document.getElementsByClassName("yataBtnClickable");
  Array.from(elements).forEach(function(element) {
      element.addEventListener('click', function (event) { yatabtnClickable(event) });
    });
}

function listenerLayout() {
  alert("yatashiny listenerLayout");
//  alert("Entro en creador de listener");
  // Aqui añade el listener a la clase de los botones
  var elements = document.getElementsByClassName("yata_layout");
  Array.from(elements).forEach(function(element) {
      element.addEventListener('change', function (event) { yataLayoutChanged(event) });
    });
}

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
