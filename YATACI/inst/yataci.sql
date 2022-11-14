DROP DATABASE IF EXISTS YATACI;
CREATE DATABASE YATACI CHARACTER SET utf8 COLLATE utf8_general_ci;
GRANT ALL PRIVILEGES ON YATACI.*          TO 'YATA'@'localhost' WITH GRANT OPTION;

USE YATACI;

-- Tabla de Camaras
-- Lugares donde puede haber cuentas
DROP TABLE  IF EXISTS CAMERAS CASCADE;
CREATE TABLE CAMERAS  (
    CAMERA  VARCHAR(64) NOT NULL -- Codigo de camara
   ,NAME    VARCHAR(64) NOT NULL           -- Clearing Name
   ,MAKER   DOUBLE      NOT NULL DEFAULT 0 -- Fees
   ,TAKER   DOUBLE      NOT NULL DEFAULT 0
   ,ACTIVE  TINYINT     NOT NULL DEFAULT 1 -- 0 Inactivo / 1 Activo
   ,ICON    VARCHAR(255)
   ,URL     VARCHAR(255)
-- Datos de acceso
   ,TOKEN      VARCHAR(255)
   ,USR        VARCHAR(32)
   ,PWD        VARCHAR(32)
   ,PRIMARY KEY ( CAMERA )
);

-- Tabla de Posiciones
-- Necesita un clearing global, cuyo precio medio se calcula como la media de los otros
-- Simplemente guarda la posicion de cada cuenta
-- El disponible se alamacena y se ajusta por diferencias
-- ---------------------------------------------------------
-- NO ADMITIMOS VARIAS MONEDAS EN LA MISMA CAMARA
-- ---------------------------------------------------------
--       Con lo que el ID es simplemente un numero

DROP TABLE  IF EXISTS POSITION CASCADE;
CREATE TABLE POSITION  (
    CAMERA      VARCHAR(64)  NOT NULL     -- Codigo de camara
   ,CURRENCY    INT UNSIGNED NOT NULL     -- Moneda
   ,BALANCE     DOUBLE      DEFAULT 0.0  -- Saldo real
   ,AVAILABLE   DOUBLE      DEFAULT 0.0  -- Saldo disponible
   ,BUY_HIGH    DOUBLE      DEFAULT 0.0  -- Precio maximo de compra
   ,BUY_LOW     DOUBLE      DEFAULT 0.0  -- Precio minimo de compra
   ,BUY_LAST    DOUBLE      DEFAULT 0.0  -- Ultimo precio de compra
   ,BUY_NET     DOUBLE      DEFAULT 0.0  -- Precio medio de compra
   ,SELL_HIGH   DOUBLE      DEFAULT 0.0  -- Precio maximo de compra
   ,SELL_LOW    DOUBLE      DEFAULT 0.0  -- Precio minimo de compra
   ,SELL_LAST   DOUBLE      DEFAULT 0.0  -- Ultimo precio de compra
   ,SELL_NET    DOUBLE      DEFAULT 0.0  -- Precio medio de compra
   ,BUY         DOUBLE      DEFAULT 0.0  -- Cantdad Comprada
   ,SELL        DOUBLE      DEFAULT 0.0  -- Cantidad Vendida
   ,NET         DOUBLE      DEFAULT 0.0  -- Valor neutro (punto en el que el beneficio es cero)
   ,PROFIT      DOUBLE      DEFAULT 0.0  -- Beneficio/Perdida desde la ultima regularizacion
   ,TMS         TIMESTAMP   DEFAULT   CURRENT_TIMESTAMP  -- Momento desde el que se calcula
   ,LAST        TIMESTAMP   DEFAULT   CURRENT_TIMESTAMP
                            ON UPDATE CURRENT_TIMESTAMP  -- Ultima actualizacion
   ,CC          VARCHAR(512)        -- Codigo de cuenta
   ,PRIMARY KEY ( CAMERA, CURRENCY )
);

