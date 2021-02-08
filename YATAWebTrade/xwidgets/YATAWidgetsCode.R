comboClearings = function(cash=F) {
  TClearing = TBLClearing$new()
  names  = TClearing$df[,TClearing$NAME]
  values = TClearing$df[,TClearing$ID]
  
  if (cash) {
    names  = c("Cash", names)
    values = c("Cash", values)
  }
  names(values) = names
  values
} 

comboBases = function(clearing = NULL) {
  TFiat = TBLFiat$new()
  data = TFiat$df
  if (!is.null(clearing)) {
    TPairs = TBLPairs$new()
    bases = TPairs$getBases(clearing)
    data = data %>% filter(df$SYMBOL %in% bases)
  }
  names = data[, TFiat$NAME]
  values = data[,TFiat$SYMBOL]
  names(values) = names
  values
} 
comboCounters = function() {
  TCTC = TBLCTC$new()
  names = TCTC$df[, TCTC$NAME]
  values = TCTC$df[,TCTC$SYMBOL]
  names(values) = names
  values[1:50]
} 
comboModels = function(temporary=F) {
  TMod = TBLModels$new()
  mods = TMod$getCombo()
  if (temporary) {
    nm = names(mods)
    mods = c(0, mods)
    names(mods) = c("Work", nm)
  }
  mods
} 
comboIndGroups = function() {
  YATAENV$indGroups$getCombo()
} 
comboIndNames = function(group) {
  if (group == "") return (NULL)
  YATAENV$indNames$getCombo(as.integer(group))
} 

#JGG Esto no recuerdo la pantalla (Sera del inicio)
comboBases2 = function(camera) {
  TPortfolio = TBLPortfolio$new()
  pos = TPortfolio$getClearingPosition(camera)
  TCTC = TBLCurrencies$new()
  data = TCTC$df %>% subset(TCTC$df$SYMBOL %in% pos[,TPortfolio$CTC])
  names = data[, TCTC$NAME]
  values = data[,TCTC$ID]
  names(values) = names
  values
} 

comboCurrencies = function() {
  TCTC   = TBLCurrencies$new()
  names  = TCTC$df$NAME
  values = TCTC$df$SYMBOL
  names(values) = names
  values
} 


DTPrepare = function(df) {
  tmp = df;
  # Remove auxiliar column: PRICE
  p=which(colnames(tmp) == "Price")
  if (length(p) > 0) tmp = tmp[,-p[1]]
  
  tblHead = .DTMakeHead(tmp)
  
  dt = DT::datatable(tmp, rownames = FALSE, escape=FALSE, selection = list(mode="single", target="row"))
  dt = .DTFormatColumns(tmp, dt)
  
  dt
}

.DTMakeHead <- function(data) {
  dfh = data.frame(head=character(), beg=integer(), len=integer(), stringsAsFactors = F)
  pat = "^[A-Z0-9]+_"
  w = str_extract(colnames(data), pat)
  prfx = unique(w)
  for (p in prfx) {
    if (!is.na(p)) {
      r = which(w == p)
      l = list(head=p, beg=r[1], len=length(r))
      dfh = rbind(dfh, as.data.frame(l, stringAsFactors= F))
    }
  }
  l = list(head="Data", beg=dfh[1,"beg"] - 1, len=dfh[1,"beg"])
  dfh = rbind(as.data.frame(l, stringAsFactors= F), dfh)
  dfh$head = gsub('.{1}$', '', dfh$head)
  
  head2 = gsub(pat, "", colnames(data))
  htmltools::withTags(table(
    class = 'display',
    thead(
      tr(
        lapply(1:nrow(dfh), function(x) { print(x) ; th(colspan=dfh[x,"len"], dfh[x, "head"])})
      ),
      tr(
        lapply(head2, th)
      )
    )
  ))
  
}

.DTFormatColumns <- function(tmp, dt, decFiat=2) {
  ctcCol   = c()
  lngCol   = c()
  prcCol   = c()
  datedCol = c()
  datetCol = c()
  fiatCol  = c()
  numberCol = c() 
  
  for (col in colnames(tmp)) {
    if ("fiat"       %in% class(tmp[,col])) fiatCol = c(fiatCol, col)        
    if ("ctc"        %in% class(tmp[,col])) ctcCol = c(ctcCol, col)
    if ("long"       %in% class(tmp[,col])) lngCol = c(lngCol, col)
    if ("number"     %in% class(tmp[,col])) numberCol = c(numberCol, col)        
    if ("percentage" %in% class(tmp[,col])) prcCol = c(prcCol, col)
    if ("dated"      %in% class(tmp[,col])) datedCol = c(datedCol, col)
    if ("datet"      %in% class(tmp[,col])) datetCol = c(datetCol, col)
  }
  if (length(ctcCol)    > 0) dt = dt %>% formatRound(ctcCol,    digits = 8)
  if (length(lngCol)    > 0) dt = dt %>% formatRound(lngCol,    digits = 0)
  if (length(prcCol)    > 0) dt = dt %>% formatRound(prcCol,    digits = 2)
  if (length(fiatCol)   > 0) dt = dt %>% formatRound(fiatCol,   digits = decFiat)
  if (length(numberCol) > 0) dt = dt %>% formatRound(numberCol, digits = 3)    
  
  if (length(datedCol)  > 0) dt = dt %>% formatDate (datedCol, "toLocaleDateString") 
  dt   
}