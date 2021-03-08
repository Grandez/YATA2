required = c(
     "bslib"
    ,"configr"
    ,"dplyr"
    ,"future"
    ,"htmltools"
    ,"httr"
    ,"jsonlite"
    ,"lubridate"
    ,"plyr"
    ,"promises"
    ,"R6"
    ,"rlist"
    ,"RMariaDB"
    ,"shiny"
    ,"shinyjs"
    ,"shinyBS"
    ,"shinydashboard"
    ,"shinydashboardPlus"
    ,"shinyWidgets"
    ,"stringr"
    ,"tibble"
    ,'tidyr'
    ,"zoo"
)


news = required[!(required %in% installed.packages()[,"Package"])]    
if(length(new.packages)) install.packages(new.packages, dependencies = TRUE)

