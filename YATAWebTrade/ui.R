lbl = WEB$getLabelsMenuMain()

YATAPage("YATA", id="mainMenu",titleActive = TRUE
#     ,JGGTab("test", "Test", NULL, JGGModule("test"))
#     ,JGGTab("dash",  lbl$DASHBOARD,  NULL,  JGGModule("dash"))
     ,YATATab("oper", lbl$OPERATION, NULL,  YATAUI("oper"))
     ,YATATab("pos",  lbl$POSITION,  NULL,  YATAUI("pos"))
#     ,JGGTab("hist", lbl$HISTORY,   NULL,  JGGModule("hist"))
#     ,JGGTab("ana",   lbl$ANALYSIS,  NULL,    JGGModule("ana"))
     ,JGGTab("blog",  lbl$BLOG,     NULL, JGGModule("blog"))
#     ,JGGTab("admin", lbl$ADMIN,    NULL, JGGModule("admin"))
      ,JGGTab("test", "Test",    NULL, YATAUI("test"))
)

# JGGDashboard( title = "YATA", id = "mainMenu", theme = bslib::bs_theme(bootswatch = "default")
#                  ,paths    = NULL,    cssFiles = NULL
#                  ,jsFiles  = NULL, jsInit   = NULL
#                  ,titleActive = FALSE,  lang     = "es"
#    # ,JGGTab(id="status",   "Situacion",      NULL, JGGUI("status"))
#    # ,JGGTab(id="position", "Posicion",       NULL, JGGUI("position"))
#    # ,JGGTab(id="budget",   "Presupuesto",    NULL, JGGUI("budget"))
#    # ,JGGTab(id="detail",   "Detalle",        NULL, JGGUI("detail"))
#    # ,JGGTab(id="config",   "Configuracion",  NULL, JGGUI("config"))
#    # ,JGGTab(id="xfer",     "Transferencias", NULL, JGGUI("xfer"))
#    # ,JGGTab(id="input",    "Entrada",        NULL, JGGUI("input") )
# )
#

# cat("Entra en UI.R")
# lbl = WEB$getLabelsMenuMain()

#JGGDashboard("DashBoard", id="dashboard"


# YATAPage("YATA", id="mainMenu",titleActive = TRUE
#     ,JGGTab("test", "Test", NULL, JGGModule("test"))
#     ,JGGTab("dash",  lbl$DASHBOARD,  NULL,  JGGModule("dash"))
#     ,JGGTab("pos",  lbl$POSITION,  NULL,  JGGModule("pos"))
#     ,JGGTab("oper", lbl$OPERATION, NULL,  JGGModule("oper"))
#     ,JGGTab("hist", lbl$HISTORY,   NULL,  JGGModule("hist"))
#     ,JGGTab("ana",   lbl$ANALYSIS,  NULL,    JGGModule("ana"))
#     ,JGGTab("blog",  lbl$BLOG,     NULL, JGGModule("blog"))
#     ,JGGTab("admin", lbl$ADMIN,    NULL, JGGModule("admin"))
# # ,YATATabPanel(lbl$STATUS,    value="status", YATAModule("status") )
# )

# YATAPage("YATA", id="mainMenu",titleActive = TRUE
#     ,JGGTab("test", "Test", NULL, JGGModule("test"))
#     ,JGGTab("dash",  lbl$DASHBOARD,  icon("dashcube"),  JGGModule("dash"))
#     ,JGGTab("pos",  lbl$POSITION,  icon("newspaper"),  JGGModule("pos"))
#     ,JGGTab("oper", lbl$OPERATION, icon("shopping-bag"),  JGGModule("oper"))
# #    ,JGGTab("hist", lbl$HISTORY,   NULL,  JGGModule("hist"))
#     ,JGGTab("ana",   lbl$ANALYSIS,  icon("chart-line"),    JGGModule("ana"))
#     ,JGGTab("blog",  lbl$BLOG,     icon("pencil-alt"), JGGModule("blog"))
#     ,JGGTab("admin", lbl$ADMIN,    icon("cog"), JGGModule("admin"))
# # ,YATATabPanel(lbl$STATUS,    value="status", YATAModule("status") )
# )

# YATAWebCore::YATAPage("YATA", id="mainMenu",titleActive = TRUE, theme =  my_theme,lang = NULL
# #   ,YATATab("Test", id="test",   YATAModule("test"))
#    ,YATATab(lbl$OPERATION, id="oper",   YATAModule("oper"))
#    ,YATATab(lbl$ADMIN,    id="admin", YATAModule("admin") )
# )

#JGGDashboardFull(title="YATA", id = "mainMenu"
#cat(paste(Sys.time(), " - Before YATAPage"), file="P:/R/YATA2/web.log", append=TRUE)
# YATAWebCore::YATAPage("YATA", id="mainMenu",titleActive = TRUE
#   #
# #   ,JGGTab("oper", lbl$OPERATION, NULL,  JGGModule("oper"))
#   # ,YATATabPanel(lbl$HISTORY,   value="hist",   YATAModule("hist")   )
#   # ,YATATabPanel(lbl$ANALYSIS,  value="ana",    YATAModule("ana")    )
# #
# #
#
#
# )
#
