# Copiado de dashboard plus para modificar el estilo adminlte
# Add dashboard dependencies to a tag object

yataDeps = function (x, md) {
    adminLTE_js <- "js/app.min.js"
    custom_js <- "js/custom.js"
    shinydashboard_js <- "shinydashboard.js"
#    adminLTE_css <- c("css/AdminLTE.min.css", "css/_all-skins.min.css")
     adminLTE_css <- c("css/_all-skins.min.css")
    if (md) {
        md_bootstrap_css <- "css/bootstrap-material-design.min.css"
        ripples_css <- "css/ripples.min.css"
        md_adminLTE_css <- "css/MaterialAdminLTE.min.css"
        md_skins_css <- "css/all-md-skins.min.css"
        md_js <- "js/material.min.js"
        ripples_js <- "js/ripples.min.js"
        md_init_js <- "js/init.js"
    }
    dashboardDeps <- list(
         htmltools::htmlDependency("shinydashboardPlus",
             as.character(utils::packageVersion("shinydashboardPlus")),
             c(file = system.file("shinydashboardPlus-2.0.0", package = "shinydashboardPlus")),
             script = c(adminLTE_js, shinydashboardPlus_js),
             stylesheet = c(adminLTE_css, custom_css))
        ,htmltools::htmlDependency("shinydashboard", as.character(utils::packageVersion("shinydashboard")),
             c(file = system.file(package = "shinydashboard")),
             script = shinydashboard_js, stylesheet = "shinydashboard.css"),
             if (md) {
                   htmltools::htmlDependency("materialDesign"
                           ,as.character(utils::packageVersion("shinydashboardPlus")),
                           c(file = system.file("materialDesign-1.0", package = "shinydashboardPlus")),
                           script = c(md_js, ripples_js, md_init_js), stylesheet = c(md_bootstrap_css,
                           ripples_css, md_adminLTE_css, md_skins_css))
             })
    tagList(x, dashboardDeps)
}

# yataDeps <- function(tag, md) { #JGG }, options) {
# browser()
#   # always use minified files (https://www.minifier.org)
#   adminLTE_js <- if (getOption("shiny.minified", TRUE)) {
#     "js/app.min.js"
#   } else {
#     "js/app.js"
#   }
#   shinydashboardPlus_js <- if (getOption("shiny.minified", TRUE)) {
#     "js/shinydashboardPlus.min.js"
#   } else {
#     "js/shinydashboardPlus.js"
#   }
# #JGG  adminLTE_css <- c("css/AdminLTE.min.css", "css/_all-skins.min.css")
#   adminLTE_css <- c("css/_all-skins.min.css")
#   custom_css <- ("css/custom.css")
#
#   # material design deps
#   if (md) {
#     # CSS
#     md_bootstrap_css <- "css/bootstrap-material-design.min.css"
#     ripples_css <- "css/ripples.min.css"
#     md_adminLTE_css <- "css/MaterialAdminLTE.min.css"
#     md_skins_css <- "css/all-md-skins.min.css"
#     # JS
#     md_js <- "js/material.min.js"
#     ripples_js <- "js/ripples.min.js"
#     md_init_js <- "js/init.js"
#   }
#
#   dashboardDeps <- list(
#     # additional options (this needs to be loaded before shinydashboardPlus deps)
#     htmltools::htmlDependency(
#       "options",
#       as.character(utils::packageVersion("shinydashboardPlus")),
#       src = c(file = system.file("shinydashboardPlus-2.0.0", package = "shinydashboardPlus")),
#       head = if (!is.null(options)) {
#         paste0(
#           "<script>var AdminLTEOptions = ",
#           jsonlite::toJSON(
#             options,
#             auto_unbox = TRUE,
#             pretty = TRUE
#           ),
#           ";</script>"
#         )
#       }
#     ),
#     # custom adminLTE js and css for shinydashboardPlus
#     htmltools::htmlDependency(
#       "shinydashboardPlus",
#       as.character(utils::packageVersion("shinydashboardPlus")),
#       c(file = system.file("shinydashboardPlus-2.0.0", package = "shinydashboardPlus")),
#       script = c(adminLTE_js, shinydashboardPlus_js),
#       stylesheet = c(adminLTE_css, custom_css)
#     ),
#     # shinydashboard css and js deps
#     htmltools::htmlDependency(
#       "shinydashboard",
#       as.character(utils::packageVersion("shinydashboard")),
#       c(file = system.file(package = "shinydashboard")),
#       stylesheet = "shinydashboard.css"
#     ),
#     # material design deps
#     if (md) {
#       htmltools::htmlDependency(
#         "materialDesign",
#         as.character(utils::packageVersion("shinydashboardPlus")),
#         c(file = system.file("materialDesign-1.0", package = "shinydashboardPlus")),
#         script = c(md_js, ripples_js, md_init_js),
#         stylesheet = c(md_bootstrap_css, ripples_css, md_adminLTE_css, md_skins_css)
#       )
#     }
#   )
#
#   shiny::tagList(tag, dashboardDeps)
# }
