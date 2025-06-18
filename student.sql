-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: localhost    Database: student
-- ------------------------------------------------------
-- Server version	8.0.35

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `announcement`
--

DROP TABLE IF EXISTS `announcement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `announcement` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL COMMENT '公告标题',
  `content` text NOT NULL COMMENT '公告内容',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `announcement`
--

LOCK TABLES `announcement` WRITE;
/*!40000 ALTER TABLE `announcement` DISABLE KEYS */;
INSERT INTO `announcement` VALUES (1,'交易安全须知','请勿提前支付定金！见面交易时务必检查物品完好性，确认无误后再付款。','2025-06-05 08:44:56'),(2,'系统维护通知','平台将于2023年6月10日凌晨2:00-3:00进行系统维护，期间无法访问。','2025-06-05 08:44:56'),(3,'新功能上线','即日起支持商品举报功能，发现违规商品请及时举报！','2025-06-05 08:44:56');
/*!40000 ALTER TABLE `announcement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `banner`
--

DROP TABLE IF EXISTS `banner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `banner` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) DEFAULT NULL COMMENT '标题',
  `image_url` varchar(255) NOT NULL COMMENT '图片URL',
  `link_url` varchar(255) DEFAULT NULL COMMENT '跳转链接',
  `sort` int DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态(1-显示)',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='轮播图表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banner`
--

