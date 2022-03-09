if (typeof jQuery === "undefined") { throw new Error("jQuery is required"); }
$.jggshiny = {
    page: undefined  // Active page
//   ,panels: new Map()
   ,options: {
       leftSideIcon:  "[data-toggle='jgg_left_button']"
      ,rightSideIcon: "[data-toggle='jgg_right_button']"
      ,menuTag:       "[data-toggle='tab']"
   }
   ,init: function(title) {
    //   alert("Initializing JGG code");
       $("#app_title").text(title);
       $(document).on('click', this.options.leftSideIcon,  {jgg: this}, this.sidebarLeft);
       $(document).on('click', this.options.rightSideIcon, {jgg: this}, this.sidebarRight);
       /*
       $(document).on('click', '#mainmenu', {jgg: this}, this.mainmenu_click);
       $('a.nav-link').click({jgg: this}, this.mainmenu_click);
       $('.nav-link').on('click', function(evt) { alert("Pulsado"); });
       $("#mainMenu").on("click", ".searchterm", function(event){
    alert('clicked');
});
*/
   }
   ,set_page: function(name) {
       this.page = this.panels.get(name);
       if (this.page  === undefined) return;
       let div    = "#jgg_left_side";
       let cls    = "jgg_side_none";
       let hasCls = $(div).hasClass(cls);
       if (this.page.left) {
           if (hasCls) $(div).removeClass(cls);
       } else {
           if (!hasCls) $(div).addClass(cls);
       }
       div = "#jgg_right_side";
       hasCls = $(div).hasClass(cls);
       if (this.page.right) {
           if (hasCls) $(div).removeClass(cls);
       } else {
           if (!hasCls) $(div).addClass(cls);
       }
    }
   ,add_page: function(name) {
       res = this.panels.get(name);
       if (res !== undefined) return;

       let panel = {
            name:  name
           ,left:  true
           ,right: true
           ,openLeft: false
           ,openRight: false
       };
       let divBase = name + "_container";
       let div = divBase + "_left";
       let obj = $(div);
       if (obj === undefined) panel.left = false;
       div = divBase + "_right";
       obj = $(div);
       if (obj === undefined) panel.right = false;
       this.panels.put(name, panel);
       this.set_page(name);
  }

   ,mainmenu_click: function(evt) {
       alert("mainmenu");
   }
   ,sidebarLeft: function(evt) {
       alert(evt.data.jgg);
       if (evt.data.jgg.page === undefined) return;
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
   ,sidebarRight: function(evt) {
       alert(evt.data.jgg);
       if (evt.data.jgg.page === undefined) return;

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


};
