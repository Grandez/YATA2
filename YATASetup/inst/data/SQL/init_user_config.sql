DELETE FROM CONFIG;

-- 1 - 1 - Usuario
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  1,   1,   1,   1,   1, 'user'           , 'YATA'  );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  1,   1,   1,   2,   1, 'pwd'            , 'yata'  );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  1,   1,   1,   3,   1, 'fiat'           , 'EUR'   );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  1,   1,   1,   4,   1, 'lang'           , 'XX'    );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  1,   1,   1,   5,   1, 'region'         , 'XX'    );
                                                                                                                          
-- 1 - 2 - Preferencias
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  1,   2,   2,   1,  10, 'default'        , '1'     );                                                                                                 
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  1,   2,   2,   2,  10, 'autoOpen'       , '1'     );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  1,   2,   2,   3,  10, 'last'           , '1'     );                                                                                                 
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  1,   2,   2,   4,  20, 'cookies'        , '1'     );         
-- 3 - 

INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  2,   1,   2,   1,   1, 'label'          , 'auto save'                 );         
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  2,   2,   1,   1,  10, 'interval'       , '15'                        );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  2,   2,   2,   2,   1, 'label'          , 'autoupdate every minutes'  );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  2,   3,   1,   1,  10, 'alive'          , '16'                        );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  2,   3,   2,   2,   1, 'label'          , 'obtain session data'       );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  2,   4,   1,   1,  10, 'history'        , '48'                        );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  2,   4,   2,   2,   1, 'label'          , 'historia a mantener'       );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  2,   5,   1,   1,  10, 'each'           ,  '3'                        );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  2,   5,   2,   2,   1, 'label'          ,  'no se'                    );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  2,   6,   1,   1,  10, 'sleep'          ,  '1'                        );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  2,   6,   2,   2,   1, 'label'          ,  'no se'                    );

-- 5 - Carteras/Portfolios
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   1,   1,   1,  10, 'id'             , '1'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   1,   1,   2,   1, 'name'           , 'Cartera General'           );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   1,   1,   3,   1, 'title'          , 'GENERAL'                   );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   1,   1,   4,  10, 'scope'          , '1'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   1,   1,   5,  10, 'target'         , '3'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   1,   1,   6,  10, 'selective'      , '0'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   1,   1,   7,   1, 'comment'        , 'Cartera de pruebas'        );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   1,   1,   8,   1, 'db_sfx'         , 'YATA'                      );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   1,   1,   9,  20, 'active'         , '1'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   1,   1,  10,  31, 'since'          , '1970-01-01'                );

INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   2,   2,   1,  10, 'id'             , '2'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   2,   2,   2,   1, 'name'           , 'Tokens'                    );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   2,   2,   3,   1, 'title'          , 'TOKENS'                    );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   2,   2,   4,  10, 'scope'          , '2'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   2,   2,   5,  10, 'target'         , '2'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   2,   2,   6,  10, 'selective'      , '0'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   2,   2,   7,   1, 'comment'        , 'Solo tokens'               );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   2,   2,   8,   1, 'db_sfx'         , 'TOKENS'                    );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   2,   2,   9,  20, 'active'         , '1'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   2,   2,  10,  31, 'since'          , '1970-01-01'                );

INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   3,   3,   1,  10, 'id'             , '3'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   3,   3,   2,   1, 'name'           , 'Coins'                     );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   3,   3,   3,   1, 'title'          , 'COINS'                     );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   3,   3,   4,  10, 'scope'          , '2'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   3,   3,   5,  10, 'target'         , '1'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   3,   3,   6,  10, 'selective'      , '0'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   3,   3,   7,   1, 'comment'        , 'Solo monedas'              );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   3,   3,   8,   1, 'db_sfx'         , 'COINS'                     );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   3,   3,   9,  20, 'active'         , '1'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   3,   3,  10,  31, 'since'          , '1970-01-01'                );

INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   4,   4,   1,  10, 'id'             , '4'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   4,   4,   2,   1, 'name'           , 'Short'                     );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   4,   4,   3,   1, 'title'          , 'SHORT'                     );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   4,   4,   4,  10, 'scope'          , '1'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   4,   4,   5,  10, 'target'         , '3'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   4,   4,   6,  10, 'selective'      , '0'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   4,   4,   7,   1, 'comment'        , 'Corto plazo'               );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   4,   4,   8,   1, 'db_sfx'         , 'SHORT'                     );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   4,   4,   9,  20, 'active'         , '1'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   4,   4,  10,  31, 'since'          , '1970-01-01'                );

INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   5,   5,   1,  10, 'id'             , '5'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   5,   5,   2,   1, 'name'           , 'Medium'                    );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   5,   5,   3,   1, 'title'          , 'MEDIUM'                    );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   5,   5,   4,  10, 'scope'          , '2'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   5,   5,   5,  10, 'target'         , '3'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   5,   5,   6,  10, 'selective'      , '100'                       );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   5,   5,   7,   1, 'comment'        , 'Medio plazo'               );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   5,   5,   8,   1, 'db_sfx'         , 'MEDIUM'                    );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   5,   5,   9,  20, 'active'         , '1'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   5,   5,  10,  31, 'since'          , '1970-01-01'                );
                                                                                                                                                        
-- 10 - Database info for portfolios for current user                                                                                                                                       
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10,   1,   1,   1,   1, 'engine'        , 'MariaDB'                    );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10,   1,   1,   2,   1, 'host'          , '127.0.0.1'                  );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10,   1,   1,   3,  10, 'port'          , '3306'                       );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10,   1,   1,   4,   1, 'user'          , 'YATA'                       );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10,   1,   1,   5,   1, 'password'      , 'yata'                       );

COMMIT;