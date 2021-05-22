if (typeof jQuery === "undefined") { throw new Error("YATA requires jQuery"); }

/* *****************************************
 * Objeto de la aplicacion
 * ****************************************/

class YATAAPP  {
  constructor () {
    alert("Creando Clase YATAAPP");
  }
  loaded() {
    alert("YATA3 esta cargado");
  }
  activatePanel (name) {
    alert("Activando Panel " + name);
  }
  listenerTabClosable() {
        var elements = document.getElementsByClassName("yata_tab_closable");
        Array.from(elements).forEach(function(element) {
        element.addEventListener('click', function (event) { yataTabClose(event) });
    });
    }
  listenerButtonInTable(mode) {
        // Aqui añade el listener a la clase de los botones
        var elements = document.getElementsByClassName("yataBtnClickable");
        Array.from(elements).forEach(function(element) {
              element.addEventListener('click', function (event) { yatabtnClickable(event) });
        });
    }
  listenerLayout() {
alert("Entro en creador de listener");
  // Aqui añade el listener a la clase de los botones
  var elements = document.getElementsByClassName("yata_layout");
  Array.from(elements).forEach(function(element) {
      element.addEventListener('change', function (event) { yataLayoutChanged(event) });
    });
   }
   yataTableclick(rowInfo, colInfo, evt, tgt) {
//    window.alert('Details for click: \\n Fila: ' + colInfo.index + '\\n' + "boton: " + colInfo.id);
                                   //if (colInfo.id !== 'details') { return }
//                         window.alert('Details: row ' + rowInfo.index + 'col: ' + colInfo.id);
     if (window.Shiny) {
         Shiny.setInputValue(evt, { row: rowInfo.index + 1, colName: colInfo.id, target: tgt
                                 }, { priority: 'event' });
     }
   }
   yataMoveChildren (from, to) {
   let   childs   = from.children;
   for (let i = 0; i < childs.length; i++) {
        let hijo =  document.getElementById(childs[i].id);
        to.appendChild(hijo);
    }
}

  yataUpdateLayout (data) {
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
  yataLayoutChanged (event) {
   yataUpdateLayout([event.currentTarget.id, event.target.value]);
}
  yataTabClose (event) {
    Shiny.setInputValue(event.id, { id: event.id}, { priority: 'event' });
}
      setPanel(data) {
                  alert("Entra en yataSetPanel");
                  $.YATA.page = data.id;

                  data.left      = false;
                  data.right     = false;
                  data.openLeft  = false;
                  data.openRight = false;
/*
                  var child;
                  var pnl = $.YATA.panels.get(data.id);
                  if (pnl === undefined) { //primera vez
                      child = $('#' + data.id + '-left-side');
                      if (child !== undefined) {
                          $('#yataContentLeft').append(child);
                          data.left = true;
                      }
                      child = $('#' + data.id + '-right-side');
                      if (child !== undefined) {
                          $('#yataContentRight').append(child);
                          data.right = true;
                      }
                      $.YATA.panels.set(id, data);
                  }
*/

              }


}




/* Detectar la dimension de la pantalla

var dimension = [0, 0];
                                $(document).on("shiny:connected", function(e) {
                                    dimension[0] = window.innerWidth;
                                    dimension[1] = window.innerHeight;
                                    Shiny.onInputChange("dimension", dimension);
                                });
                                $(window).resize(function(e) {
                                    dimension[0] = window.innerWidth;
                                    dimension[1] = window.innerHeight;
                                    Shiny.onInputChange("dimension", dimension);
                                });

en el server

paste(input$dimension[1], input$dimension[2], input$dimension[2]/input$dimension[1])
   })

*/
/* YATA Objeto para guardar las cosas y no pregarnos con otros js */
  $.YATA = {
     page: null
    ,panels: new Map()
  };

  /* --------------------
    * - YATA Options -
    * --------------------
    * Modify these options to suit your implementation
  */
    $.YATA.options = {
      navbarMenuSlimscroll: true,
      navbarMenuSlimscrollWidth: "3px", //The width of the scroll bar
      navbarMenuHeight: "200px", //The height of the inner menu
      animationSpeed: 500,
      sidebarToggleSelector: "[data-toggle='yataoffcanvas']",
      sidebarPushMenu: true,
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
      },
      //Direct Chat plugin options
      directChat: {
      //Enable direct chat by default
      enable: true,
      //The button to open and close the chat contacts pane
      contactToggleSelector: '[data-widget="chat-pane-toggle"]'
      },

