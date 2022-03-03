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
    ID       INTEGER      DEFAULT 0
   ,NAME     VARCHAR(64)  NOT NULL        -- Clearing Name
   ,SYMBOL   VARCHAR(20)  NOT NULL        -- Moneda   
   ,SLUG     VARCHAR(64)   
   ,RANK     INTEGER      DEFAULT 99999   
   ,DECIMALS TINYINT      DEFAULT 6
   ,CREATED  TINYINT      DEFAULT 0       -- Since mark the beginning of CTC?    
   ,ICON     VARCHAR(255)    
   ,CAMERAS  TIMESTAMP   
   ,TMS      TIMESTAMP DEFAULT   CURRENT_TIMESTAMP
                       ON UPDATE CURRENT_TIMESTAMP
   ,BEG      DATE                         -- First record
   ,END      DATE                         -- Last record
   ,CREATED  TINYINT      DEFAULT 0
   ,ACTIVE   TINYINT      DEFAULT 1                       
   ,PRIMARY KEY ( ID )
   ,INDEX       ( SYMBOL )
);


-- Tabla de Proveedores
DROP TABLE  IF EXISTS PROVIDERS CASCADE;
CREATE TABLE PROVIDERS  (
    PROVIDER     VARCHAR(10)  NOT NULL -- To Currency 
   ,NAME         VARCHAR(32)  NOT NULL -- From currency
   ,ACTIVE       TINYINT    DEFAULT 1
   ,PRTY         TINYINT    DEFAULT 99
-- Datos de acceso   
   ,TOKEN      VARCHAR(255)
   ,URL        VARCHAR(255)   
   ,USER       VARCHAR(32) 
   ,PWD        VARCHAR(32) 
   ,ICON       VARCHAR(255)    
   ,OBJECT     VARCHAR(255)   
   ,PRIMARY KEY ( PROVIDER )
);

-- Tabla de Camaras
-- Lugares donde puede haber cuentas
DROP TABLE  IF EXISTS CAMERAS CASCADE;
CREATE TABLE CAMERAS  (
    CAMERA  VARCHAR(10) NOT NULL -- Codigo de camara
   ,NAME    VARCHAR(32) NOT NULL           -- Clearing Name
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


-- Tabla de monedas trabajadas por cada camara
DROP TABLE  IF EXISTS EXCHANGES CASCADE;
CREATE TABLE EXCHANGES  (
    CAMERA    VARCHAR(10)  NOT NULL -- Camara
   ,SYMBOL    VARCHAR(10)  NOT NULL -- Moneda
   ,ID        INTEGER      DEFAULT 0
   ,ACTIVE    TINYINT      DEFAULT 1
   ,PRIMARY KEY ( CAMERA, SYMBOL )
);

-- Path para obtener una moneda en un provider
-- Ejemplo:
-- EUR/XTT -> 1: XEM/XTT - 2: ETH/XEM - 3: BTC/ETH - 4: USDT/BTC - 5:USD/USDT (ultimo BASE/USD)
DROP TABLE  IF EXISTS CHAIN CASCADE;
CREATE TABLE CHAIN  (
    PROVIDER  VARCHAR(10)  NOT NULL -- Camara
   ,BASE      VARCHAR(10)  NOT NULL -- Moneda Base (EUR o USD)
   ,COUNTER   VARCHAR(10)  NOT NULL -- Moneda destino
   ,PATH1     VARCHAR(10)
   ,PATH2     VARCHAR(10)
   ,PATH3     VARCHAR(10)
   ,PATH4     VARCHAR(10)
   ,PATH5     VARCHAR(10)            
   ,PRIMARY KEY ( PROVIDER, BASE, COUNTER )
);

-- Tabla de Textos
-- bLOCK ES para recuperar traducciones de bloques
DROP TABLE  IF EXISTS MESSAGES;
CREATE TABLE MESSAGES  (
    BLOCK    INTEGER         NOT NULL DEFAULT 0
   ,CODE     VARCHAR    (64) NOT NULL
   ,LANG     CHAR(2)         NOT NULL DEFAULT "XX"
   ,REGION   CHAR(2)         NOT NULL DEFAULT "XX"
   ,MSG      VARCHAR(255)
   ,PRIMARY KEY ( BLOCK, CODE, LANG, REGION ) 
);

DROP TABLE  IF EXISTS HISTORY CASCADE;
CREATE TABLE HISTORY  (
    TMS      DATE        NOT NULL -- Moneda   
   ,SYMBOL   VARCHAR(20)  NOT NULL -- Moneda   
   ,OPEN     DOUBLE   
   ,CLOSE    DOUBLE
   ,HIGH     DOUBLE
   ,LOW      DOUBLE
   ,VOLUME   DOUBLE
   ,MKTCAP   DOUBLE
   ,PRIMARY KEY ( SYMBOL, TMS DESC )
);

-- SYMBOL puede estar repetido
-- Se debe machear contra currencies
DROP TABLE  IF EXISTS SESSION;
CREATE TABLE SESSION  (
    ID        INTEGER       NOT NULL
   ,SYMBOL    VARCHAR(18)   NOT NULL
   ,PRICE     DOUBLE   
   ,VOLUME    DOUBLE   
   ,RANK      INTEGER
   ,VAR01     DOUBLE
   ,VAR24     DOUBLE
   ,VAR07     DOUBLE
   ,VAR30     DOUBLE
   ,VAR60     DOUBLE
   ,VAR90     DOUBLE
   ,VOL24     DOUBLE
   ,VOL07     DOUBLE
   ,VOL30     DOUBLE
   ,DOMINANCE DOUBLE
   ,TURNOVER  DOUBLE
   ,TMS       TIMESTAMP     NOT NULL
   ,PRIMARY KEY (ID, TMS)
--   ,UNIQUE  KEY (SYMBOL, TMS)
   ,INDEX       (SYMBOL)
);

-- ----------------------------------------------------------
-- Contiene la ultima vez que se acutalizo session
-- Nos evita hacer una query
-- ----------------------------------------------------------
DROP TABLE  IF EXISTS SESSION_CTRL;
CREATE TABLE SESSION_CTRL  (
    TMS       TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
   ,PRIMARY KEY (TMS)
);