-- Tabla de Cuentas/Camara historica
-- Simplemente guarda la posicion de cada cuenta por dias
-- De acuerdo con la cotizacion de ese dia
-- Se ordena por fecha descendente
DROP TABLE  IF EXISTS HIST_POSITION CASCADE;
CREATE TABLE HIST_POSITION  (
    DATE_POS    DATE        NOT NULL
   ,CAMERA      VARCHAR(64) NOT NULL     -- Codigo de camara
   ,CURRENCY    INT UNSIGNED NOT NULL     -- Moneda
   ,BALANCE     DOUBLE      DEFAULT 0.0  -- Saldo real
   ,AVAILABLE   DOUBLE      DEFAULT 0.0  -- Saldo disponible
   ,BUY_HIGH    DOUBLE      DEFAULT 0.0  -- Precio maximo de compra
   ,BUY_LOW     DOUBLE      DEFAULT 0.0  -- Precio minimo de compra
   ,BUY_LAST    DOUBLE      DEFAULT 0.0  -- Ultimo precio de compra
   ,BUY_NET     DOUBLE      DEFAULT 0.0  -- Precio medio de compra
   ,SELL_HIGH   DOUBLE      DEFAULT 0.0  -- Precio maximo de compra
   ,SELL_LOW    DOUBLE      DEFAULT 0.0  -- Precio minimo de compra
   ,SELL_LAST   DOUBLE      DEFAULT 0.0  -- Ultimo precio de compra
   ,SELL_NET    DOUBLE      DEFAULT 0.0  -- Precio medio de compra
   ,BUY         DOUBLE      DEFAULT 0.0  -- Cantdad Comprada
   ,SELL        DOUBLE      DEFAULT 0.0  -- Cantidad Vendida
   ,NET         DOUBLE      DEFAULT 0.0  -- Valor neutro (punto en el que el beneficio es cero)
   ,PROFIT      DOUBLE      DEFAULT 0.0  -- Beneficio/Perdida desde la ultima regularizacion
   ,TMS        TIMESTAMP   DEFAULT   CURRENT_TIMESTAMP  -- Momento desde el que se calcula
   ,LAST        TIMESTAMP   DEFAULT   CURRENT_TIMESTAMP
   ,CC          VARCHAR(512)        -- Codigo de cuenta
   ,PRIMARY KEY ( DATE_POS DESC, CAMERA, CURRENCY )
);

-- Contiene el registro de regularizacion
-- Igual que la tabla POSITION pero indexada por LAST
-- Para el calculo de los precios de coste y netos
DROP TABLE  IF EXISTS REGULARIZATION CASCADE;
CREATE TABLE REGULARIZATION  (
    ID          INT UNSIGNED  NOT NULL     -- Identificador unico de la operacion
   ,CAMERA      VARCHAR(64)   NOT NULL     -- Codigo de camara
   ,CURRENCY    INT UNSIGNED  NOT NULL     -- Moneda
   ,DATE_REG    DATE          NOT NULL     -- Fecha de regularizacion
   ,BALANCE     DOUBLE        DEFAULT 0.0  -- Saldo real
   ,AVAILABLE   DOUBLE        DEFAULT 0.0  -- Saldo disponible
   ,BUY_HIGH    DOUBLE        DEFAULT 0.0  -- Precio maximo de compra
   ,BUY_LOW     DOUBLE        DEFAULT 0.0  -- Precio minimo de compra
   ,BUY_LAST    DOUBLE        DEFAULT 0.0  -- Ultimo precio de compra
   ,BUY_NET     DOUBLE        DEFAULT 0.0  -- Precio medio de compra
   ,SELL_HIGH   DOUBLE        DEFAULT 0.0  -- Precio maximo de compra
   ,SELL_LOW    DOUBLE        DEFAULT 0.0  -- Precio minimo de compra
   ,SELL_LAST   DOUBLE        DEFAULT 0.0  -- Ultimo precio de compra
   ,SELL_NET    DOUBLE        DEFAULT 0.0  -- Precio medio de compra
   ,BUY         DOUBLE        DEFAULT 0.0  -- Cantdad Comprada
   ,SELL        DOUBLE        DEFAULT 0.0  -- Cantidad Vendida
   ,VALUE       DOUBLE        DEFAULT 1.0  -- Valor neutro (punto en el que el beneficio es cero)
   ,PROFIT      DOUBLE        DEFAULT 0.0  -- Resultado en FIAT
   ,PERIOD      INT                        -- Periodo regularizado en dias
   ,ID_OPER     INT UNSIGNED  NOT NULL     -- Identificador de la operacion
   ,TMS         TIMESTAMP
   ,LAST        TIMESTAMP
   ,PRIMARY KEY ( CAMERA, CURRENCY, DATE_REG DESC, ID )
);

