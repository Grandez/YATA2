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
--  Sub  5 - Configuracion directories
--           1 - Plugins/Extern information
--           2 - Temporary directory
-- Sub  10 - Datos de temporizacion
             1 - Session
-- --------------------------------------------------- 

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (  1,  1,  1,  1, 'Code'       , '$FIAT');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (  1,  1,  2,  1, 'FIAT'       , 'EUR');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (  1,  1,  3,  1, 'convert'    , 'eur');
                                                                                                 
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (  1,  2,  1,  1, 'camera'     , 'CASH');
                                                                             
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (  1,  3,  1, 20, 'autoOpen'   , '1');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (  1,  3,  2, 10, 'defaultDB'  , '1');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (  1,  3,  3, 10, 'lastDB'     , '1');
                                                                                                 
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (  1,  4,  1, 10, 'alert'      , '1');

-- Bloque Session
-- interval - Cada cuanto tiempo chequeamos datos
-- alive    - Cuantas veces obtenemos datos
-- history  - Historia a mantener
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  1, 10,  1,  1, 10, 'interval'    , '15');
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  1, 10,  1,  2, 10, 'alive'       , '16');
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  1, 10,  1,  3, 10, 'history'     , '48');

INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  1, 11,  1,  1, 10, 'each'        ,  '3');
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  1, 11,  1,  2, 10, 'sleep'       ,  '1');

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


INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5, 100, 100,  1,  1, 'name'     , 'Base'          );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5, 100, 100,  2,  1, 'engine'   , 'MariaDB'       );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5, 100, 100,  3,  1, 'dbname'   , 'YATABase'      );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5, 100, 100,  4,  1, 'user'     , 'YATA'          );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5, 100, 100,  5,  1, 'password' , 'yata'          );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5, 100, 100,  6,  1, 'host'     , '127.0.0.1'     );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5, 100, 100,  7, 10, 'port'     , '3306'          );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5, 100, 100,  8,  1, 'descr'    , 'YATA system'   );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5, 100, 100, 10, 20, 'active'   , '0'             );

INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5, 101, 101,  1,  1, 'name'     , 'Data'          );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5, 101, 101,  2,  1, 'engine'   , 'MariaDB'       );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5, 101, 101,  3,  1, 'dbname'   , 'YATAData'      );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5, 101, 101,  4,  1, 'user'     , 'YATA'          );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5, 101, 101,  5,  1, 'password' , 'yata'          );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5, 101, 101,  6,  1, 'host'     , '127.0.0.1'     );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5, 101, 101,  7, 10, 'port'     , '3306'          );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5, 101, 101,  8,  1, 'descr'    , 'Common Data'   );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5, 101, 101, 10, 20, 'active'   , '0'             );
                                                                                                              
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5,   1,   1,  1,  1, 'name'     , 'Real'          );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5,   1,   1,  2,  1, 'engine'   , 'MariaDB'       );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5,   1,   1,  3,  1, 'dbname'   , 'YATA'          );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5,   1,   1,  4,  1, 'user'     , 'YATA'          );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5,   1,   1,  5,  1, 'password' , 'yata'          );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5,   1,   1,  6,  1, 'host'     , '127.0.0.1'     );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5,   1,   1,  7, 10, 'port'     , '3306'          );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5,   1,   1,  8,  1, 'descr'    , 'Operacional'   );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5,   1,   1, 10, 20, 'active'   , '1'             );
                                                                               
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5,   2,   2,  1,  1, 'name'     , 'Test'          );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5,   2,   2,  2,  1, 'engine'   , 'MariaDB'       );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5,   2,   2,  3,  1, 'dbname'   , 'YATATest'      );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5,   2,   2,  4,  1, 'user'     , 'YATA'          );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5,   2,   2,  5,  1, 'password' , 'yata'          );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5,   2,   2,  6,  1, 'host'     , '127.0.0.1'     );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5,   2,   2,  7, 10, 'port'     , '3306'          );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5,   2,   2,  8,  1, 'descr'    , 'Datos de test' );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5,   2,   2, 10, 20, 'active'   , '1'             );
                                                                               
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5,   3,   3,  1,  1, 'name'     , 'Simm'          );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5,   3,   3,  2,  1, 'engine'   , 'MariaDB'       );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5,   3,   3,  3,  1, 'dbname'   , 'YATASimm'      );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5,   3,   3,  4,  1, 'user'     , 'YATA'          );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5,   3,   3,  5,  1, 'password' , 'yata'          );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5,   3,   3,  6,  1, 'host'     , '127.0.0.1'     );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5,   3,   3,  7, 10, 'port'     , '3306'          );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5,   3,   3,  8,  1, 'descr'    , 'Simulacion'    );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (5,   3,   3, 10, 20, 'active'   , '1'             );

