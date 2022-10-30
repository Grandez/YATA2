-- ----------------------------------------------
-- Ajusta las tablas
-- ----------------------------------------------
-- Cambio en YATABase
   use YATABase;
   source yata_tables_base.sql;
   source yata_dat_base_init.sql;
   source currencies.sql;
   commit;

-- -------------------------------------------------------------------
-- Crea y carga las bases de datos a su estado inicial
-- -------------------------------------------------------------------
   
   use YATASimm;
   source yata_tables.sql;
   commit;
   
   use YATA;
   source yata_tables.sql;
   commit;
   
   use YATATpl;
   source yata_tables.sql;
   commit;

   use YATATest;
   source yata_tables.sql;
   
   commit;
   