-- -------------------------------------------------------------------
-- La base de datos BASE contiene las tablas que son comunes 
-- Y la configuracion inicial
-- -------------------------------------------------------------------
-- Tabla de Parametros
DROP TABLE  IF EXISTS CONFIG CASCADE;
CREATE TABLE CONFIG  (
    GRUPO    INTEGER     NOT NULL -- Grupo, no usamos GROUP para evitar problemas de nombres
   ,SUBGROUP INTEGER     NOT NULL -- Parametro
   ,BLOCK    INTEGER     DEFAULT 0
   ,ID       INTEGER     NOT NULL -- Parametro
   ,TYPE     TINYINT     NOT NULL -- Tipo de parametro
   ,NAME     VARCHAR(32) NOT NULL
   ,VALUE    VARCHAR(64) NOT NULL
   ,PRIMARY KEY ( GRUPO, SUBGROUP, BLOCK, ID ) USING BTREE
);

DROP TABLE  IF EXISTS CAMERAS CASCADE;
CREATE TABLE CAMERAS  (
    CAMERA   VARCHAR(64)  NOT NULL -- Codigo de camara
   ,DESCR    VARCHAR(64)  NOT NULL  
   ,EXCHANGE INTEGER      NOT NULL -- Pointer to Exchanges
   ,ACTIVE   TINYINT      DEFAULT 1 
-- Datos de acceso
   ,TOKEN    VARCHAR(255)
   ,USR      VARCHAR(64) 
   ,PWD      VARCHAR(64) 
   ,CC       VARCHAR(512)        -- Codigo de cuenta   
   ,PRIMARY KEY ( CAMERA )
);

DROP TABLE  IF EXISTS TRANSFERS;
CREATE TABLE TRANSFERS  (
    ID_XFER      INT UNSIGNED  NOT NULL -- Identificador de la operacion
   ,CAMERA_OUT   VARCHAR(32)   NOT NULL  -- Clearing from
   ,CAMERA_IN    VARCHAR(32)   NOT NULL  -- Clearing to
   ,CURRENCY     VARCHAR(64)   NOT NULL  -- Currency
   ,AMOUNT       DOUBLE        NOT NULL  -- Cantidad
   ,VALUE        DOUBLE        NOT NULL  -- Valor
   ,TMS          TIMESTAMP     DEFAULT   CURRENT_TIMESTAMP           -- Fecha de entrada
   ,PRIMARY KEY ( ID_XFER )
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

INSERT INTO CAMERAS( CAMERA, DESCR, EXCHANGE, ACTIVE) VALUES ("CASH", "Cuenta Fiduciaria", 0, 1);