-- Monedas conocidas como duplicadas

-- haremos un proceso que actualice symbol a [$]n symbol
-- Luego podemos ir cambiando los nombres
-- SELECT COUNT(*) FROM  (SELECT A.SYMBOL, A.CNT FROM (SELECT SYMBOL, COUNT(*) AS CNT FROM CURRENCIES GROUP BY SYMBOL) AS A WHERE A.CNT = 2) AS B;

--- A
UPDATE CURRENCIES SET MKTCAP = "AAA"        , SYMBOL = "RABBIT"           WHERE ID =     11392;
UPDATE CURRENCIES SET MKTCAP = "AAPL"       , SYMBOL = "AAPL_BITTREX"     WHERE ID =      7924;
UPDATE CURRENCIES SET MKTCAP = "ABS"        , SYMBOL = "ABSORBER"         WHERE ID =      8032;
UPDATE CURRENCIES SET MKTCAP = "ACA"        , SYMBOL = "ACALA"            WHERE ID =      6756;
UPDATE CURRENCIES SET MKTCAP = "ACE"        , SYMBOL = "ASCEND"           WHERE ID =      5879;
UPDATE CURRENCIES SET MKTCAP = "ACE"        , SYMBOL = "ACE_ENT"          WHERE ID =      5717;
UPDATE CURRENCIES SET MKTCAP = "ACED"       , SYMBOL = "ACED_TOKEN"       WHERE ID =     16839;
UPDATE CURRENCIES SET MKTCAP = "ACM"        , SYMBOL = "ACTINIUM"         WHERE ID =      3386;
UPDATE CURRENCIES SET MKTCAP = "ACM"        , SYMBOL = "ACUMEN"           WHERE ID =     17791;
UPDATE CURRENCIES SET MKTCAP = "ACOIN"      , SYMBOL = "ALCHEMY"          WHERE ID =      5465;
UPDATE CURRENCIES SET MKTCAP = "ACT"        , SYMBOL = "ACET"             WHERE ID =     11706;
UPDATE CURRENCIES SET MKTCAP = "ACU"        , SYMBOL = "ACUITY"           WHERE ID =      7167;
UPDATE CURRENCIES SET MKTCAP = "ADOGE"      , SYMBOL = "ARBIDOGE"         WHERE ID =     11878;
UPDATE CURRENCIES SET MKTCAP = "aEth"       , SYMBOL = "AETHERIUS"        WHERE ID =     17134;
UPDATE CURRENCIES SET MKTCAP = "aEth"       , SYMBOL = "AAVE_ETH"         WHERE ID =      8595;
UPDATE CURRENCIES SET MKTCAP = "AFC"        , SYMBOL = "APIARY"           WHERE ID =      7469;
UPDATE CURRENCIES SET MKTCAP = "AI"         , SYMBOL = "FLOURISHING"      WHERE ID =     10712;
UPDATE CURRENCIES SET MKTCAP = "AI"         , SYMBOL = "MULTIVERSE"       WHERE ID =     11061;
UPDATE CURRENCIES SET MKTCAP = "AIDI"       , SYMBOL = "AIDI_BSC"         WHERE ID =     14246;
UPDATE CURRENCIES SET MKTCAP = "AIR"        , SYMBOL = "APE_RECORDS"      WHERE ID =     18626;
UPDATE CURRENCIES SET MKTCAP = "AIR"        , SYMBOL = "ALTAIR"           WHERE ID =     12209;
UPDATE CURRENCIES SET MKTCAP = "AIR"        , SYMBOL = "AIRDROPPER"       WHERE ID =     15955;
                                                                                         
UPDATE CURRENCIES SET MKTCAP = "TITAN"      , SYMBOL = "ITITAN"           WHERE ID =     10467;


