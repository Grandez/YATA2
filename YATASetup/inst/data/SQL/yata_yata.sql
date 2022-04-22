/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

CREATE DATABASE IF NOT EXISTS `YATA_YATA` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `YATA_YATA`;

CREATE TABLE IF NOT EXISTS `ALERTS` (
  `ID_ALERT` int(10) unsigned NOT NULL,
  `TYPE` tinyint(4) DEFAULT 0,
  `SUBJECT` varchar(64) NOT NULL,
  `MATCHER` char(2) NOT NULL,
  `TARGET` varchar(64) NOT NULL,
  `STATUS` tinyint(4) DEFAULT 0,
  `ACTIVE` tinyint(4) DEFAULT 1,
  `TMS` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`ID_ALERT`),
  KEY `ACTIVE` (`ACTIVE`,`TYPE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `ALERTS` DISABLE KEYS */;
/*!40000 ALTER TABLE `ALERTS` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `BLOG` (
  `ID_BLOG` int(10) unsigned NOT NULL,
  `TMS` timestamp NOT NULL DEFAULT current_timestamp(),
  `TYPE` tinyint(4) DEFAULT 0,
  `TARGET` varchar(64) DEFAULT NULL,
  `TITLE` varchar(255) DEFAULT NULL,
  `SUMMARY` text DEFAULT NULL,
  `DATA` text DEFAULT NULL,
  PRIMARY KEY (`ID_BLOG`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `BLOG` DISABLE KEYS */;
/*!40000 ALTER TABLE `BLOG` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `CAMERAS` (
  `CAMERA` varchar(64) NOT NULL,
  `DESCR` varchar(64) NOT NULL,
  `EXCHANGE` int(11) NOT NULL,
  `ACTIVE` tinyint(4) DEFAULT 1,
  `TOKEN` varchar(255) DEFAULT NULL,
  `USR` varchar(64) DEFAULT NULL,
  `PWD` varchar(64) DEFAULT NULL,
  `CC` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`CAMERA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `CAMERAS` DISABLE KEYS */;
INSERT INTO `CAMERAS` (`CAMERA`, `DESCR`, `EXCHANGE`, `ACTIVE`, `TOKEN`, `USR`, `PWD`, `CC`) VALUES
	('CASH', 'FIAT Externo', 0, 0, NULL, NULL, NULL, NULL),
	('DEFAULT', 'Camara general', 0, 1, NULL, NULL, NULL, NULL);
/*!40000 ALTER TABLE `CAMERAS` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `CONFIG` (
  `GRUPO` int(11) NOT NULL,
  `SUBGROUP` int(11) NOT NULL,
  `BLOCK` int(11) NOT NULL DEFAULT 0,
  `ID` int(11) NOT NULL,
  `TYPE` tinyint(4) NOT NULL,
  `NAME` varchar(32) NOT NULL,
  `VALUE` varchar(64) NOT NULL,
  PRIMARY KEY (`GRUPO`,`SUBGROUP`,`BLOCK`,`ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `CONFIG` DISABLE KEYS */;
INSERT INTO `CONFIG` (`GRUPO`, `SUBGROUP`, `BLOCK`, `ID`, `TYPE`, `NAME`, `VALUE`) VALUES
	(1, 1, 1, 1, 1, 'user', 'YATA'),
	(1, 1, 1, 2, 1, 'pwd', 'yata'),
	(1, 1, 1, 3, 1, 'fiat', 'EUR'),
	(1, 1, 1, 4, 1, 'lang', 'XX'),
	(1, 1, 1, 5, 1, 'region', 'XX'),
	(1, 2, 2, 1, 10, 'default', '1'),
	(1, 2, 2, 2, 10, 'autoOpen', '1'),
	(1, 2, 2, 3, 10, 'last', '1'),
	(2, 1, 1, 1, 20, 'cookies', '1'),
	(2, 1, 2, 1, 1, 'label', 'auto save'),
	(2, 2, 1, 1, 10, 'interval', '15'),
	(2, 2, 2, 2, 1, 'label', 'autoupdate every minutes'),
	(2, 3, 1, 1, 10, 'alive', '16'),
	(2, 3, 2, 2, 1, 'label', 'obtain session data'),
	(2, 4, 1, 1, 10, 'history', '48'),
	(2, 4, 2, 2, 1, 'label', 'historia a mantener'),
	(2, 5, 1, 1, 10, 'each', '3'),
	(2, 5, 2, 2, 1, 'label', 'no se'),
	(2, 6, 1, 1, 10, 'sleep', '1'),
	(2, 6, 2, 2, 1, 'label', 'no se'),
	(5, 1, 1, 1, 1, 'id', 'Simm'),
	(5, 1, 1, 2, 1, 'name', 'Cartera 1'),
	(5, 1, 1, 3, 1, 'title', 'SHORT'),
	(5, 1, 1, 4, 1, 'scope', '1'),
	(5, 1, 1, 5, 10, 'target', '1'),
	(5, 1, 1, 6, 10, 'selective_ctc', '0'),
	(5, 1, 1, 7, 10, 'selective_tok', '0'),
	(5, 1, 1, 8, 1, 'comment', 'Simulacion'),
	(5, 1, 1, 9, 10, 'db', '1'),
	(5, 1, 1, 10, 20, 'active', '1'),
	(5, 1, 1, 11, 31, 'since', '1970-01-01'),
	(5, 2, 2, 1, 1, 'id', 'Test'),
	(5, 2, 2, 2, 1, 'name', 'Cartera 2'),
	(5, 2, 2, 3, 1, 'title', 'SHORT'),
	(5, 2, 2, 4, 1, 'scope', '1'),
	(5, 2, 2, 5, 10, 'target', '1'),
	(5, 2, 2, 6, 10, 'selective_ctc', '0'),
	(5, 2, 2, 7, 10, 'selective_tok', '0'),
	(5, 2, 2, 8, 1, 'comment', 'Simulacion'),
	(5, 2, 2, 9, 10, 'db', '2'),
	(5, 2, 2, 10, 20, 'active', '1'),
	(5, 2, 2, 11, 31, 'since', '1970-01-01'),
	(10, 1, 1, 1, 1, 'name', 'Simm'),
	(10, 1, 1, 2, 1, 'descr', 'YATA Simulacion'),
	(10, 1, 1, 3, 1, 'engine', 'MariaDB'),
	(10, 1, 1, 4, 1, 'dbname', 'YATA_Simm'),
	(10, 1, 1, 5, 1, 'host', '127.0.0.1'),
	(10, 1, 1, 6, 10, 'port', '3306'),
	(10, 2, 2, 1, 1, 'name', 'Test'),
	(10, 2, 2, 2, 1, 'descr', 'YATA Test'),
	(10, 2, 2, 3, 1, 'engine', 'MariaDB'),
	(10, 2, 2, 4, 1, 'dbname', 'YATA_Test'),
	(10, 2, 2, 5, 1, 'host', '127.0.0.1'),
	(10, 2, 2, 6, 10, 'port', '3306');
/*!40000 ALTER TABLE `CONFIG` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `FAVORITES` (
  `ID_FAV` int(11) NOT NULL DEFAULT 0,
  `SYMBOL` varchar(64) NOT NULL,
  `PRTY` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`ID_FAV`,`PRTY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `FAVORITES` DISABLE KEYS */;
/*!40000 ALTER TABLE `FAVORITES` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `FLOWS` (
  `ID_OPER` int(10) unsigned NOT NULL,
  `ID_FLOW` int(10) unsigned NOT NULL,
  `TYPE` tinyint(4) NOT NULL,
  `CURRENCY` varchar(64) NOT NULL,
  `AMOUNT` double NOT NULL,
  `PRICE` double NOT NULL,
  `TMS` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`ID_OPER`,`ID_FLOW`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `FLOWS` DISABLE KEYS */;
INSERT INTO `FLOWS` (`ID_OPER`, `ID_FLOW`, `TYPE`, `CURRENCY`, `AMOUNT`, `PRICE`, `TMS`) VALUES
	(36259303, 36259305, 42, '$FIAT', -10000, 1, '2022-04-06 00:57:33'),
	(36259304, 36259305, 41, '$FIAT', 10000, 1, '2022-04-06 00:57:33'),
	(67900801, 67900802, 30, '$FIAT', -25.6610538460326, 2.56610538460326, '2022-04-09 16:51:08'),
	(67900801, 67900803, 20, 'NMC', 10, 2.56610538460326, '2022-04-09 16:51:08'),
	(67909001, 67909002, 30, '$FIAT', -25.6610538460326, 2.56610538460326, '2022-04-09 16:52:30'),
	(67909001, 67909003, 20, 'NMC', 10, 2.56610538460326, '2022-04-09 16:52:30'),
	(85716301, 85716302, 30, '$FIAT', -25.3452952085406, 2.53452952085406, '2022-04-11 18:20:23'),
	(85716301, 85716303, 20, 'NMC', 10, 2.53452952085406, '2022-04-11 18:20:23'),
	(85725201, 85725202, 30, '$FIAT', -25.3452952085406, 2.53452952085406, '2022-04-11 18:21:52'),
	(85725201, 85725203, 20, 'NMC', 10, 2.53452952085406, '2022-04-11 18:21:52'),
	(85761601, 85761602, 30, '$FIAT', -2.1017773667767097, 0.0210177736677671, '2022-04-11 18:27:56'),
	(85761601, 85761603, 20, 'TRC', 100, 0.0210177736677671, '2022-04-11 18:27:56'),
	(85896901, 85896902, 30, '$FIAT', -30.41435425024872, 2.53452952085406, '2022-04-11 18:50:29'),
	(85896901, 85896903, 20, 'NMC', 12, 2.53452952085406, '2022-04-11 18:50:29'),
	(85921301, 85921302, 30, '$FIAT', -0.2732310576809723, 0.0210177736677671, '2022-04-11 18:54:33'),
	(85921301, 85921303, 20, 'TRC', 13, 0.0210177736677671, '2022-04-11 18:54:33'),
	(85924801, 85924802, 30, '$FIAT', -27.87982472939466, 2.53452952085406, '2022-04-11 18:55:08'),
	(85924801, 85924803, 20, 'NMC', 11, 2.53452952085406, '2022-04-11 18:55:08'),
	(85962101, 85962102, 30, '$FIAT', -304.1435425024872, 2.53452952085406, '2022-04-11 19:01:21'),
	(85962101, 85962103, 20, 'NMC', 120, 2.53452952085406, '2022-04-11 19:01:21'),
	(85983901, 85983902, 30, '$FIAT', -304.1435425024872, 2.53452952085406, '2022-04-11 19:04:59'),
	(85983901, 85983903, 20, 'NMC', 120, 2.53452952085406, '2022-04-11 19:04:59'),
	(86017701, 86017702, 30, '$FIAT', -108.984019385496, 108.984019385496, '2022-04-11 19:10:37'),
	(86017701, 86017703, 20, 'LTC', 1, 108.984019385496, '2022-04-11 19:10:37'),
	(86032501, 86032502, 30, '$FIAT', -55.75964945878932, 2.53452952085406, '2022-04-11 19:13:05'),
	(86032501, 86032503, 20, 'NMC', 22, 2.53452952085406, '2022-04-11 19:13:05'),
	(86039401, 86039402, 30, '$FIAT', -2.1017773667767097, 0.0210177736677671, '2022-04-11 19:14:14'),
	(86039401, 86039403, 20, 'TRC', 100, 0.0210177736677671, '2022-04-11 19:14:14'),
	(86054901, 86054902, 30, '$FIAT', -2.5851861611353533, 0.0210177736677671, '2022-04-11 19:16:49'),
	(86054901, 86054903, 20, 'TRC', 123, 0.0210177736677671, '2022-04-11 19:16:49'),
	(86069601, 86069602, 30, '$FIAT', -25.3452952085406, 2.53452952085406, '2022-04-11 19:19:16'),
	(86069601, 86069603, 20, 'NMC', 10, 2.53452952085406, '2022-04-11 19:19:16'),
	(86091901, 86091902, 30, '$FIAT', -108.984019385496, 108.984019385496, '2022-04-11 19:22:59'),
	(86091901, 86091903, 20, 'LTC', 1, 108.984019385496, '2022-04-11 19:22:59'),
	(86098601, 86098602, 30, '$FIAT', -50.6905904170812, 2.53452952085406, '2022-04-11 19:24:06'),
	(86098601, 86098603, 20, 'NMC', 20, 2.53452952085406, '2022-04-11 19:24:06'),
	(86105201, 86105202, 30, '$FIAT', -6.935865310363143, 0.0210177736677671, '2022-04-11 19:25:12'),
	(86105201, 86105203, 20, 'TRC', 330, 0.0210177736677671, '2022-04-11 19:25:12'),
	(86116501, 86116502, 30, '$FIAT', -36.38452670429598, 0.606408778404933, '2022-04-11 19:27:05'),
	(86116501, 86116503, 20, 'PPC', 60, 0.606408778404933, '2022-04-11 19:27:05');
/*!40000 ALTER TABLE `FLOWS` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `HIST_POSITION` (
  `DATE_POS` date NOT NULL,
  `CAMERA` varchar(10) NOT NULL,
  `CURRENCY` varchar(10) NOT NULL,
  `BALANCE` double DEFAULT 0,
  `AVAILABLE` double DEFAULT 0,
  `BUY_HIGH` double DEFAULT 0,
  `BUY_LOW` double DEFAULT 0,
  `BUY_LAST` double DEFAULT 0,
  `BUY_NET` double DEFAULT 0,
  `SELL_HIGH` double DEFAULT 0,
  `SELL_LOW` double DEFAULT 0,
  `SELL_LAST` double DEFAULT 0,
  `SELL_NET` double DEFAULT 0,
  `BUY` double DEFAULT 0,
  `SELL` double DEFAULT 0,
  `VALUE` double DEFAULT 0,
  `PROFIT` double DEFAULT 0,
  `TMS` timestamp NOT NULL DEFAULT current_timestamp(),
  `LAST` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`DATE_POS`,`CAMERA`,`CURRENCY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `HIST_POSITION` DISABLE KEYS */;
/*!40000 ALTER TABLE `HIST_POSITION` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `OPERATIONS` (
  `ID_OPER` int(10) unsigned NOT NULL,
  `TYPE` tinyint(4) NOT NULL,
  `CAMERA` varchar(32) NOT NULL,
  `BASE` varchar(64) NOT NULL,
  `COUNTER` varchar(64) NOT NULL,
  `AMOUNT` double NOT NULL,
  `VALUE` double DEFAULT 0,
  `PRICE` double NOT NULL,
  `ACTIVE` tinyint(4) DEFAULT 1,
  `STATUS` tinyint(4) DEFAULT 0,
  `PARENT` int(10) unsigned DEFAULT 0,
  `TMS` timestamp NOT NULL DEFAULT current_timestamp(),
  `TMS_LAST` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`ID_OPER`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `OPERATIONS` DISABLE KEYS */;
INSERT INTO `OPERATIONS` (`ID_OPER`, `TYPE`, `CAMERA`, `BASE`, `COUNTER`, `AMOUNT`, `VALUE`, `PRICE`, `ACTIVE`, `STATUS`, `PARENT`, `TMS`, `TMS_LAST`) VALUES
	(36259303, 40, 'CASH', '$FIAT', '$FIAT', 10000, 10000, 1, 0, 2, 36259302, '2022-04-06 00:57:33', '2022-04-06 00:57:33'),
	(36259304, 40, 'DEFAULT', '$FIAT', '$FIAT', 10000, 10000, 1, 0, 2, 36259302, '2022-04-06 00:57:33', '2022-04-06 00:57:33'),
	(60733001, 20, 'DEFAULT', '$FIAT', 'BTC', 0.05, 2173.30937518008, 43466.1875036016, 0, 2, 0, '2022-04-08 20:56:30', '2022-04-08 20:56:30'),
	(65479701, 10, 'DEFAULT', '$FIAT', 'ADA', 1000, 1085.1990211501402, 1.08519902115014, 1, 0, 0, '2022-04-09 10:07:37', '2022-04-09 10:07:37'),
	(65554801, 20, 'DEFAULT', '$FIAT', 'PPC', 380, 245.14738690615903, 0.645124702384629, 1, 2, 0, '2022-04-09 10:20:08', '2022-04-09 10:20:08'),
	(65602401, 20, 'DEFAULT', '$FIAT', 'TRC', 1000, 20.8185433020997, 0.0208185433020997, 1, 2, 0, '2022-04-09 10:28:04', '2022-04-09 10:28:04'),
	(65615001, 20, 'DEFAULT', '$FIAT', 'TRC', 100, 2.0818543302099703, 0.0208185433020997, 1, 2, 0, '2022-04-09 10:30:11', '2022-04-09 10:30:11'),
	(65757001, 20, 'DEFAULT', '$FIAT', 'NVC', 10, 1.0041171918379401, 0.100411719183794, 1, 2, 0, '2022-04-09 10:53:50', '2022-04-09 10:53:50'),
	(65761601, 20, 'DEFAULT', '$FIAT', 'NVC', 50, 5.020585959189701, 0.100411719183794, 1, 2, 0, '2022-04-09 10:54:36', '2022-04-09 10:54:36'),
	(65777401, 20, 'DEFAULT', '$FIAT', 'NMC', 10, 25.6610538460326, 2.56610538460326, 1, 2, 0, '2022-04-09 10:57:14', '2022-04-09 10:57:14'),
	(65810801, 20, 'DEFAULT', '$FIAT', 'NMC', 50, 128.30526923016302, 2.56610538460326, 1, 2, 0, '2022-04-09 11:02:49', '2022-04-09 11:02:49'),
	(65824201, 20, 'DEFAULT', '$FIAT', 'NMC', 50, 128.30526923016302, 2.56610538460326, 1, 2, 0, '2022-04-09 11:05:02', '2022-04-09 11:05:02'),
	(65852801, 20, 'DEFAULT', '$FIAT', 'NMC', 200, 513.2210769206521, 2.56610538460326, 1, 2, 0, '2022-04-09 11:09:48', '2022-04-09 11:09:48'),
	(65905001, 20, 'DEFAULT', '$FIAT', 'NMC', 150, 384.91580769048903, 2.56610538460326, 1, 2, 0, '2022-04-09 11:18:30', '2022-04-09 11:18:30'),
	(65922401, 20, 'DEFAULT', '$FIAT', 'NMC', 10, 25.6610538460326, 2.56610538460326, 1, 2, 0, '2022-04-09 11:21:24', '2022-04-09 11:21:24'),
	(65993201, 10, 'DEFAULT', '$FIAT', 'NMC', 10, 25.6610538460326, 2.56610538460326, 1, 0, 0, '2022-04-09 11:33:12', '2022-04-09 11:33:12'),
	(66003301, 20, 'DEFAULT', '$FIAT', 'NMC', 10, 25.6610538460326, 2.56610538460326, 1, 2, 0, '2022-04-09 11:34:53', '2022-04-09 11:34:53'),
	(66034401, 20, 'DEFAULT', '$FIAT', 'NMC', 10, 25.6610538460326, 2.56610538460326, 1, 2, 0, '2022-04-09 11:40:04', '2022-04-09 11:40:04'),
	(66074501, 20, 'DEFAULT', '$FIAT', 'NMC', 10, 25.6610538460326, 2.56610538460326, 1, 2, 0, '2022-04-09 11:46:45', '2022-04-09 11:46:45'),
	(66122901, 20, 'DEFAULT', '$FIAT', 'NMC', 10, 25.6610538460326, 2.56610538460326, 1, 2, 0, '2022-04-09 11:54:49', '2022-04-09 11:54:49'),
	(66137101, 20, 'DEFAULT', '$FIAT', 'NMC', 50, 128.30526923016302, 2.56610538460326, 1, 2, 0, '2022-04-09 11:57:11', '2022-04-09 11:57:11'),
	(66148501, 20, 'DEFAULT', '$FIAT', 'NMC', 10, 25.6610538460326, 2.56610538460326, 1, 2, 0, '2022-04-09 11:59:05', '2022-04-09 11:59:05'),
	(66221501, 20, 'DEFAULT', '$FIAT', 'TAG', 100, 2.9993110925029502, 0.0299931109250295, 1, 2, 0, '2022-04-09 12:11:15', '2022-04-09 12:11:15'),
	(66347801, 20, 'DEFAULT', '$FIAT', 'NMC', 10, 25.6610538460326, 2.56610538460326, 1, 2, 0, '2022-04-09 12:32:18', '2022-04-09 12:32:18'),
	(66360701, 20, 'DEFAULT', '$FIAT', 'NMC', 10, 25.6610538460326, 2.56610538460326, 1, 2, 0, '2022-04-09 12:34:27', '2022-04-09 12:34:27'),
	(66378601, 20, 'DEFAULT', '$FIAT', 'NMC', 10, 25.6610538460326, 2.56610538460326, 1, 2, 0, '2022-04-09 12:37:26', '2022-04-09 12:37:26'),
	(66396001, 20, 'DEFAULT', '$FIAT', 'NMC', 10, 25.6610538460326, 2.56610538460326, 1, 2, 0, '2022-04-09 12:40:20', '2022-04-09 12:40:20'),
	(66419301, 20, 'DEFAULT', '$FIAT', 'NMC', 10, 25.6610538460326, 2.56610538460326, 1, 2, 0, '2022-04-09 12:44:13', '2022-04-09 12:44:13'),
	(66486601, 20, 'DEFAULT', '$FIAT', 'NMC', 10, 25.6610538460326, 2.56610538460326, 1, 2, 0, '2022-04-09 12:55:26', '2022-04-09 12:55:26'),
	(66493501, 20, 'DEFAULT', '$FIAT', 'NMC', 10, 25.6610538460326, 2.56610538460326, 1, 2, 0, '2022-04-09 12:56:35', '2022-04-09 12:56:35'),
	(66508701, 20, 'DEFAULT', '$FIAT', 'NMC', 10, 25.6610538460326, 2.56610538460326, 1, 2, 0, '2022-04-09 12:59:07', '2022-04-09 12:59:07'),
	(66529101, 20, 'DEFAULT', '$FIAT', 'NMC', 10, 25.6610538460326, 2.56610538460326, 1, 2, 0, '2022-04-09 13:02:31', '2022-04-09 13:02:31'),
	(66677001, 20, 'DEFAULT', '$FIAT', 'NMC', 10, 25.6610538460326, 2.56610538460326, 1, 2, 0, '2022-04-09 13:27:10', '2022-04-09 13:27:10'),
	(66705701, 20, 'DEFAULT', '$FIAT', 'NMC', 10, 25.6610538460326, 2.56610538460326, 1, 2, 0, '2022-04-09 13:31:57', '2022-04-09 13:31:57'),
	(66710601, 20, 'DEFAULT', '$FIAT', 'NMC', 10, 25.6610538460326, 2.56610538460326, 1, 2, 0, '2022-04-09 13:32:46', '2022-04-09 13:32:46'),
	(66717601, 20, 'DEFAULT', '$FIAT', 'NMC', 10, 25.6610538460326, 2.56610538460326, 1, 2, 0, '2022-04-09 13:33:56', '2022-04-09 13:33:56'),
	(66828301, 20, 'DEFAULT', '$FIAT', 'NMC', 10, 25.6610538460326, 2.56610538460326, 1, 2, 0, '2022-04-09 13:53:23', '2022-04-09 13:53:23'),
	(67900801, 20, 'DEFAULT', '$FIAT', 'NMC', 10, 25.6610538460326, 2.56610538460326, 1, 2, 0, '2022-04-09 16:51:08', '2022-04-09 16:51:08'),
	(67909001, 20, 'DEFAULT', '$FIAT', 'NMC', 10, 25.6610538460326, 2.56610538460326, 1, 2, 0, '2022-04-09 16:52:30', '2022-04-09 16:52:30'),
	(85716301, 10, 'DEFAULT', '$FIAT', 'NMC', 10, 25.3452952085406, 2.53452952085406, 1, 0, 0, '2022-04-11 18:20:23', '2022-04-11 18:20:23'),
	(85725201, 10, 'DEFAULT', '$FIAT', 'NMC', 10, 25.3452952085406, 2.53452952085406, 1, 0, 0, '2022-04-11 18:21:52', '2022-04-11 18:21:52'),
	(85761601, 10, 'DEFAULT', '$FIAT', 'TRC', 100, 2.1017773667767097, 0.0210177736677671, 1, 0, 0, '2022-04-11 18:27:56', '2022-04-11 18:27:56'),
	(85896901, 10, 'DEFAULT', '$FIAT', 'NMC', 12, 30.41435425024872, 2.53452952085406, 1, 0, 0, '2022-04-11 18:50:29', '2022-04-11 18:50:29'),
	(85921301, 10, 'DEFAULT', '$FIAT', 'TRC', 13, 0.2732310576809723, 0.0210177736677671, 1, 0, 0, '2022-04-11 18:54:33', '2022-04-11 18:54:33'),
	(85924801, 10, 'DEFAULT', '$FIAT', 'NMC', 11, 27.87982472939466, 2.53452952085406, 1, 0, 0, '2022-04-11 18:55:08', '2022-04-11 18:55:08'),
	(85962101, 10, 'DEFAULT', '$FIAT', 'NMC', 120, 304.1435425024872, 2.53452952085406, 1, 0, 0, '2022-04-11 19:01:21', '2022-04-11 19:01:21'),
	(85983901, 10, 'DEFAULT', '$FIAT', 'NMC', 120, 304.1435425024872, 2.53452952085406, 1, 0, 0, '2022-04-11 19:04:59', '2022-04-11 19:04:59'),
	(86017701, 10, 'DEFAULT', '$FIAT', 'LTC', 1, 108.984019385496, 108.984019385496, 1, 0, 0, '2022-04-11 19:10:37', '2022-04-11 19:10:37'),
	(86032501, 10, 'DEFAULT', '$FIAT', 'NMC', 22, 55.75964945878932, 2.53452952085406, 1, 0, 0, '2022-04-11 19:13:05', '2022-04-11 19:13:05'),
	(86039401, 10, 'DEFAULT', '$FIAT', 'TRC', 100, 2.1017773667767097, 0.0210177736677671, 1, 0, 0, '2022-04-11 19:14:14', '2022-04-11 19:14:14'),
	(86054901, 10, 'DEFAULT', '$FIAT', 'TRC', 123, 2.5851861611353533, 0.0210177736677671, 1, 0, 0, '2022-04-11 19:16:49', '2022-04-11 19:16:49'),
	(86069601, 10, 'DEFAULT', '$FIAT', 'NMC', 10, 25.3452952085406, 2.53452952085406, 1, 0, 0, '2022-04-11 19:19:16', '2022-04-11 19:19:16'),
	(86091901, 10, 'DEFAULT', '$FIAT', 'LTC', 1, 108.984019385496, 108.984019385496, 1, 0, 0, '2022-04-11 19:22:59', '2022-04-11 19:22:59'),
	(86098601, 10, 'DEFAULT', '$FIAT', 'NMC', 20, 50.6905904170812, 2.53452952085406, 1, 0, 0, '2022-04-11 19:24:06', '2022-04-11 19:24:06'),
	(86105201, 10, 'DEFAULT', '$FIAT', 'TRC', 330, 6.935865310363143, 0.0210177736677671, 1, 0, 0, '2022-04-11 19:25:12', '2022-04-11 19:25:12'),
	(86116501, 10, 'DEFAULT', '$FIAT', 'PPC', 60, 36.38452670429598, 0.606408778404933, 1, 0, 0, '2022-04-11 19:27:05', '2022-04-11 19:27:05');
/*!40000 ALTER TABLE `OPERATIONS` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `OPERATIONS_CONTROL` (
  `ID_OPER` int(10) unsigned NOT NULL,
  `FEE` double DEFAULT 0,
  `GAS` double DEFAULT 0,
  `TARGET` double DEFAULT 0,
  `STOP` double DEFAULT 0,
  `LIMITE` double DEFAULT 0,
  `DEADLINE` int(11) DEFAULT 0,
  `AMOUNT_IN` double NOT NULL,
  `PRICE_IN` double NOT NULL,
  `AMOUNT_OUT` double DEFAULT 0,
  `PRICE_OUT` double DEFAULT 0,
  `EXPENSE` double DEFAULT 0,
  `PROFIT` double DEFAULT 0,
  `ALIVE` int(11) DEFAULT 0,
  `RANK` int(11) DEFAULT 0,
  `ALERT` tinyint(4) DEFAULT 0,
  `TMS_ALERT` date DEFAULT NULL,
  PRIMARY KEY (`ID_OPER`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `OPERATIONS_CONTROL` DISABLE KEYS */;
INSERT INTO `OPERATIONS_CONTROL` (`ID_OPER`, `FEE`, `GAS`, `TARGET`, `STOP`, `LIMITE`, `DEADLINE`, `AMOUNT_IN`, `PRICE_IN`, `AMOUNT_OUT`, `PRICE_OUT`, `EXPENSE`, `PROFIT`, `ALIVE`, `RANK`, `ALERT`, `TMS_ALERT`) VALUES
	(36259303, 0, 0, 0, 0, 0, 0, 10000, 1, 10000, 1, 0, 0, 0, 0, 0, NULL),
	(36259304, 0, 0, 0, 0, 0, 0, 10000, 1, 10000, 1, 0, 0, 0, 0, 0, NULL),
	(60733001, 0, 0, 45639.49687878168, 42162.20187849355, 0, 7, 0.05, 43466.1875036016, 0.05, 43466.1875036016, 0, 0, 0, 0, 1, '2022-04-11'),
	(65479701, 0, 0, 1.1394589722076471, 1.052643050515636, 0, 7, 1000, 1.08519902115014, 1000, 1.08519902115014, 0, 0, 0, 0, 1, '2022-04-12'),
	(65554801, 0, 0, 0.6773809375038605, 0.6257709613130902, 0, 7, 380, 0.645124702384629, 380, 0.645124702384629, 0, 0, 0, 0, 1, '2022-04-12'),
	(65602401, 0, 0, 0.021859470467204687, 0.02019398700303671, 0, 7, 1000, 0.0208185433020997, 1000, 0.0208185433020997, 0, 0, 0, 0, 1, '2022-04-12'),
	(65615001, 0, 0, 0.021859470467204687, 0.02019398700303671, 0, 7, 100, 0.0208185433020997, 100, 0.0208185433020997, 0, 0, 0, 0, 1, '2022-04-12'),
	(65757001, 0, 0, 0.10543230514298371, 0.09739936760828018, 0, 7, 10, 0.100411719183794, 10, 0.100411719183794, 0, 0, 0, 0, 1, '2022-04-12'),
	(65761601, 0, 0, 0.10543230514298371, 0.09739936760828018, 0, 7, 50, 0.100411719183794, 50, 0.100411719183794, 0, 0, 0, 0, 1, '2022-04-12'),
	(65777401, 0, 0, 2.6944106538334234, 2.4891222230651624, 0, 7, 10, 2.56610538460326, 10, 2.56610538460326, 0, 0, 0, 0, 1, '2022-04-12'),
	(65810801, 0, 0, 2.6944106538334234, 2.4891222230651624, 0, 7, 50, 2.56610538460326, 50, 2.56610538460326, 0, 0, 0, 0, 1, '2022-04-12'),
	(65824201, 0, 0, 2.6944106538334234, 2.4891222230651624, 0, 7, 50, 2.56610538460326, 50, 2.56610538460326, 0, 0, 0, 0, 1, '2022-04-12'),
	(65852801, 0, 0, 2.6944106538334234, 2.4891222230651624, 0, 7, 200, 2.56610538460326, 200, 2.56610538460326, 0, 0, 0, 0, 1, '2022-04-12'),
	(65905001, 0, 0, 2.6944106538334234, 2.4891222230651624, 0, 7, 150, 2.56610538460326, 150, 2.56610538460326, 0, 0, 0, 0, 1, '2022-04-12'),
	(65922401, 0, 0, 2.6944106538334234, 2.4891222230651624, 0, 7, 10, 2.56610538460326, 10, 2.56610538460326, 0, 0, 0, 0, 1, '2022-04-12'),
	(65993201, 0, 0, 2.6944106538334234, 2.4891222230651624, 0, 7, 10, 2.56610538460326, 10, 2.56610538460326, 0, 0, 0, 0, 1, '2022-04-12'),
	(66003301, 0, 0, 2.6944106538334234, 2.4891222230651624, 0, 7, 10, 2.56610538460326, 10, 2.56610538460326, 0, 0, 0, 0, 1, '2022-04-12'),
	(66034401, 0, 0, 2.6944106538334234, 2.4891222230651624, 0, 7, 10, 2.56610538460326, 10, 2.56610538460326, 0, 0, 0, 0, 1, '2022-04-12'),
	(66074501, 0, 0, 2.6944106538334234, 2.4891222230651624, 0, 7, 10, 2.56610538460326, 10, 2.56610538460326, 0, 0, 0, 0, 1, '2022-04-12'),
	(66122901, 0, 0, 2.6944106538334234, 2.4891222230651624, 0, 7, 10, 2.56610538460326, 10, 2.56610538460326, 0, 0, 0, 0, 1, '2022-04-12'),
	(66137101, 0, 0, 2.6944106538334234, 2.4891222230651624, 0, 7, 50, 2.56610538460326, 50, 2.56610538460326, 0, 0, 0, 0, 1, '2022-04-12'),
	(66148501, 0, 0, 2.6944106538334234, 2.4891222230651624, 0, 7, 10, 2.56610538460326, 10, 2.56610538460326, 0, 0, 0, 0, 1, '2022-04-12'),
	(66221501, 0, 0, 0.03149276647128098, 0.029093317597278616, 0, 7, 100, 0.0299931109250295, 100, 0.0299931109250295, 0, 0, 0, 0, 1, '2022-04-12'),
	(66347801, 0, 0, 2.6944106538334234, 2.4891222230651624, 0, 7, 10, 2.56610538460326, 10, 2.56610538460326, 0, 0, 0, 0, 1, '2022-04-12'),
	(66360701, 0, 0, 2.6944106538334234, 2.4891222230651624, 0, 7, 10, 2.56610538460326, 10, 2.56610538460326, 0, 0, 0, 0, 1, '2022-04-12'),
	(66378601, 0, 0, 2.6944106538334234, 2.4891222230651624, 0, 7, 10, 2.56610538460326, 10, 2.56610538460326, 0, 0, 0, 0, 1, '2022-04-12'),
	(66396001, 0, 0, 2.6944106538334234, 2.4891222230651624, 0, 7, 10, 2.56610538460326, 10, 2.56610538460326, 0, 0, 0, 0, 1, '2022-04-12'),
	(66419301, 0, 0, 2.6944106538334234, 2.4891222230651624, 0, 7, 10, 2.56610538460326, 10, 2.56610538460326, 0, 0, 0, 0, 1, '2022-04-12'),
	(66486601, 0, 0, 2.6944106538334234, 2.4891222230651624, 0, 7, 10, 2.56610538460326, 10, 2.56610538460326, 0, 0, 0, 0, 1, '2022-04-12'),
	(66493501, 0, 0, 2.6944106538334234, 2.4891222230651624, 0, 7, 10, 2.56610538460326, 10, 2.56610538460326, 0, 0, 0, 0, 1, '2022-04-12'),
	(66508701, 0, 0, 2.6944106538334234, 2.4891222230651624, 0, 7, 10, 2.56610538460326, 10, 2.56610538460326, 0, 0, 0, 0, 1, '2022-04-12'),
	(66529101, 0, 0, 2.6944106538334234, 2.4891222230651624, 0, 7, 10, 2.56610538460326, 10, 2.56610538460326, 0, 0, 0, 0, 1, '2022-04-12'),
	(66677001, 0, 0, 2.6944106538334234, 2.4891222230651624, 0, 7, 10, 2.56610538460326, 10, 2.56610538460326, 0, 0, 0, 0, 1, '2022-04-12'),
	(66705701, 0, 0, 2.6944106538334234, 2.4891222230651624, 0, 7, 10, 2.56610538460326, 10, 2.56610538460326, 0, 0, 0, 0, 1, '2022-04-12'),
	(66710601, 0, 0, 2.6944106538334234, 2.4891222230651624, 0, 7, 10, 2.56610538460326, 10, 2.56610538460326, 0, 0, 0, 0, 1, '2022-04-12'),
	(66717601, 0, 0, 2.6944106538334234, 2.4891222230651624, 0, 7, 10, 2.56610538460326, 10, 2.56610538460326, 0, 0, 0, 0, 1, '2022-04-12'),
	(66828301, 0, 0, 2.6944106538334234, 2.4891222230651624, 0, 7, 10, 2.56610538460326, 10, 2.56610538460326, 0, 0, 0, 0, 1, '2022-04-12'),
	(67900801, 0, 0, 2.6944106538334234, 2.4891222230651624, 0, 7, 10, 2.56610538460326, 10, 2.56610538460326, 0, 0, 0, 0, 1, '2022-04-12'),
	(67909001, 0, 0, 2.6944106538334234, 2.4891222230651624, 0, 7, 10, 2.56610538460326, 10, 2.56610538460326, 0, 0, 0, 0, 1, '2022-04-12'),
	(85716301, 0, 0, 2.661255996896763, 2.458493635228438, 0, 7, 10, 2.53452952085406, 10, 2.53452952085406, 0, 0, 0, 0, 1, '2022-04-14'),
	(85725201, 0, 0, 2.661255996896763, 2.458493635228438, 0, 7, 10, 2.53452952085406, 10, 2.53452952085406, 0, 0, 0, 0, 1, '2022-04-14'),
	(85761601, 0, 0, 0.022068662351155455, 0.020387240457734084, 0, 7, 100, 0.0210177736677671, 100, 0.0210177736677671, 0, 0, 0, 0, 1, '2022-04-14'),
	(85896901, 0, 0, 2.661255996896763, 2.458493635228438, 0, 7, 12, 2.53452952085406, 12, 2.53452952085406, 0, 0, 0, 0, 1, '2022-04-14'),
	(85921301, 0, 0, 0.022068662351155455, 0.020387240457734084, 0, 7, 13, 0.0210177736677671, 13, 0.0210177736677671, 0, 0, 0, 0, 1, '2022-04-14'),
	(85924801, 0, 0, 2.661255996896763, 2.458493635228438, 0, 7, 11, 2.53452952085406, 11, 2.53452952085406, 0, 0, 0, 0, 1, '2022-04-14'),
	(85962101, 0, 0, 2.661255996896763, 2.458493635228438, 0, 7, 120, 2.53452952085406, 120, 2.53452952085406, 0, 0, 0, 0, 1, '2022-04-14'),
	(85983901, 0, 0, 2.661255996896763, 2.458493635228438, 0, 7, 120, 2.53452952085406, 120, 2.53452952085406, 0, 0, 0, 0, 1, '2022-04-14'),
	(86017701, 0, 0, 114.4332203547708, 105.71449880393112, 0, 7, 1, 108.984019385496, 1, 108.984019385496, 0, 0, 0, 0, 1, '2022-04-14'),
	(86032501, 0, 0, 2.661255996896763, 2.458493635228438, 0, 7, 22, 2.53452952085406, 22, 2.53452952085406, 0, 0, 0, 0, 1, '2022-04-14'),
	(86039401, 0, 0, 0.022068662351155455, 0.020387240457734084, 0, 7, 100, 0.0210177736677671, 100, 0.0210177736677671, 0, 0, 0, 0, 1, '2022-04-14'),
	(86054901, 0, 0, 0.022068662351155455, 0.020387240457734084, 0, 7, 123, 0.0210177736677671, 123, 0.0210177736677671, 0, 0, 0, 0, 1, '2022-04-14'),
	(86069601, 0, 0, 2.661255996896763, 2.458493635228438, 0, 7, 10, 2.53452952085406, 10, 2.53452952085406, 0, 0, 0, 0, 1, '2022-04-14'),
	(86091901, 0, 0, 114.4332203547708, 105.71449880393112, 0, 7, 1, 108.984019385496, 1, 108.984019385496, 0, 0, 0, 0, 1, '2022-04-14'),
	(86098601, 0, 0, 2.661255996896763, 2.458493635228438, 0, 7, 20, 2.53452952085406, 20, 2.53452952085406, 0, 0, 0, 0, 1, '2022-04-14'),
	(86105201, 0, 0, 0.022068662351155455, 0.020387240457734084, 0, 7, 330, 0.0210177736677671, 330, 0.0210177736677671, 0, 0, 0, 0, 1, '2022-04-14'),
	(86116501, 0, 0, 0.6367292173251797, 0.588216515052785, 0, 7, 60, 0.606408778404933, 60, 0.606408778404933, 0, 0, 0, 0, 1, '2022-04-14');
/*!40000 ALTER TABLE `OPERATIONS_CONTROL` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `OPERATIONS_LOG` (
  `ID_OPER` int(10) unsigned NOT NULL,
  `ID_LOG` int(10) unsigned NOT NULL,
  `TMS` timestamp NOT NULL DEFAULT current_timestamp(),
  `TYPE` tinyint(4) DEFAULT 0,
  `REASON` int(11) DEFAULT 0,
  `COMMENT` text DEFAULT NULL,
  PRIMARY KEY (`ID_OPER`,`ID_LOG`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `OPERATIONS_LOG` DISABLE KEYS */;
/*!40000 ALTER TABLE `OPERATIONS_LOG` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `POSITION` (
  `CAMERA` varchar(32) NOT NULL,
  `CURRENCY` varchar(64) NOT NULL,
  `BALANCE` double DEFAULT 0,
  `AVAILABLE` double DEFAULT 0,
  `BUY_HIGH` double DEFAULT 0,
  `BUY_LOW` double DEFAULT 0,
  `BUY_LAST` double DEFAULT 0,
  `BUY_NET` double DEFAULT 0,
  `SELL_HIGH` double DEFAULT 0,
  `SELL_LOW` double DEFAULT 0,
  `SELL_LAST` double DEFAULT 0,
  `SELL_NET` double DEFAULT 0,
  `BUY` double DEFAULT 0,
  `SELL` double DEFAULT 0,
  `VALUE` double DEFAULT 0,
  `PROFIT` double DEFAULT 0,
  `TMS` timestamp NOT NULL DEFAULT current_timestamp(),
  `LAST` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `CC` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`CAMERA`,`CURRENCY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `POSITION` DISABLE KEYS */;
INSERT INTO `POSITION` (`CAMERA`, `CURRENCY`, `BALANCE`, `AVAILABLE`, `BUY_HIGH`, `BUY_LOW`, `BUY_LAST`, `BUY_NET`, `SELL_HIGH`, `SELL_LOW`, `SELL_LAST`, `SELL_NET`, `BUY`, `SELL`, `VALUE`, `PROFIT`, `TMS`, `LAST`, `CC`) VALUES
	('CASH', '$FIAT', 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, '2022-03-04 13:29:53', '2022-04-06 00:57:33', NULL),
	('DEFAULT', '$FIAT', 6374.4632446249425, 3056.3451835496767, 0, 0, 0, 0, 3253.54426737761, 1.0041171918379401, 25.6610538460326, 1, 0, 13561.31865781445, 1, 0, '2022-04-06 00:57:33', '2022-04-11 19:27:05', NULL),
	('DEFAULT', 'BTC', 0.05, 0.05, 43466.1875036016, 43466.1875036016, 43466.1875036016, 43466.1875036016, 0, 0, 0, 0, 0.05, 0, 43466.1875036016, 0, '2022-04-08 20:56:30', '2022-04-08 20:56:30', NULL),
	('DEFAULT', 'ETH', 2, 2, 3253.54426737761, 3253.54426737761, 3253.54426737761, 3253.54426737761, 0, 0, 0, 0, 2, 0, 3253.54426737761, 0, '2022-04-09 09:14:07', '2022-04-09 09:19:32', NULL),
	('DEFAULT', 'LTC', 21, 21, 114.125817500374, 114.125817500374, 114.125817500374, 114.125817500374, 0, 0, 0, 0, 21, 0, 114.125817500374, 0, '2022-04-09 09:25:37', '2022-04-09 09:59:53', NULL),
	('DEFAULT', 'NMC', 840, 840, 2.56610538460326, 2.56610538460326, 2.56610538460326, 2.5661053846032624, 0, 0, 0, 0, 840, 0, 2.5661053846032624, 0, '2022-04-09 09:35:21', '2022-04-09 16:52:30', NULL),
	('DEFAULT', 'NVC', 160, 160, 0.100411719183794, 0.100411719183794, 0.100411719183794, 0.10041171918379402, 0, 0, 0, 0, 160, 0, 0.10041171918379402, 0, '2022-04-09 10:04:02', '2022-04-09 10:54:36', NULL),
	('DEFAULT', 'PPC', 380, 380, 0.645124702384629, 0.645124702384629, 0.645124702384629, 0.645124702384629, 0, 0, 0, 0, 380, 0, 0.645124702384629, 0, '2022-04-09 10:20:08', '2022-04-09 10:20:08', NULL),
	('DEFAULT', 'TAG', 100, 100, 0.0299931109250295, 0.0299931109250295, 0.0299931109250295, 0.0299931109250295, 0, 0, 0, 0, 100, 0, 0.0299931109250295, 0, '2022-04-09 12:11:15', '2022-04-09 12:11:15', NULL),
	('DEFAULT', 'TRC', 3100, 3100, 0.0208185433020997, 0.0208185433020997, 0.0208185433020997, 0.0208185433020997, 0, 0, 0, 0, 3100, 0, 0.0208185433020997, 0, '2022-04-09 09:51:31', '2022-04-09 10:30:11', NULL);
/*!40000 ALTER TABLE `POSITION` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `TRANSFERS` (
  `ID_XFER` int(10) unsigned NOT NULL,
  `CAMERA_OUT` varchar(32) NOT NULL,
  `CAMERA_IN` varchar(32) NOT NULL,
  `CURRENCY` varchar(64) NOT NULL,
  `AMOUNT` double NOT NULL,
  `VALUE` double NOT NULL,
  `TMS` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`ID_XFER`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `TRANSFERS` DISABLE KEYS */;
INSERT INTO `TRANSFERS` (`ID_XFER`, `CAMERA_OUT`, `CAMERA_IN`, `CURRENCY`, `AMOUNT`, `VALUE`, `TMS`) VALUES
	(36226802, 'CASH', 'DEFAULT', '$FIAT', 10000, 1, '2022-04-06 00:52:08'),
	(36259302, 'CASH', 'DEFAULT', '$FIAT', 10000, 1, '2022-04-06 00:57:33');
/*!40000 ALTER TABLE `TRANSFERS` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;