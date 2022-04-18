use YATABase;

-- -------------------------------------------------------------------
-- La base de datos BASE contiene las tablas que son comunes 
-- Y la configuracion inicial
-- -------------------------------------------------------------------
-- Tabla de Parametros
DROP TABLE  IF EXISTS PARAMETERS CASCADE;
CREATE TABLE PARAMETERS  (
    GRUPO    INTEGER     NOT NULL -- Grupo, no usamos GROUP para evitar problemas de nombres
   ,SUBGROUP INTEGER     NOT NULL -- Parametro
   ,BLOCK    INTEGER     DEFAULT 0
   ,ID       INTEGER     NOT NULL -- Parametro
   ,TYPE     TINYINT     NOT NULL -- Tipo de parametro
   ,NAME     VARCHAR(32) NOT NULL
   ,VALUE    VARCHAR(64) NOT NULL
   ,PRIMARY KEY ( GRUPO, SUBGROUP, BLOCK, ID ) USING BTREE
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

-- Tabla de Textos
-- bLOCK ES para recuperar traducciones de bloques
DROP TABLE  IF EXISTS MESSAGES;
CREATE TABLE MESSAGES  (
    BLOCK    INTEGER         NOT NULL DEFAULT 0
   ,CODE     VARCHAR    (64) NOT NULL
   ,LANG     CHAR(2)         NOT NULL DEFAULT "XX"
   ,REGION   CHAR(2)         NOT NULL DEFAULT "XX"
   ,VALUE    VARCHAR(255)
   ,PRIMARY KEY ( BLOCK, CODE, LANG, REGION ) 
   ,INDEX       (        CODE, LANG, REGION )  
);


