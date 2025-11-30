-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: board_db
-- ------------------------------------------------------
-- Server version	8.0.41

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
-- Table structure for table `chat_messages`
--

DROP TABLE IF EXISTS `chat_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chat_messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `room_id` int NOT NULL,
  `user_id` int NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `room_id` (`room_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `chat_messages_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `chat_rooms` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chat_messages_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chat_messages`
--

LOCK TABLES `chat_messages` WRITE;
/*!40000 ALTER TABLE `chat_messages` DISABLE KEYS */;
INSERT INTO `chat_messages` VALUES (1,1,5,'ㅎㅇㅎㅇ','2025-11-28 03:04:30'),(2,1,1,'어서오시고','2025-11-28 03:05:07'),(3,1,5,'닌 뭐임','2025-11-28 03:05:12'),(4,1,1,'나? 관리자','2025-11-28 03:05:17'),(5,1,5,'시발련아','2025-11-28 03:10:43'),(6,3,6,'안녕하세요','2025-11-30 17:26:29'),(7,3,6,'안녕하세여','2025-11-30 17:26:39'),(8,3,5,'네 안녕하세요','2025-11-30 17:26:55'),(9,3,5,'구매하시나요??','2025-11-30 17:33:42'),(10,3,5,'ㅁㄴㅇ','2025-11-30 17:34:27'),(11,3,5,'ㅁㄴㅇ','2025-11-30 17:36:48'),(12,3,5,'ㅁㄴㅇ','2025-11-30 17:36:48'),(13,3,5,'ㅁㄴㅇ','2025-11-30 17:36:49'),(14,3,6,'넹','2025-11-30 17:37:11'),(15,4,8,'gd','2025-11-30 18:26:13'),(16,4,6,'ㅎㅇㅎㅇ','2025-11-30 18:26:17'),(17,4,5,'ㅎㅇㅎㅇ','2025-11-30 18:26:38');
/*!40000 ALTER TABLE `chat_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chat_rooms`
--

DROP TABLE IF EXISTS `chat_rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chat_rooms` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `owner_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `linked_post_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chat_rooms`
--

LOCK TABLES `chat_rooms` WRITE;
/*!40000 ALTER TABLE `chat_rooms` DISABLE KEYS */;
INSERT INTO `chat_rooms` VALUES (1,'안녕하세요',81,'2025-11-28 03:03:44',NULL),(2,'asd',92,'2025-11-28 03:17:43',NULL),(3,'[구매문의] 중고 아이폰13',6,'2025-11-30 17:14:42',NULL),(4,'[공구] 마스크팩',5,'2025-11-30 18:25:41',108);
/*!40000 ALTER TABLE `chat_rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `post_id` int NOT NULL,
  `user_id` int NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `post_id` (`post_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` VALUES (2,106,5,'asd','2025-11-30 18:40:02');
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `posts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `view_count` int DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `author_id` int DEFAULT NULL,
  `category` varchar(20) DEFAULT '자유',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=111 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` VALUES (6,'아이디 공지','관리자 ID/PW : admin / admin\r\n\r\n1. 로그인 안하면 글 못씀.\r\n2. 작성자만 글 삭제가능.\r\n3. 관리자는 모든 게시물 삭제/수정 가능\r\n\r\n\r\nUSER ID/PW : USER(1 ~ 100) / 1234\r\n\r\n유저 1 ~ 100 까지 있음',97,'2025-11-20 17:09:42','2025-12-01 04:14:46',1,'공지'),(7,'안녕하세요..','안녕하세요. 유저1 입니다.\r\n비밀번호는 1234 입니다.',4,'2025-11-25 15:22:35','2025-11-28 11:25:13',5,'가입인사'),(8,'안녕하세요22','안녕하세요, 유저2 입니다.\r\n비밀번호는 1234 입니다.',3,'2025-11-25 15:23:04','2025-11-28 11:22:26',6,'가입인사'),(9,'안녕하세요! 3번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',7,'가입인사'),(10,'안녕하세요! 4번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',8,'가입인사'),(11,'안녕하세요! 5번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',9,'가입인사'),(12,'안녕하세요! 6번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',10,'가입인사'),(13,'안녕하세요! 7번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',11,'가입인사'),(14,'안녕하세요! 8번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',12,'가입인사'),(15,'안녕하세요! 9번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',13,'가입인사'),(16,'안녕하세요! 10번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',14,'가입인사'),(17,'안녕하세요! 11번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',15,'가입인사'),(18,'안녕하세요! 12번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',16,'가입인사'),(19,'안녕하세요! 13번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',17,'가입인사'),(20,'안녕하세요! 14번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',18,'가입인사'),(21,'안녕하세요! 15번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',19,'가입인사'),(22,'안녕하세요! 16번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',20,'가입인사'),(23,'안녕하세요! 17번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',21,'가입인사'),(24,'안녕하세요! 18번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',22,'가입인사'),(25,'안녕하세요! 19번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',23,'가입인사'),(26,'안녕하세요! 20번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',24,'가입인사'),(27,'안녕하세요! 21번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',25,'가입인사'),(28,'안녕하세요! 22번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',26,'가입인사'),(29,'안녕하세요! 23번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',27,'가입인사'),(30,'안녕하세요! 24번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',28,'가입인사'),(31,'안녕하세요! 25번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',29,'가입인사'),(32,'안녕하세요! 26번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',30,'가입인사'),(33,'안녕하세요! 27번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',31,'가입인사'),(34,'안녕하세요! 28번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',32,'가입인사'),(35,'안녕하세요! 29번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',33,'가입인사'),(36,'안녕하세요! 30번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',34,'가입인사'),(37,'안녕하세요! 31번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',35,'가입인사'),(38,'안녕하세요! 32번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',36,'가입인사'),(39,'안녕하세요! 33번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',37,'가입인사'),(40,'안녕하세요! 34번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',38,'가입인사'),(41,'안녕하세요! 35번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',39,'가입인사'),(42,'안녕하세요! 36번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',40,'가입인사'),(43,'안녕하세요! 37번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',41,'가입인사'),(44,'안녕하세요! 38번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',42,'가입인사'),(45,'안녕하세요! 39번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',43,'가입인사'),(46,'안녕하세요! 40번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',44,'가입인사'),(47,'안녕하세요! 41번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',45,'가입인사'),(48,'안녕하세요! 42번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',46,'가입인사'),(49,'안녕하세요! 43번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',47,'가입인사'),(50,'안녕하세요! 44번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',48,'가입인사'),(51,'안녕하세요! 45번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',49,'가입인사'),(52,'안녕하세요! 46번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',50,'가입인사'),(53,'안녕하세요! 47번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',51,'가입인사'),(54,'안녕하세요! 48번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',52,'가입인사'),(55,'안녕하세요! 49번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',53,'가입인사'),(56,'안녕하세요! 50번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',54,'가입인사'),(57,'안녕하세요! 51번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',55,'가입인사'),(58,'안녕하세요! 52번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',56,'가입인사'),(59,'안녕하세요! 53번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',57,'가입인사'),(60,'안녕하세요! 54번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',58,'가입인사'),(61,'안녕하세요! 55번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',59,'가입인사'),(62,'안녕하세요! 56번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',60,'가입인사'),(63,'안녕하세요! 57번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',61,'가입인사'),(64,'안녕하세요! 58번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',62,'가입인사'),(65,'안녕하세요! 59번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',63,'가입인사'),(66,'안녕하세요! 60번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',64,'가입인사'),(67,'안녕하세요! 61번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',65,'가입인사'),(68,'안녕하세요! 62번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',66,'가입인사'),(69,'안녕하세요! 63번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',67,'가입인사'),(70,'안녕하세요! 64번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',68,'가입인사'),(71,'안녕하세요! 65번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',69,'가입인사'),(72,'안녕하세요! 66번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',70,'가입인사'),(73,'안녕하세요! 67번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',71,'가입인사'),(74,'안녕하세요! 68번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',72,'가입인사'),(75,'안녕하세요! 69번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',73,'가입인사'),(76,'안녕하세요! 70번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',74,'가입인사'),(77,'안녕하세요! 71번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',75,'가입인사'),(78,'안녕하세요! 72번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',76,'가입인사'),(79,'안녕하세요! 73번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',77,'가입인사'),(80,'안녕하세요! 74번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',78,'가입인사'),(81,'안녕하세요! 75번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',79,'가입인사'),(82,'안녕하세요! 76번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',80,'가입인사'),(83,'안녕하세요! 77번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',81,'가입인사'),(84,'안녕하세요! 78번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',82,'가입인사'),(85,'안녕하세요! 79번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',83,'가입인사'),(86,'안녕하세요! 80번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',84,'가입인사'),(87,'안녕하세요! 81번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',85,'가입인사'),(88,'안녕하세요! 82번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',86,'가입인사'),(89,'안녕하세요! 83번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',87,'가입인사'),(90,'안녕하세요! 84번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',88,'가입인사'),(91,'안녕하세요! 85번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',89,'가입인사'),(92,'안녕하세요! 86번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',90,'가입인사'),(93,'안녕하세요! 87번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',91,'가입인사'),(94,'안녕하세요! 88번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',92,'가입인사'),(95,'안녕하세요! 89번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',93,'가입인사'),(96,'안녕하세요! 90번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',94,'가입인사'),(97,'안녕하세요! 91번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',95,'가입인사'),(98,'안녕하세요! 92번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',96,'가입인사'),(99,'안녕하세요! 93번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',97,'가입인사'),(100,'안녕하세요! 94번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',98,'가입인사'),(101,'안녕하세요! 95번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',1,'2025-11-28 11:36:16','2025-12-01 03:10:25',99,'가입인사'),(102,'안녕하세요! 96번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',100,'가입인사'),(103,'안녕하세요! 97번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',0,'2025-11-28 11:36:16','2025-11-28 11:36:16',101,'가입인사'),(104,'안녕하세요! 98번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',1,'2025-11-28 11:36:16','2025-12-01 03:06:16',102,'가입인사'),(105,'안녕하세요! 99번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',2,'2025-11-28 11:36:16','2025-12-01 03:35:41',103,'가입인사'),(106,'안녕하세요! 100번째 유저입니다.','반갑습니다. 앞으로 잘 부탁드립니다! (자동 생성된 가입인사)',16,'2025-11-28 11:36:16','2025-12-01 03:40:11',104,'가입인사'),(107,'중고 거래 테스트','.\r\n.\r\n.\r\n',27,'2025-12-01 02:14:01','2025-12-01 03:52:13',5,'중고거래'),(108,'공구 테스트','.\r\n.\r\n.',15,'2025-12-01 03:21:44','2025-12-01 03:52:35',5,'공구'),(110,'자유게시판 테스트','.\r\n.\r\n.',8,'2025-12-01 03:51:27','2025-12-01 04:14:30',5,'자유');
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `room_members`
--

DROP TABLE IF EXISTS `room_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room_members` (
  `room_id` int NOT NULL,
  `user_id` int NOT NULL,
  `joined_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_read_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`room_id`,`user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `room_members_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `chat_rooms` (`id`) ON DELETE CASCADE,
  CONSTRAINT `room_members_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room_members`
--

LOCK TABLES `room_members` WRITE;
/*!40000 ALTER TABLE `room_members` DISABLE KEYS */;
INSERT INTO `room_members` VALUES (1,81,'2025-11-28 03:12:54','2025-11-30 17:40:25'),(3,5,'2025-11-30 17:14:42','2025-11-30 18:29:59'),(3,6,'2025-11-30 17:14:42','2025-11-30 17:40:25'),(4,5,'2025-11-30 18:25:41','2025-11-30 18:30:01'),(4,6,'2025-11-30 18:25:41','2025-11-30 18:25:43'),(4,8,'2025-11-30 18:26:07','2025-11-30 18:26:08');
/*!40000 ALTER TABLE `room_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `is_admin` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'관리자','admin@example.com','admin','$2b$10$OY0ht2Ineg38qzV2nM1qiufLvxA/rwNu807yzJ3URYKKjDT/CWGLu',1,'2025-11-20 07:55:19'),(5,'유저1','user1@example.com','user1','$2b$10$X30C9ZTvrPCJJfJLY.f2rusGKFMstt0DDaiSCHpmIGCq/CevEXAi6',0,'2025-11-25 06:21:47'),(6,'유저2','user2@example.com','user2','$2b$10$.X/gSVjEjExFPeDEiZcjIuqtFT6SoEO2tomRT85PU9LOyqb8l.Iem',0,'2025-11-25 06:22:09'),(7,'유저3','user3@example.com','user3','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(8,'유저4','user4@example.com','user4','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(9,'유저5','user5@example.com','user5','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(10,'유저6','user6@example.com','user6','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(11,'유저7','user7@example.com','user7','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(12,'유저8','user8@example.com','user8','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(13,'유저9','user9@example.com','user9','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(14,'유저10','user10@example.com','user10','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(15,'유저11','user11@example.com','user11','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(16,'유저12','user12@example.com','user12','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(17,'유저13','user13@example.com','user13','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(18,'유저14','user14@example.com','user14','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(19,'유저15','user15@example.com','user15','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(20,'유저16','user16@example.com','user16','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(21,'유저17','user17@example.com','user17','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(22,'유저18','user18@example.com','user18','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(23,'유저19','user19@example.com','user19','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(24,'유저20','user20@example.com','user20','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(25,'유저21','user21@example.com','user21','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(26,'유저22','user22@example.com','user22','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(27,'유저23','user23@example.com','user23','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(28,'유저24','user24@example.com','user24','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(29,'유저25','user25@example.com','user25','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(30,'유저26','user26@example.com','user26','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(31,'유저27','user27@example.com','user27','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(32,'유저28','user28@example.com','user28','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(33,'유저29','user29@example.com','user29','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(34,'유저30','user30@example.com','user30','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(35,'유저31','user31@example.com','user31','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(36,'유저32','user32@example.com','user32','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(37,'유저33','user33@example.com','user33','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(38,'유저34','user34@example.com','user34','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(39,'유저35','user35@example.com','user35','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(40,'유저36','user36@example.com','user36','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(41,'유저37','user37@example.com','user37','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(42,'유저38','user38@example.com','user38','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(43,'유저39','user39@example.com','user39','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(44,'유저40','user40@example.com','user40','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(45,'유저41','user41@example.com','user41','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(46,'유저42','user42@example.com','user42','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(47,'유저43','user43@example.com','user43','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(48,'유저44','user44@example.com','user44','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(49,'유저45','user45@example.com','user45','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(50,'유저46','user46@example.com','user46','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(51,'유저47','user47@example.com','user47','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(52,'유저48','user48@example.com','user48','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(53,'유저49','user49@example.com','user49','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(54,'유저50','user50@example.com','user50','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(55,'유저51','user51@example.com','user51','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(56,'유저52','user52@example.com','user52','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(57,'유저53','user53@example.com','user53','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(58,'유저54','user54@example.com','user54','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(59,'유저55','user55@example.com','user55','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(60,'유저56','user56@example.com','user56','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(61,'유저57','user57@example.com','user57','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(62,'유저58','user58@example.com','user58','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(63,'유저59','user59@example.com','user59','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(64,'유저60','user60@example.com','user60','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(65,'유저61','user61@example.com','user61','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(66,'유저62','user62@example.com','user62','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(67,'유저63','user63@example.com','user63','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(68,'유저64','user64@example.com','user64','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(69,'유저65','user65@example.com','user65','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(70,'유저66','user66@example.com','user66','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(71,'유저67','user67@example.com','user67','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(72,'유저68','user68@example.com','user68','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(73,'유저69','user69@example.com','user69','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(74,'유저70','user70@example.com','user70','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(75,'유저71','user71@example.com','user71','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(76,'유저72','user72@example.com','user72','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(77,'유저73','user73@example.com','user73','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(78,'유저74','user74@example.com','user74','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(79,'유저75','user75@example.com','user75','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(80,'유저76','user76@example.com','user76','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(81,'유저77','user77@example.com','user77','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(82,'유저78','user78@example.com','user78','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(83,'유저79','user79@example.com','user79','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(84,'유저80','user80@example.com','user80','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(85,'유저81','user81@example.com','user81','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(86,'유저82','user82@example.com','user82','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(87,'유저83','user83@example.com','user83','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(88,'유저84','user84@example.com','user84','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(89,'유저85','user85@example.com','user85','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(90,'유저86','user86@example.com','user86','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(91,'유저87','user87@example.com','user87','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(92,'유저88','user88@example.com','user88','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(93,'유저89','user89@example.com','user89','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(94,'유저90','user90@example.com','user90','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(95,'유저91','user91@example.com','user91','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(96,'유저92','user92@example.com','user92','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(97,'유저93','user93@example.com','user93','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(98,'유저94','user94@example.com','user94','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(99,'유저95','user95@example.com','user95','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(100,'유저96','user96@example.com','user96','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(101,'유저97','user97@example.com','user97','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(102,'유저98','user98@example.com','user98','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(103,'유저99','user99@example.com','user99','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41'),(104,'유저100','user100@example.com','user100','$2b$10$CMy0oyfR5PjHdjf37UfCZ.kXMDgbqFs8x5br2xpHfi5btjQJq8wUK',0,'2025-11-28 02:33:41');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-01  4:20:54
