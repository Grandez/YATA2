DELETE FROM MESSAGES;

INSERT INTO MESSAGES  (CODE, LANG, REGION, MSG) VALUES ( "XFER.OK"               ,"XX", "XX"     , "Trasnferencia realizada"                   );
INSERT INTO MESSAGES  (CODE, LANG, REGION, MSG) VALUES ( "XFER.KO"               ,"XX", "XX"     , "Error al realizar la transferencia"        );
INSERT INTO MESSAGES  (CODE, LANG, REGION, MSG) VALUES ( "OK.XFER"               ,"XX", "XX"     , "Trasnferencia realizada"                   );
INSERT INTO MESSAGES  (CODE, LANG, REGION, MSG) VALUES ( "OK.OPER"               ,"XX", "XX"     , "Operacion Realizada: %s"                   );
INSERT INTO MESSAGES  (CODE, LANG, REGION, MSG) VALUES ( "MSG.SAME.CLEARING"     ,"XX", "XX"     , "Origen y destino no pueden ser iguales"    );
INSERT INTO MESSAGES  (CODE, LANG, REGION, MSG) VALUES ( "MSG.INVALID.AMOUNT"    ,"XX", "XX"     , "El importe es erroneo"                     );
INSERT INTO MESSAGES  (CODE, LANG, REGION, MSG) VALUES ( "MSG.AMOUNT.ERR"        ,"XX", "XX"     , "La cantidad es erronea"                    );
INSERT INTO MESSAGES  (CODE, LANG, REGION, MSG) VALUES ( "MSG.PRICE.ERR"         ,"XX", "XX"     , "El precio es erroneo"                      );

INSERT INTO MESSAGES  (CODE, LANG, REGION, MSG) VALUES ( "REASON.NONE"           ,"XX", "XX"     , "Sin motivo especifico"                     );
INSERT INTO MESSAGES  (CODE, LANG, REGION, MSG) VALUES ( "REASON.OTHER"          ,"XX", "XX"     , "Otros motivos"                             );
INSERT INTO MESSAGES  (CODE, LANG, REGION, MSG) VALUES ( "REASON.TARGET"         ,"XX", "XX"     , "Objetivo alcanzado"                        );
INSERT INTO MESSAGES  (CODE, LANG, REGION, MSG) VALUES ( "REASON.LIMIT"          ,"XX", "XX"     , "Limite alcanzado"                          );
INSERT INTO MESSAGES  (CODE, LANG, REGION, MSG) VALUES ( "REASON.CHANGE"         ,"XX", "XX"     , "Cambio a otra posicion"                    );
INSERT INTO MESSAGES  (CODE, LANG, REGION, MSG) VALUES ( "REASON.FAIL"           ,"XX", "XX"     , "Operacion fallida"                         );
INSERT INTO MESSAGES  (CODE, LANG, REGION, MSG) VALUES ( "REASON.UP"             ,"XX", "XX"     , "Tendencia al alza"                         );
INSERT INTO MESSAGES  (CODE, LANG, REGION, MSG) VALUES ( "REASON.DOWN"           ,"XX", "XX"     , "Tendencia a la baja"                       );
COMMIT;
