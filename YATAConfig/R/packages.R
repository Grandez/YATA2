required = c(
     "anytime"
    ,"bslib"
    ,"configr"
    ,"dplyr"
    ,"future"
    ,"ggplot2"
    ,"hash"
    ,"htmltools"
    ,"httr"
    ,"jsonlite"
    ,"lubridate"
    ,"plotly"
    ,"plyr"
    ,"promises"
    ,"R6"
    ,"RestRserve"
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

