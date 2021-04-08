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
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "REASON.DOWN"           ,"XX", "XX"     , "Tendencia a la baja"                       );

INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "REASON.ACCEPT"         ,"XX", "XX"     , "Operacion aceptada"                        );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "REASON.CANCEL"         ,"XX", "XX"     , "Operacion cancelada"                       );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "REASON.REJECT"         ,"XX", "XX"     , "Operacion rechazada"                       );


INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "TITLE.XFER"           ,"XX", "XX"     , "Transferir entre cuentas"                    );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "TITLE.OPER.ACCEPT"    ,"XX", "XX"     , "Aceptar Operación"                           );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "TITLE.OPER.EXECUTE"   ,"XX", "XX"     , "Ejecutar Operación"                          );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "TITLE.OPER.CANCEL"    ,"XX", "XX"     , "Cancelar Operación"                          );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "TITLE.OPER.REJECT"    ,"XX", "XX"     , "Operacion rechazada"                         );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "TITLE.OPER.CLOSE"     ,"XX", "XX"     , "Deshacer posición"                           );

INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "OPER.MAKE.OPER"      ,"XX", "XX"     , "Posicion abierta. Pendiente aceptacion"       );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "OPER.MAKE.BUY"       ,"XX", "XX"     , "Compra registrada. Pendiente aceptacion"      );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "OPER.MAKE.SELL"      ,"XX", "XX"     , "Venta registrada. Pendiente aceptacion"       );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "OPER.MAKE.ERR"       ,"XX", "XX"     , "Error al realizar la operacion"               );

INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "OPER.PEND.ACCEPT"    ,"XX", "XX"     , "No hay operaciones pendientes de aceptar"     );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "OPER.PEND.EXECUTE"   ,"XX", "XX"     , "No hay operaciones pendientes de procesar"    );

INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "BOX.OPER.OPEN"       ,"XX", "XX"     , "Posiciones abiertas"                         );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "BOX.OPER.PEND"       ,"XX", "XX"     , "Pendientes aceptar"                          );
INSERT INTO MESSAGES  (BLOCK, CODE, LANG, REGION, MSG) VALUES ( 0, "BOX.OPER.EXEC"       ,"XX", "XX"     , "Pendientes ejecutar"                         );
                                                                                                                                                       
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
COMMIT;
