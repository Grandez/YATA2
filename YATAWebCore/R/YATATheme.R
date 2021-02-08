YATATheme2 = function(base = "cerulean") {
    bslib::bs_theme(bootswatch = base) %>% .addDeclarations() %>% .addRules()
}

.addDeclarations = function(theme) {
    dt <- system.file("extdata/www/yata", "yatadt.scss", package = "YATAWebCore")
    bs_add_rules(theme, sass::sass_file(dt))
}

.addRules = function(theme) {
    bs_add_rules(theme, "main-header { padding: 0; margin-left: 0}")
    bs_add_rules(theme, "main-header navbar{ padding: 0; margin-left: 0}")
    bs_add_rules(theme, "navbar{ padding: 0; }")
    bs_add_rules(theme, "navbar-static-top { padding: 8px; }")
    bs_add_rules(theme, "table.dataTable { background-color: blue; }")
    bs_add_rules(theme, "table.dataTable.display.gral{ background-color: white; }")
    bs_add_rules(theme, ".table-striped tbody tr:nth-of-type(2n+1) { background-color: rgba(255,255,224,0.05); }")
    bs_add_rules(theme, ".table th,  { padding: 0; }")
    bs_add_rules(theme, ".table td { padding: 0; }")

}

#person_rules <- system.file("custom", "person.scss", package = "bslib")
#theme <- bs_theme() %>% bs_add_rules(sass::sass_file(person_rules))
