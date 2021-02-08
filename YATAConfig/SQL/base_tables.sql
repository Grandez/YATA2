-- -------------------------------------------------------------------
-- La base de datos BASE contiene las tablas que son comunes 
-- Y la configuracion inicial
-- -------------------------------------------------------------------
-- Tabla de Parametros
DROP TABLE  IF EXISTS PARMS CASCADE;
CREATE TABLE PARMS  (
    GRUPO    INTEGER     NOT NULL -- Grupo, no usamos GROUP para evitar problemas de nombres
   ,SUBGROUP INTEGER     NOT NULL -- Parametro
   ,ID       INTEGER     NOT NULL -- Parametro
   ,TYPE     TINYINT     NOT NULL -- Tipo de parametro
   ,NAME     VARCHAR(32) NOT NULL
   ,VALUE    VARCHAR(64) NOT NULL
   ,PRIMARY KEY ( GRUPO, SUBGROUP, ID ) USING BTREE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

-- Tabla de crypto monedas con las que trabajamos
DROP TABLE  IF EXISTS CURRENCIES CASCADE;
CREATE TABLE CURRENCIES  (
    SYMBOL   VARCHAR(10)  NOT NULL -- To Currency
   ,NAME     VARCHAR(64)  NOT NULL -- From currency
   ,DECIMALS INTEGER      DEFAULT 2 -- Numero de decimales
   ,ACTIVE   TINYINT      DEFAULT 1-- 0 - Inactivo / 1 - activo
   ,FEE      DOUBLE       DEFAULT 0.0 -- Tasa
   ,PRTY     INTEGER      NOT NULL DEFAULT 999 -- Prioridad   
   ,ICON     VARCHAR(255) 
   ,PRIMARY KEY ( SYMBOL )
);

-- Tabla de Proveedores
DROP TABLE  IF EXISTS PROVIDERS CASCADE;
CREATE TABLE PROVIDERS  (
    PROVIDER     VARCHAR(10)  NOT NULL -- To Currency 
   ,NAME         VARCHAR(32)  NOT NULL -- From currency
   ,ACTIVE       TINYINT    DEFAULT 1
   ,ORDER        TINYINT    DEFAULT 99
-- Datos de acceso   
   ,TOKEN      VARCHAR(256)
   ,USER       VARCHAR(32) 
   ,PWD        VARCHAR(32) 
   ,URL        VARCHAR(255)
   ,ICON       VARCHAR(255)
   ,OBJECT     VARCHAR(32)
   ,PRIMARY KEY ( PROVIDER )
);

-- Tabla de monedas trabajadas por cada camara
DROP TABLE  IF EXISTS EXCHANGES CASCADE;
CREATE TABLE EXCHANGES  (
    CAMERA    VARCHAR(10)  NOT NULL -- Camara
   ,SYMBOL    VARCHAR(10)  NOT NULL -- Moneda
   ,ACTIVE    TINYINT      DEFAULT 1
   ,PRIMARY KEY ( CLEARING, SYMBOL )
);

-- Path para obtener una moneda en un provider
-- Ejemplo:
-- EUR/XTT -> 1: XEM/XTT - 2: ETH/XEM - 3: BTC/ETH - 4: USDT/BTC - 5:USD/USDT (ultimo BASE/USD)
DROP TABLE  IF EXISTS PATH CASCADE;
CREATE TABLE PATH  (
    PROVIDER  VARCHAR(10)  NOT NULL -- Camara
   ,BASE      VARCHAR(10)  NOT NULL -- Moneda Base (EUR o USD)
   ,COUNTER   VARCHAR(10)  NOT NULL -- Moneda destino
   ,PATH      VARCHAR(255)   
   ,ACTIVE    TINYINT DEFAULT 1
   ,PRIMARY KEY ( PROVIDER, BASE, COUNTER )
);
