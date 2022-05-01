lbl = WEB$getLabelsMenuMain()
#JGGDashboard("DashBoard", id="dashboard"
YATAPage("YATA", id="mainMenu",titleActive = TRUE
    ,JGGTab("test", "Test", NULL, JGGModule("test"))
    ,JGGTab("pos",  lbl$POSITION,  icon("dashcube"),  JGGModule("pos"))
    ,JGGTab("oper", lbl$OPERATION, icon("shopping-bag"),  JGGModule("oper"))
#    ,JGGTab("hist", lbl$HISTORY,   NULL,  JGGModule("hist"))
    ,JGGTab("ana",   lbl$ANALYSIS,  icon("chart-line"),    JGGModule("ana"))
    ,JGGTab("blog",  lbl$BLOG,     icon("pencil"), JGGModule("blog"))
    ,JGGTab("admin", lbl$ADMIN,    icon("cog"), JGGModule("admin"))
# ,YATATabPanel(lbl$STATUS,    value="status", YATAModule("status") )
)

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
