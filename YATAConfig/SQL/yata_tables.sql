
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
   ,BALANCE     DOUBLE      DEFAULT 0.0 -- Saldo real 
   ,AVAILABLE   DOUBLE      DEFAULT 0.0 -- Saldo disponible
   ,PRICE       DOUBLE      DEFAULT 1.0   -- Precio neto de venta   
   ,BUY         DOUBLE      DEFAULT 0.0 -- Comprado
   ,SELL        DOUBLE      DEFAULT 0.0 -- Vendido   
   ,PRICEBUY    DOUBLE      DEFAULT 1.0 -- Comprado
   ,PRICESELL   DOUBLE      DEFAULT 1.0 -- Vendido   
   ,SINCE       TIMESTAMP   DEFAULT CURRENT_TIMESTAMP 
   ,LAST        TIMESTAMP   DEFAULT CURRENT_TIMESTAMP 
                            ON UPDATE CURRENT_TIMESTAMP          -- Ultima actualizacion
   ,CC          VARCHAR(512)        -- Codigo de cuenta
   ,PRIMARY KEY ( CAMERA, CURRENCY )
);

-- Contiene el registro de regularizacion
-- Para el calculo de los precios de coste y netos
DROP TABLE  IF EXISTS REGULARIZATION CASCADE;
CREATE TABLE REGULARIZATION  (
    CAMERA      VARCHAR(10) NOT NULL -- Codigo de camara
   ,CURRENCY    VARCHAR(10) NOT NULL -- Moneda
   ,BALANCE     DOUBLE      DEFAULT 0.0 -- Saldo real 
   ,AVAILABLE   DOUBLE      DEFAULT 0.0 -- Saldo disponible
   ,PRICE       DOUBLE      DEFAULT 1.0   -- Precio neto de venta   
   ,BUY         DOUBLE      DEFAULT 0.0 -- Comprado
   ,SELL        DOUBLE      DEFAULT 0.0 -- Vendido   
   ,PRICEBUY    DOUBLE      DEFAULT 1.0 -- Comprado
   ,PRICESELL   DOUBLE      DEFAULT 1.0 -- Vendido   
   ,SINCE       TIMESTAMP   DEFAULT CURRENT_TIMESTAMP    
   ,LAST        TIMESTAMP   DEFAULT CURRENT_TIMESTAMP 
                            ON UPDATE CURRENT_TIMESTAMP          -- Ultima actualizacion
   ,PRIMARY KEY ( CAMERA, CURRENCY, LAST DESC )
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
   ,BUY         DOUBLE      DEFAULT 0.0 -- Comprado
   ,SELL        DOUBLE      DEFAULT 0.0 -- Vendido      
   ,COST        DOUBLE      DEFAULT 1   -- Precio medio de compra
   ,NET         DOUBLE      DEFAULT 1   -- Precio neto de venta
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
    ID_OPER      INT UNSIGNED      NOT NULL -- Identificador de la operacion
   ,TYPE         TINYINT     NOT NULL -- Compra o Venta    
   ,CAMERA       VARCHAR(10) NOT NULL -- Clearing House
   ,BASE         VARCHAR(10) NOT NULL -- From currency
   ,COUNTER      VARCHAR(10) NOT NULL -- To currency
   ,AMOUNT       DOUBLE      NOT NULL -- Cantidad propuesta
   ,PRICE        DOUBLE      NOT NULL -- Precio de la operacion
   ,ACTIVE       TINYINT     DEFAULT 1 -- Flag activa/inactiva
   ,STATUS       TINYINT     DEFAULT 0 -- Estado de la operacion
   ,PARENT       INT UNSIGNED      DEFAULT 0 -- Padre de la operacion si se ha spliteado/neteado     
   ,RANK         INT               DEFAULT 0
   ,TMS          TIMESTAMP   DEFAULT   CURRENT_TIMESTAMP           -- Fecha de entrada
   ,TMS_LAST     TIMESTAMP  DEFAULT   CURRENT_TIMESTAMP 
                            ON UPDATE CURRENT_TIMESTAMP          -- Ultima actualizacion
   ,PRIMARY KEY ( ID_OPER )
);

-- Datos de control de la operacion
-- Los mantenemos aparte para la paginacion
DROP TABLE  IF EXISTS OPERATIONS_CONTROL;
CREATE TABLE OPERATIONS_CONTROL  (
    ID_OPER      INT UNSIGNED     NOT NULL -- Identificador de la operacion
   ,FEE          DOUBLE     DEFAULT 0.0  -- Comision
   ,GAS          DOUBLE     DEFAULT 0.0  -- Comision blockchain
   ,TARGET       DOUBLE                  -- Objetivo
   ,STOP         DOUBLE                  -- Stop
   ,LIMITE       DOUBLE                  -- Limit
   ,DEADLINE     INTEGER   DEFAULT 0     -- Plazo en dias
   ,AMOUNT       DOUBLE      NOT NULL -- Cantidad propuesta
   ,PRICE        DOUBLE      NOT NULL -- Precio de la operacion   
   ,ALERT        TINYINT     DEFAULT 0 -- Flag de alerta pendiente
   ,TMS_ALERT    DATE                -- Para chequear la operacion         
   ,PRIMARY KEY ( ID_OPER )
);

-- Datos de control de la operacion
-- Los mantenemos aparte para la paginacion
DROP TABLE  IF EXISTS OPERATIONS_LOG;
CREATE TABLE OPERATIONS_LOG  (
    ID_OPER      INT UNSIGNED     NOT NULL -- Identificador de la operacion
   ,TMS          TIMESTAMP    DEFAULT   CURRENT_TIMESTAMP -- Fecha de entrada       
   ,TYPE         TINYINT      DEFAULT 0 -- Tipo de entrada
   ,REASON       INTEGER      DEFAULT 0 -- Razon de la operacion

   ,COMMENT         TEXT 
   ,PRIMARY KEY ( ID_OPER, TMS )
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
    ID_OPER    INT UNSIGNED      NOT NULL -- Identificador de la operacion
   ,ID_FLOW    INT UNSIGNED      NOT NULL -- Identificador del flujo
   ,TYPE       TINYINT     NOT NULL -- Tipo de flujo segun codigo
   ,CURRENCY   VARCHAR(10) NOT NULL -- Moneda
   ,AMOUNT     DOUBLE      NOT NULL -- Unidades  
   ,PRICE      DOUBLE      NOT NULL -- Precio Necesario para saber la diferencia
   ,TMS          TIMESTAMP DEFAULT CURRENT_TIMESTAMP           -- Fecha de entrada
   ,PRIMARY KEY ( ID_OPER, ID_FLOW )
);

-- Tabla de razones de la operacion

-- DROP TABLE  IF EXISTS REASONS;
-- CREATE TABLE REASONS  (
--     ID_REASON      INT UNSIGNED     NOT NULL -- Identificador de la razon
--    ,DATA           TEXT       
--    ,TMS           TIMESTAMP DEFAULT CURRENT_TIMESTAMP           -- Fecha de entrada   
--    ,PRIMARY KEY ( ID_REASON )
-- );
-- 


