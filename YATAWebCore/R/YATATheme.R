YATATheme = function(base = "cerulean") {
    bslib::bs_theme(bootswatch = base) %>%
                   .addDeclarations() %>%
                   .addRules() %>%
                   .addRulesPosition
}

.addDeclarations = function(theme) {
    # dt <- system.file("extdata/www/yata", "yatadt.scss", package = "YATAWebCore")
    # bs_add_rules(theme, sass::sass_file(dt))
    theme
}

.addRules = function(theme) {
    # bs_add_rules(theme, "main-header { padding: 0; margin-left: 0}")
    # bs_add_rules(theme, "main-header navbar{ padding: 0; margin-left: 0}")
    # bs_add_rules(theme, "navbar{ padding: 0; }")
    # bs_add_rules(theme, "navbar-static-top { padding: 8px; }")
    # Para ver si lo coge
    theme = bs_add_rules(theme, "table.dataTable { background-color: blue; }") # Chequeo
    theme = bs_add_rules(theme, "table.dataTable.display.gral{ background-color: white; }")
    theme = bs_add_rules(theme, ".table-striped tbody tr:nth-of-type(2n+1) { background-color: rgb(255,255,204); }")
    theme = bs_add_rules(theme, ".table th,  { padding: 0; }")
    theme = bs_add_rules(theme, ".table.dataTable td { padding: 0 5px 0 0; }")
    theme

}

.addRulesPosition = function(theme) {
    theme = bs_add_rules(theme, "table.dataTable.display.position{ background-color: white; }")
    theme = bs_add_rules(theme, ".table-striped tbody tr:nth-of-type(2n+1) { background-color: rgb(255,255,204); }")
    theme
}
