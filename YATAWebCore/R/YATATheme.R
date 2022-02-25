# Este es el tema general
YATATheme = function(base = "cerulean") {
    bslib::bs_theme(bootswatch = base) %>%
                    .addSass()
    #                .addDeclarations() %>%
    #                .addRules() %>%
    #                .addRulesPosition
}

.addSass = function(theme) {

    base <- system.file("extdata/www/yata", "yatabase.scss", package = "YATAWebCore")
    bs_add_rules(theme, sass::sass_file(base))
    theme
}
.addDeclarations = function(theme) {
    dt <- system.file("extdata/www/yata", "yatadt.scss", package = "YATAWebCore")
    bs_add_rules(theme, sass::sass_file(dt))
    theme
}

.addRules = function(theme) {
    # bs_add_rules(theme, "main-header { padding: 0; margin-left: 0}")
    # bs_add_rules(theme, "main-header navbar{ padding: 0; margin-left: 0}")
    # bs_add_rules(theme, "navbar{ padding: 0; }")
    # bs_add_rules(theme, "navbar-static-top { padding: 8px; }")
    # Para ver si lo coge
     # theme = bs_add_rules(theme, "table.dataTable { background-color: red; }")
     # theme = bs_add_rules(theme, "table.dataTable.display.gral{ background-color: white; }")
     # theme = bs_add_rules(theme, ".table-striped tbody tr:nth-of-type(2n+1) { background-color: rgb(255,255,204); }")
     # theme = bs_add_rules(theme, ".table th,  { padding: 0; }")
     # theme = bs_add_rules(theme, ".table td { padding: 0; }")
    theme = bs_add_rules(theme, "h1, h2, h3 { margin-top: 0; }")
    theme

}

.addRulesPosition = function(theme) {
    theme = bs_add_rules(theme, "table.dataTable.display.position{ background-color: white; }")
    theme = bs_add_rules(theme, ".table-striped tbody tr:nth-of-type(2n+1) { background-color: rgb(255,255,204); }")
    theme
}

#person_rules <- system.file("custom", "person.scss", package = "bslib")
#theme <- bs_theme() %>% bs_add_rules(sass::sass_file(person_rules))
