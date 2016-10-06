CREATE DATABASE  IF NOT EXISTS `usage` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `usage`;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `counter_br1`
--

DROP TABLE IF EXISTS `counter_br1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `counter_br1` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `print_issn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `online_issn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `print_isbn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `online_isbn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `doi` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `proprietary_identifier` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `platform` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `publisher` text CHARACTER SET utf8,
  `item_name` text COLLATE utf8_unicode_ci,
  `data_type` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_begin` datetime DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `sec_html` int(11) DEFAULT NULL,
  `ft_pdf` int(11) DEFAULT NULL,
  `ft_pdf_mobile` int(11) DEFAULT NULL,
  `ft_html` int(11) DEFAULT NULL,
  `ft_html_mobile` int(11) DEFAULT NULL,
  `ft_epub` int(11) DEFAULT NULL,
  `ft_total` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=614750 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `counter_br2`
--

DROP TABLE IF EXISTS `counter_br2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `counter_br2` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `print_isbn` varchar(45) CHARACTER SET utf8 DEFAULT NULL,
  `online_isbn` varchar(45) CHARACTER SET utf8 DEFAULT NULL,
  `doi` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `proprietary_identifier` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `platform` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `publisher` text CHARACTER SET utf8,
  `item_name` text COLLATE utf8_unicode_ci,
  `data_type` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_begin` datetime DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `sec_html` int(11) DEFAULT NULL,
  `ft_total` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2141339 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `counter_br3`
--

DROP TABLE IF EXISTS `counter_br3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `counter_br3` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `print_isbn` varchar(45) CHARACTER SET utf8 DEFAULT NULL,
  `online_isbn` varchar(45) CHARACTER SET utf8 DEFAULT NULL,
  `doi` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `proprietary_identifier` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `platform` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `publisher` text CHARACTER SET utf8,
  `item_name` text COLLATE utf8_unicode_ci,
  `data_type` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_begin` datetime DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `no_license` int(11) DEFAULT NULL,
  `turnaways` int(11) DEFAULT NULL,
  `other_reason` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2429696 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `counter_br4`
--

DROP TABLE IF EXISTS `counter_br4`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `counter_br4` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `platform` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `publisher` text CHARACTER SET utf8,
  `item_name` text COLLATE utf8_unicode_ci,
  `data_type` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_begin` datetime DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `no_license` int(11) DEFAULT NULL,
  `turnaways` int(11) DEFAULT NULL,
  `other_reason` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=444 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `counter_br5`
--

DROP TABLE IF EXISTS `counter_br5`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `counter_br5` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `proprietary_identifier` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `platform` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `item_name` text COLLATE utf8_unicode_ci,
  `data_type` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_begin` datetime DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `searches` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `counter_cr1`
--

DROP TABLE IF EXISTS `counter_cr1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `counter_cr1` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `print_issn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `online_issn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `print_isbn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `online_isbn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `doi` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `proprietary_identifier` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `platform` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `publisher` text CHARACTER SET utf8,
  `item_name` text COLLATE utf8_unicode_ci,
  `data_type` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_begin` datetime DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `sec_html` int(11) DEFAULT NULL,
  `ft_pdf` int(11) DEFAULT NULL,
  `ft_pdf_mobile` int(11) DEFAULT NULL,
  `ft_html` int(11) DEFAULT NULL,
  `ft_html_mobile` int(11) DEFAULT NULL,
  `ft_total` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `counter_db1`
--

DROP TABLE IF EXISTS `counter_db1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `counter_db1` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `platform` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `publisher` text CHARACTER SET utf8,
  `item_name` text COLLATE utf8_unicode_ci,
  `data_type` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_begin` datetime DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `reg_searches` int(11) DEFAULT NULL,
  `fed_searches` int(11) DEFAULT NULL,
  `res_clicks` int(11) DEFAULT NULL,
  `rec_views` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9967 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `counter_db2`
--

DROP TABLE IF EXISTS `counter_db2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `counter_db2` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `platform` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `publisher` text CHARACTER SET utf8,
  `item_name` text COLLATE utf8_unicode_ci,
  `data_type` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_begin` datetime DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `turnaways` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=955 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `counter_db3`
--

