-- ===============================================================================================================================================================================================
-- Purpose: This script initializes the database schema, including table structures and constraints, to support user management, financial transactions, and system logging.
-- Warning: Ensure you have backups before running this script, as it will alter the database structure and may lead to data loss if executed improperly.
-- ============================================================================================================================================================================================== 

-- MySQL dump 10.13  Distrib 5.7.44, for Win64 (x86_64)
--
-- Host: localhost    Database: ttl_ishc
-- ------------------------------------------------------
-- Server version	5.7.44-log

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
-- Table structure for table `image_mast`
--

DROP TABLE IF EXISTS `image_mast`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `image_mast` (
  `img_guid` varchar(100) NOT NULL,
  `img_etype` varchar(10) NOT NULL DEFAULT 'jpg',
  `img_name` varchar(100) NOT NULL,
  `img_exif_date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `image_mast`
--

LOCK TABLES `image_mast` WRITE;
/*!40000 ALTER TABLE `image_mast` DISABLE KEYS */;
INSERT INTO `image_mast` VALUES ('i1-1-1-1','jpg','fly', '2023-07-04 00:00:00'),
	('i1-1-1-2','jpg','tc_blog', '2019-04-09 00:00:00'),
    ('i1-1-2-1','jpg','tgmaveric', '2017-06-27 00:00:00'),
    ('i1-1-2-1-1','jpg','tc_jack_reacher', '2023-12-03 00:00:00'),
    ('i1-1-2-1-2','jpg','tom_cruise_jack_reacher', '2022-08-06 00:00:00'),
    ('i1-1-2-2-1-1','jpg','mi2_poster', '2020-07-25 00:00:00'),
    ('i1-1-2-2-1-2','jpg','mi2_tc', '2015-02-23 00:00:00'),
    ('i1-1-2-2-2-1','jpg','mission_i_tc', '2022-03-24 00:00:00'),
    ('i2-1-1','jpg','jc', '2017-04-05 00:00:00'),
    ('i1-2-1-1','jpg','tyson_punch', '2021-01-12 00:00:00'),
    ('i1-2-1-2','jpg','tyson_vs_jones', '2020-10-15 00:00:00'),
    ('i1-2-2-1','jpg','mt', '2017-12-05 00:00:00'),
    ('i1-2-2-2','jpg','tyson1', '2019-10-03 00:00:00'),
    ('i1-2-2-1-1','jpg','family_photo', '2016-12-22 00:00:00'),
    ('i1-2-2-1-2','jpg','fpmt', '2021-08-24 00:00:00'),
    ('i1-2-2-2-1','jpg','ali_tyson', '2019-09-21 00:00:00'),
    ('i1-2-2-2-2','jpg','tyson_holifild', '2022-03-24 00:00:00');
/*!40000 ALTER TABLE `image_mast` ENABLE KEYS */;
UNLOCK TABLES;

INSERT INTO `image_mast` VALUES ('i1-1-1-3','jpg','test_null', '2000-07-04 00:00:00');

INSERT INTO `image_mast` VALUES ('i1-3-1-1','jpg','tbf_null_test', '2000-07-04 00:00:00');

--
-- Table structure for table `orig_images`
--

DROP TABLE IF EXISTS `orig_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orig_images` (
  `oi_guid` varchar(100) NOT NULL,
  `oi_data` mediumblob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orig_images`
--

--
-- Table structure for table `patient_info`
--

DROP TABLE IF EXISTS `patient_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `patient_info` (
  `pat_fguid` varchar(100) NOT NULL,
  `pat_fname` varchar(50) NOT NULL,
  `pat_lname` varchar(50) NOT NULL,
  `pat_mname` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient_info`
--

LOCK TABLES `patient_info` WRITE;
/*!40000 ALTER TABLE `patient_info` DISABLE KEYS */;
INSERT INTO `patient_info` VALUES ('1-1','Thomas','Cruise','Mapother'),('1-2','Michael','Tyson','Gerard'),('2-1','John','Cena','Felix');
/*!40000 ALTER TABLE `patient_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `spark_vfwp`
--

DROP TABLE IF EXISTS `spark_vfwp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spark_vfwp` (
  `fld_guid` text,
  `fld_name` text,
  `full_path` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `spark_vfwp`
--

LOCK TABLES `spark_vfwp` WRITE;
/*!40000 ALTER TABLE `spark_vfwp` DISABLE KEYS */;
INSERT INTO `spark_vfwp` VALUES ('1-2-2-1','Family','/Tyson,Michael,Gerard(1-2)/Daily(1-2-2)/Family(1-2-2-1)'),('1-2-2-2','Friends','/Tyson,Michael,Gerard(1-2)/Daily(1-2-2)/Friends(1-2-2-2)'),('1-1-2-1','Jack Reacher','/Cruise,Thomas,Mapother(1-1)/movie_photos(1-1-2)/Jack Reacher(1-1-2-1)'),('1-1-2-2','Mission Impossible','/Cruise,Thomas,Mapother(1-1)/movie_photos(1-1-2)/Mission Impossible(1-1-2-2)'),('1-1','Pat1(Tom Cruise)','/Cruise,Thomas,Mapother(1-1)'),('1-1-2-2-1','MI2','/Cruise,Thomas,Mapother(1-1)/movie_photos(1-1-2)/Mission Impossible(1-1-2-2)/MI2(1-1-2-2-1)'),('1-2','Pat2(Mike Tyson)','/Tyson,Michael,Gerard(1-2)'),('1-1-2-2-2','Mission Impossible 1','/Cruise,Thomas,Mapother(1-1)/movie_photos(1-1-2)/Mission Impossible(1-1-2-2)/Mission Impossible 1(1-1-2-2-2)'),('1-1-1','holiday','/Cruise,Thomas,Mapother(1-1)/holiday(1-1-1)'),('1-1-2','movie_photos','/Cruise,Thomas,Mapother(1-1)/movie_photos(1-1-2)'),('1-2-1','Boxing','/Tyson,Michael,Gerard(1-2)/Boxing(1-2-1)'),('1-2-2','Daily','/Tyson,Michael,Gerard(1-2)/Daily(1-2-2)');
/*!40000 ALTER TABLE `spark_vfwp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `test`
--

DROP TABLE IF EXISTS `test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test` (
  `id` int(11) DEFAULT NULL,
  `img` mediumblob
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `test`
--

LOCK TABLES `test` WRITE;
/*!40000 ALTER TABLE `test` DISABLE KEYS */;
INSERT INTO `test` VALUES (1,NULL);
/*!40000 ALTER TABLE `test` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `virtual_folder`
--

DROP TABLE IF EXISTS `virtual_folder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `virtual_folder` (
  `fld_guid` varchar(100) NOT NULL,
  `fld_owner` varchar(100) NOT NULL,
  `fld_parent_guid` varchar(100) NOT NULL,
  `fld_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

INSERT INTO `virtual_folder` VALUES ('1-3','1','ph-1-tbf','To be Filed');
INSERT INTO `virtual_folder` VALUES ('1-3-1','1','1-3','aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');

--
-- Dumping data for table `virtual_folder`
--

LOCK TABLES `virtual_folder` WRITE;
/*!40000 ALTER TABLE `virtual_folder` DISABLE KEYS */;
INSERT INTO `virtual_folder` VALUES ('1-1','1','','Pat1(Tom Cruise)'),('1-1-1','1','1-1','holiday'),('1-1-2','1','1-1','movie_photos'),('1-1-2-1','1','1-1-2','Jack Reacher'),('1-1-2-2','1','1-1-2','Mission Impossible'),('1-1-2-2-1','1','1-1-2-2','MI2'),('1-1-2-2-2','1','1-1-2-2','Mission Impossible 1'),('1-2','1','','Pat2(Mike Tyson)'),('1-2-1','1','1-2','Boxing'),('1-2-2','1','1-2','Daily'),('1-2-2-1','1','1-2-2','Family'),('1-2-2-2','1','1-2-2','Friends'),('2-1','2','','Pat3(John Cena)');
/*!40000 ALTER TABLE `virtual_folder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `virtual_folder_imagemap`
--

DROP TABLE IF EXISTS `virtual_folder_imagemap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `virtual_folder_imagemap` (
  `imap_folder_guid` varchar(100) CHARACTER SET latin1 NOT NULL,
  `imap_img_guid` varchar(100) CHARACTER SET latin1 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `virtual_folder_imagemap`
--

LOCK TABLES `virtual_folder_imagemap` WRITE;
/*!40000 ALTER TABLE `virtual_folder_imagemap` DISABLE KEYS */;
INSERT INTO `virtual_folder_imagemap` VALUES ('1-1-1','i1-1-1-1'),('1-1-1','i1-1-1-2'),('1-1-2','i1-1-2-1'),('1-1-2-1','i1-1-2-1-1'),('1-1-2-1','i1-1-2-1-2'),('1-1-2-2-1','i1-1-2-2-1-1'),('1-1-2-2-1','i1-1-2-2-1-2'),('1-1-2-2-2','i1-1-2-2-2-1'),('2-1','i2-1-1'),('1-2-1','i1-2-1-1'),('1-2-1','i1-2-1-2'),('1-2-2','i1-2-2-1'),('1-2-2','i1-2-2-2'),('1-2-2-1','i1-2-2-1-1'),('1-2-2-1','i1-2-2-1-2'),('1-2-2-2','i1-2-2-2-1'),('1-2-2-2','i1-2-2-2-2');
/*!40000 ALTER TABLE `virtual_folder_imagemap` ENABLE KEYS */;
UNLOCK TABLES;

INSERT INTO `virtual_folder_imagemap` VALUES ('1-1-1', 'i1-1-1-3');

INSERT INTO `virtual_folder_imagemap` VALUES ('1-3-1', 'i1-3-1-1')
--
-- Table structure for table `virtual_folder_with_path`
--

DROP TABLE IF EXISTS `virtual_folder_with_path`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `virtual_folder_with_path` (
  `fld_guid` text,
  `fld_name` text,
  `full_path` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `virtual_folder_with_path`
--

LOCK TABLES `virtual_folder_with_path` WRITE;
/*!40000 ALTER TABLE `virtual_folder_with_path` DISABLE KEYS */;
INSERT INTO `virtual_folder_with_path` VALUES ('1-1','Pat1(Tom Cruise)','/Cruise,Thomas,Mapother(1-1)'),('1-2','Pat2(Mike Tyson)','/Tyson,Michael,Gerard(1-2)'),('1-1-1','holiday','/Cruise,Thomas,Mapother(1-1)/holiday(1-1-1)'),('1-1-2','movie_photos','/Cruise,Thomas,Mapother(1-1)/movie_photos(1-1-2)'),('1-2-1','Boxing','/Tyson,Michael,Gerard(1-2)/Boxing(1-2-1)'),('1-2-2','Daily','/Tyson,Michael,Gerard(1-2)/Daily(1-2-2)'),('1-1-2-1','Jack Reacher','/Cruise,Thomas,Mapother(1-1)/movie_photos(1-1-2)/Jack Reacher(1-1-2-1)'),('1-1-2-2','Mission Impossible','/Cruise,Thomas,Mapother(1-1)/movie_photos(1-1-2)/Mission Impossible(1-1-2-2)'),('1-2-2-1','Family','/Tyson,Michael,Gerard(1-2)/Daily(1-2-2)/Family(1-2-2-1)'),('1-2-2-2','Friends','/Tyson,Michael,Gerard(1-2)/Daily(1-2-2)/Friends(1-2-2-2)'),('1-1-2-2-1','MI2','/Cruise,Thomas,Mapother(1-1)/movie_photos(1-1-2)/Mission Impossible(1-1-2-2)/MI2(1-1-2-2-1)'),('1-1-2-2-2','Mission Impossible 1','/Cruise,Thomas,Mapother(1-1)/movie_photos(1-1-2)/Mission Impossible(1-1-2-2)/Mission Impossible 1(1-1-2-2-2)');
/*!40000 ALTER TABLE `virtual_folder_with_path` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-11-20 12:45:51
