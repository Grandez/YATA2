-- Monedas conocidas como duplicadas

-- haremos un proceso que actualice symbol a [$]n symbol
-- Luego podemos ir cambiando los nombres
-- SELECT COUNT(*) FROM  (SELECT A.SYMBOL, A.CNT FROM (SELECT SYMBOL, COUNT(*) AS CNT FROM CURRENCIES GROUP BY SYMBOL) AS A WHERE A.CNT = 2) AS B;

--- A
UPDATE CURRENCIES SET MKTCAP = "AAA"        , SYMBOL = "RABBIT"           WHERE ID = 11392;
UPDATE CURRENCIES SET MKTCAP = "AAPL"       , SYMBOL = "AAPL_BITTREX"     WHERE ID =  7924;
UPDATE CURRENCIES SET MKTCAP = "ABS"        , SYMBOL = "ABSORBER"         WHERE ID =  8032;
UPDATE CURRENCIES SET MKTCAP = "ACA"        , SYMBOL = "ACALA"            WHERE ID =  6756;
UPDATE CURRENCIES SET MKTCAP = "ACE"        , SYMBOL = "ASCEND"           WHERE ID =  5879;
UPDATE CURRENCIES SET MKTCAP = "ACE"        , SYMBOL = "ACE_ENT"          WHERE ID =  5717;
UPDATE CURRENCIES SET MKTCAP = "ACED"       , SYMBOL = "ACED_TOKEN"       WHERE ID = 16839;
UPDATE CURRENCIES SET MKTCAP = "ACM"        , SYMBOL = "ACTINIUM"         WHERE ID =  3386;
UPDATE CURRENCIES SET MKTCAP = "ACM"        , SYMBOL = "ACUMEN"           WHERE ID = 17791;
UPDATE CURRENCIES SET MKTCAP = "ACOIN"      , SYMBOL = "ALCHEMY"          WHERE ID =  5465;
UPDATE CURRENCIES SET MKTCAP = "ACT"        , SYMBOL = "ACET"             WHERE ID = 11706;
UPDATE CURRENCIES SET MKTCAP = "ACU"        , SYMBOL = "ACUITY"           WHERE ID =  7167;
UPDATE CURRENCIES SET MKTCAP = "ADOGE"      , SYMBOL = "ARBIDOGE"         WHERE ID = 11878;
UPDATE CURRENCIES SET MKTCAP = "aEth"       , SYMBOL = "AETHERIUS"        WHERE ID = 17134;
UPDATE CURRENCIES SET MKTCAP = "aEth"       , SYMBOL = "AAVE_ETH"         WHERE ID =  8595;
UPDATE CURRENCIES SET MKTCAP = "AFC"        , SYMBOL = "APIARY"           WHERE ID =  7469;
UPDATE CURRENCIES SET MKTCAP = "AI"         , SYMBOL = "FLOURISHING"      WHERE ID = 10712;
UPDATE CURRENCIES SET MKTCAP = "AI"         , SYMBOL = "MULTIVERSE"       WHERE ID = 11061;
UPDATE CURRENCIES SET MKTCAP = "AIDI"       , SYMBOL = "AIDI_BSC"         WHERE ID = 14246;
UPDATE CURRENCIES SET MKTCAP = "AIR"        , SYMBOL = "APE_RECORDS"      WHERE ID = 18626;
UPDATE CURRENCIES SET MKTCAP = "AIR"        , SYMBOL = "ALTAIR"           WHERE ID = 12209;
UPDATE CURRENCIES SET MKTCAP = "AIR"        , SYMBOL = "AIRDROPPER"       WHERE ID = 15955;

UPDATE CURRENCIES SET MKTCAP = "TITAN"      , SYMBOL = "ITITAN"           WHERE ID = 10467;


-- BANK
UPDATE CURRENCIES SET SYMBOL = "BANKDAO"      WHERE ID =  9607;
UPDATE CURRENCIES SET SYMBOL = "BANKCOIN"     WHERE ID =  8112;
UPDATE CURRENCIES SET SYMBOL = "CROBANK"      WHERE ID = 18157;

-- BULL
UPDATE CURRENCIES SET SYMBOL = "BULLION"      WHERE ID = 12961;
UPDATE CURRENCIES SET SYMBOL = "STRONGBULL"   WHERE ID = 16695;
UPDATE CURRENCIES SET SYMBOL = "BULLFINANCE"  WHERE ID = 10482;
UPDATE CURRENCIES SET SYMBOL = "BUYSELL"      WHERE ID =  5056;

