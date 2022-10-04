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
