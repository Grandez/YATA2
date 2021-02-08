-- Tabla de Camaras
-- Lugares donde puede haber cuentas
DROP TABLE  IF EXISTS CAMERAS CASCADE;
CREATE TABLE CAMERAS  (
    CAMERA     VARCHAR(10) NOT NULL -- Codigo de camara
   ,NAME       VARCHAR(32) NOT NULL           -- Clearing Name
   ,BASE       VARCHAR(10) NOT NULL -- Moneda base 
   ,MAKER      DOUBLE      NOT NULL DEFAULT 0 -- Fees
   ,TAKER      DOUBLE      NOT NULL DEFAULT 0
   ,ACTIVE     TINYINT     NOT NULL DEFAULT 1 -- 0 Inactivo / 1 Activo   
-- Datos de acceso
   ,TOKEN      VARCHAR(256)
   ,USER       VARCHAR(32) 
   ,PWD        VARCHAR(32) 
   ,PRIMARY KEY ( CAMERA )
);


-- Tabla de Posiciones
-- Necesita un clearing global, cuyo precio medio se calcula como la media de los otros
-- Simplemente guarda la posicion de cada cuenta
-- El disponible se alamacena y se ajusta por diferencias
-- ---------------------------------------------------------
-- NO ADMITIMOS VARIAS MONEDAS EN LA MISMA CAMARA
-- ---------------------------------------------------------
--       Con lo que el ID es simplemente un numero

DROP TABLE  IF EXISTS POSITION CASCADE;
CREATE TABLE POSITION  (
    CAMERA      VARCHAR(10) NOT NULL -- Codigo de camara
   ,CURRENCY    VARCHAR(10) NOT NULL -- Moneda
   ,BALANCE     DOUBLE     DEFAULT 0.0 -- Saldo real 
   ,AVAILABLE   DOUBLE     DEFAULT 0.0 -- Saldo disponible
   ,PRICE       DOUBLE     DEFAULT 1   -- Precio medio
   ,TMS         TIMESTAMP   DEFAULT CURRENT_TIMESTAMP 
                            ON UPDATE CURRENT_TIMESTAMP          -- Ultima actualizacion
   ,CC          VARCHAR(512)        -- Codigo de cuenta
   ,PRIMARY KEY ( CAMERA, CURRENCY )
);

-- Tabla de Cuentas/Camara historica
-- Simplemente guarda la posicion de cada cuenta por dias
-- De acuerdo con la cotizacion de ese dia
-- Se ordena por fecha descendente
DROP TABLE  IF EXISTS HIST_POSITION CASCADE;
CREATE TABLE HIST_POSITION  (
    DATE_POS    DATE        NOT NULL
   ,CAMERA      VARCHAR(10) NOT NULL -- Codigo de camara
   ,CURRENCY    VARCHAR(10) NOT NULL -- Moneda
   ,BALANCE     DOUBLE      NOT NULL -- Saldo real 
   ,AVAILABLE   DOUBLE      NOT NULL -- Saldo disponible
   ,PRICE       DOUBLE      NOT NULL -- Precio medio
   ,TMS         TIMESTAMP   DEFAULT CURRENT_TIMESTAMP 
                            ON UPDATE CURRENT_TIMESTAMP          -- Ultima actualizacion
   ,PRIMARY KEY ( DATE_POS DESC, CAMERA, CURRENCY )
);

-- ------------------------------------------------------------------
-- Operaciones
-- Una operacion tiene:
--    Un registro padre
--    Un conjunto de flujos
--
-- En un split cerramos la operacion y creamos dos nuevas
-- la primera se vende completa
-- Cuando vendemos mas de la compra, buscamos hacia atras
-- Es decir:
--  Op 1 - Compro 1000  a 100
--  Op 2 - Compro 1000  a  50
--  Op 3 - Vendo 1500
--         Calcular el valor en base al split
--            100 * 100 + 500 * 50
--         Op 1 - Se cierra como vendida
--         Op 2 - Se splitea
--                op 4 - 500 y cerrada padre 2  hija de Op 3
--                op 5 - 500 y abierta padre 2 
-- ------------------------------------------------------------------

