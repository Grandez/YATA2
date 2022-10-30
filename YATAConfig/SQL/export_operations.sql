-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         10.5.8-MariaDB - mariadb.org binary distribution
-- SO del servidor:              Win64
-- HeidiSQL Versión:             11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Volcando datos para la tabla yatasimm.flows: ~5 rows (aproximadamente)
/*!40000 ALTER TABLE `flows` DISABLE KEYS */;
REPLACE INTO `flows` (`ID_OPER`, `ID_FLOW`, `TYPE`, `CURRENCY`, `AMOUNT`, `PRICE`, `TMS`) VALUES
	(116435118, 116435119, 41, 'EUR', 25000, 1, '2021-02-20 11:20:35'),
	(117161120, 118606128, 30, 'EUR', -50, 246.51, '2021-02-20 11:56:46'),
	(117161120, 118612129, 20, 'BNB', 50, 1, '2021-02-20 11:56:52'),
	(119269130, 119705132, 30, 'EUR', -0.25, 46113, '2021-02-20 12:15:05'),
	(119269130, 119710134, 20, 'BTC', 0.25, 1, '2021-02-20 12:15:10');
/*!40000 ALTER TABLE `flows` ENABLE KEYS */;

-- Volcando datos para la tabla yatasimm.operations: ~3 rows (aproximadamente)
/*!40000 ALTER TABLE `operations` DISABLE KEYS */;
REPLACE INTO `operations` (`ID_OPER`, `TYPE`, `CAMERA`, `BASE`, `COUNTER`, `AMOUNT`, `PRICE`, `ACTIVE`, `STATUS`, `ALERT`, `PARENT`, `TMS`, `TMS_ALERT`, `TMS_LAST`, `REASON`) VALUES
	(116435118, 4, 'XFER', 'EXT', 'POL', 25000, 1, 0, 2, 0, 0, '2021-02-20 11:20:35', NULL, '2021-02-20 11:20:35', 0),
	(117161120, 2, 'POL', 'EUR', 'BNB', 50, 246.51, 1, 2, 1, 0, '2021-02-20 11:32:41', '2021-02-20', '2021-02-20 12:15:58', 0),
	(119269130, 1, 'POL', 'EUR', 'BTC', 0.25, 46113, 1, 2, 1, 0, '2021-02-20 12:07:49', '2021-02-20', '2021-02-20 12:15:10', 0);
/*!40000 ALTER TABLE `operations` ENABLE KEYS */;

-- Volcando datos para la tabla yatasimm.position: ~3 rows (aproximadamente)
/*!40000 ALTER TABLE `position` DISABLE KEYS */;
REPLACE INTO `position` (`CAMERA`, `CURRENCY`, `BALANCE`, `AVAILABLE`, `PRICE`, `BUY`, `SELL`, `PRICEBUY`, `PRICESELL`, `SINCE`, `LAST`, `CC`) VALUES
	('POL', 'BNB', 50, 50, 246.51, 50, 0, 246.51, 1, '2021-02-20 11:56:52', '2021-02-20 11:56:52', NULL),
	('POL', 'BTC', 0.5, 0.5, 46113, 0.5, 0, 46113, 1, '2021-02-20 12:15:10', '2021-02-20 12:15:11', NULL),
	('POL', 'EUR', -1012, 1146.25, 1, 0, 0, 1, 1, '2021-02-20 11:20:35', '2021-02-20 12:15:06', NULL);
/*!40000 ALTER TABLE `position` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
