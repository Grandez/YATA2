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
-- mensaje = 99


DELETE FROM PARAMETERS;

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

-- Datos por defecto para el usuario

INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (  1,  1,  1,  1, 'Code'       , '$FIAT');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (  1,  1,  2,  1, 'FIAT'       , 'EUR');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (  1,  1,  3,  1, 'convert'    , 'eur');
                                                                                                 
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (  1,  2,  1,  1, 'camera'     , 'CASH');
                                                                             
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (  1,  3,  1, 20, 'autoOpen'   , '1');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (  1,  3,  2, 10, 'defaultDB'  , '1');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (  1,  3,  3, 10, 'lastDB'     , '1');
                                                                                                 
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (  1,  4,  1, 10, 'alert'      , '1');

-- Bloque Session
-- interval - Cada cuanto tiempo chequeamos datos
-- alive    - Cuantas veces obtenemos datos
-- history  - Historia a mantener
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  1, 10,  1,  1, 10, 'interval'    , '15');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  1, 10,  1,  2, 10, 'alive'       , '16');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  1, 10,  1,  3, 10, 'history'     , '48');

INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  1, 11,  1,  1, 10, 'each'        ,  '3');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  1, 11,  1,  2, 10, 'sleep'       ,  '1');

-- ----------------------------------------------------
-- Grupo 4 - Portfolios / Carteras
--   scope - Tipo de cartera 
--           1 - Corto plazo / Intradia
--           2 - Medio plazo 
--           3 - Largo plazo / inversion
--   type - Uso/tipo de la cartera (Por definir)
--           1 - Operativa
--          10 - Simulacion
--          20 - Pruebas
-- ----------------------------------------------------

INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (4,   1,   1,  1,  1, 'name'     , 'Cartera 1'     );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (4,   1,   1,  2,  1, 'title'    , 'SHORT'         );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (4,   1,   1,  3,  1, 'type'     , '1'             );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (4,   1,   1,  4, 10, 'db'       , '1'             );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (4,   1,   1,  5, 10, 'scope'    , '1'             );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (4,   1,   1,  6,  1, 'comment'  , 'Prueba'        );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (4,   1,   1, 10, 20, 'active'   , '1'             );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (4,   1,   1, 11, 31, 'since'    , '1970-01-01'    );

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

INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  1,  0,  1, 'label'    , 'Web');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  1,  1,  1, 'name'     , 'Web server');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  1,  2,  1, 'url'      , 'http://127.0.0.1');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  1,  3, 10, 'port'     , '80');

INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  2,  0,  1, 'label'    , 'WebAdmin');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  2,  1,  1, 'name'     , 'Web Admin server');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  2,  2,  1, 'url'      , 'http://127.0.0.1');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  2,  3, 10, 'port'     , '3939');

INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  5,  0,  1, 'label'    , 'REST');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  5,  1,  1, 'name'     , 'REST Service');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  5,  2,  1, 'url'      , 'http://127.0.0.1');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  5,  3, 10, 'port'     , '4005');

INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  6,  0,  1, 'label'    , 'Deferred');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  6,  1,  1, 'name'     , 'REST Deferred');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  6,  2,  1, 'url'      , 'http://127.0.0.1');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  6,  3, 10, 'port'     , '4006');

INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  7,  0,  1, 'label'    , 'Batch');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  7,  1,  1, 'name'     , 'REST Batch');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  7,  2,  1, 'url'      , 'http://127.0.0.1');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2,  7,  3, 10, 'port'     , '4007');

INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 10,  0,  1, 'label'    , 'DB_BASE');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 10,  1,  1, 'name'     , 'Base Database');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 10,  2,  1, 'url'      , '127.0.0.1');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 10,  3, 10, 'port'     , '4007');

INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 11,  0,  1, 'label'    , 'DB_DATA');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 11,  1,  1, 'name'     , 'Data Database');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 11,  2,  1, 'url'      , '127.0.0.1');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 11,  3, 10, 'port'     , '4007');

INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 12,  0,  1, 'label'    , 'DB_CI');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 12,  1,  1, 'name'     , 'CI Database');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 12,  2,  1, 'url'      , '127.0.0.1');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 12,  3, 10, 'port'     , '4007');

INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 14,  0,  1, 'label'    , 'DB_USER');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 14,  1,  1, 'name'     , 'Instances Database');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 14,  2,  1, 'url'      , '127.0.0.1');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 14,  3, 10, 'port'     , '4007');


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

INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (3, 1, 1,   1, 'default'    , 'POL');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (3, 1, 2,  10, 'autoupdate' ,   '5');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (3, 1, 4,  10, 'closeTime'  , '22');

INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (3, 2, 1,  10, 'requests'   , '500');

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


INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10, 100, 100,  1,  1, 'name'     , 'Base'          );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10, 100, 100,  2,  1, 'engine'   , 'MariaDB'       );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10, 100, 100,  3,  1, 'dbname'   , 'YATABase'      );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10, 100, 100,  4,  1, 'user'     , 'YATA'          );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10, 100, 100,  5,  1, 'password' , 'yata'          );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10, 100, 100,  6,  1, 'host'     , '127.0.0.1'     );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10, 100, 100,  7, 10, 'port'     , '3306'          );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10, 100, 100,  8,  1, 'descr'    , 'YATA system'   );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10, 100, 100, 10, 20, 'active'   , '0'             );

INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10, 101, 101,  1,  1, 'name'     , 'Data'          );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10, 101, 101,  2,  1, 'engine'   , 'MariaDB'       );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10, 101, 101,  3,  1, 'dbname'   , 'YATAData'      );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10, 101, 101,  4,  1, 'user'     , 'YATA'          );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10, 101, 101,  5,  1, 'password' , 'yata'          );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10, 101, 101,  6,  1, 'host'     , '127.0.0.1'     );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10, 101, 101,  7, 10, 'port'     , '3306'          );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10, 101, 101,  8,  1, 'descr'    , 'Common Data'   );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10, 101, 101, 10, 20, 'active'   , '0'             );
                                                                                                              
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10, 102, 102,  1,  1, 'name'     , 'User'          );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10, 102, 102,  2,  1, 'engine'   , 'MariaDB'       );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10, 102, 102,  3,  1, 'dbname'   , 'YATA'          );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10, 102, 102,  4,  1, 'user'     , 'YATA'          );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10, 102, 102,  5,  1, 'password' , 'yata'          );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10, 102, 102,  6,  1, 'host'     , '127.0.0.1'     );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10, 102, 102,  7, 10, 'port'     , '3306'          );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10, 102, 102,  8,  1, 'descr'    , 'User SGDB'     );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10, 102, 102, 10, 20, 'active'   , '1'             );
                                                                               

-- ----------------------------------------------------
-- Grupo 10 - Preferencias
--   Sub 1 - Match posicion (expresado en dias)
-- ----------------------------------------------------


INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 11, 1, 1,   10, ''    , ' 0');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 11, 1, 2,   10, ''    , ' 1');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 11, 1, 3,   10, ''    , ' 7');
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES ( 11, 1, 4,   10, ''    , '30');
-- ----------------------------------------------------
-- Grupo 12 - Motivos 
--  El subgrupo coincide cn el codigo  de la operacion
--  ID esta codificado
--     xx0 - Todos
--     xx1 - Compras
--     xx2 - Ventas
--     xx3 - Eventos en operaciones
-- ----------------------------------------------------

INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 12,  2,   0,  1,   1, 'label'    , 'REASON.NONE'       );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 12,  2,  10,  1,   1, 'label'    , 'REASON.FAIL'       );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 12,  2,  20,  1,   1, 'label'    , 'REASON.OTHER'      );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 12,  2,  11,  1,   1, 'label'    , 'REASON.UP'         );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 12,  2,  21,  1,   1, 'label'    , 'REASON.SUGGEST'    );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 12,  2,  31,  1,   1, 'label'    , 'REASON.TOP'        );

-- ----------------------------------------------------
-- Grupos 50 - Combos y grupos
--   Sub  1  - Operaciones (key tiene que coincidir con los codigos de las tablas)
--             Los pares (0) crean-entran / impares (1) venden-salen
--   Sub  2  - Razones

--   Sub  5 - Log aplica
-- ----------------------------------------------------

INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  1,  1,  1,  1, 'label'      ,  'BID'      );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  1,  2,  1,  1, 'label'      ,  'ASK'      );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  1,  3,  1,  1, 'label'      ,  'BUY'      );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  1,  4,  1,  1, 'label'      ,  'SELL'     );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  1,  5,  1,  1, 'label'      ,  'OPEN'     );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  1,  6,  1,  1, 'label'      ,  'CLOSE'    );

INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  1,  1,  2, 10, 'key'       ,  '10'           );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  1,  2,  2, 10, 'key'       ,  '11'           );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  1,  3,  2, 10, 'key'       ,  '20'           );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  1,  4,  2, 10, 'key'       ,  '21'           );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  1,  5,  2, 10, 'key'       ,  '30'           ); 
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  1,  6,  2, 10, 'key'       ,  '31'           );

-- INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  1,  7,  1,  1, 'label'     ,  'TXT.REG'      );
-- INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  1,  7,  2, 10, 'key'       ,  '41'           );

-- ----------------------------------------------------
-- Grupo 15 - Motivos 
--  El subgrupo coincide cn el codigo  de la operacion
--  ID esta codificado
--     xx0 - Todos
--     xx1 - Compras
--     xx2 - Ventas
--     xx3 - Eventos en operaciones
-- ----------------------------------------------------

INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,   0,  1,   1, 'label'    , 'REASON.NONE'       );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  10,  1,   1, 'label'    , 'REASON.FAIL'       );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  20,  1,   1, 'label'    , 'REASON.OTHER'      );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  11,  1,   1, 'label'    , 'REASON.UP'         );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  21,  1,   1, 'label'    , 'REASON.SUGGEST'    );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  31,  1,   1, 'label'    , 'REASON.TOP'        );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  12,  1,   1, 'label'    , 'REASON.DOWN'       );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  22,  1,   1, 'label'    , 'REASON.TARGET'     );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  32,  1,   1, 'label'    , 'REASON.LIMIT'      );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  42,  1,   1, 'label'    , 'REASON.CHANGE'     );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  13,  1,   1, 'label'    , 'REASON.ACCEPT'     );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  23,  1,   1, 'label'    , 'REASON.EXECUTED'   );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  33,  1,   1, 'label'    , 'REASON.CANCEL'     );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  43,  1,   1, 'label'    , 'REASON.REJECT'     );

INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,   0,  2,  10,  'key'    ,  '0'   );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  10,  2,  10,  'key'    , '98'   );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  20,  2,  10,  'key'    , '99'   );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  11,  2,  10,  'key'    , '11'   );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  21,  2,  10,  'key'    , '12'   );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  31,  2,  10,  'key'    , '13'   );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  12,  2,  10,  'key'    , '21'   );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  22,  2,  10,  'key'    , '41'   );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  32,  2,  10,  'key'    , '42'   );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  42,  2,  10,  'key'    , '43'   );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  13,  2,  10,  'key'    , '90'   );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  23,  2,  10,  'key'    , '91'   );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  33,  2,  10,  'key'    , '92'   );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  2,  43,  2,  10,  'key'    , '93'   );

INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  3,  1,  1,   1, 'label'    , 'BLOG.GRAL'        );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  3,  2,  1,   1, 'label'    , 'BLOG.CURRENCY'    );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  3,  3,  1,   1, 'label'    , 'BLOG.EXCHANGE'    );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  3,  4,  1,   1, 'label'    , 'BLOG.CAMERA'      );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  3,  5,  1,   1, 'label'    , 'BLOG.OPER'        );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  3,  6,  1,   1, 'label'    , 'BLOG.NOTE'        );

INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  3,  1,  2,   1, 'key'      , 'GRAL'            );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  3,  2,  2,   1, 'key'      , 'CURRENCY'        );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  3,  3,  2,   1, 'key'      , 'EXCHANGE'        );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  3,  4,  2,   1, 'key'      , 'CAMERA'          );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  3,  5,  2,   1, 'key'      , 'OPER'            );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  3,  6,  2,   1, 'key'      , 'NOTE'            );

INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  4,  1,  1,   1, 'label'    , 'LBL.CTC'          );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  4,  2,  1,   1, 'label'    , 'LBL.TOKEN'        );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  4,  3,  1,   1, 'label'    , 'LBL.CTC_TOKEN'    );

INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  4,  1,  2,   1, 'key'      , '1'            );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  4,  2,  2,   1, 'key'      , '2'        );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 50,  4,  3,  2,   1, 'key'      , '3'        );

-- Grupo 60 - Etiquetas para tablas y dataframes

-- Subgrupo 1: Etiquetas de nombres de campos en tablas
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 60,  1,  1,  1,  99, "camera"     , "LBL.CAMERA"     );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 60,  1,  2,  1,  99, "currency"   , "LBL.CURRENCY"   );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 60,  1,  3,  1,  99, "balance"    , "LBL.BALANCE"    );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 60,  1,  4,  1,  99, "available"  , "LBL.AVAILABLE"  );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 60,  1,  5,  1,  99, "buy_high"   , "LBL.BUY_HIGH"   );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 60,  1,  6,  1,  99, "buy_low"    , "LBL.BUY_LOW"    );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 60,  1,  7,  1,  99, "buy_last"   , "LBL.BUY_LAST"   );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 60,  1,  8,  1,  99, "buy_net"    , "LBL.BUY_NET"    );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 60,  1,  9,  1,  99, "sell_high"  , "LBL.SELL_HIGH"  );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 60,  1, 10,  1,  99, "sell_low"   , "LBL.SELL_LOW"   );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 60,  1, 11,  1,  99, "sell_last"  , "LBL.SELL_LAST"  );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 60,  1, 12,  1,  99, "sell_net"   , "LBL.SELL_NET"   );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 60,  1, 13,  1,  99, "buy"        , "LBL.BUY"        );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 60,  1, 14,  1,  99, "sell"       , "LBL.SELL"       );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 60,  1, 15,  1,  99, "value"      , "LBL.VALUE"      );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 60,  1, 16,  1,  99, "profit"     , "LBL.PROFIT"     );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 60,  1, 17,  1,  99, "since"      , "LBL.SINCE"      );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 60,  1, 18,  1,  99, "tms"        , "LBL.TMS"        );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 60,  1, 19,  1,  99, "last"       , "LBL.LAST"       );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 60,  1, 20,  1,  99, "cc"         , "LBL.CC"         );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 60,  1, 21,  1,  99, "day"        , "LBL.DAY"        );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 60,  1, 22,  1,  99, "week"       , "LBL.WEEK"       );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 60,  1, 23,  1,  99, "month"      , "LBL.MONTH"      );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 60,  1, 24,  1,  99, "hour"       , "LBL.HOUR"       );
INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 60,  1, 25,  1,  99, "symbol"     , "LBL.SYMBOL"     );
-- INSERT INTO PARAMETERS  (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 60,  1, 26,  1,  99, "day"        , "LBL.DAY"        );
COMMIT;