-- B
UPDATE CURRENCIES SET MKTCAP = "BANK"          , SYMBOL = "BANKDAO"         WHERE ID =    9607;
UPDATE CURRENCIES SET MKTCAP = "BANK"          , SYMBOL = "BANKCOIN"        WHERE ID =    8112;
UPDATE CURRENCIES SET MKTCAP = "BANK"          , SYMBOL = "CROBANK"         WHERE ID =   18157;
UPDATE CURRENCIES SET MKTCAP = "BCP"           , SYMBOL = "BCP_PIEDAO"      WHERE ID =    8323;
UPDATE CURRENCIES SET MKTCAP = "BCP"           , SYMBOL = "BCP_BLOCK"       WHERE ID =   11338;
UPDATE CURRENCIES SET MKTCAP = "BCP"           , SYMBOL = "BCP_BITCASH"     WHERE ID =   11882;
UPDATE CURRENCIES SET MKTCAP = "BID"           , SYMBOL = "BID_DEFI"        WHERE ID =    6857;
UPDATE CURRENCIES SET MKTCAP = "BID"           , SYMBOL = "BID_BIDAO"       WHERE ID =    7200;
UPDATE CURRENCIES SET MKTCAP = "BID"           , SYMBOL = "BID_BIDDER"      WHERE ID =    9236;
UPDATE CURRENCIES SET MKTCAP = "BULL"          , SYMBOL = "BULLION"         WHERE ID =   12961;
UPDATE CURRENCIES SET MKTCAP = "BULL"          , SYMBOL = "STRONGBULL"      WHERE ID =   16695;
UPDATE CURRENCIES SET MKTCAP = "BULL"          , SYMBOL = "BULLFINANCE"     WHERE ID =   10482;
UPDATE CURRENCIES SET MKTCAP = "BULL"          , SYMBOL = "BUYSELL"         WHERE ID =    5056;
                                                                                         
-- C                                                                                     
UPDATE CURRENCIES SET MKTCAP = "CBC"          , SYMBOL = "CBC_BOSS"         WHERE ID =    4633;
UPDATE CURRENCIES SET MKTCAP = "CBC"          , SYMBOL = "CBC_BHARAT"       WHERE ID =    5563;
UPDATE CURRENCIES SET MKTCAP = "CBC"          , SYMBOL = "CBC_CARBON"       WHERE ID =   11214;
UPDATE CURRENCIES SET MKTCAP = "CBT"          , SYMBOL = "CRYPTOBLAST"      WHERE ID =   14479;
UPDATE CURRENCIES SET MKTCAP = "CBT"          , SYMBOL = "CRYPTOBANK"       WHERE ID =   17204;
UPDATE CURRENCIES SET MKTCAP = "CBT"          , SYMBOL = "CRYPTOBATTLES"    WHERE ID =   18408;
UPDATE CURRENCIES SET MKTCAP = "CBT"          , SYMBOL = "CYBLOC"           WHERE ID =   18659;
                                                                                         
UPDATE CURRENCIES SET MKTCAP = "CPU"          , SYMBOL = "$CPU"             WHERE ID =    8295;
UPDATE CURRENCIES SET MKTCAP = "CPX"          , SYMBOL = "$CPX"             WHERE ID =   14615;                                            

-- D
UPDATE CURRENCIES SET MKTCAP = "DON"          , SYMBOL = "DONNIE"           WHERE ID =    8814;
UPDATE CURRENCIES SET MKTCAP = "DON"          , SYMBOL = "DON_KEY"          WHERE ID =    9643;
UPDATE CURRENCIES SET MKTCAP = "DON"          , SYMBOL = "DONGEON"          WHERE ID =   16750;

-- E                    
UPDATE CURRENCIES SET MKTCAP = "EFT"          ,SYMBOL = "EFT_ENERGY"       WHERE ID =    15602;                    
UPDATE CURRENCIES SET MKTCAP = "EFT"          ,SYMBOL = "EFT_ETERNAL"      WHERE ID =    16143;                    
UPDATE CURRENCIES SET MKTCAP = "EFT"          ,SYMBOL = "EFT_ETH"          WHERE ID =    16230;                    

