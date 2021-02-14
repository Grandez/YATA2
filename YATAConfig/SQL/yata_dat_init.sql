DELETE FROM POSITION;
DELETE FROM REGULARIZATION;
DELETE FROM HIST_POSITION;
DELETE FROM FLOWS;
DELETE FROM OPERATIONS;
DELETE FROM OPERATIONS_CONTROL;
DELETE FROM OPERATIONS_LOG;

-- Camaras 
DELETE FROM CAMERAS;
INSERT INTO CAMERAS (CAMERA, NAME, MAKER, TAKER, ACTIVE) VALUES               ( "CASH"     ,"Cuenta de control"   ,0,     0, 0);
INSERT INTO CAMERAS (CAMERA, NAME, MAKER, TAKER, ACTIVE) VALUES               ( "POL"      ,"Poloniex"            ,0,     0, 1);
INSERT INTO CAMERAS (CAMERA, NAME, MAKER, TAKER, ACTIVE) VALUES               ( "BINANCE"  ,"Binance"             ,0,     0, 0);
INSERT INTO CAMERAS (CAMERA, NAME, MAKER, TAKER, ACTIVE) VALUES               ( "ETORO"    ,"eToro"               ,0,     0, 0);
INSERT INTO CAMERAS (CAMERA, NAME, MAKER, TAKER, ACTIVE) VALUES               ( "MKTSX"    ,"MarketSX"            ,0,     0, 0);
INSERT INTO CAMERAS (CAMERA, NAME, MAKER, TAKER, ACTIVE) VALUES               ( "KRAKEN"   ,"KRAKEN"              ,0,     0, 0);
INSERT INTO CAMERAS (CAMERA, NAME, MAKER, TAKER, ACTIVE) VALUES               ( "CBASE"    ,"Coin Base"           ,0,     0, 0);
INSERT INTO CAMERAS (CAMERA, NAME, MAKER, TAKER, ACTIVE) VALUES               ( "CBASEPRO" ,"Coin Base Pro"       ,0,     0, 0);
INSERT INTO CAMERAS (CAMERA, NAME, MAKER, TAKER, ACTIVE) VALUES               ( "BISQ"     ,"Bisq"                ,0,     0, 0);
INSERT INTO CAMERAS (CAMERA, NAME, MAKER, TAKER, ACTIVE) VALUES               ( "BBIT"     ,"ByBit"               ,0,     0, 0);
INSERT INTO CAMERAS (CAMERA, NAME, MAKER, TAKER, ACTIVE) VALUES               ( "FTX"      ,"FTX"                 ,0,     0, 0);
                                                         
COMMIT;