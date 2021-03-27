//---------------------------------------------------------------------
  // Source file: ../srcjs/YATA/app.js

/*! YATA app.js
* ================
  * Main JS application file for YATA v2. This file
* should be included in all pages. It controls some layout
* options and implements exclusive YATA plugins.
*
  * @Author  Almsaeed Studio
* @Support <http://www.almsaeedstudio.com>
  * @Email   <abdullah@almsaeedstudio.com>
  * @version 2.3.11
* @license MIT <http://opensource.org/licenses/MIT>
  */

  //Make sure jQuery has been loaded before app.js
if (typeof jQuery === "undefined") {
  throw new Error("YATA requires jQuery");
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
/* YATA
*
  * @type Object
* @description $.YATA is the main object for the template's app.
*              It's used for implementing functions and options related
*              to the template. Keeping everything wrapped in an object
*              prevents conflict with other plugins and is a better
*              way to organize our code.
*/
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
      //Add slimscroll to navbar menus
      //This requires you to load the slimscroll plugin
      //in every page before app.js
      navbarMenuSlimscroll: true,
      navbarMenuSlimscrollWidth: "3px", //The width of the scroll bar
      navbarMenuHeight: "200px", //The height of the inner menu
      //General animation speed for JS animated elements such as box collapse/expand and
      //sidebar treeview slide up/down. This options accepts an integer as milliseconds,
      //'fast', 'normal', or 'slow'
      animationSpeed: 500,
      //Sidebar push menu toggle button selector
      sidebarToggleSelector: "[data-toggle='yataoffcanvas']",
      //Activate sidebar push menu
      sidebarPushMenu: true,
      // JGG Activate menu
      yataTraceMenu: true,
      yataTraceMenuSelector: "[data-toggle='tab']",
      //Activate sidebar slimscroll if the fixed layout is set (requires SlimScroll Plugin)
      sidebarSlimScroll: true,
      //Enable sidebar expand on hover effect for sidebar mini
      //This option is forced to true if both the fixed layout and sidebar mini
      //are used together
      sidebarExpandOnHover: false,
      //BoxRefresh Plugin
      enableBoxRefresh: true,
      //Bootstrap.js tooltip
      enableBSToppltip: true,
      BSTooltipSelector: "[data-toggle='tooltip']",
      //Enable Fast Click. Fastclick.js creates a more
      //native touch experience with touch devices. If you
      //choose to enable the plugin, make sure you load the script
      //before YATA's app.js
      enableFastclick: false,
      //Control Sidebar Tree views
      enableControlTreeView: true,
      //Control Sidebar Options
      enableControlSidebar: true,
      controlSidebarOptions: {
      //Which button should trigger the open/close event
      toggleBtnSelector: "[data-toggle='control-sidebar']",
      //The sidebar selector
      selector: ".control-sidebar",
      //Enable slide over content
      slide: false
      },
      //Box Widget Plugin. Enable this plugin
      //to allow boxes to be collapsed and/or removed
      enableBoxWidget: true,
      //Box Widget plugin options
      boxWidgetOptions: {
      boxWidgetIcons: {
      //Collapse icon
      collapse: 'fa-minus',
      //Open icon
      open: 'fa-plus',
      //Remove icon
      remove: 'fa-times'
      },
      boxWidgetSelectors: {
      //Remove button selector
      remove: '[data-widget="remove"]',
      //Collapse button selector
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

      /* ----------------------------------
        * - Initialize the YATA Object -
        * ----------------------------------
        * All YATA functions are implemented below.
      */
        function _init() {
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
//JGG                                  alert("En Javascript activate");
                  //Get the screen sizes
                  var screenSizes = $.YATA.options.screenSizes;

                  //Enable sidebar toggle
                  $(document).on('click', toggleBtn, function (e) {
//JGG                                    alert("Pushmenu onclick");
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
//JGG                                  alert("En Javascript collapse");
                  if ($('body').hasClass('sidebar-expanded-on-hover')) {
                    $('body').removeClass('sidebar-expanded-on-hover').addClass('sidebar-collapse');
                  }
                }
              };

              $.YATA.yataTraceMenu = {
                activate: function (datatoggle) {
//JGG                                  alert("JGG En Javascript activate");

                  //Enable sidebar toggle
                  $(document).on('click', datatoggle, function (e) {
//JGG                                    alert("JGG Menu clickeado");
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

    /*
    * EXPLICIT BOX CONTROLS
    * -----------------------
    * This is a custom plugin to use with the component BOX. It allows you to activate
    * a box inserted in the DOM after the app.js was loaded, toggle and remove box.
    *
    * @type plugin
    * @usage $("#box-widget").activateBox();
    * @usage $("#box-widget").toggleBox();
    * @usage $("#box-widget").removeBox();
    */
    (function ($) {

    'use strict';

    $.fn.activateBox = function () {
    $.YATA.boxWidget.activate(this);
    };

    $.fn.toggleBox = function () {
    var button = $($.YATA.boxWidget.selectors.collapse, this);
    $.YATA.boxWidget.collapse(button);
    };

    $.fn.removeBox = function () {
    var button = $($.YATA.boxWidget.selectors.remove, this);
    $.YATA.boxWidget.remove(button);
    };

    })(jQuery);

    /*
    * TODO LIST CUSTOM PLUGIN
    * -----------------------
    * This plugin depends on iCheck plugin for checkbox and radio inputs
    *
    * @type plugin
    * @usage $("#todo-widget").todolist( options );
    */
    (function ($) {

    'use strict';

    $.fn.todolist = function (options) {
    // Render options
    var settings = $.extend({
    //When the user checks the input
    onCheck: function (ele) {
    return ele;
    },
    //When the user unchecks the input
    onUncheck: function (ele) {
    return ele;
    }
    }, options);

    return this.each(function () {

    if (typeof $.fn.iCheck != 'undefined') {
    $('input', this).on('ifChecked', function () {
    var ele = $(this).parents("li").first();
    ele.toggleClass("done");
    settings.onCheck.call(ele);
    });

    $('input', this).on('ifUnchecked', function () {
    var ele = $(this).parents("li").first();
    ele.toggleClass("done");
    settings.onUncheck.call(ele);
    });
    } else {
    $('input', this).on('change', function () {
    var ele = $(this).parents("li").first();
    ele.toggleClass("done");
    if ($('input', ele).is(":checked")) {
    settings.onCheck.call(ele);
    } else {
    settings.onUncheck.call(ele);
    }
    });
    }
    });
    };
    }(jQuery));

    //# sourceMappingURL=app.js.map

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
