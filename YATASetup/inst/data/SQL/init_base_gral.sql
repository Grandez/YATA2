
-- Proveedores de datos
DELETE FROM PROVIDERS;       
INSERT INTO PROVIDERS  (PROVIDER, NAME, PRTY, ICON, OBJECT)  VALUES ('MKTCAP',   'CoinMarketCap'   , 1  ,"coinmarketcap.png"  ,"MarketCap" );
INSERT INTO PROVIDERS  (PROVIDER, NAME, PRTY, ICON, OBJECT)  VALUES ('POL'   ,   'Poloniex'        , 2  ,"poloniex.png"       ,"Poloniex"  );


-- DELETE FROM CAMERAS;                                                                                                            
-- INSERT INTO CAMERAS (CAMERA, NAME, MAKER, TAKER, ACTIVE)     VALUES ( "CASH"     ,"Cuenta de control"   ,0,  0,  0);
-- INSERT INTO CAMERAS (CAMERA, NAME, MAKER, TAKER, ACTIVE)     VALUES ( "POL"      ,"Poloniex"            ,0,  0,  0);
-- INSERT INTO CAMERAS (CAMERA, NAME, MAKER, TAKER, ACTIVE)     VALUES ( "BINANCE"  ,"Binance"             ,0,  0,  0);
-- INSERT INTO CAMERAS (CAMERA, NAME, MAKER, TAKER, ACTIVE)     VALUES ( "ETORO"    ,"eToro"               ,0,  0,  0);
-- INSERT INTO CAMERAS (CAMERA, NAME, MAKER, TAKER, ACTIVE)     VALUES ( "MKTSX"    ,"MarketSX"            ,0,  0,  0);
-- INSERT INTO CAMERAS (CAMERA, NAME, MAKER, TAKER, ACTIVE)     VALUES ( "KRAKEN"   ,"KRAKEN"              ,0,  0,  0);
-- INSERT INTO CAMERAS (CAMERA, NAME, MAKER, TAKER, ACTIVE)     VALUES ( "CBASE"    ,"Coin Base"           ,0,  0,  0);
-- INSERT INTO CAMERAS (CAMERA, NAME, MAKER, TAKER, ACTIVE)     VALUES ( "CBASEPRO" ,"Coin Base Pro"       ,0,  0,  0);
-- INSERT INTO CAMERAS (CAMERA, NAME, MAKER, TAKER, ACTIVE)     VALUES ( "BISQ"     ,"Bisq"                ,0,  0,  0);
-- INSERT INTO CAMERAS (CAMERA, NAME, MAKER, TAKER, ACTIVE)     VALUES ( "BBIT"     ,"ByBit"               ,0,  0,  0);
-- INSERT INTO CAMERAS (CAMERA, NAME, MAKER, TAKER, ACTIVE)     VALUES ( "FTX"      ,"FTX"                 ,0,  0,  0);
-- INSERT INTO CAMERAS (CAMERA, NAME, MAKER, TAKER, ACTIVE)     VALUES ( "YATA"     ,"YATA"                ,0,  0,  1);

-- -- Intercambios
-- DELETE FROM EXCHANGES;
-- INSERT INTO EXCHANGES  (CAMERA, SYMBOL, ACTIVE)  VALUES ("YATA",  "BTC",  1);
-- INSERT INTO EXCHANGES  (CAMERA, SYMBOL, ACTIVE)  VALUES ("YATA",  "ETH",  1);
-- INSERT INTO EXCHANGES  (CAMERA, SYMBOL, ACTIVE)  VALUES ("YATA",  "USDT", 1);
-- INSERT INTO EXCHANGES  (CAMERA, SYMBOL, ACTIVE)  VALUES ("YATA",  "XRP",  1);
-- INSERT INTO EXCHANGES  (CAMERA, SYMBOL, ACTIVE)  VALUES ("YATA",  "LTC",  1);
-- INSERT INTO EXCHANGES  (CAMERA, SYMBOL, ACTIVE)  VALUES ("YATA",  "BCH",  1);
-- INSERT INTO EXCHANGES  (CAMERA, SYMBOL, ACTIVE)  VALUES ("YATA",  "ADA",  1);
-- INSERT INTO EXCHANGES  (CAMERA, SYMBOL, ACTIVE)  VALUES ("YATA",  "BNB",  1);

COMMIT;