-- Script de creacion de BBDD
-- Necesita ejecutarse como root
-- Variables:
-- __DB__ Database YATACI
-- __DBUSER__ Usuario de YATA

DROP DATABASE IF EXISTS __DB__;
CREATE DATABASE __DB__ CHARACTER SET utf8 COLLATE utf8_general_ci;

GRANT ALL PRIVILEGES ON __DB__.*  TO '__DBUSER__'@'localhost' WITH GRANT OPTION;