DROP TABLE IF EXISTS `counter_db3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `counter_db3` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `proprietary_identifier` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `platform` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `publisher` text CHARACTER SET utf8,
  `item_name` text COLLATE utf8_unicode_ci,
  `data_type` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_begin` datetime DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `reg_sessions` int(11) DEFAULT NULL,
  `fed_sessions` int(11) DEFAULT NULL,
  `reg_searches` int(11) DEFAULT NULL,
  `fed_searches` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `counter_jr1`
--

DROP TABLE IF EXISTS `counter_jr1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `counter_jr1` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `print_issn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `online_issn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `doi` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `proprietary_identifier` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `platform` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `publisher` text CHARACTER SET utf8,
  `item_name` text COLLATE utf8_unicode_ci,
  `data_type` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_begin` datetime DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `ft_pdf` int(11) DEFAULT NULL,
  `ft_pdf_mobile` int(11) DEFAULT NULL,
  `ft_html` int(11) DEFAULT NULL,
  `ft_html_mobile` int(11) DEFAULT NULL,
  `ft_total` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1508170 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `counter_jr1_goa`
--

DROP TABLE IF EXISTS `counter_jr1_goa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `counter_jr1_goa` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `print_issn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `online_issn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `doi` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `proprietary_identifier` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `platform` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `publisher` text CHARACTER SET utf8,
  `item_name` text COLLATE utf8_unicode_ci,
  `data_type` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_begin` datetime DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `ft_pdf` int(11) DEFAULT NULL,
  `ft_pdf_mobile` int(11) DEFAULT NULL,
  `ft_html` int(11) DEFAULT NULL,
  `ft_html_mobile` int(11) DEFAULT NULL,
  `ft_total` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1188901 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `counter_jr1a`
--

DROP TABLE IF EXISTS `counter_jr1a`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `counter_jr1a` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `print_issn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `online_issn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `doi` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `proprietary_identifier` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `platform` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `publisher` text CHARACTER SET utf8,
  `item_name` text COLLATE utf8_unicode_ci,
  `data_type` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_begin` datetime DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `ft_pdf` int(11) DEFAULT NULL,
  `ft_pdf_mobile` int(11) DEFAULT NULL,
  `ft_html` int(11) DEFAULT NULL,
  `ft_html_mobile` int(11) DEFAULT NULL,
  `ft_total` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=192685 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `counter_jr2`
--

DROP TABLE IF EXISTS `counter_jr2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `counter_jr2` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `print_issn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `online_issn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `doi` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `proprietary_identifier` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `platform` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `publisher` text CHARACTER SET utf8,
  `item_name` text COLLATE utf8_unicode_ci,
  `data_type` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_begin` datetime DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `no_license` int(11) DEFAULT NULL,
  `turnaways` int(11) DEFAULT NULL,
  `other_reason` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=690041 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `counter_jr3`
--

DROP TABLE IF EXISTS `counter_jr3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `counter_jr3` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `print_issn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `online_issn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `doi` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `proprietary_identifier` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `platform` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `publisher` text CHARACTER SET utf8,
  `item_name` text COLLATE utf8_unicode_ci,
  `data_type` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_begin` datetime DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `toc` int(11) DEFAULT NULL,
  `abstracts` int(11) DEFAULT NULL,
  `references` int(11) DEFAULT NULL,
  `ft_pdf` int(11) DEFAULT NULL,
  `ft_pdf_mobile` int(11) DEFAULT NULL,
  `ft_html` int(11) DEFAULT NULL,
  `ft_html_mobile` int(11) DEFAULT NULL,
  `ft_epub` int(11) DEFAULT NULL,
  `ft_total` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=231777 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `counter_jr4`
--

DROP TABLE IF EXISTS `counter_jr4`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `counter_jr4` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `proprietary_identifier` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `platform` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `item_name` text COLLATE utf8_unicode_ci,
  `data_type` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_begin` datetime DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `searches` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30617 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `counter_mr1`
--

DROP TABLE IF EXISTS `counter_mr1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `counter_mr1` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `platform` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `publisher` text CHARACTER SET utf8,
  `item_name` text COLLATE utf8_unicode_ci,
  `data_type` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_begin` datetime DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `media_requests` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `counter_mr2`
--

DROP TABLE IF EXISTS `counter_mr2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `counter_mr2` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `platform` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `publisher` text CHARACTER SET utf8,
  `item_name` text COLLATE utf8_unicode_ci,
  `data_type` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_begin` datetime DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `audio_requests` int(11) DEFAULT NULL,
  `video_requests` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `counter_pr1`
--

