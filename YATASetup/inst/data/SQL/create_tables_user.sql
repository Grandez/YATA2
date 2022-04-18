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