-- ----------------------------------------------------
-- Grupos 50 - Combos y grupos
--   Sub  1  - Operaciones (key tiene que coincidir con los codigos de las tablas)
--             Los pares (0) crean-entran / impares (1) venden-salen
--   Sub  2  - Razones

--   Sub  5 - Log aplica
-- ----------------------------------------------------

INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  1,  1,  1,  1, 'label'      ,  'TXT.BID'      );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  1,  2,  1,  1, 'label'      ,  'TXT.ASK'      );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  1,  3,  1,  1, 'label'      ,  'TXT.BUY'      );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  1,  4,  1,  1, 'label'      ,  'TXT.SELL'     );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  1,  5,  1,  1, 'label'      ,  'TXT.OPEN'     );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  1,  6,  1,  1, 'label'      ,  'TXT.CLOSE'    );

INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  1,  1,  2, 10, 'key'       ,  '10'           );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  1,  2,  2, 10, 'key'       ,  '11'           );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  1,  3,  2, 10, 'key'       ,  '20'           );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  1,  4,  2, 10, 'key'       ,  '21'           );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  1,  5,  2, 10, 'key'       ,  '30'           ); 
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  1,  6,  2, 10, 'key'       ,  '31'           );

-- INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  1,  7,  1,  1, 'label'     ,  'TXT.REG'      );
-- INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  1,  7,  2, 10, 'key'       ,  '41'           );

-- ----------------------------------------------------
-- Grupo 15 - Motivos 
--  El subgrupo coincide cn el codigo  de la operacion
--  ID esta codificado
--     xx0 - Todos
--     xx1 - Compras
--     xx2 - Ventas
--     xx3 - Eventos en operaciones
-- ----------------------------------------------------

INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,   0,  1,   1, 'label'    , 'REASON.NONE'       );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  10,  1,   1, 'label'    , 'REASON.FAIL'       );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  20,  1,   1, 'label'    , 'REASON.OTHER'      );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  11,  1,   1, 'label'    , 'REASON.UP'         );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  21,  1,   1, 'label'    , 'REASON.SUGGEST'    );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  31,  1,   1, 'label'    , 'REASON.TOP'        );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  12,  1,   1, 'label'    , 'REASON.DOWN'       );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  22,  1,   1, 'label'    , 'REASON.TARGET'     );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  32,  1,   1, 'label'    , 'REASON.LIMIT'      );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  42,  1,   1, 'label'    , 'REASON.CHANGE'     );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  13,  1,   1, 'label'    , 'REASON.ACCEPT'     );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  23,  1,   1, 'label'    , 'REASON.EXECUTED'   );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  33,  1,   1, 'label'    , 'REASON.CANCEL'     );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  43,  1,   1, 'label'    , 'REASON.REJECT'     );

INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,   0,  2,  10,  'key'    , ' 0'   );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  10,  2,  10,  'key'    , '98'   );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  20,  2,  10,  'key'    , '99'   );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  11,  2,  10,  'key'    , '11'   );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  21,  2,  10,  'key'    , '12'   );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  31,  2,  10,  'key'    , '13'   );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  12,  2,  10,  'key'    , '21'   );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  22,  2,  10,  'key'    , '41'   );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  32,  2,  10,  'key'    , '42'   );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  42,  2,  10,  'key'    , '43'   );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  13,  2,  10,  'key'    , '90'   );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  23,  2,  10,  'key'    , '91'   );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  33,  2,  10,  'key'    , '92'   );
INSERT INTO PARMS (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  43,  2,  10,  'key'    , '93'   );

COMMIT;