DROP TABLE IF EXISTS `counter_pr1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `counter_pr1` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `platform` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `publisher` text CHARACTER SET utf8,
  `data_type` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_begin` datetime DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `reg_searches` int(11) DEFAULT NULL,
  `fed_searches` int(11) DEFAULT NULL,
  `res_clicks` int(11) DEFAULT NULL,
  `rec_views` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9428 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `counter_sushi`
--

DROP TABLE IF EXISTS `counter_sushi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `counter_sushi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` text COLLATE utf8_unicode_ci,
  `requestorID` text COLLATE utf8_unicode_ci,
  `requestorName` text COLLATE utf8_unicode_ci,
  `requestorEmail` text COLLATE utf8_unicode_ci,
  `customerID` text COLLATE utf8_unicode_ci,
  `customerName` text COLLATE utf8_unicode_ci,
  `counterRelease` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `counterReportType` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `wsdlURL` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=417 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `counter_tr1`
--

DROP TABLE IF EXISTS `counter_tr1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `counter_tr1` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `print_issn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `online_issn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `print_isbn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `online_isbn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `doi` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `proprietary_identifier` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `platform` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `publisher` text CHARACTER SET utf8,
  `item_name` text COLLATE utf8_unicode_ci,
  `data_type` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_begin` datetime DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `sec_html` int(11) DEFAULT NULL,
  `ft_pdf` int(11) DEFAULT NULL,
  `ft_pdf_mobile` int(11) DEFAULT NULL,
  `ft_html` int(11) DEFAULT NULL,
  `ft_html_mobile` int(11) DEFAULT NULL,
  `ft_total` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=120300 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `counter_tr2`
--

DROP TABLE IF EXISTS `counter_tr2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `counter_tr2` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `print_issn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `online_issn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `print_isbn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `online_isbn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `doi` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `proprietary_identifier` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `platform` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `publisher` text CHARACTER SET utf8,
  `item_name` text COLLATE utf8_unicode_ci,
  `data_type` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_begin` datetime DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `no_license` int(11) DEFAULT NULL,
  `turnaways` int(11) DEFAULT NULL,
  `other_reason` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=492191 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `counter_tr3`
--

DROP TABLE IF EXISTS `counter_tr3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `counter_tr3` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `print_issn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `online_issn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `print_isbn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `online_isbn` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `doi` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `proprietary_identifier` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `platform` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `publisher` text CHARACTER SET utf8,
  `item_name` text COLLATE utf8_unicode_ci,
  `data_type` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_begin` datetime DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `toc` int(11) DEFAULT NULL,
  `abstracts` int(11) DEFAULT NULL,
  `ft_pdf` int(11) DEFAULT NULL,
  `ft_pdf_mobile` int(11) DEFAULT NULL,
  `ft_html` int(11) DEFAULT NULL,
  `ft_html_mobile` int(11) DEFAULT NULL,
  `ft_epub` int(11) DEFAULT NULL,
  `ft_total` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=123462 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `scimago_journal_rank`
--

DROP TABLE IF EXISTS `scimago_journal_rank`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `scimago_journal_rank` (
  `Rank` int(11) NOT NULL,
  `Title` text,
  `Type` varchar(25) DEFAULT NULL,
  `Issn` varchar(255) DEFAULT NULL,
  `SJR` decimal(65,30) DEFAULT NULL,
  `SJR_Best_Quartile` varchar(5) DEFAULT NULL,
  `H_index` int(11) NOT NULL,
  `Total_Docs._2015` int(11) NOT NULL,
  `Total_Docs._3years` int(11) NOT NULL,
  `Total_Refs.` int(11) NOT NULL,
  `Total_Cites_3years` int(11) NOT NULL,
  `Citable_Docs._3years` int(11) NOT NULL,
  `Cites_/_Doc._2years` decimal(12,2) DEFAULT NULL,
  `Ref._/_Doc.` decimal(12,2) DEFAULT NULL,
  `Country` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Rank`),
  KEY `H_index_index` (`H_index`),
  KEY `Total_Docs._2015_index` (`Total_Docs._2015`),
  KEY `Total_Docs._3years_index` (`Total_Docs._3years`),
  KEY `Total_Refs._index` (`Total_Refs.`),
  KEY `Total_Cites_3years_index` (`Total_Cites_3years`),
  KEY `Citable_Docs._3years_index` (`Citable_Docs._3years`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping events for database 'usage'
--

--
-- Dumping routines for database 'usage'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-09-12 12:09:36