UPDATE CURRENCIES SET MKTCAP = "EGG"          ,SYMBOL = "GOOSE"            WHERE ID =     8449;
UPDATE CURRENCIES SET MKTCAP = "EGG"          ,SYMBOL = "NESTEGG"          WHERE ID =     7665;
UPDATE CURRENCIES SET MKTCAP = "EGG"          ,SYMBOL = "EGGCHICKEN"       WHERE ID =    16330;
UPDATE CURRENCIES SET MKTCAP = "EGG"          ,SYMBOL = "POLYFARM"         WHERE ID =    17989;
UPDATE CURRENCIES SET MKTCAP = "EGG"          ,SYMBOL = "WAVESDUCK"        WHERE ID =    10723;
                                                                                        
-- F                                                                                    
UPDATE CURRENCIES SET MKTCAP = "FIRE"         ,SYMBOL = "FIREPHOENIX"      WHERE ID =    17407;
UPDATE CURRENCIES SET MKTCAP = "FIRE"         ,SYMBOL = "FIREPROTO"        WHERE ID =     8129;
UPDATE CURRENCIES SET MKTCAP = "FIRE"         ,SYMBOL = "FIRE_X"           WHERE ID =    18518;
UPDATE CURRENCIES SET MKTCAP = "FIRE"         ,SYMBOL = "SOLFIRE"          WHERE ID =    16889;
UPDATE CURRENCIES SET MKTCAP = "FIRE"         ,SYMBOL = "FIREFLAME"        WHERE ID =    15454;
UPDATE CURRENCIES SET MKTCAP = "FLOKI"        ,SYMBOL = "BABY_MOON"        WHERE ID =    13074;
UPDATE CURRENCIES SET MKTCAP = "FLOKI"        ,SYMBOL = "FLOKI_MUSK"       WHERE ID =    16703;
UPDATE CURRENCIES SET MKTCAP = "FLOKI"        ,SYMBOL = "SHIBA_FLOKI"      WHERE ID =    10901;
UPDATE CURRENCIES SET MKTCAP = "FLOKI"        ,SYMBOL = "FLOKI_ONE"        WHERE ID =    15525;
UPDATE CURRENCIES SET MKTCAP = "FREE"         ,SYMBOL = "FREEDAO"          WHERE ID =    16148;
UPDATE CURRENCIES SET MKTCAP = "FREE"         ,SYMBOL = "FREEDOM22"        WHERE ID =    18449;
UPDATE CURRENCIES SET MKTCAP = "FREE"         ,SYMBOL = "FREERIVER"        WHERE ID =    11964;
UPDATE CURRENCIES SET MKTCAP = "FREE"         ,SYMBOL = "LOCKDOWN"         WHERE ID =     9538;
UPDATE CURRENCIES SET MKTCAP = "FREN"         ,SYMBOL = "FREN_TOKEN"       WHERE ID =    14476;
UPDATE CURRENCIES SET MKTCAP = "FREN"         ,SYMBOL = "FREN_SOLANA"      WHERE ID =    16377;
UPDATE CURRENCIES SET MKTCAP = "FREN"         ,SYMBOL = "FREN_COIN"        WHERE ID =    17495;
                                                                                        