      //Define the set of colors to use globally around the website
      colors: {
      lightBlue: "#3c8dbc",
      red: "#f56954",
      green: "#00a65a",
      aqua: "#00c0ef",
      yellow: "#f39c12",
      blue: "#0073b7",
      navy: "#001F3F",
      teal: "#39CCCC",
      olive: "#3D9970",
      lime: "#01FF70",
      orange: "#FF851B",
      fuchsia: "#F012BE",
      purple: "#8E24AA",
      maroon: "#D81B60",
      black: "#222222",
      gray: "#d2d6de"
      },

      //The standard screen sizes that bootstrap uses.
      //If you change these in the variables.less file, change
      //them here too.
      screenSizes: {
      xs: 480,
      sm: 768,
      md: 992,
      lg: 1200
      }
    };

      /* ------------------
      * - Implementation -
      * ------------------
      * The next block of code implements YATA's
      * functions and plugins as specified by the
      * options above.
      */
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

          //Activate the layout maker
          $.YATA.layout.activate();

          //Enable sidebar tree view controls
          if (o.enableControlTreeView) {
            $.YATA.tree('.sidebar');
          }

          //Enable control sidebar
          if (o.enableControlSidebar) {
            $.YATA.controlSidebar.activate();
          }

          //Add slimscroll to navbar dropdown
          if (o.navbarMenuSlimscroll && typeof $.fn.slimscroll != 'undefined') {
            $(".navbar .menu").slimscroll({
              height: o.navbarMenuHeight,
              alwaysVisible: false,
              size: o.navbarMenuSlimscrollWidth
            }).css("width", "100%");
          }

          //Activate sidebar push menu
          if (o.sidebarPushMenu) {
            $.YATA.pushMenu.activate(o.sidebarToggleSelector);
          }
          //JGG Activate menus
          if (o.yataTraceMenu) {
            $.YATA.yataTraceMenu.activate(o.yataTraceMenuSelector);
          }

          //Activate Bootstrap tooltip
          if (o.enableBSToppltip) {
            $('body').tooltip({
              selector: o.BSTooltipSelector,
              container: 'body'
            });
          }

          //Activate box widget
          if (o.enableBoxWidget) {
            $.YATA.boxWidget.activate();
          }

          //Activate fast click
          if (o.enableFastclick && typeof FastClick != 'undefined') {
            FastClick.attach(document.body);
          }

          //Activate direct chat widget
          if (o.directChat.enable) {
            $(document).on('click', o.directChat.contactToggleSelector, function () {
              var box = $(this).parents('.direct-chat').first();
              box.toggleClass('direct-chat-contacts-open');
            });
          }

          /*
            * INITIALIZE BUTTON TOGGLE
          * ------------------------
            */
            $('.btn-group[data-toggle="btn-toggle"]').each(function () {
              var group = $(this);
              $(this).find(".btn").on('click', function (e) {
                group.find(".btn.active").removeClass("active");
                $(this).addClass("active");
                e.preventDefault();
              });

            });
        });

        function _init() {
          $.YATA.showBlock = function(data) {
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
//JGGALERT            alert("MovePanel");
            const source = document.getElementById(data.from);
            const target = document.getElementById(data.to);
            target.appendChild(source);
            /*
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

            }*/
          };

          'use strict';
          /* Layout
          * ======
            * Fixes the layout height in case min-height fails.
          *
            * @type Object
          * @usage $.YATA.layout.activate()
          *        $.YATA.layout.fix()
          *        $.YATA.layout.fixSidebar()
          */
            $.YATA.layout = {
              activate: function () {
                var _this = this;
                _this.fix();
                _this.fixSidebar();
                $('body, html, .wrapper').css('height', 'auto');
                $(window, ".wrapper").resize(function () {
                  _this.fix();
                  _this.fixSidebar();
                });
              },
              fix: function () {
                // Remove overflow from .wrapper if layout-boxed exists
                $(".layout-boxed > .wrapper").css('overflow', 'hidden');
                //Get window height and the wrapper height
                var footer_height = $('.main-footer').outerHeight() || 0;
                var neg = $('.main-header').outerHeight() + footer_height;
                var window_height = $(window).height();
                var sidebar_height = $(".sidebar").height() || 0;
                //Set the min-height of the content and sidebar based on the
                //the height of the document.
                if ($("body").hasClass("fixed")) {
                  $(".content-wrapper, .right-side").css('min-height', window_height - footer_height);
                } else {
                  var postSetWidth;
                  if (window_height >= sidebar_height) {
                    $(".content-wrapper, .right-side").css('min-height', window_height - neg);
                    postSetWidth = window_height - neg;
                  } else {
                    $(".content-wrapper, .right-side").css('min-height', sidebar_height);
                    postSetWidth = sidebar_height;
                  }

                  //Fix for the control sidebar height
                  var controlSidebar = $($.YATA.options.controlSidebarOptions.selector);
                  if (typeof controlSidebar !== "undefined") {
                    if (controlSidebar.height() > postSetWidth)
                      $(".content-wrapper, .right-side").css('min-height', controlSidebar.height());
                  }

                }
              },
              fixSidebar: function () {
                //Make sure the body tag has the .fixed class
                if (!$("body").hasClass("fixed")) {
                  if (typeof $.fn.slimScroll != 'undefined') {
                    $(".sidebar").slimScroll({destroy: true}).height("auto");
                  }
                  return;
                } else if (typeof $.fn.slimScroll == 'undefined' && window.console) {
                  window.console.error("Error: the fixed layout requires the slimscroll plugin!");
                }
                //Enable slimscroll for fixed layout
                if ($.YATA.options.sidebarSlimScroll) {
                  if (typeof $.fn.slimScroll != 'undefined') {
                    //Destroy if it exists
                    $(".sidebar").slimScroll({destroy: true}).height("auto");
                    //Add slimscroll
                    $(".sidebar").slimScroll({
                      height: ($(window).height() - $(".main-header").height()) + "px",
                      color: "rgba(0,0,0,0.2)",
                      size: "3px"
                    });
                  }
                }
              }
            };

            /* PushMenu()
            * ==========
              * Adds the push menu functionality to the sidebar.
            *
              * @type Function
            * @usage: $.YATA.pushMenu("[data-toggle='offcanvas']")
            */
              $.YATA.pushMenu = {
                activate: function (toggleBtn) {
alert("pushmenu");
                  //Get the screen sizes
                  var screenSizes = $.YATA.options.screenSizes;

                  //Enable sidebar toggle
                  $(document).on('click', toggleBtn, function (e) {
alert("Pushmenu onclick");
                    e.preventDefault();

                    var page = $.YATA.page;

                    if (page !== null) {
                        var id = "#" + page + "-container_left";
                        if ($(id).hasClass('yata_leftside_closed')) {
                            //$(id).addClass('yata_leftside_open');
                            $(id).removeClass('yata_leftside_closed').trigger('expanded.pushMenu');
                            $("#left_side_closed").addClass("yata_side_closed");
                            $("#left_side_open").removeClass("yata_side_closed");
                        } else {
                            //$(id).removeClass('yata_leftside_open');
                            $(id).addClass('yata_leftside_closed').trigger('collapsed.pushMenu');
                            $("#left_side_closed").removeClass("yata_side_closed");
                            $("#left_side_open").addClass("yata_side_closed");
                        }
                    }
/*
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
*/
                  });

                  $(".content-wrapper").click(function () {
                    //Enable hide menu when clicking on the content-wrapper on small screens
                    if ($(window).width() <= (screenSizes.sm - 1) && $("body").hasClass("sidebar-open")) {
                      $("body").removeClass('sidebar-open');
                    }
                  });

                  //Enable expand on hover for sidebar mini
                  if ($.YATA.options.sidebarExpandOnHover
                      || ($('body').hasClass('fixed')
                          && $('body').hasClass('sidebar-mini'))) {
                    this.expandOnHover();
                  }
                },
                expandOnHover: function () {
                  var _this = this;
                  var screenWidth = $.YATA.options.screenSizes.sm - 1;
                  //Expand sidebar on hover
                  $('.main-sidebar').hover(function () {
                    if ($('body').hasClass('sidebar-mini')
                        && $("body").hasClass('sidebar-collapse')
                        && $(window).width() > screenWidth) {
                      _this.expand();
                    }
                  }, function () {
                    if ($('body').hasClass('sidebar-mini')
                        && $('body').hasClass('sidebar-expanded-on-hover')
                        && $(window).width() > screenWidth) {
                      _this.collapse();
                    }
                  });
                },
                expand: function () {
                  $("body").removeClass('sidebar-collapse').addClass('sidebar-expanded-on-hover');
                },
                collapse: function () {
//alert("En Javascript collapse");
                  if ($('body').hasClass('sidebar-expanded-on-hover')) {
                    $('body').removeClass('sidebar-expanded-on-hover').addClass('sidebar-collapse');
                  }
                }
              };

              $.YATA.yataTraceMenu = {
                activate: function (datatoggle) {
                  alert("JGG Menu clickeado");
                  //Enable sidebar toggle
                  $(document).on('click', datatoggle, function (e) {

                  e.preventDefault();
                    //alert(e.target.dataset.value);

                  $.YATA.page = e.target.dataset.value;
                    // Obtener la info del panel
                  var pnl = $.YATA.panels.get(e.target.dataset.value);
//                  alert(pnl);
                    // Hacer lo que haya que hacer

                  });

                  $(".content-wrapper").click(function () {
                    //Enable hide menu when clicking on the content-wrapper on small screens
                    if ($(window).width() <= (screenSizes.sm - 1) && $("body").hasClass("sidebar-open")) {
                      $("body").removeClass('sidebar-open');
                    }
                  });

                  //Enable expand on hover for sidebar mini
                  if ($.YATA.options.sidebarExpandOnHover
                      || ($('body').hasClass('fixed')
                          && $('body').hasClass('sidebar-mini'))) {
                    this.expandOnHover();
                  }
                },
                expandOnHover: function () {
                  var _this = this;
                  var screenWidth = $.YATA.options.screenSizes.sm - 1;
                  //Expand sidebar on hover
                  $('.main-sidebar').hover(function () {
                    if ($('body').hasClass('sidebar-mini')
                        && $("body").hasClass('sidebar-collapse')
                        && $(window).width() > screenWidth) {
                      _this.expand();
                    }
                  }, function () {
                    if ($('body').hasClass('sidebar-mini')
                        && $('body').hasClass('sidebar-expanded-on-hover')
                        && $(window).width() > screenWidth) {
                      _this.collapse();
                    }
                  });
                },
                expand: function () {
                  $("body").removeClass('sidebar-collapse').addClass('sidebar-expanded-on-hover');
                },
                collapse: function () {
//                                  alert("En Javascript collapse");
                  if ($('body').hasClass('sidebar-expanded-on-hover')) {
                    $('body').removeClass('sidebar-expanded-on-hover').addClass('sidebar-collapse');
                  }
                }
              };

              // JGG. Carga el panel en el mapa y mueve los menus si existen
              $.YATA.yataSetPanel = function(data) {
//                  alert("Entra en yataSetPanel");
                  $.YATA.page = data.id;

                  data.left      = false;
                  data.right     = false;
                  data.openLeft  = false;
                  data.openRight = false;
/*
                  var child;
                  var pnl = $.YATA.panels.get(data.id);
                  if (pnl === undefined) { //primera vez
                      child = $('#' + data.id + '-left-side');
                      if (child !== undefined) {
                          $('#yataContentLeft').append(child);
                          data.left = true;
                      }
                      child = $('#' + data.id + '-right-side');
                      if (child !== undefined) {
                          $('#yataContentRight').append(child);
                          data.right = true;
                      }
                      $.YATA.panels.set(id, data);
                  }
*/

              };
              /* Tree()
              * ======
                * Converts the sidebar into a multilevel
              * tree view menu.
              *
                * @type Function
              * @Usage: $.YATA.tree('.sidebar')
              */
                $.YATA.tree = function (menu) {
                  var _this = this;
                  var animationSpeed = $.YATA.options.animationSpeed;
                  $(document).off('click', menu + ' li a')
                  .on('click', menu + ' li a', function (e) {
                    //Get the clicked link and the next element
                    var $this = $(this);
                    var checkElement = $this.next();

                    //Check if the next element is a menu and is visible
                    if ((checkElement.is('.treeview-menu')) && (checkElement.is(':visible')) && (!$('body').hasClass('sidebar-collapse'))) {
                      //Close the menu
                      checkElement.slideUp(animationSpeed, function () {
                        checkElement.removeClass('menu-open');
                        //Fix the layout in case the sidebar stretches over the height of the window
                        //_this.layout.fix();
                      });
                      checkElement.parent("li").removeClass("active");
                    }
                    //If the menu is not visible
                    else if ((checkElement.is('.treeview-menu')) && (!checkElement.is(':visible'))) {
                      //Get the parent menu
                      var parent = $this.parents('ul').first();
                      //Close all open menus within the parent
                      var ul = parent.find('ul:visible').slideUp(animationSpeed);
                      //Remove the menu-open class from the parent
                      ul.removeClass('menu-open');
                      //Get the parent li
                      var parent_li = $this.parent("li");

                      // shiny-mod (see README-shiny-mods.md)
                      var shinyOutput = checkElement.find('.shiny-bound-output');
                      if (shinyOutput.length !== 0 && shinyOutput.first().html().length === 0) {
                        shinyOutput.first().html('<br/>');
                      }

                      //Open the target menu and add the menu-open class
                      checkElement.slideDown(animationSpeed, function () {
                        //Add the class active to the parent li
                        checkElement.addClass('menu-open');
                        parent.find('li.active').removeClass('active');
                        parent_li.addClass('active');
                        //Fix the layout in case the sidebar stretches over the height of the window
                        _this.layout.fix();
                      });
                    }
                    //if this isn't a link, prevent the page from being redirected
                    if (checkElement.is('.treeview-menu')) {
                    e.preventDefault();
                    }
                  });
        };

                    /* ControlSidebar
                    * ==============
                    * Adds functionality to the right sidebar
                    *
                    * @type Object
                    * @usage $.YATA.controlSidebar.activate(options)
                    */
                    $.YATA.controlSidebar = {
                    //instantiate the object
                    activate: function () {
                    //Get the object
                    var _this = this;
                    //Update options
                    var o = $.YATA.options.controlSidebarOptions;
                    //Get the sidebar
                    var sidebar = $(o.selector);
                    //The toggle button
                    var btn = $(o.toggleBtnSelector);

                    //Listen to the click event
                    btn.on('click', function (e) {
                    e.preventDefault();
                    //If the sidebar is not open
                    if (!sidebar.hasClass('control-sidebar-open')
                    && !$('body').hasClass('control-sidebar-open')) {
                    //Open the sidebar
                    _this.open(sidebar, o.slide);
                    } else {
                    _this.close(sidebar, o.slide);
                    }
                    });

                    //If the body has a boxed layout, fix the sidebar bg position
                    var bg = $(".control-sidebar-bg");
                    _this._fix(bg);

                    //If the body has a fixed layout, make the control sidebar fixed
                    if ($('body').hasClass('fixed')) {
                    _this._fixForFixed(sidebar);
                    } else {
                    //If the content height is less than the sidebar's height, force max height
                    if ($('.content-wrapper, .right-side').height() < sidebar.height()) {
                      _this._fixForContent(sidebar);
                    }
                    }
                    },
                //Open the control sidebar
                open: function (sidebar, slide) {
                  //Slide over content
                  if (slide) {
                    sidebar.addClass('control-sidebar-open');
                  } else {
                    //Push the content by adding the open class to the body instead
                    //of the sidebar itself
                    $('body').addClass('control-sidebar-open');
                  }
                },
                //Close the control sidebar
                close: function (sidebar, slide) {
                  if (slide) {
                    sidebar.removeClass('control-sidebar-open');
                  } else {
                    $('body').removeClass('control-sidebar-open');
                  }
                },
                _fix: function (sidebar) {
                  var _this = this;
                  if ($("body").hasClass('layout-boxed')) {
                    sidebar.css('position', 'absolute');
                    sidebar.height($(".wrapper").height());
                    if (_this.hasBindedResize) {
                      return;
                    }
                    $(window).resize(function () {
                      _this._fix(sidebar);
                    });
                    _this.hasBindedResize = true;
                  } else {
                    sidebar.css({
                      'position': 'fixed',
                      'height': 'auto'
                    });
                  }
                },
                _fixForFixed: function (sidebar) {
                  sidebar.css({
                    'position': 'fixed',
                    'max-height': '100%',
                    'overflow': 'auto',
                    'padding-bottom': '50px'
                  });
                },
                _fixForContent: function (sidebar) {
                  $(".content-wrapper, .right-side").css('min-height', sidebar.height());
                }
                };

      /* BoxWidget
      * =========
        * BoxWidget is a plugin to handle collapsing and
      * removing boxes from the screen.
      *
        * @type Object
      * @usage $.YATA.boxWidget.activate()
      *        Set all your options in the main $.YATA.options object
      */
        $.YATA.boxWidget = {
          selectors: $.YATA.options.boxWidgetOptions.boxWidgetSelectors,
          icons: $.YATA.options.boxWidgetOptions.boxWidgetIcons,
          animationSpeed: $.YATA.options.animationSpeed,
          activate: function (_box) {
            var _this = this;
            if (!_box) {
              _box = document; // activate all boxes per default
            }
            //Listen for collapse event triggers
            $(_box).on('click', _this.selectors.collapse, function (e) {
              e.preventDefault();
              _this.collapse($(this));
            });

            //Listen for remove event triggers
            $(_box).on('click', _this.selectors.remove, function (e) {
              e.preventDefault();
              _this.remove($(this));
            });
          },
          collapse: function (element) {
            var _this = this;
            //Find the box parent
            var box = element.parents(".box").first();
            //Find the body and the footer
            var box_content = box.find("> .box-body, > .box-footer, > form  >.box-body, > form > .box-footer");
            if (!box.hasClass("collapsed-box")) {
              //Convert minus into plus
              element.children(":first")
              .removeClass(_this.icons.collapse)
              .addClass(_this.icons.open);
              //Hide the content
              box_content.slideUp(_this.animationSpeed, function () {
                box.addClass("collapsed-box");
                box.trigger("hidden.bs.collapse");
              });
            } else {
              //Convert plus into minus
              element.children(":first")
              .removeClass(_this.icons.open)
              .addClass(_this.icons.collapse);

              // Technically, it should be 'show' which is triggered here, and
              // 'shown' which is triggered later. However, this works better because
              // of the slow expansion transition -- the box would fully expand, and
              // only then trigger 'shown', which then results in an update of the
              // content. This would allow users to see the old content during the
              // expansion.
              box.trigger("shown.bs.collapse");

              //Show the content
              box_content.slideDown(_this.animationSpeed, function () {
                box.removeClass("collapsed-box");
              });
            }
          },
          remove: function (element) {
            //Find the box parent
            var box = element.parents(".box").first();
            box.slideUp(this.animationSpeed);
          }
        };
        }

    /* ------------------
      * - Custom Plugins -
      * ------------------
      * All custom plugins are defined below.
    */

      /*
      * BOX REFRESH BUTTON
    * ------------------
      * This is a custom plugin to use with the component BOX. It allows you to add
    * a refresh button to the box. It converts the box's state to a loading state.
    *
    * @type plugin
    * @usage $("#box-widget").boxRefresh( options );
    */
    (function ($) {

    "use strict";

    $.fn.boxRefresh = function (options) {

    // Render options
    var settings = $.extend({
    //Refresh button selector
    trigger: ".refresh-btn",
    //File source to be loaded (e.g: ajax/src.php)
    source: "",
    //Callbacks
    onLoadStart: function (box) {
    return box;
    }, //Right after the button has been clicked
    onLoadDone: function (box) {
    return box;
    } //When the source has been loaded

    }, options);

    //The overlay
    var overlay = $('<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>');

    return this.each(function () {
    //if a source is specified
    if (settings.source === "") {
    if (window.console) {
    window.console.log("Please specify a source first - boxRefresh()");
    }
    return;
    }
    //the box
    var box = $(this);
    //the button
    var rBtn = box.find(settings.trigger).first();

    //On trigger click
    rBtn.on('click', function (e) {
    e.preventDefault();
    //Add loading overlay
    start(box);

    //Perform ajax call
    box.find(".box-body").load(settings.source, function () {
    done(box);
    });
    });
    });

    function start(box) {
    //Add overlay and loading img
    box.append(overlay);

    settings.onLoadStart.call(box);
    }

    function done(box) {
    //Remove overlay and loading img
    box.find(overlay).remove();

    settings.onLoadDone.call(box);
    }

    };

    })(jQuery);


/*JGGMAP    //# sourceMappingURL=app.js.map */

// Esto se supone que cargaria los scripts despues de todo lo demas
/*
<script type="text/javascript">
//<![CDATA[
if(document.createStyleSheet) {
  document.createStyleSheet('http://example.com/big.css');
}
else {
  var styles = "@import url('http://example.com/big.css');";
  var newSS=document.createElement('link');
  newSS.rel='stylesheet';
  newSS.href='data:text/css,'+escape(styles);
  document.getElementsByTagName("head")[0].appendChild(newSS);
}
//]]>
*/

/* *****************************************
 * Funciones extendiendo shinyjs
 * ****************************************/
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


// Funcion que se ejecuta on document.ready
$(function() {
    alert( "Documento listo" );
    YATA3 = new YATAAPP();
//    Shiny.addCustomMessageHandler('buttonInTable', YATA3.listenerButtonInTable);
    Shiny.addCustomMessageHandler('setTitle', function(text) {document.title = "YATA - " + text;});
    YATA3.listenerLayout();
    YATA3.listenerTabClosable();
    YATA3.loaded();

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

