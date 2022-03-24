-- !preview conn=DBI::dbConnect(RSQLite::SQLite())
USE __DB_NAME__;
LOAD DATA LOCAL
    INFILE '__DATA_FILE__'
    REPLACE
    INTO TABLE __TABLE_NAME__
    COLUMNS TERMINATED BY ';'
    ( __TABLE_COLUMNS__)
;
