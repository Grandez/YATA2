-- Tabla de Camaras
-- Mas correctamente son cuentas que estan en EXCHANGES
-- EXCHANGE ES EL PUNTERO A EXCHANGES EN DATA
DROP TABLE  IF EXISTS CAMERAS CASCADE;
CREATE TABLE CAMERAS  (
    CAMERA   VARCHAR(64)  NOT NULL -- Codigo de camara
   ,NAME     VARCHAR(64)  NOT NULL
   ,EXCHANGE INTEGER      NOT NULL -- Pointer to Exchanges
   ,ACTIVE   TINYINT      DEFAULT 1
-- Datos de acceso
   ,TOKEN    VARCHAR(255)
   ,USR      VARCHAR(64)
   ,PWD      VARCHAR(64)
   ,CC       VARCHAR(512)        -- Codigo de cuenta
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
   ,RESULT      DOUBLE      DEFAULT 0.0  -- Beneficio/Perdida desde la ultima regularizacion
   ,REGULARIZATION DATE   DEFAULT "2000-01-01"
   ,SINCE          DATE                COMMENT 'FECHA DE CREACION'
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
   ,CAMERA      VARCHAR(10) NOT NULL     -- Codigo de camara
   ,CURRENCY    VARCHAR(10) NOT NULL     -- Moneda
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
   ,VALUE       DOUBLE      DEFAULT 0.0  -- Valor neutro (punto en el que el beneficio es cero)
   ,PROFIT      DOUBLE      DEFAULT 0.0  -- Beneficio/Perdida desde la ultima regularizacion
   ,TMS        TIMESTAMP   DEFAULT   CURRENT_TIMESTAMP  -- Momento desde el que se calcula
   ,LAST        TIMESTAMP   DEFAULT   CURRENT_TIMESTAMP
   ,PRIMARY KEY ( DATE_POS DESC, CAMERA, CURRENCY )
);

-- Contiene el registro de regularizacion
-- Igual que la tabla POSITION pero indexada por LAST
-- Para el calculo de los precios de coste y netos
DROP TABLE  IF EXISTS REGULARIZATION CASCADE;
CREATE TABLE REGULARIZATION  (
    ID_REG      INT UNSIGNED  NOT NULL     -- Identificador unico de la operacion
   ,CAMERA      VARCHAR(32)   NOT NULL     -- Codigo de camara
   ,CURRENCY    VARCHAR(64)   NOT NULL     -- Moneda
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
   ,PRIMARY KEY ( CAMERA, CURRENCY, DATE_REG DESC, ID_REG )
);

-- ------------------------------------------------------------------
-- Operaciones
-- Una operacion tiene:
--    Un registro padre
--    Un conjunto de flujos
--
-- ------------------------------------------------------------------

