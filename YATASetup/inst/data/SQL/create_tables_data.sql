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
   ,TOKEN    TINYINT       DEFAULT 0
   ,DECIMALS TINYINT       DEFAULT 6
   ,ICON     VARCHAR(255)    
   ,SINCE    DATE                         COMMENT 'Date when incorporated'
   ,FIRST    DATE                         COMMENT 'First history record'
   ,LAST     DATE                         COMMENT 'Last history record'
   ,ACTIVE   TINYINT       DEFAULT 1                       
   ,TMS      TIMESTAMP     DEFAULT   CURRENT_TIMESTAMP
                           ON UPDATE CURRENT_TIMESTAMP   
   ,PRIMARY KEY ( ID )
   ,INDEX       ( SYMBOL )
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
   ,TMS      DATE         NOT NULL  COMMENT 'Fecha de cierre de sesion'
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
   ,TOKEN     TINYINT     DEFAULT 0
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
   ,PRIMARY KEY (ID,     TMS DESC)
   ,INDEX       (SYMBOL, TMS DESC)
);


-- ----------------------------------------------------------
-- Contiene la ultima vez que se acutalizo session
-- Nos evita hacer una query 
-- Evita que haya monedas con diferentes tms
-- OJO Hay problemas con los time zone en timestamp
-- ----------------------------------------------------------
DROP TABLE  IF EXISTS SESSION_CTRL;
CREATE TABLE SESSION_CTRL  (
     ID        INTEGER  NOT NULL
    ,TMS       BIGINT   DEFAULT 0
   ,PRIMARY KEY (ID)
);


DROP TABLE  IF EXISTS EXCHANGES_FIATS CASCADE;
CREATE TABLE EXCHANGES  (
    ID_EXCH  INTEGER     NOT NULL
   ,ID_FIAT  CHAR(3)     NOT NULL
   ,PRIMARY KEY ( ID_EXCH, ID_FIAT )
);

