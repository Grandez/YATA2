DELETE FROM PARMS;

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (1, 1, 1, 20, 'autoOpen' , '1');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (1, 1, 2, 10, 'lastDB'   , '2');
-- Clave 2: Bases de datos
-- Subgrupo: Cada base de datos
-- ID:
-- 1 - Nombre
-- 2 - Engine
-- 3 - DBName
-- 4 - Usuario
-- 5 - password
-- 6 - Host
-- 7 - Puerto

-- La 0 no se deberia ver. La usamos para clonar una base de datos vacia
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 0, 1,  1, 'name'   , 'Plantilla');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 0, 2,  1, 'engine' , 'MariaDB');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 0, 3,  1, 'dbname' , 'YATATPL');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 0, 4,  1, 'user'   , 'YATA');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 0, 5,  1, 'pwd'    , 'yata');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 0, 6,  1, 'host'   , '127.0.0.1');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 0, 7, 10, 'port'   , '3306');

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 1, 1,  1, 'name'   , 'Operacional');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 1, 2,  1, 'engine' , 'MariaDB');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 1, 3,  1, 'dbname' , 'YATA');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 1, 4,  1, 'user'   , 'YATA');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 1, 5,  1, 'pwd'    , 'yata');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 1, 6,  1, 'host'   , '127.0.0.1');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 1, 7, 10, 'port'   , '3306');

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 2, 1,  1, 'name'   , 'Test');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 2, 2,  1, 'engine' , 'MariaDB');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 2, 3,  1, 'dbname' , 'YATATest');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 2, 4,  1, 'user'   , 'YATA');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 2, 5,  1, 'pwd'    , 'yata');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 2, 6,  1, 'host'   , '127.0.0.1');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 2, 7, 10, 'port'   , '3306');

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 3, 1,  1, 'name'   , 'Simulacion');                                                                      
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 3, 2,  1, 'engine' , 'MariaDB');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 3, 3,  1, 'dbname' , 'YATASimm');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 3, 4,  1, 'user'   , 'YATA');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 3, 5,  1, 'pwd'    , 'yata');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 3, 6,  1, 'host'   , '127.0.0.1');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (2, 3, 7, 10, 'port'   , '3306');

-- Clave 3: Proveedores
-- Subgrupo: 1 - Online
-- ID        1 - Proveedor de informacion Online
-- ID        2 - Autoupdate en minutos
-- ID        3 - Moneda base por defecto
-- ID        4 - Hora de cierre
-- Subgrupo: 2
-- ID        1 - MAximo numero de sessiones a recuperar paraa controlar las transacciones

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (3, 1, 1,   1, 'default'    , 'POL');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (3, 1, 2,  10, 'autoupdate' ,   '5');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (3, 1, 3,   1, 'currency'   , 'EUR');
INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (3, 1, 4,  10, 'closeTime'  , '22');

INSERT INTO PARMS (GRUPO, SUBGROUP, ID, TYPE, NAME, VALUE) VALUES (3, 2, 1,  10, 'requests'   , '500');

commit;