-- En principio las operaciones deben empezar en una compra
-- luego acabar con una venta
-- Pero se podria splitear, es decir, compro 1000 y primero vendo 300, luego otras 300, etc
DROP TABLE  IF EXISTS OPERATIONS;
CREATE TABLE OPERATIONS  (
    ID_OPER      BIGINT      NOT NULL -- Identificador de la operacion
   ,TYPE         TINYINT     NOT NULL -- Compra o Venta    
   ,CAMERA       VARCHAR(10) NOT NULL -- Clearing House
   ,BASE         VARCHAR(10) NOT NULL -- From currency
   ,COUNTER      VARCHAR(10) NOT NULL -- To currency
   ,AMOUNT       DOUBLE      NOT NULL -- Cantidad propuesta
   ,PRICE        DOUBLE      NOT NULL -- Precio de la operacion
   ,ACTIVE       TINYINT     DEFAULT 1 -- Flag activa/inactiva
   ,STATUS       TINYINT     DEFAULT 0 -- Motivo estado
   ,ALERT        TINYINT     DEFAULT 0 -- Flag de alerta pendiente
   ,PARENT       BIGINT      DEFAULT 0 -- Padre de la operacion si se ha spliteado/neteado      
   ,TMS          TIMESTAMP   DEFAULT   CURRENT_TIMESTAMP           -- Fecha de entrada
   ,TMS_ALERT    DATE                -- Para chequear la operacion   
   ,TMS_LAST     TIMESTAMP  DEFAULT   CURRENT_TIMESTAMP 
                            ON UPDATE CURRENT_TIMESTAMP          -- Ultima actualizacion
   ,PRIMARY KEY ( ID_OPER )
   ,UNIQUE KEY  ( CAMERA, BASE, COUNTER, TMS)
   ,KEY         ( STATUS, TMS )
);

-- Datos de control de la operacion
-- Los mantenemos aparte para la paginacion
DROP TABLE  IF EXISTS OPERATIONS_CONTROL;
CREATE TABLE OPERATIONS_CONTROL  (
    ID_OPER      BIGINT     NOT NULL -- Identificador de la operacion
   ,FEE          DOUBLE     DEFAULT 0.0  -- Comision
   ,GAS          DOUBLE     DEFAULT 0.0  -- Comision blockchain
   ,PRIMARY KEY ( ID_OPER )
);

-- Datos de control de la operacion
-- Los mantenemos aparte para la paginacion
DROP TABLE  IF EXISTS OPERATIONS_LOG;
CREATE TABLE OPERATIONS_LOG  (
    ID_OPER      BIGINT     NOT NULL -- Identificador de la operacion
   ,ID_LOG       BIGINT     NOT NULL -- Identificador de la operacion
   ,TYPE         TINYINT    DEFAULT 0 -- Flag de alerta pendiente
   ,TMS          TIMESTAMP  DEFAULT   CURRENT_TIMESTAMP           -- Fecha de entrada       
   ,COMMENT         TEXT 
   ,PRIMARY KEY ( ID_OPER, ID_LOG )
);

-- Flujos
-- Cada operacion lleva asociado una serie de flujos:
-- La compra, la comision, las tasas
-- La venta, comisiones, etc.
-- Type:
--   0 - Compra
--   1 - Venta
--   2 - Comision
--   3 - Tasa
--   ... 
DROP TABLE  IF EXISTS FLOWS;
CREATE TABLE FLOWS  (
    ID_OPER    BIGINT     NOT NULL -- Identificador de la operacion
   ,ID_FLOW    BIGINT     NOT NULL -- Identificador del flujo
   ,TYPE       TINYINT    NOT NULL -- Tipo de concepto  
                                     --  1 - Compra
                                     --  2 - Venta
                                     -- 11 - Comision camara
                                     -- 12 - Tasa  de gas
   ,CLEARING   VARCHAR(8) NOT NULL -- Camara                                     
   ,CURRENCY   VARCHAR(8) NOT NULL -- Moneda
   ,AMOUNT     DOUBLE     NOT NULL -- Unidades  
   ,TMS          TIMESTAMP DEFAULT CURRENT_TIMESTAMP           -- Fecha de entrada
   ,PRIMARY KEY ( ID_OPER, ID_FLOW )
);

-- Tabla de razones de la operacion

DROP TABLE  IF EXISTS REASONS;
CREATE TABLE REASONS  (
    ID_REASON      BIGINT     NOT NULL -- Identificador de la razon
   ,DATA           TEXT       
   ,TMS           TIMESTAMP DEFAULT CURRENT_TIMESTAMP           -- Fecha de entrada   
   ,PRIMARY KEY ( ID_REASON )
);



