-- MariaDB dump 10.18  Distrib 10.5.8-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: YATASimm
-- ------------------------------------------------------
-- Server version	10.5.8-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `YATASimm`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `yatasimm` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `YATASimm`;

--
-- Table structure for table `flows`
--

DROP TABLE IF EXISTS `flows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `flows` (
  `ID_OPER` int(10) unsigned NOT NULL,
  `ID_FLOW` int(10) unsigned NOT NULL,
  `TYPE` tinyint(4) NOT NULL,
  `CURRENCY` varchar(18) NOT NULL,
  `AMOUNT` double NOT NULL,
  `PRICE` double NOT NULL,
  `TMS` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`ID_OPER`,`ID_FLOW`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flows`
--

LOCK TABLES `flows` WRITE;
/*!40000 ALTER TABLE `flows` DISABLE KEYS */;
/*!40000 ALTER TABLE `flows` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hist_position`
--

DROP TABLE IF EXISTS `hist_position`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hist_position` (
  `DATE_POS` date NOT NULL,
  `CAMERA` varchar(10) NOT NULL,
  `CURRENCY` varchar(10) NOT NULL,
  `BALANCE` double NOT NULL,
  `AVAILABLE` double NOT NULL,
  `BUY` double DEFAULT 0,
  `SELL` double DEFAULT 0,
  `COST` double DEFAULT 1,
  `NET` double DEFAULT 1,
  `TMS` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`DATE_POS`,`CAMERA`,`CURRENCY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hist_position`
--

LOCK TABLES `hist_position` WRITE;
/*!40000 ALTER TABLE `hist_position` DISABLE KEYS */;
/*!40000 ALTER TABLE `hist_position` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `operations`
--

DROP TABLE IF EXISTS `operations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `operations` (
  `ID_OPER` int(10) unsigned NOT NULL,
  `TYPE` tinyint(4) NOT NULL,
  `CAMERA` varchar(10) NOT NULL,
  `BASE` varchar(10) NOT NULL,
  `COUNTER` varchar(10) NOT NULL,
  `AMOUNT` double NOT NULL,
  `PRICE` double NOT NULL,
  `ACTIVE` tinyint(4) DEFAULT 1,
  `STATUS` tinyint(4) DEFAULT 0,
  `PARENT` int(10) unsigned DEFAULT 0,
  `RANK` int(11) DEFAULT 0,
  `TMS` timestamp NOT NULL DEFAULT current_timestamp(),
  `TMS_LAST` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`ID_OPER`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `operations`
--

LOCK TABLES `operations` WRITE;
/*!40000 ALTER TABLE `operations` DISABLE KEYS */;
INSERT INTO `operations` VALUES (2803220,1,'YATA','EUR','VNLA',100,18.37,2,16,0,0,'2021-03-27 17:08:07','2021-04-05 15:39:03'),(2952026,1,'YATA','EUR','STORJ',1000,2.37,2,16,0,0,'2021-03-27 17:32:55','2021-04-05 20:50:17'),(3003331,1,'YATA','EUR','ATT',1000,0.87,2,16,0,-1,'2021-03-27 17:41:28','2021-04-12 20:51:00'),(3640147,1,'YATA','EUR','BAR',100,39.24,2,16,0,-2,'2021-04-08 09:14:16','2021-04-12 20:53:34'),(3766654,1,'YATA','ATT','FIL',10,129.4,2,16,0,1,'2021-04-08 09:35:21','2021-04-09 17:49:42'),(14553660,1,'YATA','EUR','IGG',250000,0.002958,1,2,0,0,'2021-04-09 15:33:11','2021-04-09 17:46:14'),(15372767,3,'YATA','ATT','FIL',-10,129.4,0,2,3766654,0,'2021-04-08 09:35:21','2021-04-09 17:49:58'),(21147673,1,'YATA','EUR','XRP',500,0.9789,2,16,0,1,'2021-04-10 09:52:11','2021-04-12 20:47:05'),(21156075,1,'YATA','EUR','BNB',1,405.56,2,16,0,1,'2021-04-10 09:53:35','2021-04-12 20:49:17'),(21163277,1,'YATA','EUR','VET',1000,0.1158,2,16,0,-1,'2021-04-10 09:54:47','2021-04-12 20:52:02'),(32297181,4,'XFER','EXT','YATA',10000,1,0,2,0,0,'2021-03-19 13:17:08','2021-03-19 13:17:08'),(42357663,3,'YATA','EUR','XRP',-500,1.16,0,2,21147673,1,'2021-04-10 09:52:11','2021-04-12 20:52:55'),(42370269,3,'YATA','EUR','BNB',-1,507.38,0,2,21156075,0,'2021-04-10 09:53:35','2021-04-12 20:52:50'),(42374671,3,'YATA','EUR','LTC',-10,204.99,0,2,84638608,0,'2021-03-25 14:40:41','2021-04-12 20:52:45'),(42380573,3,'YATA','EUR','ATT',-1000,0.5242,0,2,3003331,0,'2021-03-27 17:41:28','2021-04-12 20:54:04'),(42386775,3,'YATA','EUR','VET',-1000,0.1119,0,2,21163277,0,'2021-04-10 09:54:47','2021-04-12 20:52:39'),(42395995,3,'YATA','EUR','BAR',-100,334.49,0,2,3640147,0,'2021-04-08 09:14:16','2021-04-12 20:53:59'),(47092805,1,'YATA','EUR','XRP',1000,1.36,1,2,0,0,'2021-04-13 09:56:22','2021-04-13 10:07:03'),(47101308,1,'YATA','EUR','CET',1000,0.06433,1,2,0,0,'2021-04-13 09:57:47','2021-04-13 10:06:57'),(47109010,1,'YATA','EUR','NEXO',1000,2.92,1,2,0,0,'2021-04-13 09:59:04','2021-04-13 10:06:51'),(57824658,3,'POL','EUR','BTC',-25,1000,0,2,57769256,0,'2021-04-14 15:35:47','2021-04-14 15:35:47'),(58034759,1,'YATA','EUR','ETH',1,1987.42,1,2,0,0,'2021-04-14 16:20:01','2021-04-14 16:20:01'),(58387061,1,'YATA','EUR','DOGE',10000,0.1104,1,2,0,0,'2021-04-14 17:18:44','2021-04-14 17:18:44'),(80028820,3,'YATA','EUR','VNLA',-100,40.145,0,2,2803220,0,'2021-03-27 17:08:07','2021-04-05 21:11:34'),(81896224,3,'YATA','EUR','STORJ',-1000,2.433,0,2,2952026,0,'2021-03-27 17:32:55','2021-04-05 21:01:15'),(84638608,1,'YATA','EUR','LTC',10,160,2,16,0,0,'2021-03-25 14:40:41','2021-04-12 20:50:01');
/*!40000 ALTER TABLE `operations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `operations_control`
--

DROP TABLE IF EXISTS `operations_control`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `operations_control` (
  `ID_OPER` int(10) unsigned NOT NULL,
  `FEE` double DEFAULT 0,
  `GAS` double DEFAULT 0,
  `TARGET` double DEFAULT NULL,
  `STOP` double DEFAULT NULL,
  `LIMITE` double DEFAULT NULL,
  `DEADLINE` int(11) DEFAULT 0,
  `AMOUNT_IN` double NOT NULL,
  `PRICE_IN` double NOT NULL,
  `ALERT` tinyint(4) DEFAULT 0,
  `TMS_ALERT` date DEFAULT NULL,
  `AMOUNT_OUT` double DEFAULT NULL,
  `PRICE_OUT` double DEFAULT NULL,
  PRIMARY KEY (`ID_OPER`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `operations_control`
--

LOCK TABLES `operations_control` WRITE;
/*!40000 ALTER TABLE `operations_control` DISABLE KEYS */;
INSERT INTO `operations_control` VALUES (2803220,0,0,NULL,NULL,NULL,0,100,18.37,1,'2021-03-27',100,40.115),(2952026,0,0,NULL,NULL,NULL,0,1000,2.37,1,'2021-03-27',1000,2.436),(3003331,0,0,NULL,NULL,NULL,0,1000,0.87,1,'2021-03-27',NULL,NULL),(3241438,0,0,NULL,NULL,NULL,0,500,3.51,1,'2021-04-08',NULL,NULL),(3640147,0,0,NULL,NULL,NULL,0,100,39.24,1,'2021-04-08',NULL,NULL),(3766654,0,0,150,NULL,NULL,15,10,129.4,1,'2021-04-08',NULL,NULL),(14553660,0,0,0.004,NULL,NULL,7,250000,0.002958,1,'2021-04-09',NULL,NULL),(15372767,0,0,NULL,NULL,NULL,0,-10,129.4,1,'2021-04-09',10,129.4),(21147673,0,0,1.02,NULL,NULL,5,500,0.9789,1,'2021-04-10',NULL,NULL),(21156075,0,0,425.838,NULL,NULL,5,1,405.56,1,'2021-04-10',NULL,NULL),(21163277,0,0,0.12,NULL,NULL,5,1000,0.1158,1,'2021-04-10',NULL,NULL),(42357061,0,0,NULL,NULL,NULL,0,-500,1.16,1,'2021-04-12',500,1.16),(42357663,0,0,NULL,NULL,NULL,0,-500,1.16,1,'2021-04-12',500,1.16),(42370269,0,0,NULL,NULL,NULL,0,-1,507.38,1,'2021-04-12',1,507.38),(42374671,0,0,NULL,NULL,NULL,0,-10,204.99,1,'2021-04-12',10,204.99),(42380573,0,0,NULL,NULL,NULL,0,-1000,0.5242,1,'2021-04-12',1000,0.5242),(42386775,0,0,NULL,NULL,NULL,0,-1000,0.1119,1,'2021-04-12',1000,0.1119),(42395995,0,0,NULL,NULL,NULL,0,-100,334.49,1,'2021-04-12',100,334.49),(47092805,0,0,1.4280000000000002,NULL,NULL,7,1000,1.36,1,'2021-04-13',NULL,NULL),(47101308,0,0,0.0675465,NULL,NULL,7,1000,0.06433,1,'2021-04-13',NULL,NULL),(47109010,0,0,3.066,NULL,NULL,7,1000,2.92,1,'2021-04-13',NULL,NULL),(57065825,0,0,NULL,NULL,NULL,0,2,1992.92,1,'2021-04-14',NULL,NULL),(57168728,0,0,NULL,NULL,NULL,0,1,1000,1,'2021-04-14',NULL,NULL),(57436230,0,0,NULL,NULL,NULL,0,10,1000,1,'2021-04-14',NULL,NULL),(57464632,0,0,NULL,NULL,NULL,0,10,1000,1,'2021-04-14',NULL,NULL),(57497034,0,0,NULL,NULL,NULL,0,10,1000,1,'2021-04-14',NULL,NULL),(57511236,0,0,NULL,NULL,NULL,0,10,100,1,'2021-04-14',NULL,NULL),(57573237,0,0,NULL,NULL,NULL,0,10,100,1,'2021-04-14',NULL,NULL),(57580338,0,0,NULL,NULL,NULL,0,10,1000,1,'2021-04-14',NULL,NULL),(57629139,0,0,NULL,NULL,NULL,0,10,100,1,'2021-04-14',NULL,NULL),(57726850,0,0,NULL,NULL,NULL,0,15,2000,1,'2021-04-14',NULL,NULL),(57751253,0,0,NULL,NULL,NULL,0,10,1000,1,'2021-04-14',NULL,NULL),(57755755,0,0,NULL,NULL,NULL,0,-10,10000,1,'2021-04-14',NULL,NULL),(57769256,0,0,NULL,NULL,NULL,0,25,5000,1,'2021-04-14',NULL,NULL),(57824658,0,0,NULL,NULL,NULL,0,-25,1000,1,'2021-04-14',NULL,NULL),(58034759,0,0,NULL,NULL,NULL,0,1,1987.42,1,'2021-04-14',NULL,NULL),(58387061,0,0,NULL,NULL,NULL,0,10000,0.1104,1,'2021-04-14',NULL,NULL),(80028820,0,0,NULL,NULL,NULL,0,-100,40.145,1,'2021-04-05',NULL,NULL),(80030622,0,0,NULL,NULL,NULL,0,-100,40.145,1,'2021-04-05',NULL,NULL),(81896224,0,0,NULL,NULL,NULL,0,-1000,2.433,1,'2021-04-05',NULL,NULL),(83141342,0,0,NULL,NULL,NULL,0,10,20,1,'2021-03-25',NULL,NULL),(84638608,0,0,NULL,NULL,NULL,0,10,160,1,'2021-03-25',NULL,NULL),(84646714,0,0,NULL,NULL,NULL,0,-10,200,1,'2021-03-25',NULL,NULL);
/*!40000 ALTER TABLE `operations_control` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `operations_log`
--

DROP TABLE IF EXISTS `operations_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `operations_log` (
  `ID_OPER` int(10) unsigned NOT NULL,
  `ID_LOG` int(10) unsigned NOT NULL,
  `TMS` timestamp NOT NULL DEFAULT current_timestamp(),
  `TYPE` tinyint(4) DEFAULT 0,
  `REASON` int(11) DEFAULT 0,
  `COMMENT` text DEFAULT NULL,
  PRIMARY KEY (`ID_OPER`,`ID_LOG`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `operations_log`
--

LOCK TABLES `operations_log` WRITE;
/*!40000 ALTER TABLE `operations_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `operations_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `path`
--

DROP TABLE IF EXISTS `path`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `path` (
  `PROVIDER` varchar(10) NOT NULL,
  `BASE` varchar(10) NOT NULL,
  `COUNTER` varchar(10) NOT NULL,
  `PATH1` varchar(10) DEFAULT NULL,
  `PATH2` varchar(10) DEFAULT NULL,
  `PATH3` varchar(10) DEFAULT NULL,
  `PATH4` varchar(10) DEFAULT NULL,
  `PATH5` varchar(10) DEFAULT NULL,
  `ACTIVE` tinyint(4) DEFAULT 1,
  PRIMARY KEY (`PROVIDER`,`BASE`,`COUNTER`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `path`
--

LOCK TABLES `path` WRITE;
/*!40000 ALTER TABLE `path` DISABLE KEYS */;
/*!40000 ALTER TABLE `path` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `position`
--

DROP TABLE IF EXISTS `position`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `position` (
  `CAMERA` varchar(10) NOT NULL,
  `CURRENCY` varchar(10) NOT NULL,
  `BALANCE` double DEFAULT 0,
  `AVAILABLE` double DEFAULT 0,
  `PRICE` double DEFAULT 1,
  `BUY` double DEFAULT 0,
  `SELL` double DEFAULT 0,
  `PRICEBUY` double DEFAULT 1,
  `PRICESELL` double DEFAULT 1,
  `SINCE` timestamp NOT NULL DEFAULT current_timestamp(),
  `LAST` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `CC` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`CAMERA`,`CURRENCY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `position`
--

LOCK TABLES `position` WRITE;
/*!40000 ALTER TABLE `position` DISABLE KEYS */;
INSERT INTO `position` VALUES ('POL','BTC',0,0,5000,25,25,5000,1000,'2021-04-14 15:35:48','2021-04-14 15:45:34',NULL),('POL','EUR',-100000,-100000,1,0,0,1,1,'2021-04-14 15:35:47','2021-04-14 15:45:31',NULL),('YATA','ATT',0,0,0,2294,2294,73.37122929380995,0.7925893635571055,'2021-03-27 17:41:41','2021-04-13 09:52:00',NULL),('YATA','BAR',0,0,0,100,100,39.24,334.49,'2021-04-08 09:22:22','2021-04-12 20:53:47',NULL),('YATA','BNB',0,0,0,1,1,405.56,507.38,'2021-04-10 09:59:59','2021-04-12 20:52:29',NULL),('YATA','CET',1000,1000,0.06433,1000,0,0.06433,1,'2021-04-13 10:06:57','2021-04-13 10:06:57',NULL),('YATA','DOGE',10000,10000,1,10000,0,0.1104,1,'2021-04-14 17:18:44','2021-04-14 17:18:44',NULL),('YATA','ETH',1,1,1,1,0,1987.42,1,'2021-04-14 16:20:01','2021-04-14 16:20:01',NULL),('YATA','EUR',106908.58,106908.58,1,1,1,1,1,'2021-03-19 13:17:08','2021-04-14 17:18:44',NULL),('YATA','FIL',0,0,0,10,10,129.4,129.4,'2021-04-08 10:00:25','2021-04-09 17:49:50',NULL),('YATA','IGG',250000,250000,0.002958,250000,0,0.002958,1,'2021-04-09 17:46:14','2021-04-09 17:46:14',NULL),('YATA','LTC',0,0,244.99,10,20,160,202.495,'2021-03-25 14:41:31','2021-04-13 09:51:50',NULL),('YATA','NEXO',1000,1000,2.92,1000,0,2.92,1,'2021-04-13 10:06:51','2021-04-13 10:06:51',NULL),('YATA','STORJ',0,0,0,1000,1000,2.37,2.433,'2021-03-27 17:33:25','2021-04-05 21:00:07',NULL),('YATA','VET',0,0,0,1000,1000,0.1158,0.1119,'2021-04-10 09:59:41','2021-04-12 20:52:24',NULL),('YATA','VNLA',0,0,61.92000000000001,100,200,18.37,40.145,'2021-03-27 17:08:31','2021-04-09 17:45:04',NULL),('YATA','XRP',1000,1000,0,1500,1500,1.2329666666666668,1.16,'2021-04-10 09:59:20','2021-04-13 10:07:03',NULL);
/*!40000 ALTER TABLE `position` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regularization`
--

DROP TABLE IF EXISTS `regularization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `regularization` (
  `CAMERA` varchar(10) NOT NULL,
  `CURRENCY` varchar(10) NOT NULL,
  `BALANCE` double DEFAULT 0,
  `AVAILABLE` double DEFAULT 0,
  `PRICE` double DEFAULT 1,
  `BUY` double DEFAULT 0,
  `SELL` double DEFAULT 0,
  `PRICEBUY` double DEFAULT 1,
  `PRICESELL` double DEFAULT 1,
  `SINCE` timestamp NOT NULL DEFAULT current_timestamp(),
  `LAST` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`CAMERA`,`CURRENCY`,`LAST`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `regularization`
--

LOCK TABLES `regularization` WRITE;
/*!40000 ALTER TABLE `regularization` DISABLE KEYS */;
INSERT INTO `regularization` VALUES ('POL','BTC',0,0,1,0,0,1,1,'2021-04-14 15:35:48','2021-04-14 15:35:48'),('POL','EUR',0,0,1,0,0,1,1,'2021-03-20 19:17:14','2021-03-01 19:17:14'),('POL','LPT',0,0,1,0,0,1,1,'2021-03-20 19:17:30','2021-03-01 19:17:30'),('YATA','ATT',0,0,1,0,0,1,1,'2021-03-27 17:41:41','2021-03-01 17:41:41'),('YATA','BAR',0,0,1,0,0,1,1,'2021-04-08 09:22:22','2021-04-08 09:22:22'),('YATA','BNB',0,0,1,0,0,1,1,'2021-04-10 09:59:59','2021-04-10 09:59:59'),('YATA','BTC',0,0,1,0,0,1,1,'2021-04-14 14:40:17','2021-04-14 14:40:17'),('YATA','CET',0,0,1,0,0,1,1,'2021-04-13 10:06:57','2021-04-13 10:06:57'),('YATA','DOGE',0,0,1,0,0,1,1,'2021-04-14 17:18:44','2021-04-14 17:18:44'),('YATA','ETH',0,0,1,0,0,1,1,'2021-04-14 16:20:01','2021-04-14 16:20:01'),('YATA','EUR',0,0,1,0,0,1,1,'2021-03-19 13:17:08','2021-03-01 13:17:08'),('YATA','FIL',0,0,1,0,0,1,1,'2021-04-08 10:00:25','2021-04-08 10:00:25'),('YATA','FX',0,0,1,0,0,1,1,'2021-03-20 19:17:20','2021-03-01 19:17:20'),('YATA','IGG',0,0,1,0,0,1,1,'2021-04-09 17:46:14','2021-04-09 17:46:14'),('YATA','KARMA',0,0,1,0,0,1,1,'2021-03-20 19:17:34','2021-03-01 19:17:34'),('YATA','LTC',0,0,1,0,0,1,1,'2021-03-22 22:17:13','2021-03-01 22:17:13'),('YATA','NEXO',0,0,1,0,0,1,1,'2021-04-13 10:06:51','2021-04-13 10:06:51'),('YATA','STORJ',0,0,1,0,0,1,1,'2021-03-27 17:33:25','2021-03-01 16:33:25'),('YATA','VET',0,0,1,0,0,1,1,'2021-04-10 09:59:41','2021-04-10 09:59:41'),('YATA','VNLA',0,0,1,0,0,1,1,'2021-03-27 17:08:31','2021-03-01 17:08:31'),('YATA','XRP',0,0,1,0,0,1,1,'2021-04-10 09:59:20','2021-04-10 09:59:20');
/*!40000 ALTER TABLE `regularization` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `session`
--

DROP TABLE IF EXISTS `session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `session` (
  `ID` double DEFAULT NULL,
  `SYMBOL` varchar(8) DEFAULT NULL,
  `RANK` double DEFAULT NULL,
  `PRICE` double DEFAULT NULL,
  `VOLUME` double DEFAULT NULL,
  `VOL24` double DEFAULT NULL,
  `VOL07` double DEFAULT NULL,
  `VOL30` double DEFAULT NULL,
  `VAR01` double DEFAULT NULL,
  `VAR24` double DEFAULT NULL,
  `VAR07` double DEFAULT NULL,
  `VAR30` double DEFAULT NULL,
  `VAR60` double DEFAULT NULL,
  `VAR90` double DEFAULT NULL,
  `DOMINANCE` double DEFAULT NULL,
  `TURNOVER` double DEFAULT NULL,
  `TMS` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session`
--

LOCK TABLES `session` WRITE;
/*!40000 ALTER TABLE `session` DISABLE KEYS */;
/*!40000 ALTER TABLE `session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `session_ctrl`
--

DROP TABLE IF EXISTS `session_ctrl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `session_ctrl` (
  `TMS` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`TMS`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session_ctrl`
--

LOCK TABLES `session_ctrl` WRITE;
/*!40000 ALTER TABLE `session_ctrl` DISABLE KEYS */;
INSERT INTO `session_ctrl` VALUES ('2021-04-14 17:13:30');
/*!40000 ALTER TABLE `session_ctrl` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-04-14 19:50:03
