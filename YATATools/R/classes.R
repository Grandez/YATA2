# Inserta en el df las clases propias para edicion
yataGetClasses = function() {
   c( "Text"  , "Label"
     ,"Number", "Integer", "Percentage", "Amount"
     ,"Date"  , "Time"   , "Tms" )
}
yataSetClasses = function(df, prc = c(), tms=c(), int=c(), lbl=c(), dat=c(), tim=c(), imp =c()) {
    for (idx in 1:ncol(df)) {
        cls = class(df[,idx])
        if (idx %in% prc) { class(df[,idx]) = c(cls, "yataPercentage"); next}
        if (idx %in% tms) { class(df[,idx]) = c(cls, "yataTms");        next}
        if (idx %in% int) { class(df[,idx]) = c(cls, "yataInteger");    next}
        if (idx %in% imp) { class(df[,idx]) = c(cls, "yataAmount");     next}
        if (idx %in% lbl) { class(df[,idx]) = c(cls, "yataLabel");      next}
        if (idx %in% dat) { class(df[,idx]) = c(cls, "yataDate");       next}
        if (idx %in% tim) { class(df[,idx]) = c(cls, "yataTime");       next}

        if ("numeric"   %in% cls) class(df[,idx]) = c(cls, "yataNumber")
        if ("character" %in% cls) class(df[,idx]) = c(cls, "yataText")
    }
    df
}
