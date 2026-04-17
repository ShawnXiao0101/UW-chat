-- MySQL dump 10.13  Distrib 8.4.0, for macos13.2 (arm64)
--
-- Host: localhost    Database: kama_chat
-- ------------------------------------------------------
-- Server version	9.0.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `contact_apply`
--

DROP TABLE IF EXISTS `contact_apply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_apply` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `uuid` char(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '申请id',
  `user_id` char(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '申请人id',
  `contact_id` char(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '被申请id',
  `contact_type` tinyint NOT NULL COMMENT '被申请类型，0.用户，1.群聊',
  `status` tinyint NOT NULL COMMENT '申请状态，0.申请中，1.通过，2.拒绝，3.拉黑',
  `message` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '申请信息',
  `last_apply_at` datetime NOT NULL COMMENT '最后申请时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_contact_apply_uuid` (`uuid`),
  KEY `idx_contact_apply_user_id` (`user_id`),
  KEY `idx_contact_apply_contact_id` (`contact_id`),
  KEY `idx_contact_apply_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact_apply`
--

LOCK TABLES `contact_apply` WRITE;
/*!40000 ALTER TABLE `contact_apply` DISABLE KEYS */;
INSERT INTO `contact_apply` VALUES (1,'A2026041454031532935','U2026041412345678901','U000000000000000001',0,1,'','2026-04-14 23:34:14',NULL);
/*!40000 ALTER TABLE `contact_apply` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `group_info`
--

DROP TABLE IF EXISTS `group_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `group_info` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `uuid` char(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '群组唯一id',
  `name` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '群名称',
  `notice` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '群公告',
  `members` json DEFAULT NULL COMMENT '群组成员',
  `member_cnt` bigint DEFAULT '1' COMMENT '群人数',
  `owner_id` char(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '群主uuid',
  `add_mode` tinyint DEFAULT '0' COMMENT '加群方式，0.直接，1.审核',
  `avatar` char(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png' COMMENT '头像',
  `status` tinyint DEFAULT '0' COMMENT '状态，0.正常，1.禁用，2.解散',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted_at` datetime(3) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_group_info_uuid` (`uuid`),
  KEY `idx_group_info_created_at` (`created_at`),
  KEY `idx_group_info_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `group_info`
--

LOCK TABLES `group_info` WRITE;
/*!40000 ALTER TABLE `group_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `group_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `message`
--

DROP TABLE IF EXISTS `message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `message` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `uuid` char(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '消息uuid',
  `session_id` char(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '会话uuid',
  `type` tinyint NOT NULL COMMENT '消息类型，0.文本，1.语音，2.文件，3.通话',
  `content` text COLLATE utf8mb4_unicode_ci COMMENT '消息内容',
  `url` char(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '消息url',
  `send_id` char(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '发送者uuid',
  `send_name` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '发送者昵称',
  `send_avatar` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '发送者头像',
  `receive_id` char(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '接受者uuid',
  `file_type` char(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '文件类型',
  `file_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '文件名',
  `file_size` char(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '文件大小',
  `status` tinyint NOT NULL COMMENT '状态，0.未发送，1.已发送',
  `created_at` datetime(3) NOT NULL COMMENT '创建时间',
  `send_at` datetime(3) DEFAULT NULL COMMENT '发送时间',
  `av_data` longtext COLLATE utf8mb4_unicode_ci COMMENT '通话传递数据',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_message_uuid` (`uuid`),
  KEY `idx_message_session_id` (`session_id`),
  KEY `idx_message_send_id` (`send_id`),
  KEY `idx_message_receive_id` (`receive_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `message`
--

LOCK TABLES `message` WRITE;
/*!40000 ALTER TABLE `message` DISABLE KEYS */;
INSERT INTO `message` VALUES (1,'M2026041488472665115','S2026041463072926299',0,'nihao\n','','U2026041412345678901','user2','https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png','U000000000000000001','','','0B',1,'2026-04-14 23:34:34.404',NULL,''),(2,'M2026041473416886834','S2026041463072926299',0,'我是老努粉丝 请爱我吧\n','','U2026041412345678901','威朗普','https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png','U000000000000000001','','','0B',1,'2026-04-14 23:36:10.221',NULL,''),(3,'M2026041436386210119','S2026041463072926299',0,'老努 以后我都听你的\n','','U2026041412345678901','威朗普','https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png','U000000000000000001','','','0B',1,'2026-04-14 23:49:57.355',NULL,''),(4,'M2026041441410081769','S2026041463072926299',0,'老魏蜜汁小憨包\n','','U2026041412345678901','威朗普','https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png','U000000000000000001','','','0B',1,'2026-04-14 23:53:31.138',NULL,''),(5,'M2026041444514177259','S2026041463072926299',0,'的说法是\n','','U2026041412345678901','威朗普','https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png','U000000000000000001','','','0B',1,'2026-04-14 23:57:11.450',NULL,''),(6,'M2026041466210503583','S2026041463072926299',0,'梵蒂冈','','U2026041412345678901','威朗普','https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png','U000000000000000001','','','0B',1,'2026-04-14 23:57:44.013',NULL,'');
/*!40000 ALTER TABLE `message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `session`
--

DROP TABLE IF EXISTS `session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `session` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `uuid` char(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '会话uuid',
  `send_id` char(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '创建会话人id',
  `receive_id` char(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '接受会话人id',
  `receive_name` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '名称',
  `avatar` char(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'default_avatar.png' COMMENT '头像',
  `last_message` text COLLATE utf8mb4_unicode_ci COMMENT '最新的消息',
  `last_message_at` datetime DEFAULT NULL COMMENT '最近接收时间',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_session_uuid` (`uuid`),
  KEY `idx_session_send_id` (`send_id`),
  KEY `idx_session_receive_id` (`receive_id`),
  KEY `idx_session_created_at` (`created_at`),
  KEY `idx_session_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session`
--

LOCK TABLES `session` WRITE;
/*!40000 ALTER TABLE `session` DISABLE KEYS */;
INSERT INTO `session` VALUES (1,'S2026041463072926299','U2026041412345678901','U000000000000000001','123','https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png','',NULL,'2026-04-14 23:34:29',NULL),(2,'S2026041443728640177','U000000000000000001','U2026041412345678901','user2','https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png','',NULL,'2026-04-14 23:34:41',NULL);
/*!40000 ALTER TABLE `session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_contact`
--

DROP TABLE IF EXISTS `user_contact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_contact` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `user_id` char(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户唯一id',
  `contact_id` char(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '对应联系id',
  `contact_type` tinyint NOT NULL COMMENT '联系类型，0.用户，1.群聊',
  `status` tinyint NOT NULL COMMENT '联系状态，0.正常，1.拉黑，2.被拉黑，3.删除好友，4.被删除好友，5.被禁言，6.退出群聊，7.被踢出群聊',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `update_at` datetime NOT NULL COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_contact_user_id` (`user_id`),
  KEY `idx_user_contact_contact_id` (`contact_id`),
  KEY `idx_user_contact_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_contact`
--

LOCK TABLES `user_contact` WRITE;
/*!40000 ALTER TABLE `user_contact` DISABLE KEYS */;
INSERT INTO `user_contact` VALUES (1,'U000000000000000001','U2026041412345678901',0,0,'2026-04-14 23:34:22','2026-04-14 23:34:22',NULL),(2,'U2026041412345678901','U000000000000000001',0,0,'2026-04-14 23:34:22','2026-04-14 23:34:22',NULL);
/*!40000 ALTER TABLE `user_contact` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_info`
--

DROP TABLE IF EXISTS `user_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_info` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `uuid` char(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '用户唯一id',
  `nickname` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '昵称',
  `telephone` char(11) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '电话',
  `email` char(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '邮箱',
  `avatar` char(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png' COMMENT '头像',
  `gender` tinyint DEFAULT NULL COMMENT '性别，0.男，1.女',
  `signature` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '个性签名',
  `password` char(18) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `birthday` char(8) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '生日',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  `last_online_at` datetime DEFAULT NULL COMMENT '上次登录时间',
  `last_offline_at` datetime DEFAULT NULL COMMENT '最近离线时间',
  `is_admin` tinyint NOT NULL COMMENT '是否是管理员，0.不是，1.是',
  `status` tinyint NOT NULL COMMENT '状态，0.正常，1.禁用',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_user_info_uuid` (`uuid`),
  KEY `idx_user_info_created_at` (`created_at`),
  KEY `idx_user_info_status` (`status`),
  KEY `idx_user_info_telephone` (`telephone`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_info`
--

LOCK TABLES `user_info` WRITE;
/*!40000 ALTER TABLE `user_info` DISABLE KEYS */;
INSERT INTO `user_info` VALUES (1,'U000000000000000001','努努','15513322886','','https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png',0,'','123','20000101','2026-04-14 21:39:24',NULL,NULL,NULL,0,0),(2,'U2026041412345678901','威朗普','13036351261','','https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png',0,'','123','','2026-04-14 23:33:12',NULL,NULL,NULL,0,0);
/*!40000 ALTER TABLE `user_info` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-16 23:00:45