LOCK TABLES `banner` WRITE;
/*!40000 ALTER TABLE `banner` DISABLE KEYS */;
INSERT INTO `banner` VALUES (1,'开学季特惠','/static/images/banner1.jpg','/goods/list?category=1',1,1,'2025-05-22 23:04:34'),(2,'数码产品专场','/static/images/banner2.jpg','/goods/list?category=2',2,1,'2025-05-22 23:04:34'),(3,'家电大促销','/static/images/banner3.jpg','/goods/list?category=3',3,1,'2025-05-22 23:04:34'),(4,'限时秒杀活动','/static/images/banner4.jpg','/promotion',4,1,'2025-05-22 23:04:34');
/*!40000 ALTER TABLE `banner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(50) NOT NULL COMMENT '分类名称',
  `icon` varchar(50) DEFAULT NULL COMMENT 'FontAwesome图标类名',
  `sort` int DEFAULT '0' COMMENT '排序权重',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：1-显示, 0-隐藏',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品分类表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'手机数码','fa-mobile-alt',1,1,'2025-05-21 21:07:25'),(2,'电脑办公','fa-laptop',2,1,'2025-05-21 21:07:25'),(3,'家用电器','fa-tv',3,1,'2025-05-21 21:07:25'),(4,'服饰鞋包','fa-tshirt',4,1,'2025-05-21 21:07:25'),(5,'图书音像','fa-book',5,1,'2025-05-21 21:07:25'),(6,'运动户外','fa-bicycle',6,1,'2025-05-21 21:07:25');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorite`
--

DROP TABLE IF EXISTS `favorite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favorite` (
  `favorite_id` int NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `user_id` int NOT NULL COMMENT '用户ID',
  `goods_id` int NOT NULL COMMENT '商品ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`favorite_id`),
  UNIQUE KEY `idx_user_goods` (`user_id`,`goods_id`),
  KEY `idx_goods_id` (`goods_id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户收藏表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorite`
--

LOCK TABLES `favorite` WRITE;
/*!40000 ALTER TABLE `favorite` DISABLE KEYS */;
INSERT INTO `favorite` VALUES (7,5,12,'2025-05-27 19:11:23'),(24,1,12,'2025-05-27 23:30:06'),(27,1,6,'2025-05-28 09:56:38'),(28,2,11,'2025-05-28 10:24:38'),(32,5,4,'2025-06-03 15:40:25'),(36,3,2,'2025-06-05 20:59:41'),(37,3,13,'2025-06-05 20:59:51'),(38,3,15,'2025-06-05 20:59:56');
/*!40000 ALTER TABLE `favorite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goods`
--

DROP TABLE IF EXISTS `goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `goods` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `name` varchar(100) NOT NULL COMMENT '商品名称',
  `description` text COMMENT '商品描述',
  `price` decimal(10,2) NOT NULL COMMENT '商品价格',
  `images` varchar(255) DEFAULT NULL COMMENT '商品图片(多图URL,逗号分隔)',
  `category_id` int NOT NULL COMMENT '分类ID',
  `user_id` int NOT NULL COMMENT '发布用户ID',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：1-上架, 0-下架, 2-审核中',
  `view_count` int DEFAULT '0' COMMENT '浏览量（用于热门排序）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `main_image` varchar(255) DEFAULT NULL COMMENT '商品主图',
  PRIMARY KEY (`id`),
  KEY `idx_category` (`category_id`),
  KEY `idx_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goods`
--

LOCK TABLES `goods` WRITE;
/*!40000 ALTER TABLE `goods` DISABLE KEYS */;
INSERT INTO `goods` VALUES (1,'iPhone 13 Pro','99新，国行，全套配件齐全',5999.00,'/static/images/iphone1.jpg,/static/images/iphone1.jpg',1,2,1,149,'2025-05-21 21:17:23','2025-06-05 21:04:01','/static/images/iphone1.jpg'),(2,'MacBook Pro 2021','M1芯片，16GB内存，512GB SSD',12999.00,'/static/images/macbook1.jpg,/static/images/macbook1.jpg',2,2,1,103,'2025-05-21 21:17:23','2025-06-08 01:02:34','/static/images/macbook1.jpg'),(3,'索尼4K电视','65英寸，4K HDR，安卓系统',4999.00,'/static/images/huawei-p40.jpg,/static/images/nike1.jpg',3,3,1,268,'2025-05-21 21:17:23','2025-06-05 20:58:39','/static/images/tv1.jpg'),(4,'Nike Air Max','42码，白色，仅试穿',699.00,NULL,4,3,1,54,'2025-05-21 21:17:23','2025-06-04 17:28:15','/static/images/nike1.jpg'),(5,'Java编程思想','第4版，几乎全新',59.00,NULL,5,2,1,225,'2025-05-21 21:17:23','2025-06-08 01:02:18','/static/images/book1.jpg'),(6,'山地自行车','27速，铝合金车架，9成新',999.00,NULL,6,3,1,211,'2025-05-21 21:17:23','2025-06-08 01:02:22','/static/images/bike1.jpg'),(7,'AirPods Pro','二代，降噪，在保',1299.00,NULL,1,2,1,123,'2025-05-21 21:17:23','2025-06-03 15:59:48','/static/images/airpods1.jpg'),(8,'戴尔显示器','27英寸，2K分辨率，IPS面板',1299.00,NULL,2,3,1,69,'2025-05-21 21:17:23','2025-06-05 00:03:10','/static/images/monitor1.jpg'),(9,'小米14','急出',5000.00,NULL,1,5,2,3,'2025-05-25 16:06:53','2025-06-03 15:38:26','/static/uploads/goods/goods_1748160412503.jpg'),(10,'小米14','急出',5000.00,NULL,1,5,2,6,'2025-05-25 16:20:36','2025-06-06 10:07:21','/static/uploads/goods/goods_1748161236450.jpg'),(11,'华为P40 Pro','8+256G 冰霜银 99新',3999.00,'/static/images/huawei-p40-1.jpg,/static/images/huawei-p40-2.jpg',1,2,1,328,'2025-05-25 21:07:41','2025-06-06 09:35:56','/static/images/huawei-p40.jpg'),(12,'小米11 Ultra','12+256G 陶瓷黑 95新',4299.99,NULL,1,3,1,214,'2025-05-25 21:07:41','2025-06-08 01:01:45','/static/images/xiaomi-11u.jpg'),(13,'OPPO Find X3','8+128G 镜黑 99新',3299.00,NULL,1,4,1,162,'2025-05-25 21:07:41','2025-06-05 20:59:49','/static/images/oppo-findx3.jpg'),(14,'vivo X60 Pro','12+256G 原力 98新',3699.00,NULL,1,5,1,147,'2025-05-25 21:07:41','2025-06-06 10:13:55','/static/images/vivo-x60.jpg'),(15,'一加9 Pro','12+256G 闪银 97新',3899.00,NULL,1,2,1,150,'2025-05-25 21:07:41','2025-06-05 20:59:55','/static/images/oneplus-9p.jpg'),(16,'苹果','出出出',2222.00,NULL,1,5,2,4,'2025-05-28 08:37:15','2025-06-03 17:00:54','/static/uploads/goods/goods_1748392634764.jpg'),(17,'冰箱','新买的，没用过几次，可面交',10000.00,NULL,3,5,0,10,'2025-05-29 10:43:31','2025-06-06 10:07:51','/static/uploads/goods/goods_1748486611146.jpg'),(18,'一件U17','买回来仅试穿可小刀',100.00,'/static/uploads/goods/goods_1748940935429.jpg,/static/uploads/goods/goods_1748940991160.jpg',4,2,0,NULL,'2025-06-03 16:55:35','2025-06-05 19:47:31','/static/uploads/goods/goods_1748940991160.jpg');
/*!40000 ALTER TABLE `goods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `message`
--

DROP TABLE IF EXISTS `message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `message` (
  `message_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL COMMENT '接收者ID',
  `sender_id` int NOT NULL COMMENT '发送者ID',
  `title` varchar(100) NOT NULL COMMENT '消息标题',
  `content` text NOT NULL COMMENT '消息内容',
  `status` tinyint DEFAULT '0' COMMENT '0-未读,1-已读',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `deleted` tinyint DEFAULT '0' COMMENT '消息是否已删除',
  PRIMARY KEY (`message_id`),
  KEY `user_id` (`user_id`),
  KEY `sender_id` (`sender_id`),
  CONSTRAINT `message_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `message_ibfk_2` FOREIGN KEY (`sender_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `message`
--

LOCK TABLES `message` WRITE;
/*!40000 ALTER TABLE `message` DISABLE KEYS */;
INSERT INTO `message` VALUES (1,1,5,'聊聊','出吗',1,'2025-05-28 09:51:18',0),(2,5,2,'地点','线下',1,'2025-06-03 19:56:46',0),(3,2,5,'订单已删除','订单 3f3fd209d0924a77 已被删除',NULL,'2025-06-03 21:26:12',0),(4,2,5,'回复：地点','                        【原消息】线下\r\n                    在万达广场面交',0,'2025-06-03 23:06:40',0),(5,3,2,'[商品咨询] 索尼4K电视','                        你好，我想咨询商品：索尼4K电视\r\n商品链接：http://localhost:8080/ssm_war/goods/detail/3\r\n这个可以接受刀吗',1,'2025-06-03 23:11:38',0),(6,3,5,'[商品咨询] 小米11 Ultra','                        你好，我想咨询商品：小米11 Ultra\r\n商品链接：http://localhost:8080/ssm_war/goods/detail/12\r\n                    ',1,'2025-06-03 23:14:52',0),(7,5,1,'[商品咨询] vivo X60 Pro','                        你好，我想咨询商品：vivo X60 Pro\r\n商品链接：http://localhost:8080/ssm_war/goods/detail/14\r\n                    ',1,'2025-06-03 23:16:11',0),(8,5,1,'回复：聊聊','                        【原消息】出吗\r\n                    出的',1,'2025-06-03 23:16:25',0),(9,3,5,'[商品咨询] 小米11 Ultra','                        你好，我想咨询商品：小米11 Ultra\r\n商品链接：http://localhost:8080/ssm_war/goods/detail/12\r\n在吗                    ',1,'2025-06-04 08:38:38',0),(10,5,3,'回复：[商品咨询] 小米11 Ultra','                        【原消息】                        你好，我想咨询商品：小米11 Ultra\r\n商品链接：http://localhost:8080/ssm_war/goods/detail/12\r\n  怎么了亲，有什么想要咨询的吗                  \r\n                    ',1,'2025-06-04 08:47:02',0),(11,5,3,'回复：[商品咨询] 小米11 Ultra','                        【原消息】                        你好，我想咨询商品：小米11 Ultra\r\n商品链接：http://localhost:8080/ssm_war/goods/detail/12\r\n在吗                    \r\n 在的，亲                   ',1,'2025-06-04 08:47:34',0),(13,3,5,'回复：[商品咨询] 小米11 Ultra','                        【原消息】                        【原消息】                        你好，我想咨询商品：小米11 Ultra\r\n商品链接：http://localhost:8080/ssm_war/goods/detail/12\r\n  怎么了亲，有什么想要咨询的吗                  \r\n  价格还可以便宜点吗                  \r\n                    ',1,'2025-06-04 08:48:56',0);
/*!40000 ALTER TABLE `message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order`
--

DROP TABLE IF EXISTS `order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order` (
  `order_id` varchar(32) NOT NULL COMMENT '订单ID',
  `buyer_id` int NOT NULL COMMENT '买家ID',
  `product_id` int NOT NULL COMMENT '商品ID',
  `seller_id` int NOT NULL COMMENT '卖家ID',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '订单状态(0-待确认,1-已完成,2-已取消)',
  `price` decimal(10,2) NOT NULL COMMENT '成交价格',
  `buyer_message` varchar(255) DEFAULT NULL COMMENT '买家留言',
  `trade_method` varchar(50) DEFAULT '线下交易' COMMENT '交易方式',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`order_id`),
  KEY `idx_buyer_id` (`buyer_id`),
  KEY `idx_seller_id` (`seller_id`),
  KEY `idx_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order`
--

LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
INSERT INTO `order` VALUES ('19208e2653944d7e',5,12,3,1,4299.00,'','线下交易','2025-05-26 16:56:31','2025-05-26 21:36:02'),('3f90d062707646e1',5,11,2,2,3999.00,'','线下交易','2025-05-27 14:45:59','2025-05-27 14:46:01'),('45a280ea03294d84',5,8,3,1,1299.00,'','线下交易','2025-05-26 16:53:09','2025-05-26 21:36:07'),('6f1ad2b2ee554048',1,6,3,0,999.00,'','线下交易','2025-05-28 09:56:51','2025-05-28 09:56:51'),('7003b443f3f845c2',5,11,2,1,3999.00,'','线下交易','2025-05-26 16:51:23','2025-05-26 21:36:07'),('dfafcbb452fa4e6a',5,11,2,0,3999.00,'','线下交易','2025-05-28 08:36:11','2025-05-28 08:36:11'),('efed5578fb0e43b5',1,12,3,2,4299.00,'','平台担保','2025-05-28 09:56:03','2025-05-28 09:59:53'),('f1e9aa6024bf4c05',1,12,3,0,4299.00,'','线下交易','2025-05-28 09:56:09','2025-05-28 09:56:09');
/*!40000 ALTER TABLE `order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码(加密存储)',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '邮箱',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '电话',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '地址',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '/static/images/avatar.jpg',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态(1-正常,0-禁用)',
  `role` tinyint(1) NOT NULL DEFAULT '0' COMMENT '角色(0-普通用户,1-管理员)',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `idx_username` (`username`),
  UNIQUE KEY `idx_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'晴晴','e10adc3949ba59abbe56e057f20f883e','3289824240@qq.com','13729723065','','/static/images/avatar.jpg','2025-05-24 00:15:49','2025-06-08 00:59:18',1,0),(2,'钱钱钱','e10adc3949ba59abbe56e057f20f883e','3289824120@qq.com','13729723065','','/static/images/avatar.jpg','2025-05-23 11:55:21','2025-06-08 00:59:18',1,0),(3,'芦苇姐姐','e10adc3949ba59abbe56e057f20f883e','328982420@qq.com','13729723065','中国','/static/images/avatar.jpg','2025-05-23 11:57:48','2025-06-08 00:59:18',1,0),(4,'芦苇jj','e10adc3949ba59abbe56e057f20f883e','3289824230@qq.com','13729723065',NULL,'/static/images/avatar.jpg','2025-05-24 00:14:09','2025-06-08 00:59:18',1,0),(5,'钱钱钱钱钱钱','fcea920f7412b5da7be0cf42b8c93759','3289824220@qq.com','13729723065','中国','/static/images/avatar.jpg','2025-05-24 20:13:44','2025-06-08 00:59:18',1,0),(6,'admin','202cb962ac59075b964b07152d234b70','admin@example.com',NULL,NULL,'/static/images/avatar.jpg','2025-05-25 00:32:43','2025-05-25 00:38:58',1,1),(8,'bc晴晴','e10adc3949ba59abbe56e057f20f883e','qq@qq.com','13729723065',NULL,'/static/images/avatar.jpg','2025-05-25 21:32:53','2025-06-08 00:59:18',1,0);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-08  1:27:18
