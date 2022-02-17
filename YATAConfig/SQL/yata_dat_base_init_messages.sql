DELETE FROM MESSAGES;

INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "XFER.OK"               ,"XX", "XX"     , "Trasnferencia realizada"                   );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "XFER.KO"               ,"XX", "XX"     , "Error al realizar la transferencia"        );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "OK.XFER"               ,"XX", "XX"     , "Trasnferencia realizada"                   );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "OK.OPER"               ,"XX", "XX"     , "Operacion Realizada: %s"                   );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "MSG.SAME.CLEARING"     ,"XX", "XX"     , "Origen y destino no pueden ser iguales"    );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "MSG.INVALID.AMOUNT"    ,"XX", "XX"     , "El importe es erroneo"                     );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "MSG.AMOUNT.ERR"        ,"XX", "XX"     , "La cantidad es erronea"                    );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "MSG.PRICE.ERR"         ,"XX", "XX"     , "El precio es erroneo"                      );

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

-- -------------------------------------------------------------------------------------------------------
-- Titulos de ventanas, cajas, titulos en si
-- -------------------------------------------------------------------------------------------------------

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
