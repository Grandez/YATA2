if (typeof jQuery === "undefined") { throw new Error("jQuery is required"); }

class JGGShiny {
   #page; // : undefined  // Active page
   #panels; // : new Map()
   #leftSideIcon =  "[data-toggle='jgg_left_button']";
   #rightSideIcon = "[data-toggle='jgg_right_button']";
   #menuTag       = "[data-toggle='tab']";

/*
   #options: {
       leftSideIcon:  "[data-toggle='jgg_left_button']"
      ,rightSideIcon: "[data-toggle='jgg_right_button']"
      ,menuTag:       "[data-toggle='tab']"
   }
*/
   constructor() {
      this.#page = undefined;
      this.#panels = new Map();
   }
   init(title) {
       jQuery("#app_title").text(title);
       jQuery(document).on('click', this.#leftSideIcon,  {jggshiny: this}, jggshiny.sidebarLeft);
       jQuery(document).on('click', this.#rightSideIcon, {jggshiny: this}, jggshiny.sidebarRight);
   }
   set_page(data) {
       /* Called from shinyjs, parameter is an array */
//       alert("SET PAGE " + data[0]);
       this.#page = this.#panels.get(data[0]);
       if (this.#page  === undefined) return;
       this.#setSideIcons(this.#page.left,  "left");
       this.#setSideIcons(this.#page.right, "right");
    }
   add_page(data) {
       /* Called from shinyjs, parameter is an# array */
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
   sidebarLeft(evt) {
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

}
