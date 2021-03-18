YATAPage2("YATA Configuration", id="mainMenu"
  ,tabPanel("Configuracion", value=pnl$parms,  YATASubModule("Parms",      pnl$parms  , "", leftside=FALSE))
  ,tabPanel("Datos",         value=pnl$data,   YATAModule("Data",       pnl$data   , ""))
  ,tabPanel("Camaras",       value=pnl$camera, YATAModule("Cameras",    pnl$camera , ""))
  ,tabPanel("Monedas",       value=pnl$ctc,    YATAModule("Currencies", pnl$ctc    , ""))
  ,tabPanel("Proveedores",   value=pnl$prov,   YATAModule("Providers",  pnl$prov   , ""))
)