DROP TABLE  IF EXISTS EXCHANGES_CTC CASCADE;
CREATE TABLE EXCHANGES  (
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

DROP TABLE  IF EXISTS MODEL_VAR CASCADE;
CREATE TABLE MODEL_VAR (
	 ID         INTEGER NOT NULL
	,SYMBOL     VARCHAR(64) 
	,RANK       INTEGER  99999
	,PRICE00    DOUBLE 
	,PRICE01    DOUBLE 
	,PRICE02    DOUBLE 
	,PRICE03    DOUBLE 
	,PRICE04    DOUBLE 
	,PRICE05    DOUBLE 
	,VOLUME00   DOUBLE 
	,VOLUME01   DOUBLE 
	,VOLUME02   DOUBLE 
	,VOLUME03   DOUBLE 
	,VOLUME04   DOUBLE 
	,VOLUME05   DOUBLE 
	,VAR01      DOUBLE 
	,VAR02      DOUBLE 
	,VAR03      DOUBLE 
	,VAR04      DOUBLE 
	,VAR05      DOUBLE 
	,VOL01      DOUBLE 
	,VOL02      DOUBLE 
	,VOL03      DOUBLE 
	,VOL04      DOUBLE 
	,VOL05      DOUBLE 
	,IND_PRICE  DOUBLE 
	,IND_VOL    DOUBLE 
	,IND_VAR    DOUBLE 
	,UPDATED    DATE 
	,TMS        TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
	                      ON UPDATE CURRENT_TIMESTAMP 
	,PRIMARY KEY (ID)
);

DROP TABLE  IF EXISTS MODEL_VAR_LONG CASCADE;
CREATE TABLE MODEL_VAR_LONG (
	 ID         INTEGER NOT NULL
	,SYMBOL     VARCHAR(64) 
	,RANK       INTEGER  99999
	,PRICE00    DOUBLE 
	,PRICE01    DOUBLE 
	,PRICE02    DOUBLE 
	,PRICE03    DOUBLE 
	,PRICE04    DOUBLE 
	,PRICE05    DOUBLE 
	,VOLUME00   DOUBLE 
	,VOLUME01   DOUBLE 
	,VOLUME02   DOUBLE 
	,VOLUME03   DOUBLE 
	,VOLUME04   DOUBLE 
	,VOLUME05   DOUBLE 
	,VAR01      DOUBLE 
	,VAR02      DOUBLE 
	,VAR03      DOUBLE 
	,VAR04      DOUBLE 
	,VAR05      DOUBLE 
	,VOL01      DOUBLE 
	,VOL02      DOUBLE 
	,VOL03      DOUBLE 
	,VOL04      DOUBLE 
	,VOL05      DOUBLE 
	,IND_PRICE  DOUBLE 
	,IND_VOL    DOUBLE 
	,IND_VAR    DOUBLE 
	,UPDATED    DATE 
	,TMS        TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
	                      ON UPDATE CURRENT_TIMESTAMP 
	,PRIMARY KEY (ID)
);
DROP TABLE  IF EXISTS MODEL_VAR_MEDIUM CASCADE;
CREATE TABLE MODEL_VAR_MEDIUM (
	 ID         INTEGER NOT NULL
	,SYMBOL     VARCHAR(64) 
	,RANK       INTEGER  99999
	,PRICE00    DOUBLE 
	,PRICE01    DOUBLE 
	,PRICE02    DOUBLE 
	,PRICE03    DOUBLE 
	,PRICE04    DOUBLE 
	,PRICE05    DOUBLE 
	,VOLUME00   DOUBLE 
	,VOLUME01   DOUBLE 
	,VOLUME02   DOUBLE 
	,VOLUME03   DOUBLE 
	,VOLUME04   DOUBLE 
	,VOLUME05   DOUBLE 
	,VAR01      DOUBLE 
	,VAR02      DOUBLE 
	,VAR03      DOUBLE 
	,VAR04      DOUBLE 
	,VAR05      DOUBLE 
	,VOL01      DOUBLE 
	,VOL02      DOUBLE 
	,VOL03      DOUBLE 
	,VOL04      DOUBLE 
	,VOL05      DOUBLE 
	,IND_PRICE  DOUBLE 
	,IND_VOL    DOUBLE 
	,IND_VAR    DOUBLE 
	,UPDATED    DATE 
	,TMS        TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
	                      ON UPDATE CURRENT_TIMESTAMP 
	,PRIMARY KEY (ID)
);
DROP TABLE  IF EXISTS MODEL_VAR_SHORT CASCADE;
CREATE TABLE MODEL_VAR_SHORT (
	 ID         INTEGER NOT NULL
	,SYMBOL     VARCHAR(64) 
	,RANK       INTEGER  99999
	,PRICE00    DOUBLE 
	,PRICE01    DOUBLE 
	,PRICE02    DOUBLE 
	,PRICE03    DOUBLE 
	,PRICE04    DOUBLE 
	,PRICE05    DOUBLE 
	,VOLUME00   DOUBLE 
	,VOLUME01   DOUBLE 
	,VOLUME02   DOUBLE 
	,VOLUME03   DOUBLE 
	,VOLUME04   DOUBLE 
	,VOLUME05   DOUBLE 
	,VAR01      DOUBLE 
	,VAR02      DOUBLE 
	,VAR03      DOUBLE 
	,VAR04      DOUBLE 
	,VAR05      DOUBLE 
	,VOL01      DOUBLE 
	,VOL02      DOUBLE 
	,VOL03      DOUBLE 
	,VOL04      DOUBLE 
	,VOL05      DOUBLE 
	,IND_PRICE  DOUBLE 
	,IND_VOL    DOUBLE 
	,IND_VAR    DOUBLE 
	,UPDATED    DATE 
	,TMS        TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
	                      ON UPDATE CURRENT_TIMESTAMP 
	,PRIMARY KEY (ID)
);

-- Ponemos los campos como Pnn y Vnn para poder aplicar cualquir variacion
-- Las variaciones entonces son programaticas
DROP TABLE  IF EXISTS VARIATIONS;
CREATE TABLE VARIATIONS  (
    ID        INTEGER       NOT NULL
   ,TMS       TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
	                    ON UPDATE CURRENT_TIMESTAMP   COMMENT 'Evitar duplicados'  
   ,SYMBOL    VARCHAR(64)   NOT NULL
   ,PRICE     DOUBLE                  COMMENT 'Precio actual'
   ,VOLUME    DOUBLE                  COMMENT 'Volumen actual'
   ,BEGPRICE  DOUBLE                  COMMENT 'Precio del cierre de sesion anterior'
   ,BEGVOLUME DOUBLE                  COMMENT 'Volumen del cierre de sesion anterior'
   ,P01       DOUBLE  COMMENT 'Variacion precio 01'
   ,P02       DOUBLE  COMMENT 'Variacion precio 02'   
   ,P03       DOUBLE  COMMENT 'Variacion precio 03'
   ,P04       DOUBLE  COMMENT 'Variacion precio 04'   
   ,P05       DOUBLE  COMMENT 'Variacion precio 05'
   ,P06       DOUBLE  COMMENT 'Variacion precio 06'   
   ,P07       DOUBLE  COMMENT 'Variacion precio 07'
   ,P08       DOUBLE  COMMENT 'Variacion precio 08'   
   ,P09       DOUBLE  COMMENT 'Variacion precio 09'
   ,P10       DOUBLE  COMMENT 'Variacion precio 10'   
   ,P11       DOUBLE  COMMENT 'Variacion precio 11'
   ,P12       DOUBLE  COMMENT 'Variacion precio 12'   
   ,V01       DOUBLE  COMMENT 'Variacion volumen 01'
   ,V02       DOUBLE  COMMENT 'Variacion volumen 02'   
   ,V03       DOUBLE  COMMENT 'Variacion volumen 03'
   ,V04       DOUBLE  COMMENT 'Variacion volumen 04'   
   ,V05       DOUBLE  COMMENT 'Variacion volumen 05'
   ,V06       DOUBLE  COMMENT 'Variacion volumen 06'   
   ,V07       DOUBLE  COMMENT 'Variacion volumen 07'
   ,V08       DOUBLE  COMMENT 'Variacion volumen 08'   
   ,V09       DOUBLE  COMMENT 'Variacion volumen 09'
   ,V10       DOUBLE  COMMENT 'Variacion volumen 10'   
   ,V11       DOUBLE  COMMENT 'Variacion volumen 11'
   ,V12       DOUBLE  COMMENT 'Variacion volumen 12'   
   ,PRIMARY KEY (ID, TMS)
--   ,UNIQUE  KEY (SYMBOL)  Pueden haber nombres duplicados
);

COMMIT;

