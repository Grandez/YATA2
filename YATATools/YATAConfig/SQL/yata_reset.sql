use YATABase;
source yata_tables_base.sql;
source yata_dat_base_init.sql;
commit;

use YATATest;
source yata_tables.sql;
source yata_dat_init.sql;
commit;

use YATASimm;
source yata_tables.sql;
source yata_dat_init.sql;
commit;

use YATA;
source yata_tables.sql;
source yata_dat_init.sql;
commit;

use YATATpl;
source yata_tables.sql;
source yata_dat_init.sql;
commit;