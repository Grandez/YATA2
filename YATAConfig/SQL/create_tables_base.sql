use YATABase;

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
   ,MSG      VARCHAR(255)
   ,PRIMARY KEY ( BLOCK, CODE, LANG, REGION ) 
);


