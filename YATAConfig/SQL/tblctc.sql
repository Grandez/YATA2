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
