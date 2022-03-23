INSERT INTO CAMERAS  (CAMERA, DESCR , EXCHANGE, ACTIVE) VALUES ("CASH",    "FIAT Externo",   0, 0);
INSERT INTO CAMERAS  (CAMERA, DESCR , EXCHANGE, ACTIVE) VALUES ("DEFAULT", "Camara general", 0, 1);

INSERT INTO POSITION (CAMERA,    CURRENCY, BALANCE, AVAILABLE) VALUES ("CASH",    "$FIAT",     0,     0);
INSERT INTO POSITION (CAMERA,    CURRENCY, BALANCE, AVAILABLE, BUY_HIGH, BUY_LOW, BUY_LAST, BUY_NET, VALUE) 
            VALUES   ("DEFAULT", "$FIAT",    10000,    10000,         1,       1,        1,       1,     1);
            