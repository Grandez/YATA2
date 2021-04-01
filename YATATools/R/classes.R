# Inserta en el df las clases propias para edicion
yataGetClasses = function() {
   c( "Text"  , "Label"
     ,"Number", "Integer", "Percentage", "Amount"
     ,"Date"  , "Time"   , "Tms" )
}
# yataSetClasses = function(df, prc = c(), tms=c(), int=c(), lbl=c(), dat=c(), tim=c(), imp =c()) {
#     if (is.character(prc)) prc = which(colnames(df) %in% prc)
#     if (is.character(tms)) tms = which(colnames(df) %in% tms)
#     if (is.character(int)) int = which(colnames(df) %in% int)
#     if (is.character(lbl)) lbl = which(colnames(df) %in% lbl)
#     if (is.character(dat)) dat = which(colnames(df) %in% dat)
#     if (is.character(tim)) tim = which(colnames(df) %in% tim)
#     if (is.character(imp)) imp = which(colnames(df) %in% imp)
#     for (idx in 1:ncol(df)) {
#         cls = class(df[,idx])
#         if (idx %in% prc) { class(df[,idx]) = c(cls, "yataPercentage"); next}
#         if (idx %in% tms) { class(df[,idx]) = c(cls, "yataTms");        next}
#         if (idx %in% int) { class(df[,idx]) = c(cls, "yataInteger");    next}
#         if (idx %in% imp) { class(df[,idx]) = c(cls, "yataAmount");     next}
#         if (idx %in% lbl) { class(df[,idx]) = c(cls, "yataLabel");      next}
#         if (idx %in% dat) { class(df[,idx]) = c(cls, "yataDate");       next}
#         if (idx %in% tim) { class(df[,idx]) = c(cls, "yataTime");       next}
#
#         if ("numeric"   %in% cls) class(df[,idx]) = c(cls, "yataNumber")
#         if ("character" %in% cls) class(df[,idx]) = c(cls, "yataText")
#     }
#     df
# }