-- G                                                                                    
UPDATE CURRENCIES SET MKTCAP = "GEM"          ,SYMBOL = "YIELDHUNT"        WHERE ID =    17560;
UPDATE CURRENCIES SET MKTCAP = "GEM"          ,SYMBOL = "AGE_KNIGHT"       WHERE ID =    16598;
UPDATE CURRENCIES SET MKTCAP = "GEM"          ,SYMBOL = "NFTMALL"          WHERE ID =    12097;
UPDATE CURRENCIES SET MKTCAP = "GEM"          ,SYMBOL = "CLAM_ISLAND"      WHERE ID =    12879;
UPDATE CURRENCIES SET MKTCAP = "GM"           ,SYMBOL = "GOLDMINER"        WHERE ID =    12967;
UPDATE CURRENCIES SET MKTCAP = "GM"           ,SYMBOL = "GHOSTMARKET"      WHERE ID =    17454;
UPDATE CURRENCIES SET MKTCAP = "GM"           ,SYMBOL = "GMHOLDING"        WHERE ID =     5698;
UPDATE CURRENCIES SET MKTCAP = "GM"           ,SYMBOL = "GM_LOVE"          WHERE ID =    14438;
UPDATE CURRENCIES SET MKTCAP = "GM"           ,SYMBOL = "GM_ETH"           WHERE ID =    14293;
UPDATE CURRENCIES SET MKTCAP = "GOLD"         ,SYMBOL = "CYBERDRAGON"      WHERE ID =    12082;
UPDATE CURRENCIES SET MKTCAP = "GOLD"         ,SYMBOL = "GOLDENTOKEN"      WHERE ID =     4114;
UPDATE CURRENCIES SET MKTCAP = "GOLD"         ,SYMBOL = "MINNERJOE"        WHERE ID =    17934;
UPDATE CURRENCIES SET MKTCAP = "GOLD"         ,SYMBOL = "XBULLION"         WHERE ID =    12558;
UPDATE CURRENCIES SET MKTCAP = "GOLD"         ,SYMBOL = "GOLDFARM"         WHERE ID =    10642;
                                              
-- H                                          
UPDATE CURRENCIES SET MKTCAP = "HERO"         ,SYMBOL = "HEROSTEP"          WHERE ID =   11067;
UPDATE CURRENCIES SET MKTCAP = "HERO"         ,SYMBOL = "BINAHERO"          WHERE ID =   15871;
UPDATE CURRENCIES SET MKTCAP = "HERO"         ,SYMBOL = "HEROFLOKI"         WHERE ID =   13710;
UPDATE CURRENCIES SET MKTCAP = "HERO"         ,SYMBOL = "SOLHERO"           WHERE ID =   18189;
                                              
-- K                                          
UPDATE CURRENCIES SET MKTCAP = "KITTY"        ,SYMBOL = "KITTY_COIN"        WHERE ID =   13576;                                                                                         
UPDATE CURRENCIES SET MKTCAP = "KITTY"        ,SYMBOL = "KITTY_SOLANA"      WHERE ID =   14382;
UPDATE CURRENCIES SET MKTCAP = "KITTY"        ,SYMBOL = "KITTY_COIN_SOL"    WHERE ID =   15892;
UPDATE CURRENCIES SET MKTCAP = "KITTY"        ,SYMBOL = "KITTY_FINANCE"     WHERE ID =   15948;
UPDATE CURRENCIES SET MKTCAP = "KITTY"        ,SYMBOL = "KITTY_CAT"         WHERE ID =   16539;
                                              
-- L                                          
UPDATE CURRENCIES SET MKTCAP = "LOOT"         ,SYMBOL = "LOOT_NET"          WHERE ID =   15890;
UPDATE CURRENCIES SET MKTCAP = "LOOT"         ,SYMBOL = "LOOT_GAME"         WHERE ID =   16746;
UPDATE CURRENCIES SET MKTCAP = "LOOT"         ,SYMBOL = "LOOT_TOKEN"        WHERE ID =   17614;
UPDATE CURRENCIES SET MKTCAP = "LOOT"         ,SYMBOL = "LOOTEX"            WHERE ID =   17623;
UPDATE CURRENCIES SET MKTCAP = "LOVE"         ,SYMBOL = "NFT_DAO"           WHERE ID =   18563;
UPDATE CURRENCIES SET MKTCAP = "LOVE"         ,SYMBOL = "LOVEPOT"           WHERE ID =   13433;
UPDATE CURRENCIES SET MKTCAP = "LOVE"         ,SYMBOL = "HUNNYDAO"          WHERE ID =   14960;
UPDATE CURRENCIES SET MKTCAP = "LOVE"         ,SYMBOL = "LOVECOIN"          WHERE ID =    6615;
                                                                                         
