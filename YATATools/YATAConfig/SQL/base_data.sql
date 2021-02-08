-- ------------------------------
-- Tipos de datos
-- string =   1
-- integer = 10
-- numeric = 11
-- boolean = 20
-- tms     = 30
-- date    = 31
-- time    = 32

-- Parametros 
-- Claves:
--  1 - General
--  2 - Bases de datos
--  3 - Providers

DELETE FROM PARMS;

-- ----------------------------------------------------
-- Grupo 1 - General
--   Sub 2 - Base de datos
--           1 - autoOpen
--           2 - lastDB
--  Sub  2 - Operaciones
--           1 - alert - Dias para la proxima alerta
-- ----------------------------------------------------

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (1, 1, 1, 20, 'autoOpen' , '1');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (1, 1, 2, 10, 'lastDB'   , '2');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (1, 2, 1, 10, 'alert'    , '1');

-- ----------------------------------------------------
-- Grupo 2: Bases de datos
--   Subgrupo: Cada base de datos
--     La 0 no se deberia ver. La usamos para clonar una base de datos vacia
--     ID:
--         1 - Nombre
--         2 - Engine
--         3 - DBName
--         4 - Usuario
--         5 - password
--         6 - Host
--         7 - Puerto
-- ----------------------------------------------------


INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 0,  1,  1, 'name'     , 'Plantilla'   );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 0,  2,  1, 'engine'   , 'MariaDB'     );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 0,  3,  1, 'dbname'   , 'YATATPL'     );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 0,  4,  1, 'user'     , 'YATA'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 0,  5,  1, 'password' , 'yata'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 0,  6,  1, 'host'     , '127.0.0.1'   );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 0,  7, 10, 'port'     , '3306'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 3, 10, 20, 'active'   , '0'           );
                                                                                            
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 1,  1,  1, 'name'     , 'Operacional' );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 1,  2,  1, 'engine'   , 'MariaDB'     );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 1,  3,  1, 'dbname'   , 'YATA'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 1,  4,  1, 'user'     , 'YATA'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 1,  5,  1, 'password' , 'yata'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 1,  6,  1, 'host'     , '127.0.0.1'   );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 1,  7, 10, 'port'     , '3306'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 3, 10, 20, 'active'   , '1'           );
                                                                                            
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 2,  1,  1, 'name'     , 'Test'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 2,  2,  1, 'engine'   , 'MariaDB'     );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 2,  3,  1, 'dbname'   , 'YATATest'    );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 2,  4,  1, 'user'     , 'YATA'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 2,  5,  1, 'password' , 'yata'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 2,  6,  1, 'host'     , '127.0.0.1'   );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 2,  7, 10, 'port'     , '3306'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 3, 10, 20, 'active'   , '1'           );
                                                                                            
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 3,  1,  1, 'name'     , 'Simulacion'  );                                                                      
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 3,  2,  1, 'engine'   , 'MariaDB'     );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 3,  3,  1, 'dbname'   , 'YATASimm'    );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 3,  4,  1, 'user'     , 'YATA'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 3,  5,  1, 'password' , 'yata'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 3,  6,  1, 'host'     , '127.0.0.1'   );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 3,  7, 10, 'port'     , '3306'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 3, 10, 20, 'active'   , '1'           );

-- ----------------------------------------------------
-- Grupo 3 - Proveedores
--   Sub 1 - Online
--           1 - Proveedor de informacion Online
--           2 - Autoupdate en minutos
--           3 - Moneda base por defecto
--           4 - Hora de cierre
--   Sub 2 - Sin nombre
--           1 - Maximo numero de sessiones a recuperar paraa controlar las transacciones
-- ----------------------------------------------------

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (3, 1, 1,   1, 'default'    , 'POL');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (3, 1, 2,  10, 'autoupdate' ,   '5');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (3, 1, 3,   1, 'currency'   , 'EUR');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (3, 1, 4,  10, 'closeTime'  , '22');

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (3, 2, 1,  10, 'requests'   , '500');

-- Proveedores de datos
DELETE FROM PROVIDERS;       
INSERT INTO PROVIDERS  (PROVIDER, NAME)         VALUES ('POL',   'Poloniex'    );

-- Intercambios
DELETE FROM EXCHANGES;
INSERT INTO EXCHANGES  (CLEARING, SYMBOL, ACTIVE)  VALUES ("YATA",  "BTC",  1);
INSERT INTO EXCHANGES  (CLEARING, SYMBOL, ACTIVE)  VALUES ("YATA",  "ETH",  1);
INSERT INTO EXCHANGES  (CLEARING, SYMBOL, ACTIVE)  VALUES ("YATA",  "USDT", 1);
INSERT INTO EXCHANGES  (CLEARING, SYMBOL, ACTIVE)  VALUES ("YATA",  "XRP",  1);
INSERT INTO EXCHANGES  (CLEARING, SYMBOL, ACTIVE)  VALUES ("YATA",  "LTC",  1);
INSERT INTO EXCHANGES  (CLEARING, SYMBOL, ACTIVE)  VALUES ("YATA",  "BCH",  1);

source yata_dat_ctc.sql

COMMIT;