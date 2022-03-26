-- ------------------------------
-- ID = 0 Se reserva para la eiqueta de listas
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
-- Grupo 1 - Configuracion general
--   Sub 1 - Moneda
--           1 - Codigo de la moneda en el sistema
--           2 - Codigo ISO de la moneda por defecto
--           3 - Clave para convertir cotizacion
--
--   Sub 2 - Camara
--           1 - Camara FIAT (Cuenta corriente real)
--
--   Sub 3 - Base de datos
--           1 - autoOpen
--           2 - Base de datos de defecto
--           3 - lastDB
--  Sub  4 - Operaciones
--           1 - alert - Dias para la proxima alerta
-- Sub 
-- --------------------------------------------------- 

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (1, 1, 1,  1, 'Code'    , '$FIAT');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (1, 1, 2,  1, 'FIAT'    , 'EUR');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (1, 1, 3,  1, 'convert' , 'eur');

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (1, 2, 1,  1, 'camera'  , 'CASH');

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (1, 3, 1, 20, 'autoOpen' , '1');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (1, 3, 2, 10, 'defaultDB', '1');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (1, 3, 3, 10, 'lastDB'   , '1');

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (1, 4, 1, 10, 'alert'    , '1');

-- ----------------------------------------------------
-- Grupo 2 - Servers
--   Sub  1 - Web Server
--        2 - Admin Server
--        3 - Other Server
--        5 - REST Online
--        6 - REST Deferred
--        7 - REST Batch  
--       10 - Database Server BASE
--       11 - Database Server DATA
--       12 - Database Server CI
--       14 - Database Server Instances
-- ----------------------------------------------------

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  1,  0,  1, 'label'    , 'Web');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  1,  1,  1, 'name'     , 'Web server');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  1,  2,  1, 'url'      , 'http://127.0.0.1');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  1,  3, 10, 'port'     , '80');

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  2,  0,  1, 'label'    , 'WebAdmin');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  2,  1,  1, 'name'     , 'Web Admin server');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  2,  2,  1, 'url'      , 'http://127.0.0.1');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  2,  3, 10, 'port'     , '3939');

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  5,  0,  1, 'label'    , 'REST');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  5,  1,  1, 'name'     , 'REST Service');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  5,  2,  1, 'url'      , 'http://127.0.0.1');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  5,  3, 10, 'port'     , '4005');

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  6,  0,  1, 'label'    , 'Deferred');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  6,  1,  1, 'name'     , 'REST Deferred');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  6,  2,  1, 'url'      , 'http://127.0.0.1');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  6,  3, 10, 'port'     , '4006');

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  7,  0,  1, 'label'    , 'Batch');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  7,  1,  1, 'name'     , 'REST Batch');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  7,  2,  1, 'url'      , 'http://127.0.0.1');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  7,  3, 10, 'port'     , '4007');

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 10,  0,  1, 'label'    , 'DB_BASE');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 10,  1,  1, 'name'     , 'Base Database');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 10,  2,  1, 'url'      , '127.0.0.1');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 10,  3, 10, 'port'     , '4007');

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 11,  0,  1, 'label'    , 'DB_DATA');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 11,  1,  1, 'name'     , 'Data Database');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 11,  2,  1, 'url'      , '127.0.0.1');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 11,  3, 10, 'port'     , '4007');

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 12,  0,  1, 'label'    , 'DB_CI');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 12,  1,  1, 'name'     , 'CI Database');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 12,  2,  1, 'url'      , '127.0.0.1');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 12,  3, 10, 'port'     , '4007');

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 14,  0,  1, 'label'    , 'DB_USER');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 14,  1,  1, 'name'     , 'Instances Database');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 14,  2,  1, 'url'      , '127.0.0.1');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 14,  3, 10, 'port'     , '4007');


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
--  El subgrupo coincide cn el codigo  de la operacion
--  El text es la clave para REASON.text
--   Sub   0 - Comunes a todas
--   Sub  20 - Para compras/posicion
--   Sub  30 - Para ventas
--   Sub  3 - Para tomar posicion
--   Sub  4 - Para cerrar posicion
--   Sub 99 - Fijos en programa (YATACodes/reasons)
-- El id es el codigo de la razon, por eso deben ser distintos
-- El texto esta en la tabla de mensajes con prefijo REASON
-- ----------------------------------------------------

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 15,  0,  0,    1, ''    , 'NONE'       );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 15,  0, 98,    1, ''    , 'FAIL'       );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 15,  0, 99,    1, ''    , 'OTHER'      );
                                                                         
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 15, 20, 11,    1, ''    ,  'UP'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 15, 20, 12,    1, ''    ,  'SUGGEST'   );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 15, 20, 13,    1, ''    ,  'TOP'       );
                                                                         
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 15, 30, 21,    1, ''    ,  'DOWN'      );


                                                                         
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 15,  4, 41,    1, ''    , 'TARGET'     );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 15,  4, 42,    1, ''    , 'LIMIT'      );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 15,  4, 43,    1, ''    , 'CHANGE'     );

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 15, 99, 90,    1, ''    , 'ACCEPT'     );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 15, 99, 91,    1, ''    , 'EXECUTED'   );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 15, 99, 92,    1, ''    , 'CANCEL'     );
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 15, 99, 93,    1, ''    , 'REJECT'     );

-- ----------------------------------------------------
-- Grupo 16 - Combos
--   Sub  1 - Operaciones
-- ----------------------------------------------------
-- INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (16,  1,  1,  10, 'Abrir posicion' ,   '1');
-- INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (16,  1,  1,  10, 'Comprar' ,   '1');
-- INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (16,  1,  1,  10, 'Vender' ,   '1');

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