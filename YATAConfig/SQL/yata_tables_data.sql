
--- Tabla de crypto monedas con las que trabajamos
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

-- Tabla de monedas trabajadas por cada camara
DROP TABLE  IF EXISTS EXCHANGES CASCADE;
CREATE TABLE EXCHANGES  (
    CAMERA    VARCHAR(10)  NOT NULL -- Camara
   ,SYMBOL    VARCHAR(10)  NOT NULL -- Moneda
   ,ID        INTEGER      DEFAULT 0
   ,ACTIVE    TINYINT      DEFAULT 1
   ,PRIMARY KEY ( CAMERA, SYMBOL )
);

-- Camaras donde se negocian las CTC
-- Esta tabla existe en YATAData y en las de usuario
-- En la de usuario hay  datos de acceso
-- 
DROP TABLE  IF EXISTS GLOBAL_CAMERAS CASCADE;
CREATE TABLE GLOBAL_CAMERAS  (
    CAMERA  VARCHAR(10) NOT NULL -- Codigo de camara
   ,NAME    VARCHAR(32) NOT NULL           -- Clearing Name
   ,MAKER   DOUBLE      NOT NULL DEFAULT 0 -- Fees
   ,TAKER   DOUBLE      NOT NULL DEFAULT 0
   ,ACTIVE  TINYINT     NOT NULL DEFAULT 1 -- 0 Inactivo / 1 Activo 
   ,ICON    VARCHAR(255) 
   ,URL     VARCHAR(255) 
   ,PRIMARY KEY ( CAMERA )
);

COMMIT;
