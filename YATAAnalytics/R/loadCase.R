library(XLConnect)
library(plotly)
case="batch_20181027_142527"
XLConnect::xlcFreeMemory()
gc()
df = read.csv(paste0("d:/prj/R/YATA/YATAData/out/",case,".csv"),sep=";",dec=",")
# 
# plot_ly(df, x = ~Trend, y = ~Res, z = ~Period) %>% add_markers()
# plot_ly(df, x = ~Trend, y = ~Res, color = ~Period) %>% add_markers()

table(sign(df$Res))
tbl=NULL
for (w in unique(df$window)) {
 #tbl = rbind(tbl,table(sign(df[df$window == w,"Res"])))
   table(sign(df[df$window == w,"Res"]))
}


# TUSD Vale 1.11 respecto al USDT, pero contra el dólar no tiene esa diferencia, 
# no es que haya subido el TUSD tanto respecto al dólar, sino que el Tether ha caído, 
# de ahí esa diferencia de precio respecto el TUSD. 