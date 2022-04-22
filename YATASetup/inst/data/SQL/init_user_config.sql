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
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   1,   1,   2,   1, 'name'           , 'Cartera Windows'           );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   1,   1,   3,   1, 'title'          , 'WINDOWS'                   );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   1,   1,   4,   1, 'scope'          , '1'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   1,   1,   5,  10, 'target'         , '3'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   1,   1,   6,  10, 'selective_ctc'  , '0'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   1,   1,   7,  10, 'selective_tok'  , '0'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   1,   1,   8,   1, 'comment'        , 'Cartera de pruebas'                );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   1,   1,   9,  10, 'db'             , '1'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   1,   1,  10,  20, 'active'         , '1'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   1,   1,  11,  31, 'since'          , '1970-01-01'                );

INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   2,   2,   1,  10, 'id'             , '2'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   2,   2,   2,   1, 'name'           , 'Cartera 1'                 );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   2,   2,   3,   1, 'title'          , 'SHORT'                     );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   2,   2,   4,   1, 'scope'          , '1'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   2,   2,   5,  10, 'target'         , '3'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   2,   2,   6,  10, 'selective_ctc'  , '0'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   2,   2,   7,  10, 'selective_tok'  , '0'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   2,   2,   8,   1, 'comment'        , 'Simulacion'                );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   2,   2,   9,  10, 'db'             , '2'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   2,   2,  10,  20, 'active'         , '1'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   2,   2,  11,  31, 'since'          , '1970-01-01'                );

INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   3,   3,   1,  10, 'id'             , '3'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   3,   3,   2,   1, 'name'           , 'Cartera 2'                 );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   3,   3,   3,   1, 'title'          , 'SHORT'                     );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   3,   3,   4,   1, 'scope'          , '1'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   3,   3,   5,  10, 'target'         , '3'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   3,   3,   6,  10, 'selective_ctc'  , '0'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   3,   3,   7,  10, 'selective_tok'  , '0'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   3,   3,   8,   1, 'comment'        , 'Simulacion'                );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   3,   3,   9,  10, 'db'             , '3'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   3,   3,  10,  20, 'active'         , '1'                         );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES (  5,   3,   3,  11,  31, 'since'          , '1970-01-01'                );
                                                                                                                                                        
-- 10 - Databases                                                                                                                                       
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10,   1,   1,   1,   1, 'name'          , 'Normal'                     );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10,   1,   1,   2,   1, 'descr'         , 'YATA Pruebas'               );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10,   1,   1,   3,   1, 'engine'        , 'MariaDB'                    );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10,   1,   1,   4,   1, 'dbname'        , 'YATA_YATA'                  );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10,   1,   1,   5,   1, 'host'          , '127.0.0.1'                  );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10,   1,   1,   6,  10, 'port'          , '3306'                       );

INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10,   2,   1,   1,   1, 'name'          , 'Simm'                       );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10,   2,   1,   2,   1, 'descr'         , 'YATA Simulacion'            );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10,   2,   1,   3,   1, 'engine'        , 'MariaDB'                    );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10,   2,   1,   4,   1, 'dbname'        , 'YATA_SIMM'                  );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10,   2,   1,   5,   1, 'host'          , '127.0.0.1'                  );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10,   2,   1,   6,  10, 'port'          , '3306'                       );

INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10,   3,   2,   1,   1, 'name'          , 'Test'                       );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10,   3,   2,   2,   1, 'descr'         , 'YATA Test'                  );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10,   3,   2,   3,   1, 'engine'        , 'MariaDB'                    );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10,   3,   2,   4,   1, 'dbname'        , 'YATA_TEST'                  );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10,   3,   2,   5,   1, 'host'          , '127.0.0.1'                  );
INSERT INTO  CONFIG   (GRUPO, SUBGROUP, BLOCK, ID, TYPE, NAME, VALUE) VALUES ( 10,   3,   2,   6,  10, 'port'          , '3306'                       );

COMMIT;