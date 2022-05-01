if (typeof jQuery === "undefined") { throw new Error("jQuery is required"); }
class JGGLayout {
    base;
    id;
    root;
    loaded = false;
   #items = Array(5);
   #layout;
   #divRoot;
   constructor(base, id)  {
      this.base = base;
      this.id     = id;
      this.root = base + "-" + id;
      this.loaded = false;
      this.#divRoot = this.root.replace(/-/g, "_");
      this.init();
   }
   init() {
       console.log("layout init");

      this.#items[0] = "";
      let blocks = [];
      for (let i = 1; i < 5; i++) {
           this.#items[i] = document.getElementById(this.root + "-combo-" + i).value;
           blocks.push(this.#items[i]);
      }
      console.log("layout send " + this.id);
      Shiny.setInputValue(this.root, {type: "init", value: blocks}, {priority: "event"});
      console.log("layout sent " + this.id);
      this.#change_layout();
      this.loaded = true;
      console.log("layout init end");
   }
   changed (cbo) { // recibe namespace_layout_idx
      if (!this.loaded) this.init();

      let val = document.getElementById(this.root + "-combo-" + cbo).value;
      this.#items[cbo] = val;
       console.log("changed beg " + cbo);

       Shiny.setInputValue(this.root, {type: "changed", block: cbo, value: val},{priority: "event"});

       this.#change_layout();
       console.log("changed end " + cbo);
   }
   #change_layout() {
       let newLayout = this.#get_layout();
       this.#show_blocks(newLayout);
       let divs = this.#select_layout(newLayout)
       this.#set_items(divs);
   }
   #get_layout() { // Identifca el layout actual
     let lay = 0;
     let checks = [0, 0, 0];
     for (let idx = 1; idx < 5; idx++ ) {
         switch (this.#items[idx]) {
             case "rows": checks[0]++; break; // Rows
             case "cols": checks[2]++; break; // cols
             default:     checks[1]++; break; // values
         }
     }
     if (checks[1] == 1) return 10;
     if (checks[1] == 4) return 40;
     if (checks[1] == 3) {
         if (checks[0] > 0) { // 1 rows
             lay = 310;
             if (this.#items[1] != "rows" && this.#items[2] != "rows") lay++;
         } else { // 1 cols
             lay = 320;
             if (this.#items[1] != "cols" && this.#items[3] != "cols") lay++;
         }
         return lay;
     }
     // Hay dos items
     if (this.#is_tag(1) && this.#is_tag(2)) return 22;
     if (this.#is_tag(3) && this.#is_tag(4)) return 22;
     if (this.#items[1] == "rows" || this.#items[1] == "rows") return 21;
     return 22;
  }
   #select_layout(type) {
      let divs = [];
//      const type = this.#get_layout();
      if (type == 10) divs = ["full"];
      if (type == 40) divs = ["detail_1_1", "detail_1_2", "detail_2_1", "detail_2_2"];

      if (type == 310) divs = ["rows_1_0", "rows_2_1", "rows_2_2"];
      if (type == 311) divs = ["rows_1_1", "rows_1_2", "rows_2_0"];

      // Hay solo un cols
      if (type == 320) {
          if (items[1] == "cols") divs = ["cols_2_1", "cols_1_0", "cols_2_2"];
          else                    divs = ["cols_1_1", "cols_1_2", "cols_2_0"];
      }
      if (type == 321) {
          if (items[2] == "cols") divs = ["cols_2_1", "cols_2_2", "cols_2_0"];
          else                    divs = ["cols_1_1", "cols_2_0", "cols_1_2"];
      }

      // Hay dos rows o cols uno en cada fila/columna
      if (type == 21)  divs = ["rows_1_0", "rows_2_0"];
      if (type == 22)  {
          if (items[1] == "cols" || items[3] == "cols")
              divs = ["cols_2_0", "cols_1_0"];
          else {
              divs = ["cols_1_0", "cols_2_0"];
          }
      }
      return divs;
  }
   #set_items (divs) {
      let items = [];
      for (let i = 1; i < 5; i++) {
          if (this.#items[i] != "rows" && this.#items[i] != "cols") items.push(i);
      }
      for (let i = 0; i < divs.length; i++) {
          let tgt = document.getElementById(this.#divRoot + "_" + divs[i]);
          tgt.appendChild(document.getElementById(this.#divRoot + "_data_" + items[i]));
      }
  }
   #show_blocks (layout) {
      let block_layout;

      // Get container from ns-nslayout_container
      let idContainer = "#" + this.#divRoot + "_container";
      let container = document.querySelector(idContainer);

      const layouts = container.querySelectorAll('.jgg_layout_block_container');
      layouts.forEach(lay => { lay.style.display = 'none'; });

      switch (layout) {
        case 10:  block_layout = "full";   break;
        case 21:  block_layout = "rows";   break;
        case 22:  block_layout = "cols";   break;
        case 40:  block_layout = "detail"; break;
        case 310:
        case 311: block_layout = "rows";   break;
        case 320:
        case 321: block_layout = "cols";   break;
      }
      const block = this.#divRoot + "_" + block_layout;
      document.getElementById(block).style.display = "block";

      const clsHide = "jgg_layout_block_hidden";
      switch (layout) {
         case  10:  break;
         case  21:
         case  22:
              document.getElementById(block + "_0").style.display = "block";
              document.getElementById(block + "_1").style.display = "none";
              document.getElementById(block + "_2").style.display = "none";
              break;
        case  40:  break;
        case 310:
        case 320:
             document.getElementById(block + "_1_0").classList.remove(clsHide);
             document.getElementById(block + "_1_3").classList.add(clsHide);
             document.getElementById(block + "_2_0").classList.add(clsHide);
             document.getElementById(block + "_2_3").classList.remove(clsHide);

             break;
        case 311:
        case 321:
             document.getElementById(block + "_1_0").classList.add(clsHide);
             document.getElementById(block + "_1_3").classList.remove(clsHide);
             document.getElementById(block + "_2_0").classList.remove(clsHide);
             document.getElementById(block + "_2_3").classList.add(clsHide);
             break;
     }
  }
   #is_tag (idx) {
      if (this.#items[idx] == "rows") return true;
      if (this.#items[idx] == "cols") return true;
      return false;
  }
};

class JGGShiny {
   #page; // : undefined  // Active page
   #panels; // : new Map()
   #leftSideIcon =  "[data-toggle='jgg_left_button']";
   #rightSideIcon = "[data-toggle='jgg_right_button']";
   #menuTag       = "[data-toggle='tab']";
   #app;
   constructor(app)  {
      this.#page   = undefined;
      this.#panels = new Map();
      this.#app    = app;
   }
   init(title, id)    {
       jQuery("#app_title").text(title);
       jQuery(document).on('click', this.#leftSideIcon,  {jggshiny: this}, jggshiny.sidebar_left);
       jQuery(document).on('click', this.#rightSideIcon, {jggshiny: this}, jggshiny.sidebar_right);
       this.#add_listeners();
       let client = {
            "client": {
               "browser": { "width": $(window).width(),   "height": $(window).height()   }
              ,"page":    { "width": $(document).width(), "height": $(document).height() }
              ,"window":  { "width": window.innerWidth,   "height": window.innerHeight   }
              ,"language": navigator.language
            }
       };

       let cookies = Cookies.get(this.#app);
       if (cookies !== undefined) {
           cookies = JSON.parse(cookies);
           cookies.client = client.client;
       } else {
           cookies = client;
       }
       Cookies.set(this.#app, JSON.stringify(cookies), { SameSite: "Strict"});
   }
   cookies_send() {
       console.log("JGGShiny cookies_send")
      let res = Cookies.get(this.#app);
      Shiny.setInputValue('cookies', res);
   }
   cookies_recv(data) {
       console.log("JGGShiny cookies_recv")
//      let res = Cookies.get();
//      Shiny.setInputValue('cookies', res);
   }
   cookies_set(msg) {
       console.log("cookies_set: " + msg);
   }
   cookies_delete(msg) {
       console.log("cookies_delete: " + msg);
   }
   window_resize(evt) {
      Cookies.set('window_width',  window.innerWidth,  { SameSite: "Strict"});
      Cookies.set('window_height', window.innerHeight, { SameSite: "Strict"});
//      Shiny.setInputValue('resize', Cookies.get());

   }
   set_page(data) {
       console.log("set_page beg: " + data);
       /* Called from shinyjs, data is an array */
       if (this.#page !== undefined && this.#page.header !== undefined) {
           jQuery(this.#page.header).toggleClass('jgg_header_hide');
       }
       this.#page = this.#panels.get(data[0]);
       if (this.#page  === undefined) {
           console.log("set_page undefined");
           return;
       }
       this.#setSideIcons(this.#page.left,  "left");
       this.#setSideIcons(this.#page.right, "right");
       if (this.#page.header !== undefined) {
           jQuery(this.#page.header).toggleClass('jgg_header_hide');
       }
       if (this.#page.dash !== null && !this.#page.dash.loaded)  this.#page.dash.init();
       console.log("set_page end");
    }
   add_page(data) {
       console.log("add_page beg " + data);
       const panel = this.#add_page_dash(data[0], "");
       this.#panels.set(panel.name, panel);
       this.set_page(data);
       console.log("add_page end");
  }
   add_dash(data) {
       console.log("add_dash beg " + data);
       // Last token is the name of layout
       data = data[0].split('_');
       const panel = this.#add_page_dash(data[0], data[1]);
       this.#panels.set(panel.name, panel);
       this.set_page(data);
       console.log("add_dash end");
  }
  #add_page_dash(name, dash) {
       // Called from shinyjs, data is an array
       // Inserta la pagina en el map de paginas
       // Busca los id -left y -right para marcarlos y moverlos
       console.log("add_page_dash beg " + name + " - " + dash);

       const res = this.#panels.get(name);
       if (res !== undefined) {
           console.log("add_page_dash ya existe");
           return;
       }

       let panel = {
            name:  name
           ,left:  0  // 0 - No hay, 1 - Open, -1 - Closed
           ,right: 0
           ,header: undefined
           ,dash: null
       };
       let divBase = "#" + name + "_container";
       let div = divBase + "_left";
       let obj = jQuery(div);
       if (obj.length > 0) panel.left = -1;
       div = divBase + "_right";
       obj = jQuery(div);
       if (obj.length > 0) panel.right = -1;
/*JGG Pendiente
       div = divBase + "_header";
       obj = jQuery(div);
       if (obj.length > 0) {
           panel.header = div;
           $("#jgg_page_header_right").append(.getElementById(div));
       }
*/
console.log("add_page_dash before " + dash);
       if (dash.length > 0) panel.dash = new JGGLayout(name, dash);
console.log("add_page_dash before return " );
       return panel;
  }
   update_page(page) {
      this.#page = page;
      this.#panels.set(page.name, page);
   }
   layout_changed(id, item) {
       console.log("layout_changed");
       this.#page.dash.changed(item);
   }
   mainmenu_click(evt) {
       console.log("mainmenu");
   }
   sidebar_left (evt) {
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
   sidebar_right(evt) {
//       alert(evt.data.yata);
       if (evt.data.yata.page === undefined) return;

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
       if (jQuery(id).hasClass('jgg_side_closed')) {
           jQuery(id).removeClass('jgg_side_closed').trigger('expanded.pushMenu');
           jQuery("#right_side_closed").addClass("jgg_side_closed");
           jQuery("#right_side_open").removeClass("jgg_side_closed");
           this.page.right = 1; // Open
       } else {
           jQuery(id).addClass('jgg_side_closed').trigger('collapsed.pushMenu');
           jQuery("#left_side_closed").removeClass("jgg_side_closed");
           jQuery("#left_side_open").addClass("jgg_side_closed");
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
/*
       let cbo = undefined;
       let id  = undefined;

       for (var i = 1; i < 3; i++) {
           for (var j = 1; j < 3; j++) {
               id = ns[0] + "-cbolayout_" + i + "_" + j;
               cbo = document.getElementById(id);
               this.layout_update([id, cbo.selectedOptions[0].value]);
           }
       }
*/
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
//      window.addEventListener('resize', jggshiny.window_resize );

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
       if (value == 0) jQuery(id).addClass('jgg_buttons_side_hide');
       if (value != 0) jQuery(id).removeClass('jgg_buttons_side_hide');

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
