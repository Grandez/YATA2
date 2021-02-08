-- Camaras 
DELETE FROM CAMERAS;
INSERT INTO CAMERAS (CAMERA, NAME, MAKER, TAKER, ACTIVE) VALUES               ( "CASH"  ,"Cuenta de control"   ,0,     0, 0);

source ctc_dat_ctc.sql
                                                         
COMMIT;