-- M                        
UPDATE CURRENCIES SET MKTCAP = "MARS"        ,SYMBOL = "MARS_NETWORK"       WHERE ID =    7579;                                                              
UPDATE CURRENCIES SET MKTCAP = "MARS"        ,SYMBOL = "MARS_COIN"          WHERE ID =     154;
UPDATE CURRENCIES SET MKTCAP = "MARS"        ,SYMBOL = "MARS_PROTO"         WHERE ID =   18621;                                                                                                                            
UPDATE CURRENCIES SET MKTCAP = "META"        ,SYMBOL = "METADIUM"           WHERE ID =    3418;
UPDATE CURRENCIES SET MKTCAP = "META"        ,SYMBOL = "METAVERSE"          WHERE ID =   11373;
UPDATE CURRENCIES SET MKTCAP = "META"        ,SYMBOL = "METACASH"           WHERE ID =   14567;
UPDATE CURRENCIES SET MKTCAP = "META"        ,SYMBOL = "METAINU"            WHERE ID =   14659;
UPDATE CURRENCIES SET MKTCAP = "META"        ,SYMBOL = "METAVERSEPRO"       WHERE ID =   14705;
UPDATE CURRENCIES SET MKTCAP = "META"        ,SYMBOL = "METAZUCK"           WHERE ID =   14826;
UPDATE CURRENCIES SET MKTCAP = "META"        ,SYMBOL = "METAMUSK"           WHERE ID =   15404;
UPDATE CURRENCIES SET MKTCAP = "META"        ,SYMBOL = "METALAND"           WHERE ID =   16931;
UPDATE CURRENCIES SET MKTCAP = "MNFT"        ,SYMBOL = "MARVEL_NFT"         WHERE ID =   16218;
UPDATE CURRENCIES SET MKTCAP = "MNFT"        ,SYMBOL = "MEMENFT"            WHERE ID =   16822;
UPDATE CURRENCIES SET MKTCAP = "MNFT"        ,SYMBOL = "MONGOL_NFT"         WHERE ID =   17543;
UPDATE CURRENCIES SET MKTCAP = "MNFT"        ,SYMBOL = "META_NFT"           WHERE ID =   18140;
                                                                            
-- P
UPDATE CURRENCIES SET MKTCAP = "PPC"        , SYMBOL = "_PPC"               WHERE ID =    6253;        

-- R
UPDATE CURRENCIES SET MKTCAP = "RICE"       , SYMBOL = "RICE_WALLET"        WHERE ID =   14611;        
UPDATE CURRENCIES SET MKTCAP = "RICE"       , SYMBOL = "RICE_ROOSTER"       WHERE ID =   15265;
UPDATE CURRENCIES SET MKTCAP = "RICE"       , SYMBOL = "RICE_DAO_SQUARE"    WHERE ID =   12807;                
UPDATE CURRENCIES SET MKTCAP = "RBT"        , SYMBOL = "RBT_TOKEN"          WHERE ID =   10822;
UPDATE CURRENCIES SET MKTCAP = "RBT"        , SYMBOL = "RBT_RUBIX"          WHERE ID =   17972;
UPDATE CURRENCIES SET MKTCAP = "RBT"        , SYMBOL = "RBT_RABET"          WHERE ID =   18001;
                
                                                                                                               
-- S                                                                                    
UPDATE CURRENCIES SET MKTCAP = "SCC"        , SYMBOL = "STAKECUBE"          WHERE ID =    3986;
UPDATE CURRENCIES SET MKTCAP = "SCC"        , SYMBOL = "SIACASH"            WHERE ID =    3128;
UPDATE CURRENCIES SET MKTCAP = "SCC"        , SYMBOL = "SCARYCHAIN"         WHERE ID =   16054;
UPDATE CURRENCIES SET MKTCAP = "SCC"        , SYMBOL = "SCC_DIG"            WHERE ID =    6266;
UPDATE CURRENCIES SET MKTCAP = "SEED"       , SYMBOL = "SEED_DEFI"          WHERE ID =    9377;
UPDATE CURRENCIES SET MKTCAP = "SEED"       , SYMBOL = "SEED_SESAME"        WHERE ID =    4980;
UPDATE CURRENCIES SET MKTCAP = "SEED"       , SYMBOL = "SEED_FARM"          WHERE ID =   13466;
UPDATE CURRENCIES SET MKTCAP = "SOUL"       , SYMBOL = "CRYPTOSOUL"         WHERE ID =    3501;
UPDATE CURRENCIES SET MKTCAP = "SOUL"       , SYMBOL = "SOULSWAP"           WHERE ID =   13342;
UPDATE CURRENCIES SET MKTCAP = "SOUL"       , SYMBOL = "HELLHOUNDS"         WHERE ID =   16436;
UPDATE CURRENCIES SET MKTCAP = "SOUL"       , SYMBOL = "CHAINZ"             WHERE ID =    5729;
UPDATE CURRENCIES SET MKTCAP = "SOUL"       , SYMBOL = "APO"                WHERE ID =    8684;
UPDATE CURRENCIES SET MKTCAP = "SPACE"      , SYMBOL = "APEROCKET"          WHERE ID =   10441;
UPDATE CURRENCIES SET MKTCAP = "SPACE"      , SYMBOL = "SPACELEN"           WHERE ID =   11026;
UPDATE CURRENCIES SET MKTCAP = "SPACE"      , SYMBOL = "FARMSPACE"          WHERE ID =    8952;
UPDATE CURRENCIES SET MKTCAP = "SPACE"      , SYMBOL = "VORTEX"             WHERE ID =   16142;
                                                                                        
