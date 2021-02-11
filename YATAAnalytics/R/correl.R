library(dplyr)
library(XLConnect)
library(reshape2)
library(Hmisc)

XLConnect::xlcFreeMemory()
gc()
wb = loadWorkbook("d:/prj/R/YATA/YATAData/in/currencies.xlsx")
shn = getSheets(wb)
shn = shn[which(shn != "$Index")]
shn = shn[which(shn != "BTC")]
shn = shn[which(shn != "USDT")]

tmp = readWorksheet(wb, "BTC")
tmp = tmp %>% arrange(Date) %>% filter(as.Date(Date) > as.Date("2016-12-31"))
df = tmp[,c("Date","Close")]
colnames(df) = c("Date", "BTC")

for (sh in shn) {
    cat(sh, "\n")
  tmp = readWorksheet(wb, sh)
  tmp = tmp %>% arrange(Date) %>% filter(Date > "2016-12-31")
  tmp = tmp[,c("Date","Close")]
  colnames(tmp) = c("Date", sh)
  df = full_join(df,tmp, by="Date")

}

dfl = melt(df, id="Date")
#ggplot(data=dfl,aes(x=Date, y=value, colour=variable)) + geom_line()


#rcorr(as.matrix(df[,2:ncol(df)]))

# Ahora sin BTC

shn = shn[which(shn != "BTC")]
tmp = readWorksheet(wb, "ADA")
tmp = tmp %>% arrange(Date) %>% filter(as.Date(Date) > as.Date("2016-12-31"))
df = tmp[,c("Date","Close")]
colnames(df) = c("Date", "BTC")

for (sh in shn) {
    cat(sh, "\n")
  tmp = readWorksheet(wb, sh)
  tmp = tmp %>% arrange(Date) %>% filter(Date > "2016-12-31")
  tmp = tmp[,c("Date","Close")]
  colnames(tmp) = c("Date", sh)
  df = full_join(df,tmp, by="Date")

}

dfl = melt(df, id="Date")
ggplot(data=dfl,aes(x=Date, y=value, colour=variable)) + geom_line()


#rcorr(as.matrix(df[,2:ncol(df)]))

