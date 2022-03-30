DELETE FROM MESSAGES;

INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "TEST"                  ,"XX", "XX"     , "Test"                                      );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "TXT.BID"               ,"XX", "XX"     , "Bid"                                       );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "TXT.ASK"               ,"XX", "XX"     , "Ask"                                       );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "TXT.BUY"               ,"XX", "XX"     , "Comprar"                                   );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "TXT.SELL"              ,"XX", "XX"     , "Vender"                                    );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "TXT.OPEN.POS"          ,"XX", "XX"     , "Abrir posicion"                            );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "TXT.CLOSE.POS"         ,"XX", "XX"     , "Cerrar posicion"                           );

INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "XFER.OK"               ,"XX", "XX"     , "Transferencia realizada"                   );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "XFER.KO"               ,"XX", "XX"     , "Error al realizar la transferencia"        );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "MSG.SAME.CLEARING"     ,"XX", "XX"     , "Origen y destino no pueden ser iguales"    );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "MSG.INVALID.AMOUNT"    ,"XX", "XX"     , "El importe es erroneo"                     );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "MSG.AMOUNT.ERR"        ,"XX", "XX"     , "La cantidad es erronea"                    );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "MSG.PRICE.ERR"         ,"XX", "XX"     , "El precio es erroneo"                      );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "MSG.AMOUNT.EXCESS"     ,"XX", "XX"     , "La cantidad es superior a la permitida"    );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "MSG.AMOUNT.NEGATIVE"   ,"XX", "XX"     , "La cantidad debe ser positiva"             );

INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "REASON.NONE"           ,"XX", "XX"     , "Sin motivo especifico"                     );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "REASON.OTHER"          ,"XX", "XX"     , "Otros motivos"                             );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "REASON.TARGET"         ,"XX", "XX"     , "Objetivo alcanzado"                        );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "REASON.LIMIT"          ,"XX", "XX"     , "Limite alcanzado"                          );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "REASON.CHANGE"         ,"XX", "XX"     , "Cambio a otra posicion"                    );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "REASON.FAIL"           ,"XX", "XX"     , "Operacion fallida"                         );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "REASON.UP"             ,"XX", "XX"     , "Tendencia al alza"                         );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "REASON.SUGGEST"        ,"XX", "XX"     , "Recomendado"                               );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "REASON.DOWN"           ,"XX", "XX"     , "Tendencia a la baja"                       );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "REASON.TOP"            ,"XX", "XX"     , "Lista de mejores"                          );

INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "REASON.ACCEPT"         ,"XX", "XX"     , "Operacion aceptada"                        );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "REASON.CANCEL"         ,"XX", "XX"     , "Operacion cancelada"                       );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "REASON.REJECT"         ,"XX", "XX"     , "Operacion rechazada"                       );

INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "ERR.NO.OPER"           ,"XX", "XX"     , "Tipo de operacion no valida"               );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "ERR.NO.CURRENCY"       ,"XX", "XX"     , "Moneda invalida"                           );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "ERR.NO.CAMERA"         ,"XX", "XX"     , "Camara invalida"                           );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "ERR.NO.AMOUNT"         ,"XX", "XX"     , "Cantidad invalida"                         );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "ERR.NO.PRICE"          ,"XX", "XX"     , "Precio invalido"                           );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "ERR.NEG.FEE"           ,"XX", "XX"     , "Comision no puede ser negativa"            );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "ERR.NEG.GAS"           ,"XX", "XX"     , "Gas no puede ser negativo"                 );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "ERR.NO.AVAILABLE"      ,"XX", "XX"     , "No hay suficiente disponible"              );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "ERR.NO.DATA"           ,"XX", "XX"     , "Faltan datos"                              );

-- -------------------------------------------------------------------------------------------------------
-- Titulos de ventanas, cajas, titulos en si
-- -------------------------------------------------------------------------------------------------------

INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "PNL.POSITION"         ,"XX", "XX"     , "Posicion"                                    );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "PNL.OPERATION"        ,"XX", "XX"     , "Operacion"                                   );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "PNL.HISTORY"          ,"XX", "XX"     , "Historia"                                    );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "PNL.ANALYSIS"         ,"XX", "XX"     , "Analisis"                                    );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "PNL.LOG"              ,"XX", "XX"     , "Log"                                         );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "PNL.ADMIN"            ,"XX", "XX"     , "Admin"                                       );

INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "MNU.POSITION"         ,"XX", "XX"     , "Posicion"                                    );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "MNU.OPER"             ,"XX", "XX"     , "Operar"                                      );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "MNU.XFER"             ,"XX", "XX"     , "Transferir"                                  );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "MNU.REGULARIZE"       ,"XX", "XX"     , "Regularizacion"                              );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "MNU.HISTORY"          ,"XX", "XX"     , "Historia"                                    );

INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "TITLE.CURRENCIES"     ,"XX", "XX"     , "Monedas"                                     );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "TITLE.PLOTS"          ,"XX", "XX"     , "Graficos"                                    );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "TITLE.TITLE"          ,"XX", "XX"     , "Titulo"                                      );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "TITLE.SUMMARY"        ,"XX", "XX"     , "Resumen"                                     );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "TITLE.DETAIL"         ,"XX", "XX"     , "Detail"                                      );

INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "TITLE.XFER"           ,"XX", "XX"     , "Transferencias entre camaras"                );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "TITLE.REGULARIZATION" ,"XX", "XX"     , "Regularizaciones"                            );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "TITLE.OPER.ACCEPT"    ,"XX", "XX"     , "Aceptar Operación"                           );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "TITLE.OPER.EXECUTE"   ,"XX", "XX"     , "Ejecutar Operación"                          );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "TITLE.OPER.CANCEL"    ,"XX", "XX"     , "Cancelar Operación"                          );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "TITLE.OPER.REJECT"    ,"XX", "XX"     , "Operacion rechazada"                         );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "TITLE.OPER.CLOSE"     ,"XX", "XX"     , "Deshacer posición"                           );

INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "LABEL.PLOT.MAIN"     ,"XX", "XX"     , "Main Plot"                                    );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "LABEL.PLOT.AUX"      ,"XX", "XX"     , "Aux  Plot"                                    );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "LABEL.OPER.SHOW"     ,"XX", "XX"     , "Show operations"                              );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "LABEL.BTN.OK"        ,"XX", "XX"     , "Aceptar"                                      );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "LABEL.BTN.KO"        ,"XX", "XX"     , "Cancelar"                                     );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "LABEL.BTN.APPLY"     ,"XX", "XX"     , "Aplicar"                                      );

INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "LBL.AMOUNT"          ,"XX", "XX"     , "Cantidad"                                      );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "LBL.AVAILABLE"       ,"XX", "XX"     , "Disponible"                                    );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "LBL.CAMERA"          ,"XX", "XX"     , "Camara"                                        );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "LBL.CURRENCY"        ,"XX", "XX"     , "Moneda"                                        );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "LBL.DEADLINE"        ,"XX", "XX"     , "Plazo"                                         );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "LBL.FEE"             ,"XX", "XX"     , "Comision"                                      );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "LBL.FROM"            ,"XX", "XX"     , "De"                                            );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "LBL.GAS"             ,"XX", "XX"     , "Gas"                                           );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "LBL.IMPORT"          ,"XX", "XX"     , "Importe"                                       );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "LBL.LIMIT"           ,"XX", "XX"     , "Limite"                                        );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "LBL.OPER"            ,"XX", "XX"     , "Operacion"                                     );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "LBL.PRICE"           ,"XX", "XX"     , "Precio"                                        );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "LBL.REASON"          ,"XX", "XX"     , "Motivo"                                        );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "LBL.REVIEW"          ,"XX", "XX"     , "Revisar"                                       );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "LBL.STOP"            ,"XX", "XX"     , "Stop"                                          );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "LBL.SUMMARY"         ,"XX", "XX"     , "Resumen"                                       );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "LBL.TARGET"          ,"XX", "XX"     , "Objetivo"                                      );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "LBL.TO"              ,"XX", "XX"     , "A"                                             );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "LBL.VALUE"           ,"XX", "XX"     , "Valor"                                         );

INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "SUBT.APPLY"           ,"XX", "XX"     , "Aplica"                                       );

INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 51, "LABEL.RANK.0"        ,"XX", "XX"     , "Fallida"                                      );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 51, "LABEL.RANK.1"        ,"XX", "XX"     , "Mala"                                         );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 51, "LABEL.RANK.2"        ,"XX", "XX"     , "Neutra"                                       );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 51, "LABEL.RANK.3"        ,"XX", "XX"     , "Buena"                                        );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 51, "LABEL.RANK.4"        ,"XX", "XX"     , "Exito"                                        );

INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "OPER.MAKE.OPER"      ,"XX", "XX"     , "Posicion abierta. Pendiente aceptacion"       );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "OPER.MAKE.BUY"       ,"XX", "XX"     , "Compra registrada. Pendiente aceptacion"      );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "OPER.MAKE.SELL"      ,"XX", "XX"     , "Venta registrada. Pendiente aceptacion"       );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "OPER.MAKE.ERR"       ,"XX", "XX"     , "Error al realizar la operacion"               );

INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "OPER.OPEN.NONE"      ,"XX", "XX"     , "No hay posiciones abiertas"                   );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "OPER.ACCEPT.NONE"    ,"XX", "XX"     , "No hay operaciones pendientes de aceptar"     );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "OPER.EXECUTE.NONE"   ,"XX", "XX"     , "No hay operaciones pendientes de procesar"    );

INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "BOX.OPER.OPEN"       ,"XX", "XX"     , "Posiciones abiertas"                          );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "BOX.OPER.PEND"       ,"XX", "XX"     , "Pendientes aceptar"                           );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "BOX.OPER.EXEC"       ,"XX", "XX"     , "Pendientes ejecutar"                          );
                                                                                                                                                       
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "PLOT.TIT.HISTORY"    ,"XX", "XX"     , "Historico"                                    );
                                                                                                                                                       
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "ERR.REST.DOWN"        ,"XX", "XX"     , "El servidor no esta disponible"              );

-- 1 = Operaciones
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 1,  "1"        ,"XX", "XX"     , "Posicion"        );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 1,  "2"        ,"XX", "XX"     , "Compra"          );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 1,  "3"        ,"XX", "XX"     , "Venta"           );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 1,  "4"        ,"XX", "XX"     , "Transferencia"   );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 1,  "5"        ,"XX", "XX"     , "Split"           );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 1,  "6"        ,"XX", "XX"     , "Neteo"           );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 1, "10"        ,"XX", "XX"     , "Regularizacion"  );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 1, "16"        ,"XX", "XX"     , "Cierre"          );

-- 2 = Periodos. Code numerico para ordenar 
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 2,  "1"  ,"XX", "XX"     , "Hora"             );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 2,  "2"  ,"XX", "XX"     , "Dia"              );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 2,  "3"  ,"XX", "XX"     , "Semana"           );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 2,  "4"  ,"XX", "XX"     , "Mes"              );

-- 10 Monitores
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 10, "MON.CTC.COST"        ,"XX", "XX"     , "Coste"                                        );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 10, "MON.CTC.SESSION"     ,"XX", "XX"     , "Sesion"                                       );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 10, "MON.CTC.HOUR"        ,"XX", "XX"     , "Hora"                                         );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 10, "MON.CTC.DAY"         ,"XX", "XX"     , "Dia"                                          );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 10, "MON.CTC.WEEK"        ,"XX", "XX"     , "Semana"                                       );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 10, "MON.CTC.MONTH"       ,"XX", "XX"     , "Mes"                                          );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 10, "MON.FIAT.TOTAL"      ,"XX", "XX"     , "Total"                                        );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 10, "MON.FIAT.REIMB"      ,"XX", "XX"     , "Reembolsado"                                  );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 10, "MON.FIAT.SUBTOTAL"   ,"XX", "XX"     , "Subtotal"                                     );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 10, "MON.FIAT.INVEST"     ,"XX", "XX"     , "Invertido"                                    );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 10, "MON.FIAT.AVAILABLE"  ,"XX", "XX"     , "Disponible"                                   );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 10, "MON.FIAT.VALUE"      ,"XX", "XX"     , "Valor"                                        );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 10, "MON.FIAT.ACT"        ,"XX", "XX"     , "Posicion"                                     );

-- 11 Tipos de graficos
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 11, "PLOT.SESSION"        ,"XX", "XX"     , "Sesion"                                       );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 11, "PLOT.VALUE"          ,"XX", "XX"     , "Precio"                                       );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 11, "PLOT.VOLUME"         ,"XX", "XX"     , "Volumen"                                      );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 11, "PLOT.CAP"            ,"XX", "XX"     , "Capitalizacion"                               );

-- Menus
-- 7x YATAWebModels
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 70, "MODEL.MODEL"        ,"XX", "XX"     , "Modelos"                                       );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 70, "MODEL.DATA"         ,"XX", "XX"     , "Datos"                                         );
COMMIT;