-- ------------------------------------------------------------------
-- Operaciones
-- Una operacion tiene:
--    Un registro padre
--    Un conjunto de flujos
--
-- ------------------------------------------------------------------

-- En principio las operaciones deben empezar en una compra
-- luego acabar con una venta
-- Pero se podria splitear, es decir, compro 1000 y primero vendo 300, luego otras 300, etc
DROP TABLE  IF EXISTS OPERATIONS;
CREATE TABLE OPERATIONS  (
    ID_OPER      INT UNSIGNED      NOT NULL -- Identificador de la operacion
   ,TYPE         TINYINT       NOT NULL  -- Compra o Venta
   ,CAMERA       VARCHAR(64)   NOT NULL  -- Clearing House
   ,BASE         INT UNSIGNED  NOT NULL  -- From currency
   ,COUNTER      INT UNSIGNED  NOT NULL  -- To currency
   ,AMOUNT       DOUBLE        NOT NULL  -- Cantidad que sale
   ,VALUE        DOUBLE        DEFAULT 0 -- Valor de la operacion
   ,PRICE        DOUBLE        NOT NULL  -- Precio unitario
   ,ACTIVE       TINYINT       DEFAULT 1 -- Flag activa/inactiva
   ,STATUS       TINYINT       DEFAULT 0 -- Estado de la operacion
   ,PARENT       INT UNSIGNED      DEFAULT 0 -- Padre de la operacion si se ha spliteado/neteado
   ,TMS          TIMESTAMP  DEFAULT   CURRENT_TIMESTAMP           -- Fecha de entrada
   ,TMS_LAST     TIMESTAMP  DEFAULT   CURRENT_TIMESTAMP
                            ON UPDATE CURRENT_TIMESTAMP          -- Ultima actualizacion
   ,PRIMARY KEY ( ID_OPER )
);

-- Datos de control de la operacion
-- Los mantenemos aparte para la paginacion
DROP TABLE  IF EXISTS OPERATIONS_CONTROL;
CREATE TABLE OPERATIONS_CONTROL  (
    ID_OPER      INT UNSIGNED     NOT NULL -- Identificador de la operacion
   ,FEE          DOUBLE    DEFAULT 0.0  -- Comision
   ,GAS          DOUBLE    DEFAULT 0.0  -- Comision blockchain
   ,TARGET       DOUBLE    DEFAULT 0.0   -- Objetivo
   ,STOP         DOUBLE    DEFAULT 0.0   -- Stop
   ,LIMITE       DOUBLE    DEFAULT 0.0   -- Limit
   ,DEADLINE     INTEGER   DEFAULT 0     -- Plazo en dias
   ,AMOUNT_IN    DOUBLE    NOT NULL      -- Cantidad propuesta
   ,PRICE_IN     DOUBLE    NOT NULL      -- Precio de la operacion
   ,AMOUNT_OUT   DOUBLE    DEFAULT 0.0   -- Cantidad ejecutada
   ,PRICE_OUT    DOUBLE    DEFAULT 0.0   -- Precio ejecutado
   ,EXPENSE      DOUBLE    DEFAULT 0     -- Solo ventas. Coste de compra por operaciones
   ,PROFIT       DOUBLE    DEFAULT 0     -- Resultado de la operacion
   ,ALIVE        INTEGER   DEFAULT 0     -- Duracion de la operacion desde la primera compra
   ,RANK         INT       DEFAULT 0
   ,ALERT        TINYINT   DEFAULT 0     -- Flag de alerta pendiente
   ,TMS_ALERT    DATE                    -- Para chequear la operacion
   ,PRIMARY KEY ( ID_OPER )
);

