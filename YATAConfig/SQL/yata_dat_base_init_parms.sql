-- ------------------------------
-- Tipos de datos
-- string =   1
-- integer = 10
-- numeric = 11
-- boolean = 20
-- tms     = 30
-- date    = 31
-- time    = 32


DELETE FROM PARMS;

-- ----------------------------------------------------
-- Grupo 1 - General
--   Sub 1 - Configuracion
--           1 - Moneda por defecto
--           2 - Moneda alternativa
--           3 - Directorio de plugins 
--           4 - Monedas por defecto     
--   Sub 2 - Base de datos
--           1 - autoOpen
--           2 - Base de datos de defecto
--           3 - lastDB
--  Sub  3 - Operaciones
--           1 - alert - Dias para la proxima alerta
--  Sub  4 - REST Server            
--           1 - URL
--           2 - Port
-- --------------------------------------------------2- 

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (1, 1, 1,  1, 'currency'    , 'EUR');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (1, 1, 2,  1, 'altcurrency' , 'USD');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (1, 1, 3,  1, 'Plugins'  , 'P:\\R\\YATA2\\YATAExternal');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (1, 1, 4, 10, 'Monedas'  , '1000');

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (1, 2, 1, 20, 'autoOpen' , '1');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (1, 2, 2, 10, 'defaultDB', '2');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (1, 2, 3, 10, 'lastDB'   , '2');

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (1, 3, 1, 10, 'alert'    , '1');

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (1, 4, 1,  1, 'URL'      , '127.0.0.1');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (1, 4, 2, 10, 'PortL'    , '9090');
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
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (3, 1, 4,  10, 'closeTime'  , '22');

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (3, 2, 1,  10, 'requests'   , '500');


-- ----------------------------------------------------
-- Grupo 10 - Preferencias
--   Sub 1 - Match posicion (expresado en dias)
-- ----------------------------------------------------


INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 10, 1, 1,   10, ''    , ' 0');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 10, 1, 2,   10, ''    , ' 1');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 10, 1, 3,   10, ''    , ' 7');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 10, 1, 4,   10, ''    , '30');

-- ----------------------------------------------------
-- Grupo 15 - Motivos
--   Sub  0 - Comunes a todas
--   Sub  1 - Para compras
--   Sub  2 - Para ventas
--   Sub  3 - Para tomar posicion
--   Sub  4 - Para cerrar posicion
--   Sub 99 - Fijos en programa (YATACodes/reasons)
-- El id es el codigo de la razon, por eso deben ser distintos
-- El texto esta en la tabla de mensajes con prefijo REASON
-- ----------------------------------------------------

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 15,  0,  0,    1, ''    , 'NONE'       );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 15,  0, 98,    1, ''    , 'FAIL'       );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 15,  0, 99,    1, ''    , 'OTHER'      );
                                                                         
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 15,  1, 11,    1, ''    ,  'UP'        );
                                                                         
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 15,  2, 21,    1, ''    ,  'DOWN'      );
                                                                         
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 15,  4, 41,    1, ''    , 'TARGET'     );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 15,  4, 42,    1, ''    , 'LIMIT'      );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 15,  4, 43,    1, ''    , 'CHANGE'     );

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 15, 99, 90,    1, ''    , 'ACCEPT'     );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 15, 99, 91,    1, ''    , 'EXECUTED'   );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 15, 99, 92,    1, ''    , 'CANCEL'     );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 15, 99, 93,    1, ''    , 'REJECT'     );


-- ----------------------------------------------------
-- Grupo 5: Bases de datos
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


INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 0,  1,  1, 'name'     , 'Base'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 0,  2,  1, 'engine'   , 'MariaDB'     );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 0,  3,  1, 'dbname'   , 'YATABase'    );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 0,  4,  1, 'user'     , 'YATA'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 0,  5,  1, 'password' , 'yata'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 0,  6,  1, 'host'     , '127.0.0.1'   );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 0,  7, 10, 'port'     , '3306'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 0, 10, 20, 'active'   , '0'           );
                                                                                            
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 1,  1,  1, 'name'     , 'Operacional' );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 1,  2,  1, 'engine'   , 'MariaDB'     );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 1,  3,  1, 'dbname'   , 'YATA'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 1,  4,  1, 'user'     , 'YATA'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 1,  5,  1, 'password' , 'yata'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 1,  6,  1, 'host'     , '127.0.0.1'   );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 1,  7, 10, 'port'     , '3306'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 1, 10, 20, 'active'   , '1'           );
                                                                                            
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 2,  1,  1, 'name'     , 'Test'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 2,  2,  1, 'engine'   , 'MariaDB'     );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 2,  3,  1, 'dbname'   , 'YATATest'    );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 2,  4,  1, 'user'     , 'YATA'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 2,  5,  1, 'password' , 'yata'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 2,  6,  1, 'host'     , '127.0.0.1'   );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 2,  7, 10, 'port'     , '3306'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 2, 10, 20, 'active'   , '1'           );
                                                                                            
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 3,  1,  1, 'name'     , 'Simulacion'  );                                                                      
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 3,  2,  1, 'engine'   , 'MariaDB'     );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 3,  3,  1, 'dbname'   , 'YATASimm'    );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 3,  4,  1, 'user'     , 'YATA'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 3,  5,  1, 'password' , 'yata'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 3,  6,  1, 'host'     , '127.0.0.1'   );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 3,  7, 10, 'port'     , '3306'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (5, 3, 10, 20, 'active'   , '1'           );

COMMIT;