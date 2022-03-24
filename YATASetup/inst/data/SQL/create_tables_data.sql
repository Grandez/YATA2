use YATAData;

--- Tabla de crypto monedas con las que trabajamos
DROP TABLE  IF EXISTS CURRENCIES CASCADE;
CREATE TABLE CURRENCIES  (
    ID       INTEGER       DEFAULT 0
   ,SYMBOL   VARCHAR(64)   NOT NULL        
   ,MKTCAP   VARCHAR(64)   NOT NULL        
   ,NAME     VARCHAR(64)   NOT NULL        
   ,SLUG     VARCHAR(64)    
   ,RANK     INTEGER       DEFAULT 99999   
   ,DECIMALS TINYINT       DEFAULT 6
   ,ICON     VARCHAR(255)    
   ,SINCE    DATE                         -- Active from ...
   ,ACTIVE   TINYINT       DEFAULT 1                       
   ,TMS      TIMESTAMP     DEFAULT   CURRENT_TIMESTAMP
                           ON UPDATE CURRENT_TIMESTAMP   
   ,PRIMARY KEY ( ID )
   ,INDEX       ( SYMBOL )
);

DROP TABLE  IF EXISTS HISTORY CASCADE;
CREATE TABLE HISTORY  (
    ID       INTEGER      
   ,SYMBOL   VARCHAR(64)  NOT NULL -- Moneda   
   ,OPEN     DOUBLE   
   ,CLOSE    DOUBLE
   ,HIGH     DOUBLE
   ,LOW      DOUBLE
   ,VOLUME   DOUBLE
   ,MKTCAP   DOUBLE
   ,TMS      DATE         NOT NULL -- Moneda      
   ,PRIMARY KEY ( ID, TMS DESC )
);

-- SYMBOL puede estar repetido
-- Se debe machear contra currencies
DROP TABLE  IF EXISTS SESSION;
CREATE TABLE SESSION  (
    ID        INTEGER       NOT NULL
   ,SYMBOL    VARCHAR(64)   NOT NULL
   ,PRICE     DOUBLE   
   ,VOLUME    DOUBLE   
   ,RANK      INTEGER     DEFAULT 1001 -- Required to filter
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
   ,LAST      TIMESTAMP     NOT NULL   
   ,PRIMARY KEY (ID, LAST DESC)
   ,INDEX       (SYMBOL, LAST DESC)
);


-- ----------------------------------------------------------
-- Tabla de control de cargas,descargas, actualizaciones
-- Cada registro se refiere a un objeto
-- 1 - Datos de session
-- Nos evita hacer una query 
-- ----------------------------------------------------------
DROP TABLE  IF EXISTS CONTROL;
CREATE TABLE CONTROL  (
     ID        INTEGER    NOT NULL
    ,TMS       TIMESTAMP  NOT NULL
    ,TOTAL     INTEGER    DEFAULT 0
    ,LAST      TIMESTAMP  DEFAULT   CURRENT_TIMESTAMP
                          ON UPDATE CURRENT_TIMESTAMP   
   ,PRIMARY KEY (ID)
);

-- Tabla de monedas trabajadas por cada camara
DROP TABLE  IF EXISTS EXCHANGES CASCADE;
CREATE TABLE EXCHANGES  (
    ID      INTEGER      NOT NULL
   ,SYMBOL  VARCHAR(64)  NOT NULL 
   ,NAME    VARCHAR(64)  NOT NULL           
   ,SLUG    VARCHAR(64)       
   ,ICON    VARCHAR(255)    
   ,URL     VARCHAR(255)
   ,RANK    INTEGER               DEFAULT 99999      
   ,MAKER   DOUBLE       NOT NULL DEFAULT 0.0 
   ,TAKER   DOUBLE       NOT NULL DEFAULT 0.0
   ,ACTIVE   TINYINT              DEFAULT 1 
   ,PRIMARY KEY ( ID )
);

DROP TABLE  IF EXISTS EXCHANGES_FIAT CASCADE;
CREATE TABLE EXCHANGES_FIAT  (
    ID_EXCH  INTEGER     NOT NULL
   ,ID_FIAT  CHAR(3)     NOT NULL
   ,PRIMARY KEY ( ID_EXCH, ID_FIAT )
);

DROP TABLE  IF EXISTS EXCHANGES_CTC CASCADE;
CREATE TABLE EXCHANGES_CTC  (
    ID_EXCH  INTEGER     NOT NULL
   ,ID_CTC   INTEGER     NOT NULL
   ,PRIMARY KEY ( ID_EXCH, ID_CTC )
);

-- Tabla de monedas trabajadas por cada camara
DROP TABLE  IF EXISTS FIATS CASCADE;
CREATE TABLE FIATS  (
    ID        CHAR(3)       -- ISO 4217
   ,SYMBOL    CHAR(3)
   ,NAME      VARCHAR(64) 
   ,ICON      VARCHAR(255)    
   ,EXCHANGE  DOUBLE DEFAULT 1.0 
   ,PRIMARY KEY ( ID )
);

COMMIT;