-- EGG
UPDATE CURRENCIES SET MKTCAP = "EGG"         , SYMBOL = "GOOSE"        WHERE ID =  8449;
UPDATE CURRENCIES SET MKTCAP = "EGG"         , SYMBOL = "NESTEGG"      WHERE ID =  7665;
UPDATE CURRENCIES SET MKTCAP = "EGG"         , SYMBOL = "EGGCHICKEN"   WHERE ID = 16330;
UPDATE CURRENCIES SET MKTCAP = "EGG"         , SYMBOL = "POLYFARM"     WHERE ID = 17989;
UPDATE CURRENCIES SET MKTCAP = "EGG"         , SYMBOL = "WAVESDUCK"    WHERE ID = 10723;

-- FIRE
UPDATE CURRENCIES SET MKTCAP = "FIRE"        , SYMBOL = "FIREPHOENIX"  WHERE ID = 17407;
UPDATE CURRENCIES SET MKTCAP = "FIRE"        , SYMBOL = "FIREPROTO"    WHERE ID =  8129;
UPDATE CURRENCIES SET MKTCAP = "FIRE"        , SYMBOL = "FIRE_X"       WHERE ID = 18518;
UPDATE CURRENCIES SET MKTCAP = "FIRE"        , SYMBOL = "SOLFIRE"      WHERE ID = 16889;
UPDATE CURRENCIES SET MKTCAP = "FIRE"        , SYMBOL = "FIREFLAME"    WHERE ID = 15454;

-- FLOKI
UPDATE CURRENCIES SET MKTCAP = "FLOKI"       , SYMBOL = "BABY_MOON"    WHERE ID = 13074;
UPDATE CURRENCIES SET MKTCAP = "FLOKI"       , SYMBOL = "FLOKI_MUSK"   WHERE ID = 16703;
UPDATE CURRENCIES SET MKTCAP = "FLOKI"       , SYMBOL = "SHIBA_FLOKI"  WHERE ID = 10901;
UPDATE CURRENCIES SET MKTCAP = "FLOKI"       , SYMBOL = "FLOKI_ONE"    WHERE ID = 15525;

-- FREE
UPDATE CURRENCIES SET MKTCAP = "FREE"        , SYMBOL = "FREEDAO"      WHERE ID = 16148;
UPDATE CURRENCIES SET MKTCAP = "FREE"        , SYMBOL = "FREEDOM22"    WHERE ID = 18449;
UPDATE CURRENCIES SET MKTCAP = "FREE"        , SYMBOL = "FREERIVER"    WHERE ID = 11964;
UPDATE CURRENCIES SET MKTCAP = "FREE"        , SYMBOL = "LOCKDOWN"     WHERE ID =  9538;

-- GEM
UPDATE CURRENCIES SET MKTCAP = "GEM"         , SYMBOL = "YIELDHUNT"    WHERE ID = 17560;
UPDATE CURRENCIES SET MKTCAP = "GEM"         , SYMBOL = "AGE_KNIGHT"   WHERE ID = 16598;
UPDATE CURRENCIES SET MKTCAP = "GEM"         , SYMBOL = "NFTMALL"      WHERE ID = 12097;
UPDATE CURRENCIES SET MKTCAP = "GEM"         , SYMBOL = "CLAM_ISLAND"  WHERE ID = 12879;

-- GM
UPDATE CURRENCIES SET MKTCAP = "GM"          , SYMBOL = "GOLDMINER"    WHERE ID = 12967;
UPDATE CURRENCIES SET MKTCAP = "GM"          , SYMBOL = "GHOSTMARKET"  WHERE ID = 17454;
UPDATE CURRENCIES SET MKTCAP = "GM"          , SYMBOL = "GMHOLDING"    WHERE ID =  5698;
UPDATE CURRENCIES SET MKTCAP = "GM"          , SYMBOL = "GM_LOVE"      WHERE ID = 14438;
UPDATE CURRENCIES SET MKTCAP = "GM"          , SYMBOL = "GM_ETH"       WHERE ID = 14293;

-- GOLD
UPDATE CURRENCIES SET SYMBOL = "CYBERDRAGON"  WHERE ID = 12082;
UPDATE CURRENCIES SET SYMBOL = "GOLDENTOKEN"  WHERE ID =  4114;
UPDATE CURRENCIES SET SYMBOL = "MINNERJOE"    WHERE ID = 17934;
UPDATE CURRENCIES SET SYMBOL = "XBULLION"     WHERE ID = 12558;
UPDATE CURRENCIES SET SYMBOL = "GOLDFARM"     WHERE ID = 10642;