-- Datos de control de la operacion
-- Los mantenemos aparte para la paginacion
DROP TABLE  IF EXISTS OPERATIONS_LOG;
CREATE TABLE OPERATIONS_LOG  (
    ID_OPER      INT UNSIGNED     NOT NULL -- Identificador de la operacion
   ,ID_LOG       INT UNSIGNED     NOT NULL -- Identificador del registro
   ,TMS          TIMESTAMP    DEFAULT   CURRENT_TIMESTAMP -- Fecha de entrada
   ,TYPE         TINYINT      DEFAULT 0 -- Tipo de entrada
   ,REASON       INTEGER      DEFAULT 0 -- Razon de la operacion

   ,COMMENT         TEXT
   ,PRIMARY KEY ( ID_OPER, ID_LOG )
);

-- Tabla de transferencias entre camaras
-- Genera un flujo en una camara y otro en otro
DROP TABLE  IF EXISTS TRANSFERS;
CREATE TABLE TRANSFERS  (
    ID           INT UNSIGNED  NOT NULL -- Identificador de la operacion
   ,CAMERA_OUT   VARCHAR(10)   NOT NULL  -- Clearing from
   ,CAMERA_IN    VARCHAR(10)   NOT NULL  -- Clearing to
   ,CURRENCY     VARCHAR(10)   NOT NULL  -- Currency
   ,AMOUNT       DOUBLE        NOT NULL  -- Cantidad
   ,PRICE        DOUBLE        NOT NULL  -- Valor/Precio
   ,DATEOPER     DATE          DEFAULT CURRENT_DATE           -- Fecha de entrada
   ,TMS          TIMESTAMP     DEFAULT   CURRENT_TIMESTAMP           -- Fecha de entrada
   ,PRIMARY KEY ( ID )
);

-- Flujos
-- Cada operacion lleva asociado una serie de flujos:
-- La compra, la comision, las tasas
-- La venta, comisiones, etc.
-- Type:
--   0 - Compra
--   1 - Venta
--   2 - Comision
--   3 - Tasa
--   ...
DROP TABLE  IF EXISTS FLOWS;
CREATE TABLE FLOWS  (
    ID_OPER    INT UNSIGNED      NOT NULL -- Identificador de la operacion
   ,ID_FLOW    INT UNSIGNED      NOT NULL -- Identificador del flujo
   ,DATEOPER   DATE          DEFAULT CURRENT_DATE           -- Fecha de entrada
   ,TYPE       TINYINT       NOT NULL -- Tipo de flujo segun codigo
   ,CAMERA     VARCHAR(64)   NOT NULL -- Codigo de camara
   ,CURRENCY   VARCHAR(18)   NOT NULL -- Moneda
   ,AMOUNT     DOUBLE        NOT NULL -- Unidades
   ,PRICE      DOUBLE        NOT NULL -- Precio Necesario para saber la diferencia
   ,TMS          TIMESTAMP DEFAULT CURRENT_TIMESTAMP           -- Fecha de entrada
   ,PRIMARY KEY ( ID_OPER, ID_FLOW )
);

DROP TABLE  IF EXISTS BLOG;
CREATE TABLE BLOG  (
    ID_BLOG      INT UNSIGNED     NOT NULL -- Identificador de la entrada
   ,TMS          TIMESTAMP    DEFAULT   CURRENT_TIMESTAMP -- Fecha de entrada
   ,TYPE         TINYINT      DEFAULT 0 -- Tipo de entrada
   ,TARGET       VARCHAR(32)
   ,TITLE        VARCHAR(255)
   ,SUMMARY      TEXT
   ,DATA         TEXT
   ,PRIMARY KEY ( ID_BLOG )
);



INSERT INTO CAMERAS   (CAMERA, NAME, ACTIVE) VALUES("FIAT", "Control Camera", 0);
INSERT INTO POSITION  (CAMERA, CURRENCY)     VALUES("FIAT", 0);
INSERT INTO CAMERAS   (CAMERA, NAME) VALUES("CI1", "Continuous Integration 1");
INSERT INTO CAMERAS   (CAMERA, NAME) VALUES("CI2", "Continuous Integration 2");

COMMIT;