-- T                                                                                    
UPDATE CURRENCIES SET MKTCAP = "TAG"      , SYMBOL = "TAG_PROTOCOL"         WHERE ID =   14896;

-- V                                                                                    
UPDATE CURRENCIES SET MKTCAP = "VAL"        ,SYMBOL = "VAL_SORA"            WHERE ID =    7876;
UPDATE CURRENCIES SET MKTCAP = "VAL"        ,SYMBOL = "VAL_VALKIRIA"        WHERE ID =    9516;
UPDATE CURRENCIES SET MKTCAP = "VAL"        ,SYMBOL = "VAL_VIKINGS"         WHERE ID =   15611;
                                                                                        
-- W                                                                                    
UPDATE CURRENCIES SET MKTCAP = "WAR"        ,SYMBOL = "WARRIOR"             WHERE ID =    8682;
UPDATE CURRENCIES SET MKTCAP = "WAR"        ,SYMBOL = "WRAPPED"             WHERE ID =   11272;
UPDATE CURRENCIES SET MKTCAP = "WAR"        ,SYMBOL = "NFTWARS"             WHERE ID =    8927;
UPDATE CURRENCIES SET MKTCAP = "WEB3"       ,SYMBOL = "WEB3LAND"            WHERE ID =   17904;
UPDATE CURRENCIES SET MKTCAP = "WEB3"       ,SYMBOL = "WEB3DOGE"            WHERE ID =   18293;
UPDATE CURRENCIES SET MKTCAP = "WEB3"       ,SYMBOL = "WEB3PROJECT"         WHERE ID =   18999;
UPDATE CURRENCIES SET MKTCAP = "WEB3"       ,SYMBOL = "WEB3GAME"            WHERE ID =   19569;
                                                                                        
-- Z                                                                                    
UPDATE CURRENCIES SET MKTCAP = "ZOO"        ,SYMBOL = "ZOOCRYPTO"           WHERE ID =   11556;
UPDATE CURRENCIES SET MKTCAP = "ZOO"        ,SYMBOL = "ZOOWORLD"            WHERE ID =   11020;
UPDATE CURRENCIES SET MKTCAP = "ZOO"        ,SYMBOL = "ZOOCOIN"             WHERE ID =    9007;
UPDATE CURRENCIES SET MKTCAP = "ZOO"        ,SYMBOL = "ZOOLABS"             WHERE ID =   13816;
                                                                            