-- HERO
UPDATE CURRENCIES SET SYMBOL = "HEROSTEP"     WHERE ID = 11067;
UPDATE CURRENCIES SET SYMBOL = "BINAHERO"     WHERE ID = 15871;
UPDATE CURRENCIES SET SYMBOL = "HEROFLOKI"    WHERE ID = 13710;
UPDATE CURRENCIES SET SYMBOL = "SOLHERO"      WHERE ID = 18189;

-- LOVE
UPDATE CURRENCIES SET SYMBOL = "NFT_DAO"      WHERE ID = 18563;
UPDATE CURRENCIES SET SYMBOL = "LOVEPOT"      WHERE ID = 13433;
UPDATE CURRENCIES SET SYMBOL = "HUNNYDAO"     WHERE ID = 14960;
UPDATE CURRENCIES SET SYMBOL = "LOVECOIN"     WHERE ID =  6615;

-- META
UPDATE CURRENCIES SET MKTCAP = "META"       , SYMBOL = "METADIUM"     WHERE ID =  3418;
UPDATE CURRENCIES SET MKTCAP = "META"       , SYMBOL = "METAVERSE"    WHERE ID = 11373;
UPDATE CURRENCIES SET MKTCAP = "META"       , SYMBOL = "METACASH"     WHERE ID = 14567;
UPDATE CURRENCIES SET MKTCAP = "META"       , SYMBOL = "METAINU"      WHERE ID = 14659;
UPDATE CURRENCIES SET MKTCAP = "META"       , SYMBOL = "METAVERSEPRO" WHERE ID = 14705;
UPDATE CURRENCIES SET MKTCAP = "META"       , SYMBOL = "METAZUCK"     WHERE ID = 14826;
UPDATE CURRENCIES SET MKTCAP = "META"       , SYMBOL = "METAMUSK"     WHERE ID = 15404;
UPDATE CURRENCIES SET MKTCAP = "META"       , SYMBOL = "METALAND"     WHERE ID = 16931;

-- SCC
UPDATE CURRENCIES SET MKTCAP = "SCC"        , SYMBOL = "STAKECUBE"    WHERE ID =  3986;
UPDATE CURRENCIES SET MKTCAP = "SCC"        , SYMBOL = "SIACASH"      WHERE ID =  3128;
UPDATE CURRENCIES SET MKTCAP = "SCC"        , SYMBOL = "SCARYCHAIN"   WHERE ID = 16054;
UPDATE CURRENCIES SET MKTCAP = "SCC"        , SYMBOL = "SCC_DIG"      WHERE ID =  6266;

-- SOUL
UPDATE CURRENCIES SET MKTCAP = "SOUL"       , SYMBOL = "CRYPTOSOUL"   WHERE ID =  3501;
UPDATE CURRENCIES SET MKTCAP = "SOUL"       , SYMBOL = "SOULSWAP"     WHERE ID = 13342;
UPDATE CURRENCIES SET MKTCAP = "SOUL"       , SYMBOL = "HELLHOUNDS"   WHERE ID = 16436;
UPDATE CURRENCIES SET MKTCAP = "SOUL"       , SYMBOL = "CHAINZ"       WHERE ID =  5729;
UPDATE CURRENCIES SET MKTCAP = "SOUL"       , SYMBOL = "APO"          WHERE ID =  8684;

-- SPACE
UPDATE CURRENCIES SET SYMBOL = "APEROCKET"    WHERE ID = 10441;
UPDATE CURRENCIES SET SYMBOL = "SPACELEN"     WHERE ID = 11026;
UPDATE CURRENCIES SET SYMBOL = "FARMSPACE"    WHERE ID =  8952;
UPDATE CURRENCIES SET SYMBOL = "VORTEX"       WHERE ID = 16142;

-- WAR
UPDATE CURRENCIES SET SYMBOL = "WARRIOR"      WHERE ID =  8682;
UPDATE CURRENCIES SET SYMBOL = "WRAPPED"      WHERE ID = 11272;
UPDATE CURRENCIES SET SYMBOL = "NFTWARS"      WHERE ID =  8927;

-- ZOO
UPDATE CURRENCIES SET SYMBOL = "ZOOCRYPTO"    WHERE ID = 11556;
UPDATE CURRENCIES SET SYMBOL = "ZOOWORLD"     WHERE ID = 11020;
UPDATE CURRENCIES SET SYMBOL = "ZOOCOIN"      WHERE ID =  9007;
UPDATE CURRENCIES SET SYMBOL = "ZOOLABS"      WHERE ID = 13816;




