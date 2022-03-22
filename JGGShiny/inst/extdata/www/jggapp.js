if (typeof jQuery === "undefined") { throw new Error("jQuery is required"); }

class JGGShiny {
   #page; // : undefined  // Active page
   #panels; // : new Map()
   #leftSideIcon =  "[data-toggle='jgg_left_button']";
   #rightSideIcon = "[data-toggle='jgg_right_button']";
   #menuTag       = "[data-toggle='tab']";
   #app
   constructor(app)  {
      this.#page   = undefined;
      this.#panels = new Map();
      this.#app    = app;
   }
   init(title, id)    {
       jQuery("#app_title").text(title);
       jQuery(document).on('click', this.#leftSideIcon,  {jggshiny: this}, jggshiny.sidebarLeft);
       jQuery(document).on('click', this.#rightSideIcon, {jggshiny: this}, jggshiny.sidebarRight);
       this.#add_listeners();
   }
   send_cookies() {
      let res = Cookies.get();
      Shiny.setInputValue('cookies', res);
   }
   window_resize(evt) {
      Cookies.set('window_width',  window.innerWidth,  { SameSite: "Strict"});
      Cookies.set('window_height', window.innerHeight, { SameSite: "Strict"});
      Shiny.setInputValue('resize', Cookies.get());

   }
   set_page(data) {
       /* Called from shinyjs, data is an array */
//       alert("SET PAGE " + data[0]);
       this.#page = this.#panels.get(data[0]);
       if (this.#page  === undefined) return;
       this.#setSideIcons(this.#page.left,  "left");
       this.#setSideIcons(this.#page.right, "right");
    }
   add_page(data) {
       // Called from shinyjs, data is an array
       // Inserta la pagina en el map de paginas
       // Busca los id -left y -right para marcarlos y moverlos
       const name = data[0];
//       alert("ADD PAGE " + name);
       const res = this.#panels.get(name);
       if (res !== undefined) return;

       let panel = {
            name:  name
           ,left:  0  // 0 - No hay, 1 - Open, -1 - Closed
           ,right: 0
       };
       let divBase = "#" + name + "_container";
       let div = divBase + "_left";
       let obj = jQuery(div);
       if (obj.length > 0) panel.left = -1;
       div = divBase + "_right";
       obj = jQuery(div);
       if (obj.length > 0) panel.right = -1;
       this.#panels.set(name, panel);
       // this.set_page(name);
  }
   update_page(page) {
      this.#page = page;
      this.#panels.set(page.name, page);
   }
   mainmenu_click(evt) {
       alert("mainmenu");
   }
   sidebarLeft (evt) {
      // Se ha hecho click en el menu de abrir/cerrar panel
      // Icono del panel lateral clickado
      // No se por que, pero no hace el this
      let page = jggshiny.#page;
      if (page === undefined) return; // Se ha activado antes de insertarla

       // Botones
       let id = "#jgg_left_side";
       if (page.left == 0) {
           jQuery(id).addClass('jgg_side_hide');
           return;
       }
       jQuery(id).removeClass('jgg_side_hide');

       if (page.left == -1) {
           jQuery("#jgg_left_side_close").removeClass('jgg_button_side_hide');
           jQuery("#jgg_left_side_open").addClass    ('jgg_button_side_hide');
           page.left = 1; // Open
       } else {
//           jQuery(id).addClass('jgg_side_closed').trigger('collapsed.pushMenu');
           jQuery("#jgg_left_side_close").addClass  ('jgg_button_side_hide');
           jQuery("#jgg_left_side_open").removeClass('jgg_button_side_hide');
           page.left = -1; // Closed
       }

       id = "#" + page.name + "_container_left";
       if (page.left == 1) {
           $(id).removeClass('jgg_side_hide').trigger('expanded.pushMenu');
       } else {
           $(id).addClass('jgg_side_hide').trigger('collapsed.pushMenu');
       }
       jggshiny.update_page(page);
   }
   sidebarRight(evt) {
//       alert(evt.data.jgg);
       if (evt.data.jgg.page === undefined) return;

       // Se ha hecho click en el menu de abrir/cerrar panel
       // Icono del panel lateral clickado
       let page = evt.data.yata.page.id;

       // Se ha activado la pagina antes de insertarla
       if (this.#page.right === undefined) this.#page = this.#panels.get(page);
       if (page === null) return;
       // Cuando son hijos
       page = page.split('-');
       page = page[0];
       let id = "#" + page + "-container_right";
       if (jQuery(id).hasClass('yata_side_closed')) {
           jQuery(id).removeClass('yata_side_closed').trigger('expanded.pushMenu');
           jQuery("#right_side_closed").addClass("yata_side_closed");
           jQuery("#right_side_open").removeClass("yata_side_closed");
           this.page.right = 1; // Open
       } else {
           jQuery(id).addClass('yata_side_closed').trigger('collapsed.pushMenu');
           jQuery("#left_side_closed").removeClass("yata_side_closed");
           jQuery("#left_side_open").addClass("yata_side_closed");
           this.page.left = -1; // Closed
       }

  }
   layout_update_event(event) {
       this.layout_update([event.target.id, event.target.value]);
   }
   layout_notify_event(evt) {
       this.layout_notify([event.target.id, event.target.value]);
   }
   layout_set(ns) {
       // Establece el layout inicial
       let cbo = undefined;
       let id  = undefined;

       for (var i = 1; i < 3; i++) {
           for (var j = 1; j < 3; j++) {
               id = ns[0] + "-cbolayout_" + i + "_" + j;
               cbo = document.getElementById(id);
               this.layout_update([id, cbo.selectedOptions[0].value]);
           }
       }
   }
   layout_update(data) {
       /*
          layout_changed(event) {
       //NOT CHECKED
      alert('layout changed');
      this.shiny_update_layout([event.currentTarget.id, event.target.value]);
   }
*/
      let   id    = data[0];
      let   obj   = data[1];
      let   toks  = id.split("-");
      let   item  = toks.pop();
      const ns    = toks.join("-");

      item = item.split("_");  // name - fila - columna

      let panels = [];
      let cbo = undefined;
      for (var i = 1; i < 3; i++) {
           for (var j = 1; j < 3; j++) {
               id = ns + "-cbolayout_" + i + "_" + j;
               cbo = document.getElementById(id);
               panels.push(cbo.selectedOptions[0].value);
           }
       }
       // Ajusta la visibilidad de los paneles
       this.#set_blocks_layout(ns, panels);

      // Identifica el panel destino
      let tgt = "#" + ns + "-blocks_2x" + item[1] + "x2";
      if ($(tgt).hasClass("jgg_block_hide")) {
          tgt = "#" + ns + "-blocks_2x" + item[1] + "x1";
          if ($(tgt).hasClass("jgg_block_hide")) {
              tgt = $("#" + ns + "-blocks_1");
          }
      } else {
          tgt = "#" + ns + "-blocks_2x" + item[1] + "x2x" + item[2];
      }

      // Si hay cosas al container
      let container = "#" + ns + "-blocks_container";
      let   childs   = $(tgt).children();
      for (let i = 0; i < childs.length; i++) {
            $(container).append(document.getElementById(childs[i].id));
       }
       $(tgt).append(document.getElementById(ns + "-" + obj));

       // Caso especial plots con plotly
       // NO FUNCIONA
       // if (obj.startsWith("plot")) {
       //   let w = $(tgt).width();
       //       let plt = $(tgt).children(0).children(0).children(0);
       //       plt.width(w + "px");
       // }

/*
      let nfo = id.split("_");
      let evt = {"value": id, "row": nfo[nfo.length - 2], "col":nfo[nfo.length - 1]};
      Shiny.setInputValue(panel + "-layout", evt);
      */
   }
   layout_notify(data) {
           //NOT CHECKED
      //toks = evt.target.id.split("_");
      //let data = {"value": evt.target.value, "row": toks[1]};
      //if (toks.length > 2) {
      //      data.col = toks[2];
      //  if (toks.length > 3) data.colZ = toks[3];
      // }
      // Shiny.setInputValue(toks[0], data);

   }

   // ///////////////////////////////////////////////////////////////////
   // PRIVATE MEMBERS
   // ///////////////////////////////////////////////////////////////////

   #moveLayout(from, to) {
      let   childs   = from.children;
      for (let i = 0; i < childs.length; i++) {
           let hijo =  document.getElementById(childs[i].id);
            to.appendChild(hijo);
       }
   }
   #add_listeners() {
      window.addEventListener('resize', jggshiny.window_resize );

      // Listener a los combos del layout
      let elements = document.getElementsByClassName("jgg_layout");
      Array.from(elements).forEach(function(element) {
            element.addEventListener('change', function (event) { jggshiny.layout_update_event(event) });
      });
      elements = document.getElementsByClassName("jgg_layout_notify");
      Array.from(elements).forEach(function(element) {
            element.addEventListener('change', function (event) { jggshiny.layout_notify_event(event) });
      });
   }
   #setSideIcons(value, side) {
       let id = "#jgg_" + side + "_side";
       if (value == 0) jQuery(id).addClass('jgg_button_side_hide');
       if (value != 0) jQuery(id).removeClass('jgg_button_side_hide');

        const idOpen  = id + "_open"
        const idClose = id + "_close"
        if (value == 1) { // Is open
            jQuery(idClose).removeClass("jgg_button_side_hide");
            jQuery(idOpen).addClass    ("jgg_button_side_hide");
        }
        if (value == -1) {
            jQuery(idOpen).removeClass("jgg_button_side_hide");
            jQuery(idClose).addClass  ("jgg_button_side_hide");
        }
   }
    #set_blocks_layout(ns, panels) {
       let ids = [0, 0, 0];
       for (var i = 0; i < 4; i++) {
           if (panels[i] == "none") continue;
           ids[0]++;
           if (i < 2) ids[1]++;  else ids[2]++;
       }

       switch (ids[0]) {
           case 0: $("#" + ns + "-blocks_1").addClass   ("jgg_block_hide");
                   $("#" + ns + "-blocks_2x1x1").addClass   ("jgg_block_hide");
                   $("#" + ns + "-blocks_2x1x2").addClass   ("jgg_block_hide");
                   $("#" + ns + "-blocks_2x2x1").addClass   ("jgg_block_hide");
                   $("#" + ns + "-blocks_2x2x2").addClass   ("jgg_block_hide");
                   break;
           case 1: $("#" + ns + "-blocks_1").removeClass   ("jgg_block_hide");
                   $("#" + ns + "-blocks_2x1x1").addClass   ("jgg_block_hide");
                   $("#" + ns + "-blocks_2x1x2").addClass   ("jgg_block_hide");
                   $("#" + ns + "-blocks_2x2x1").addClass   ("jgg_block_hide");
                   $("#" + ns + "-blocks_2x2x2").addClass   ("jgg_block_hide");
                   break;
           case 2: switch (ids[1]) {
               case 0: $("#" + ns + "-blocks_2x1x1").addClass   ("jgg_block_hide");
                       $("#" + ns + "-blocks_2x1x2").addClass   ("jgg_block_hide");
                       $("#" + ns + "-blocks_2x2x1").addClass   ("jgg_block_hide");
                       $("#" + ns + "-blocks_2x2x2").removeClass   ("jgg_block_hide");
                       break;
               case 1: $("#" + ns + "-blocks_2x1x1").removeClass("jgg_block_hide");
                       $("#" + ns + "-blocks_2x1x2").addClass   ("jgg_block_hide");
                       $("#" + ns + "-blocks_2x2x1").removeClass   ("jgg_block_hide");
                       $("#" + ns + "-blocks_2x2x2").addClass   ("jgg_block_hide");
                       break;
               case 2: $("#" + ns + "-blocks_2x1x1").addClass("jgg_block_hide");
                       $("#" + ns + "-blocks_2x1x2").removeClass   ("jgg_block_hide");
                       $("#" + ns + "-blocks_2x2x1").addClass   ("jgg_block_hide");
                       $("#" + ns + "-blocks_2x2x2").addClass   ("jgg_block_hide");
                       break;
               }
               break;
           case 3: switch (ids[1]) {
               case 1: $("#" + ns + "-blocks_2x1x1").removeClass("jgg_block_hide");
                       $("#" + ns + "-blocks_2x1x2").addClass   ("jgg_block_hide");
                       $("#" + ns + "-blocks_2x2x1").removeClass   ("jgg_block_hide");
                       $("#" + ns + "-blocks_2x2x2").addClass   ("jgg_block_hide");
                       break;
               case 2: $("#" + ns + "-blocks_2x1x1").addClass("jgg_block_hide");
                       $("#" + ns + "-blocks_2x1x2").removeClass   ("jgg_block_hide");
                       $("#" + ns + "-blocks_2x2x1").removeClass   ("jgg_block_hide");
                       $("#" + ns + "-blocks_2x2x2").addClass   ("jgg_block_hide");
                       break;
               }
               break;
           case 4: $("#" + ns + "-blocks_1").addClass   ("jgg_block_hide");
                   $("#" + ns + "-blocks_2x1x1").addClass   ("jgg_block_hide");
                   $("#" + ns + "-blocks_2x1x2").removeClass   ("jgg_block_hide");
                   $("#" + ns + "-blocks_2x2x1").addClass   ("jgg_block_hide");
                   $("#" + ns + "-blocks_2x2x2").removeClass   ("jgg_block_hide");
                   break;
       }
    }

}