-- En principio las operaciones deben empezar en una compra y acabar en venta
-- Pero se podria splitear, es decir, compro 1000 y primero vendo 300, luego otras 300, etc
DROP TABLE  IF EXISTS OPERATIONS;
CREATE TABLE OPERATIONS  (
    ID_OPER      INT UNSIGNED      NOT NULL -- Identificador de la operacion
   ,DATEOPER     DATE          DEFAULT CURRENT_DATE           -- Fecha de entrada
   ,DATEVAL      DATE          DEFAULT CURRENT_DATE           -- Fecha de entrada
   ,TYPE         TINYINT       NOT NULL  -- Compra o Venta
   ,CAMERA       VARCHAR(64)   NOT NULL  -- Clearing House
   ,BASE         INT UNSIGNED  NOT NULL  -- From currency
   ,COUNTER      INT UNSIGNED  NOT NULL  -- To currency
   ,AMOUNT       DOUBLE        NOT NULL  -- Cantidad que sale
   ,VALUE        DOUBLE        DEFAULT 0 -- Valor de la operacion
   ,PRICE        DOUBLE        NOT NULL  -- Precio unitario
   ,RESULT       DOUBLE        DEFAULT 0 -- Resultado de la operacion
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
DROP TABLE  IF EXISTS TRANSFERS;
CREATE TABLE TRANSFERS  (
    ID           INT UNSIGNED  NOT NULL -- Identificador de la operacion
   ,CAMERA_OUT   VARCHAR(10)   NOT NULL  -- Clearing from
   ,CAMERA_IN    VARCHAR(10)   NOT NULL  -- Clearing to
   ,CURRENCY     VARCHAR(10)   NOT NULL  -- Currency
   ,AMOUNT       DOUBLE        NOT NULL  -- Cantidad
   ,PRICE        DOUBLE        NOT NULL  -- Valor/Precio
   ,DATEOPER     DATE          DEFAULT CURRENT_DATE           -- Fecha de entrada
   ,DATEVAL      DATE          DEFAULT CURRENT_DATE           -- Fecha de entrada
   ,TMS          TIMESTAMP     DEFAULT   CURRENT_TIMESTAMP           -- Fecha de entrada
   ,PRIMARY KEY ( ID )
);

-- Flujos
-- Cada operacion lleva asociado una serie de flujos:
-- La compra, la comision, las tasas
DROP TABLE  IF EXISTS FLOWS;
CREATE TABLE FLOWS  (
    ID_OPER    INT UNSIGNED      NOT NULL -- Identificador de la operacion
   ,ID_FLOW    INT UNSIGNED      NOT NULL -- Identificador del flujo
   ,DATEOPER   DATE          DEFAULT CURRENT_DATE           -- Fecha de entrada
   ,DATEVAL    DATE          DEFAULT CURRENT_DATE           -- Fecha de entrada
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
   ,TARGET       VARCHAR(64)
   ,TITLE        VARCHAR(255)
   ,SUMMARY      TEXT
   ,DATA         TEXT
   ,PRIMARY KEY ( ID_BLOG )
);

-- Tabla de favoritos
DROP TABLE  IF EXISTS FAVORITES CASCADE;
CREATE TABLE FAVORITES  (
    ID_FAV   INTEGER       DEFAULT 0
   ,SYMBOL   VARCHAR(64)   NOT NULL
   ,PRTY     INTEGER       DEFAULT 1  -- Orden de insercion
   ,PRIMARY KEY ( ID_FAV, PRTY DESC )
);

-- Tabla de alertas
DROP TABLE  IF EXISTS ALERTS CASCADE;
CREATE TABLE ALERTS     (
    ID_ALERT INT UNSIGNED      NOT NULL -- Identificador de la alerta
   ,TYPE     TINYINT           DEFAULT 0 -- Tipo de alerta (moneda, operacion, fecha, etc.)
   ,SUBJECT  VARCHAR(64)       NOT NULL   -- ID del sujeto de la alerta
   ,MATCHER  CHAR(2)           NOT NULL   -- Operador (EQ, GT, LT, etc)
   ,TARGET   VARCHAR(64)       NOT NULL   -- Objetivo de la alerta
   ,STATUS   TINYINT           DEFAULT 0  -- Estado de la alerta
   ,ACTIVE   TINYINT           DEFAULT 1  -- Flag
   ,TMS      TIMESTAMP  DEFAULT   CURRENT_TIMESTAMP
                        ON UPDATE CURRENT_TIMESTAMP          -- Ultima actualizacion
   ,PRIMARY KEY ( ID_ALERT )
   ,INDEX (ACTIVE, TYPE)
);

DROP TABLE  IF EXISTS MODEL_VAR;
CREATE TABLE MODEL_VAR  (
    ID        INTEGER       NOT NULL
   ,SYMBOL    VARCHAR(64)   NOT NULL
   ,RANK      INTEGER     DEFAULT 99999
   ,PRICE00   DOUBLE
   ,PRICE01   DOUBLE
   ,PRICE02   DOUBLE
   ,PRICE03   DOUBLE
   ,PRICE04   DOUBLE
   ,PRICE05   DOUBLE
   ,VOLUME00  DOUBLE
   ,VOLUME01  DOUBLE
   ,VOLUME02  DOUBLE
   ,VOLUME03  DOUBLE
   ,VOLUME04  DOUBLE
   ,VOLUME05  DOUBLE
   ,VAR01     DOUBLE
   ,VAR02     DOUBLE
   ,VAR03     DOUBLE
   ,VAR04     DOUBLE
   ,VAR05     DOUBLE
   ,VOL01     DOUBLE
   ,VOL02     DOUBLE
   ,VOL03     DOUBLE
   ,VOL04     DOUBLE
   ,VOL05     DOUBLE
   ,IND_PRICE DOUBLE
   ,IND_VOL   DOUBLE
   ,IND_VAR   DOUBLE
   ,UPDATED   DATE
   ,TMS       TIMESTAMP    DEFAULT   CURRENT_TIMESTAMP
                           ON UPDATE CURRENT_TIMESTAMP
   ,PRIMARY KEY (ID)
);

INSERT INTO CAMERAS   (CAMERA, NAME, ACTIVE) VALUES("FIAT", "Control Camera", 0);
INSERT INTO POSITION  (CAMERA, CURRENCY, EXCHANGE)     VALUES("FIAT", 0, 0);

COMMIT;
