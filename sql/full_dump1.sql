-- MySQL dump 10.13  Distrib 9.5.0, for Win64 (x86_64)
--
-- Host: localhost    Database: restaurant_db
-- ------------------------------------------------------
-- Server version	9.5.0

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
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '42d3a6ef-f4fb-11f0-92c6-6c0b5e6d6e55:1-1104';

--
-- Table structure for table `areas`
--

DROP TABLE IF EXISTS `areas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `areas` (
  `area_id` int NOT NULL AUTO_INCREMENT,
  `area_name` varchar(150) NOT NULL,
  `city_id` int NOT NULL,
  PRIMARY KEY (`area_id`),
  KEY `city_id` (`city_id`),
  CONSTRAINT `areas_ibfk_1` FOREIGN KEY (`city_id`) REFERENCES `cities` (`city_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `areas`
--

LOCK TABLES `areas` WRITE;
/*!40000 ALTER TABLE `areas` DISABLE KEYS */;
INSERT INTO `areas` VALUES (1,'Tiger Circle',1),(2,'MIT Road',1),(3,'KMC Campus Road',1),(4,'End Point Road',1),(5,'Manipal Town Centre',1),(6,'TMA Pai Park area',1);
/*!40000 ALTER TABLE `areas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookmarks`
--

DROP TABLE IF EXISTS `bookmarks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookmarks` (
  `bookmark_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `restaurant_id` int NOT NULL,
  `bookmarked_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`bookmark_id`),
  UNIQUE KEY `uq_bookmark` (`user_id`,`restaurant_id`),
  KEY `restaurant_id` (`restaurant_id`),
  CONSTRAINT `bookmarks_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `bookmarks_ibfk_2` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`restaurant_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookmarks`
--

LOCK TABLES `bookmarks` WRITE;
/*!40000 ALTER TABLE `bookmarks` DISABLE KEYS */;
INSERT INTO `bookmarks` VALUES (1,3,1,'2026-03-29 23:40:03'),(2,3,5,'2026-03-29 23:40:03'),(3,3,9,'2026-03-29 23:40:03'),(4,4,7,'2026-03-29 23:40:03'),(5,4,9,'2026-03-29 23:40:03'),(6,4,6,'2026-03-29 23:40:03'),(7,5,3,'2026-03-29 23:40:03'),(8,5,2,'2026-03-29 23:40:03'),(9,5,8,'2026-03-29 23:40:03'),(10,6,9,'2026-03-29 23:40:03'),(11,6,7,'2026-03-29 23:40:03'),(12,6,5,'2026-03-29 23:40:03'),(13,7,4,'2026-03-29 23:40:03'),(14,7,8,'2026-03-29 23:40:03'),(15,7,9,'2026-03-29 23:40:03');
/*!40000 ALTER TABLE `bookmarks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category_ratings`
--

DROP TABLE IF EXISTS `category_ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category_ratings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `review_id` int NOT NULL,
  `rating_cat_id` int NOT NULL,
  `score` decimal(2,1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_review_cat` (`review_id`,`rating_cat_id`),
  KEY `rating_cat_id` (`rating_cat_id`),
  CONSTRAINT `category_ratings_ibfk_1` FOREIGN KEY (`review_id`) REFERENCES `reviews` (`review_id`) ON DELETE CASCADE,
  CONSTRAINT `category_ratings_ibfk_2` FOREIGN KEY (`rating_cat_id`) REFERENCES `rating_categories` (`rating_cat_id`),
  CONSTRAINT `category_ratings_chk_1` CHECK ((`score` between 1.0 and 5.0))
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category_ratings`
--

LOCK TABLES `category_ratings` WRITE;
/*!40000 ALTER TABLE `category_ratings` DISABLE KEYS */;
INSERT INTO `category_ratings` VALUES (1,1,1,4.5),(2,1,3,4.0),(3,1,4,5.0),(8,4,1,4.5),(9,4,2,4.5),(10,4,3,4.0),(11,4,4,4.5),(12,5,1,4.0),(13,5,3,5.0),(14,5,4,4.0),(15,6,1,5.0),(16,6,2,5.0),(17,6,3,4.5),(18,6,4,4.5),(19,8,1,5.0),(20,8,2,4.5),(21,8,3,4.0),(22,8,4,4.5),(23,10,1,5.0),(24,10,2,5.0),(25,10,3,5.0),(26,10,4,4.5);
/*!40000 ALTER TABLE `category_ratings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cities`
--

DROP TABLE IF EXISTS `cities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cities` (
  `city_id` int NOT NULL AUTO_INCREMENT,
  `city_name` varchar(100) NOT NULL,
  `state` varchar(100) NOT NULL,
  `pincode` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`city_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cities`
--

LOCK TABLES `cities` WRITE;
/*!40000 ALTER TABLE `cities` DISABLE KEYS */;
INSERT INTO `cities` VALUES (1,'Manipal','Karnataka','576104');
/*!40000 ALTER TABLE `cities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cuisines`
--

DROP TABLE IF EXISTS `cuisines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cuisines` (
  `cuisine_id` int NOT NULL AUTO_INCREMENT,
  `cuisine_name` varchar(100) NOT NULL,
  `description` text,
  PRIMARY KEY (`cuisine_id`),
  UNIQUE KEY `cuisine_name` (`cuisine_name`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cuisines`
--

LOCK TABLES `cuisines` WRITE;
/*!40000 ALTER TABLE `cuisines` DISABLE KEYS */;
INSERT INTO `cuisines` VALUES (1,'South Indian','Dosas, idlis, rice dishes and tiffin from South India'),(2,'North Indian','Curries, rotis, dals and gravies from North India'),(3,'Chinese','Indo-Chinese food popular in Indian college towns'),(4,'Continental','Western style pastas, grills, sandwiches and salads'),(5,'Fast Food','Burgers, fries, ice creams and quick street bites'),(6,'Japanese','Sushi, ramen, teriyaki and Asian fusion dishes'),(7,'Italian','Pastas, pizzas, risottos and wood-fired dishes'),(8,'Middle Eastern','Shawarmas, hummus, falafels and grilled meats'),(9,'Pan Asian','Mix of Chinese, Thai, Vietnamese and Japanese flavours');
/*!40000 ALTER TABLE `cuisines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dietary_tags`
--

DROP TABLE IF EXISTS `dietary_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dietary_tags` (
  `tag_id` int NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(50) NOT NULL,
  PRIMARY KEY (`tag_id`),
  UNIQUE KEY `tag_name` (`tag_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dietary_tags`
--

LOCK TABLES `dietary_tags` WRITE;
/*!40000 ALTER TABLE `dietary_tags` DISABLE KEYS */;
INSERT INTO `dietary_tags` VALUES (4,'Gluten-Free'),(3,'Halal'),(5,'Jain'),(1,'Vegan'),(2,'Vegetarian');
/*!40000 ALTER TABLE `dietary_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `events` (
  `event_id` int NOT NULL AUTO_INCREMENT,
  `restaurant_id` int NOT NULL,
  `event_name` varchar(200) NOT NULL,
  `description` text,
  `event_date` datetime NOT NULL,
  `capacity` int DEFAULT NULL,
  `entry_fee` decimal(8,2) DEFAULT '0.00',
  PRIMARY KEY (`event_id`),
  KEY `restaurant_id` (`restaurant_id`),
  CONSTRAINT `events_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`restaurant_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
INSERT INTO `events` VALUES (1,4,'Sunset Acoustic Night','Live acoustic music on the rooftop as the sun sets. Open to all.','2025-02-14 18:00:00',40,0.00),(2,8,'Laughing Buddha Quiz Night','Weekly pub quiz night with prizes! Teams of up to 4 people.','2025-02-20 19:00:00',60,100.00),(3,9,'Middle Eastern Food Fest','A special extended menu celebrating Middle Eastern cuisine for one weekend.','2025-03-01 12:00:00',80,0.00),(4,7,'Pizza Making Workshop','Learn to make authentic wood-fired pizza from the head chef. Slots limited.','2025-03-08 15:00:00',15,500.00);
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu_categories`
--

DROP TABLE IF EXISTS `menu_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu_categories` (
  `menu_cat_id` int NOT NULL AUTO_INCREMENT,
  `restaurant_id` int NOT NULL,
  `category_name` varchar(100) NOT NULL,
  `display_order` int DEFAULT '0',
  PRIMARY KEY (`menu_cat_id`),
  KEY `restaurant_id` (`restaurant_id`),
  CONSTRAINT `menu_categories_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`restaurant_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu_categories`
--

LOCK TABLES `menu_categories` WRITE;
/*!40000 ALTER TABLE `menu_categories` DISABLE KEYS */;
INSERT INTO `menu_categories` VALUES (1,1,'Ice Creams',1),(2,1,'Shakes',2),(3,1,'Snacks',3),(4,2,'Sandwiches',1),(5,2,'Shakes and Coffees',2),(6,2,'Mains',3),(7,3,'Starters',1),(8,3,'Mains',2),(9,3,'Desserts',3),(10,5,'Ramen',1),(11,5,'Sushi',2),(12,5,'Sides',3),(13,6,'Breads',1),(14,6,'Curries',2),(15,6,'Rice',3),(16,7,'Pizzas',1),(17,7,'Pastas',2),(18,8,'Small Plates',1),(19,8,'Mains',2),(20,8,'Drinks',3),(21,9,'Mezze and Starters',1),(22,9,'Grills and Mains',2),(23,9,'Desserts',3),(24,10,'Dosa',1),(25,10,'Beverages',2),(26,11,'Pastas',1);
/*!40000 ALTER TABLE `menu_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu_item_tags`
--

DROP TABLE IF EXISTS `menu_item_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu_item_tags` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item_id` int NOT NULL,
  `tag_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_item_tag` (`item_id`,`tag_id`),
  KEY `tag_id` (`tag_id`),
  CONSTRAINT `menu_item_tags_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `menu_items` (`item_id`) ON DELETE CASCADE,
  CONSTRAINT `menu_item_tags_ibfk_2` FOREIGN KEY (`tag_id`) REFERENCES `dietary_tags` (`tag_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu_item_tags`
--

LOCK TABLES `menu_item_tags` WRITE;
/*!40000 ALTER TABLE `menu_item_tags` DISABLE KEYS */;
INSERT INTO `menu_item_tags` VALUES (1,1,2),(2,2,2),(3,3,2),(4,4,2),(5,5,2),(6,6,2),(7,7,2),(8,9,2),(9,10,2),(10,11,2),(11,12,2),(12,15,2),(13,16,2),(14,21,2),(15,22,2),(16,24,2),(17,25,2),(18,26,2),(19,27,2),(20,29,2),(21,30,2),(22,32,2),(23,35,2),(24,36,2),(25,38,2),(26,42,2),(27,43,2),(28,44,2);
/*!40000 ALTER TABLE `menu_item_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu_items`
--

DROP TABLE IF EXISTS `menu_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu_items` (
  `item_id` int NOT NULL AUTO_INCREMENT,
  `menu_cat_id` int NOT NULL,
  `restaurant_id` int NOT NULL,
  `item_name` varchar(200) NOT NULL,
  `description` text,
  `price` decimal(8,2) NOT NULL,
  `is_vegetarian` tinyint(1) DEFAULT '0',
  `is_available` tinyint(1) DEFAULT '1',
  `spice_level` enum('None','Mild','Medium','Hot','Extra Hot') DEFAULT 'None',
  PRIMARY KEY (`item_id`),
  KEY `menu_cat_id` (`menu_cat_id`),
  KEY `restaurant_id` (`restaurant_id`),
  KEY `idx_menu_price` (`price`),
  KEY `idx_menu_veg` (`is_vegetarian`),
  CONSTRAINT `menu_items_ibfk_1` FOREIGN KEY (`menu_cat_id`) REFERENCES `menu_categories` (`menu_cat_id`) ON DELETE CASCADE,
  CONSTRAINT `menu_items_ibfk_2` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`restaurant_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu_items`
--

LOCK TABLES `menu_items` WRITE;
/*!40000 ALTER TABLE `menu_items` DISABLE KEYS */;
INSERT INTO `menu_items` VALUES (1,1,1,'Butterscotch Cone',NULL,40.00,1,1,'None'),(2,1,1,'Chocolate Sundae',NULL,80.00,1,1,'None'),(3,1,1,'Strawberry Scoop',NULL,50.00,1,1,'None'),(4,2,1,'Mango Shake',NULL,70.00,1,1,'None'),(5,2,1,'Oreo Shake',NULL,90.00,1,1,'None'),(6,3,1,'Samosa (2 pcs)',NULL,30.00,1,1,'Mild'),(7,3,1,'Bread Pakora',NULL,40.00,1,1,'Mild'),(8,4,2,'Club Sandwich',NULL,130.00,0,1,'None'),(9,4,2,'Veg Sandwich',NULL,100.00,1,1,'None'),(10,5,2,'Cold Coffee',NULL,80.00,1,1,'None'),(11,5,2,'Nutella Shake',NULL,110.00,1,1,'None'),(12,6,2,'Pasta Arrabiata',NULL,180.00,1,1,'Medium'),(13,6,2,'Chicken Pasta',NULL,220.00,0,1,'Medium'),(14,7,3,'Garlic Bread',NULL,90.00,1,1,'None'),(15,7,3,'Chicken Wings',NULL,220.00,0,1,'Hot'),(16,8,3,'Veg Pasta',NULL,200.00,1,1,'Mild'),(17,8,3,'DTR Special Burger',NULL,250.00,0,1,'Medium'),(18,8,3,'Grilled Chicken Sandwich',NULL,230.00,0,1,'Mild'),(19,9,3,'Brownie with Ice Cream',NULL,150.00,1,1,'None'),(20,10,5,'Chicken Ramen',NULL,350.00,0,1,'Medium'),(21,10,5,'Veg Ramen',NULL,300.00,1,1,'Mild'),(22,11,5,'Sushi Platter (8 pcs)',NULL,420.00,0,1,'None'),(23,11,5,'Avocado Maki (6 pcs)',NULL,280.00,1,1,'None'),(24,12,5,'Edamame',NULL,120.00,1,1,'None'),(25,13,6,'Butter Naan',NULL,40.00,1,1,'None'),(26,13,6,'Garlic Naan',NULL,50.00,1,1,'None'),(27,14,6,'Dal Makhani',NULL,180.00,1,1,'Mild'),(28,14,6,'Paneer Butter Masala',NULL,220.00,1,1,'Mild'),(29,14,6,'Chicken Tikka Masala',NULL,260.00,0,1,'Medium'),(30,15,6,'Jeera Rice',NULL,120.00,1,1,'None'),(31,15,6,'Chicken Biryani',NULL,240.00,0,1,'Hot'),(32,16,7,'Margherita Pizza',NULL,320.00,1,1,'None'),(33,16,7,'Pepperoni Pizza',NULL,400.00,0,1,'Mild'),(34,16,7,'BBQ Chicken Pizza',NULL,420.00,0,1,'Medium'),(35,17,7,'Spaghetti Aglio e Olio',NULL,280.00,1,1,'Mild'),(36,17,7,'Penne Arrabbiata',NULL,260.00,1,1,'Medium'),(37,17,7,'Chicken Alfredo',NULL,340.00,0,1,'None'),(38,18,8,'Veg Dimsums (6 pcs)',NULL,180.00,1,1,'Mild'),(39,18,8,'Chicken Dimsums (6 pcs)',NULL,210.00,0,1,'Mild'),(40,19,8,'Thai Green Curry',NULL,280.00,0,1,'Hot'),(41,19,8,'Pad Thai Noodles',NULL,260.00,0,1,'Medium'),(42,19,8,'Veg Fried Rice',NULL,200.00,1,1,'Mild'),(43,20,8,'Virgin Mojito',NULL,120.00,1,1,'None'),(44,20,8,'Watermelon Cooler',NULL,110.00,1,1,'None'),(45,21,9,'Hummus with Pita',NULL,200.00,1,1,'None'),(46,21,9,'Falafel Platter',NULL,220.00,1,1,'None'),(47,22,9,'Chicken Shawarma Platter',NULL,380.00,0,1,'Medium'),(48,22,9,'Grilled Lamb Chops',NULL,520.00,0,1,'Mild'),(49,22,9,'Paneer Tikka',NULL,300.00,1,1,'Medium'),(50,23,9,'Baklava',NULL,180.00,1,1,'None'),(51,23,9,'Kunafa',NULL,220.00,1,1,'None'),(52,24,10,'Idli (2 pcs)',NULL,60.00,1,1,'None'),(53,24,10,'Vada (2 pcs)',NULL,55.00,1,1,'Mild'),(54,24,10,'Masala Dosa',NULL,85.00,1,1,'Mild'),(55,24,10,'Plain Dosa',NULL,50.00,1,1,'None'),(56,24,10,'Rava Idli',NULL,70.00,1,1,'None'),(57,24,10,'Podi Dosa',NULL,95.00,1,1,'Medium'),(58,25,10,'Filter Coffee',NULL,25.00,1,1,'None'),(59,25,10,'Masala Chai',NULL,20.00,1,1,'None'),(60,26,11,'Pesto Pasta',NULL,320.00,1,1,'Mild');
/*!40000 ALTER TABLE `menu_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `notif_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `type` varchar(100) NOT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`notif_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (1,3,'offer_alert','Dollops has a student discount! Show your MAHE ID and get 10% off. Use code MAHE10.',0,'2026-03-29 23:40:03'),(2,4,'offer_alert','Vito\'s has a Friday pizza deal! 15% off every Friday evening. Use code VITOFRI.',0,'2026-03-29 23:40:03'),(3,5,'new_review','Someone marked your review of Eye of the Tiger as helpful!',1,'2026-03-29 23:40:03'),(4,6,'offer_alert','Hadiqa has a couples discount this weekend. Use code HADDATE when you book.',0,'2026-03-29 23:40:03'),(5,7,'event_alert','Laughing Buddha Quiz Night is happening on Feb 20! Register your team now.',0,'2026-03-29 23:40:03'),(6,3,'event_alert','Pizza Making Workshop at Vito\'s on March 8! Only 15 slots. Book fast.',0,'2026-03-29 23:40:03');
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `offers`
--

DROP TABLE IF EXISTS `offers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `offers` (
  `offer_id` int NOT NULL AUTO_INCREMENT,
  `restaurant_id` int NOT NULL,
  `offer_title` varchar(200) NOT NULL,
  `description` text,
  `discount_pct` decimal(5,2) DEFAULT NULL,
  `valid_from` date NOT NULL,
  `valid_until` date NOT NULL,
  `promo_code` varchar(50) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`offer_id`),
  KEY `restaurant_id` (`restaurant_id`),
  CONSTRAINT `offers_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`restaurant_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `offers`
--

LOCK TABLES `offers` WRITE;
/*!40000 ALTER TABLE `offers` DISABLE KEYS */;
INSERT INTO `offers` VALUES (1,1,'Student Cone Deal','10% off for MAHE students on showing college ID',10.00,'2025-01-01','2025-06-30','MAHE10',1),(2,3,'DTR Happy Hours','Buy any main course and get a mocktail for free between 3-5pm',NULL,'2025-01-01','2025-03-31','DTRHAPPY',1),(3,6,'Tawa Combo Offer','Naan + Dal Makhani + Jeera Rice combo at Rs 300 flat',NULL,'2025-01-01','2025-04-30','TAWAMEAL',1),(4,7,'Pizza Night Friday','15% off on all pizzas every Friday evening',15.00,'2025-01-01','2025-03-31','VITOFRI',1),(5,9,'Hadiqa Date Night','10% off for couples on weekends, mention at booking',10.00,'2025-01-01','2025-03-31','HADDATE',1);
/*!40000 ALTER TABLE `offers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rating_categories`
--

DROP TABLE IF EXISTS `rating_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rating_categories` (
  `rating_cat_id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(100) NOT NULL,
  PRIMARY KEY (`rating_cat_id`),
  UNIQUE KEY `category_name` (`category_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rating_categories`
--

LOCK TABLES `rating_categories` WRITE;
/*!40000 ALTER TABLE `rating_categories` DISABLE KEYS */;
INSERT INTO `rating_categories` VALUES (3,'Ambiance'),(5,'Cleanliness'),(1,'Food Quality'),(2,'Service'),(4,'Value for Money');
/*!40000 ALTER TABLE `rating_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reports`
--

DROP TABLE IF EXISTS `reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reports` (
  `report_id` int NOT NULL AUTO_INCREMENT,
  `reporter_id` int NOT NULL,
  `target_type` enum('review','restaurant','user') NOT NULL,
  `target_id` int NOT NULL,
  `reason` varchar(200) NOT NULL,
  `status` enum('open','reviewed','resolved') DEFAULT 'open',
  `reported_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`report_id`),
  KEY `reporter_id` (`reporter_id`),
  CONSTRAINT `reports_ibfk_1` FOREIGN KEY (`reporter_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reports`
--

LOCK TABLES `reports` WRITE;
/*!40000 ALTER TABLE `reports` DISABLE KEYS */;
INSERT INTO `reports` VALUES (1,5,'review',2,'This review looks fake, the details mentioned do not match the actual menu at Dollops','open','2026-03-29 23:40:03'),(2,3,'review',9,'Spam content, same review copy pasted across multiple restaurants','resolved','2026-03-29 23:40:03');
/*!40000 ALTER TABLE `reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restaurant_amenities`
--

DROP TABLE IF EXISTS `restaurant_amenities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurant_amenities` (
  `amenity_id` int NOT NULL AUTO_INCREMENT,
  `restaurant_id` int NOT NULL,
  `has_wifi` tinyint(1) DEFAULT '0',
  `has_parking` tinyint(1) DEFAULT '0',
  `has_ac` tinyint(1) DEFAULT '0',
  `accepts_cards` tinyint(1) DEFAULT '0',
  `home_delivery` tinyint(1) DEFAULT '0',
  `takeaway` tinyint(1) DEFAULT '0',
  `pet_friendly` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`amenity_id`),
  UNIQUE KEY `restaurant_id` (`restaurant_id`),
  CONSTRAINT `restaurant_amenities_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`restaurant_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurant_amenities`
--

LOCK TABLES `restaurant_amenities` WRITE;
/*!40000 ALTER TABLE `restaurant_amenities` DISABLE KEYS */;
INSERT INTO `restaurant_amenities` VALUES (1,1,0,0,1,1,0,1,0),(2,2,1,0,1,1,0,1,0),(3,3,1,0,1,1,1,1,0),(4,4,1,1,1,1,0,1,1),(5,5,1,0,1,1,0,1,0),(6,6,0,1,1,1,1,1,0),(7,7,1,0,1,1,1,1,0),(8,8,1,1,1,1,0,1,0),(9,9,1,1,1,1,0,1,1),(10,10,0,0,1,0,0,1,0);
/*!40000 ALTER TABLE `restaurant_amenities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restaurant_categories`
--

DROP TABLE IF EXISTS `restaurant_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurant_categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(100) NOT NULL,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `category_name` (`category_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurant_categories`
--

LOCK TABLES `restaurant_categories` WRITE;
/*!40000 ALTER TABLE `restaurant_categories` DISABLE KEYS */;
INSERT INTO `restaurant_categories` VALUES (4,'Bar and Restaurant'),(2,'Cafe'),(1,'Casual Dining'),(3,'Fast Food'),(5,'Fine Dining');
/*!40000 ALTER TABLE `restaurant_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restaurant_contacts`
--

DROP TABLE IF EXISTS `restaurant_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurant_contacts` (
  `contact_id` int NOT NULL AUTO_INCREMENT,
  `restaurant_id` int NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `website` varchar(300) DEFAULT NULL,
  `instagram` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`contact_id`),
  UNIQUE KEY `restaurant_id` (`restaurant_id`),
  CONSTRAINT `restaurant_contacts_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`restaurant_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurant_contacts`
--

LOCK TABLES `restaurant_contacts` WRITE;
/*!40000 ALTER TABLE `restaurant_contacts` DISABLE KEYS */;
INSERT INTO `restaurant_contacts` VALUES (1,1,'9876543210','dollops.manipal@gmail.com',NULL,'@dollops_manipal'),(2,2,'9845011111','eyeofthetiger.mpl@gmail.com',NULL,'@eyeofthetiger_manipal'),(3,3,'9845022222','dtr.manipal@gmail.com',NULL,'@dtr_manipal'),(4,4,'9741234567','hakunamatata.mpl@gmail.com',NULL,'@hakunamatata_manipal'),(5,5,'9632145678','kyoto.manipal@gmail.com',NULL,'@kyoto_manipal'),(6,6,'9512367890','tawapunjab.mpl@gmail.com',NULL,'@tawapunjab_manipal'),(7,7,'9481234567','vitos.manipal@gmail.com',NULL,'@vitos_manipal'),(8,8,'9371234567','laughingbuddha.mpl@gmail.com',NULL,'@laughingbuddha_manipal'),(9,9,'9261234567','hadiqa.manipal@gmail.com',NULL,'@hadiqa_manipal'),(10,10,'0820-2571234',NULL,NULL,NULL);
/*!40000 ALTER TABLE `restaurant_contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restaurant_cuisines`
--

DROP TABLE IF EXISTS `restaurant_cuisines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurant_cuisines` (
  `id` int NOT NULL AUTO_INCREMENT,
  `restaurant_id` int NOT NULL,
  `cuisine_id` int NOT NULL,
  `is_primary` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_rest_cuisine` (`restaurant_id`,`cuisine_id`),
  KEY `cuisine_id` (`cuisine_id`),
  CONSTRAINT `restaurant_cuisines_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`restaurant_id`) ON DELETE CASCADE,
  CONSTRAINT `restaurant_cuisines_ibfk_2` FOREIGN KEY (`cuisine_id`) REFERENCES `cuisines` (`cuisine_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurant_cuisines`
--

LOCK TABLES `restaurant_cuisines` WRITE;
/*!40000 ALTER TABLE `restaurant_cuisines` DISABLE KEYS */;
INSERT INTO `restaurant_cuisines` VALUES (1,1,5,1),(2,2,4,1),(3,2,3,0),(4,3,4,1),(5,3,2,0),(6,4,4,1),(7,4,5,0),(8,5,6,1),(9,5,9,0),(10,6,2,1),(11,7,7,1),(12,8,9,1),(13,8,3,0),(14,9,8,1),(15,9,2,0),(16,10,1,1),(17,11,7,1);
/*!40000 ALTER TABLE `restaurant_cuisines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restaurant_hours`
--

DROP TABLE IF EXISTS `restaurant_hours`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurant_hours` (
  `hour_id` int NOT NULL AUTO_INCREMENT,
  `restaurant_id` int NOT NULL,
  `day_of_week` enum('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday') NOT NULL,
  `open_time` time DEFAULT NULL,
  `close_time` time DEFAULT NULL,
  `is_closed` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`hour_id`),
  UNIQUE KEY `uq_rest_day` (`restaurant_id`,`day_of_week`),
  CONSTRAINT `restaurant_hours_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`restaurant_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurant_hours`
--

LOCK TABLES `restaurant_hours` WRITE;
/*!40000 ALTER TABLE `restaurant_hours` DISABLE KEYS */;
INSERT INTO `restaurant_hours` VALUES (1,1,'Monday','10:00:00','22:30:00',0),(2,1,'Tuesday','10:00:00','22:30:00',0),(3,1,'Wednesday','10:00:00','22:30:00',0),(4,1,'Thursday','10:00:00','22:30:00',0),(5,1,'Friday','10:00:00','23:00:00',0),(6,1,'Saturday','10:00:00','23:00:00',0),(7,1,'Sunday','11:00:00','22:00:00',0),(8,2,'Monday','11:00:00','23:00:00',0),(9,2,'Tuesday','11:00:00','23:00:00',0),(10,2,'Wednesday','11:00:00','23:00:00',0),(11,2,'Thursday','11:00:00','23:00:00',0),(12,2,'Friday','11:00:00','23:30:00',0),(13,2,'Saturday','11:00:00','23:30:00',0),(14,2,'Sunday','12:00:00','22:00:00',0),(15,3,'Monday','12:00:00','23:00:00',0),(16,3,'Tuesday','12:00:00','23:00:00',0),(17,3,'Wednesday','12:00:00','23:00:00',0),(18,3,'Thursday','12:00:00','23:00:00',0),(19,3,'Friday','12:00:00','23:30:00',0),(20,3,'Saturday','11:00:00','23:30:00',0),(21,3,'Sunday','11:00:00','22:30:00',0),(22,5,'Monday','12:00:00','22:30:00',0),(23,5,'Tuesday','12:00:00','22:30:00',0),(24,5,'Wednesday','12:00:00','22:30:00',0),(25,5,'Thursday','12:00:00','22:30:00',0),(26,5,'Friday','12:00:00','23:00:00',0),(27,5,'Saturday','12:00:00','23:00:00',0),(28,5,'Sunday','13:00:00','22:00:00',0),(29,9,'Monday','12:00:00','23:00:00',0),(30,9,'Tuesday','12:00:00','23:00:00',0),(31,9,'Wednesday','12:00:00','23:00:00',0),(32,9,'Thursday','12:00:00','23:00:00',0),(33,9,'Friday','12:00:00','23:30:00',0),(34,9,'Saturday','11:00:00','23:30:00',0),(35,9,'Sunday','11:00:00','22:30:00',0);
/*!40000 ALTER TABLE `restaurant_hours` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restaurant_images`
--

DROP TABLE IF EXISTS `restaurant_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurant_images` (
  `image_id` int NOT NULL AUTO_INCREMENT,
  `restaurant_id` int NOT NULL,
  `image_url` varchar(500) NOT NULL,
  `caption` varchar(255) DEFAULT NULL,
  `is_cover` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`image_id`),
  KEY `restaurant_id` (`restaurant_id`),
  CONSTRAINT `restaurant_images_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`restaurant_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurant_images`
--

LOCK TABLES `restaurant_images` WRITE;
/*!40000 ALTER TABLE `restaurant_images` DISABLE KEYS */;
/*!40000 ALTER TABLE `restaurant_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restaurants`
--

DROP TABLE IF EXISTS `restaurants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurants` (
  `restaurant_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `description` text,
  `category_id` int DEFAULT NULL,
  `area_id` int DEFAULT NULL,
  `latitude` decimal(10,8) NOT NULL,
  `longitude` decimal(11,8) NOT NULL,
  `price_range` varchar(20) DEFAULT NULL,
  `avg_rating` decimal(3,2) DEFAULT '0.00',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`restaurant_id`),
  KEY `category_id` (`category_id`),
  KEY `area_id` (`area_id`),
  KEY `idx_location` (`latitude`,`longitude`),
  KEY `idx_rating` (`avg_rating` DESC),
  KEY `idx_price` (`price_range`),
  CONSTRAINT `restaurants_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `restaurant_categories` (`category_id`),
  CONSTRAINT `restaurants_ibfk_2` FOREIGN KEY (`area_id`) REFERENCES `areas` (`area_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurants`
--

LOCK TABLES `restaurants` WRITE;
/*!40000 ALTER TABLE `restaurants` DISABLE KEYS */;
INSERT INTO `restaurants` VALUES (1,'Dollops','Iconic Manipal ice cream and snack spot, every student knows this place',3,1,13.35180000,74.78690000,'Rs (0-450)',4.25,1,'2026-03-29 23:40:03'),(2,'Eye of the Tiger','Chilled out cafe with great shakes, sandwiches and a cosy vibe',2,2,13.35155000,74.78758000,'Rs (800+)',4.95,1,'2026-03-29 23:40:03'),(3,'The Mill','The Mill in Manipal is a well-known restaurant popular for its flavorful North Indian cuisine, offering dishes like rich curries, tandoori items, and freshly made breads. With a cozy ambiance and a laid-back vibe, it?s a favorite spot among students for hearty meals and casual dining.',1,2,13.35424000,74.79212000,'Rs (450-800)',3.87,1,'2026-03-29 23:40:03'),(4,'Hakuna Matata','Relaxed rooftop cafe, perfect for unwinding after exams',2,4,13.34740000,74.78920000,'Rs (450-800)',3.20,1,'2026-03-29 23:40:03'),(5,'Kyoto','Best Japanese and Pan Asian food in Manipal, great ramen and sushi',1,1,13.34690000,74.78900000,'Rs (800+)',4.30,1,'2026-03-29 23:40:03'),(6,'Tawa Punjab','Authentic North Indian food, famous for their butter naan and paneer dishes',1,5,13.34450000,74.78600000,'Rs (450-800)',4.60,1,'2026-03-29 23:40:03'),(7,'Vito\'s','Wood-fired pizzas and creamy pastas, the most Italian experience in Manipal',1,3,13.35300000,74.78820000,'Rs (800+)',4.45,1,'2026-03-29 23:40:03'),(8,'Laughing Buddha','Popular bar and restaurant with great Pan Asian food and a fun atmosphere',4,1,13.33980000,74.75460000,'Rs (450-800)',4.00,1,'2026-03-29 23:40:03'),(9,'Hadiqa','Beautiful garden restaurant serving Middle Eastern and North Indian cuisine',1,5,13.34790000,74.78850000,'Rs (800+)',4.50,1,'2026-03-29 23:40:03'),(10,'Pai Tiffins','Authentic South Indian tiffin centre famous for different varieties of dosa. A Manipal classic.',2,1,13.35286000,74.78985000,'Rs (0-450)',4.30,1,'2026-03-30 00:40:57'),(11,'Terra Haus','A newly opened restaurant with a really aesthetic vibe',2,6,13.35057000,74.78715000,'Rs (450-800)',4.50,1,'2026-04-08 14:17:34');
/*!40000 ALTER TABLE `restaurants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_responses`
--

DROP TABLE IF EXISTS `review_responses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review_responses` (
  `response_id` int NOT NULL AUTO_INCREMENT,
  `review_id` int NOT NULL,
  `restaurant_id` int NOT NULL,
  `response_text` text NOT NULL,
  `responded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`response_id`),
  UNIQUE KEY `review_id` (`review_id`),
  KEY `restaurant_id` (`restaurant_id`),
  CONSTRAINT `review_responses_ibfk_1` FOREIGN KEY (`review_id`) REFERENCES `reviews` (`review_id`) ON DELETE CASCADE,
  CONSTRAINT `review_responses_ibfk_2` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`restaurant_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_responses`
--

LOCK TABLES `review_responses` WRITE;
/*!40000 ALTER TABLE `review_responses` DISABLE KEYS */;
INSERT INTO `review_responses` VALUES (2,6,5,'So glad you enjoyed it! We put a lot of effort into our ramen broth so this means a lot. See you again soon!','2026-03-29 23:40:03'),(3,9,8,'Thank you! Weekends do get busy but that energy is what makes Laughing Buddha special. Hope to see you again!','2026-03-29 23:40:03');
/*!40000 ALTER TABLE `review_responses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_votes`
--

DROP TABLE IF EXISTS `review_votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review_votes` (
  `vote_id` int NOT NULL AUTO_INCREMENT,
  `review_id` int NOT NULL,
  `user_id` int NOT NULL,
  `vote_type` enum('helpful','not_helpful') NOT NULL,
  `voted_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`vote_id`),
  UNIQUE KEY `uq_vote` (`review_id`,`user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `review_votes_ibfk_1` FOREIGN KEY (`review_id`) REFERENCES `reviews` (`review_id`) ON DELETE CASCADE,
  CONSTRAINT `review_votes_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_votes`
--

LOCK TABLES `review_votes` WRITE;
/*!40000 ALTER TABLE `review_votes` DISABLE KEYS */;
INSERT INTO `review_votes` VALUES (1,6,3,'helpful','2026-03-29 23:40:03'),(2,6,4,'helpful','2026-03-29 23:40:03'),(3,6,7,'helpful','2026-03-29 23:40:03'),(4,8,5,'helpful','2026-03-29 23:40:03'),(5,8,6,'helpful','2026-03-29 23:40:03'),(6,10,3,'helpful','2026-03-29 23:40:03'),(7,10,4,'helpful','2026-03-29 23:40:03'),(8,1,6,'helpful','2026-03-29 23:40:03');
/*!40000 ALTER TABLE `review_votes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `review_id` int NOT NULL AUTO_INCREMENT,
  `restaurant_id` int NOT NULL,
  `user_id` int NOT NULL,
  `rating` decimal(2,1) NOT NULL,
  `title` varchar(200) DEFAULT NULL,
  `body` text,
  `visit_date` date DEFAULT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'approved',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`review_id`),
  UNIQUE KEY `uq_user_restaurant` (`user_id`,`restaurant_id`),
  KEY `restaurant_id` (`restaurant_id`),
  KEY `idx_review_rating` (`rating`),
  KEY `idx_reviews_user` (`user_id`,`created_at` DESC),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`restaurant_id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_chk_1` CHECK ((`rating` between 1.0 and 5.0))
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (1,1,3,4.5,'Dollops is Manipal','No matter how many times you go, Dollops never gets old. The butterscotch cone for Rs 40 is unbeatable. Mandatory stop after every exam.','2024-10-05','approved','2026-03-29 23:40:03'),(2,1,4,4.0,'Classic Manipal experience','If you haven\'t been to Dollops you haven\'t been to Manipal. Simple as that. Always crowded but always worth it.','2024-10-12','approved','2026-03-29 23:40:03'),(4,3,6,4.5,'DTR is everyone\'s second home','Every Manipal student ends up at DTR eventually. The pasta is great and the portions are huge for the price. Perfect for group hangouts.','2024-11-01','approved','2026-03-29 23:40:03'),(5,4,7,4.0,'Rooftop views are everything','Hakuna Matata is so peaceful, especially in the evenings. The shakes are really good and the vibe is very chill. Great place to decompress.','2024-11-08','approved','2026-03-29 23:40:03'),(6,5,3,5.0,'Kyoto is absolutely worth it','Okay yes it is a bit pricey for Manipal but the ramen here is legitimately incredible. The sushi platter is also very well made. 10/10 for a special occasion.','2024-11-15','approved','2026-03-29 23:40:03'),(7,6,4,4.5,'Best butter naan in Manipal','Tawa Punjab is so good. The dal makhani and garlic naan combo is something else. Very filling and reasonably priced for the quality you get.','2024-11-22','approved','2026-03-29 23:40:03'),(8,7,5,4.5,'Finally proper pizza in Manipal','Vito\'s wood fired pizza is the real deal. The margherita and the white sauce pasta are both excellent. A little expensive but absolutely worth it.','2024-12-01','approved','2026-03-29 23:40:03'),(9,8,6,4.0,'Great place for a night out','Laughing Buddha has such a fun atmosphere. The dimsums are really good and the mocktails are great. Gets loud on weekends but that\'s part of the charm.','2024-12-05','approved','2026-03-29 23:40:03'),(10,9,7,5.0,'Hadiqa is stunning','The garden setting at Hadiqa is unlike anything else in Manipal. The shawarma platter and the hummus are absolutely top notch. Definitely a special occasion place.','2024-12-10','approved','2026-03-29 23:40:03'),(12,2,3,4.9,'Best wings in Manipal!','Eye of the Tiger has the best wings I have had in Manipal. The ghost pepper wings are an absolute must try ? not for the faint hearted but totally worth it. Vibe and ambiance are just amazing, perfect place to hang out with friends.','2026-03-30','approved','2026-03-29 23:46:25'),(13,10,4,4.3,'Best breakfast spot in Manipal!','Pai Tiffins is the go-to place for authentic South Indian breakfast. Idli and vada are soft and fresh every single day. Filter coffee is amazing. Very affordable for students.','2025-01-15','approved','2026-03-30 00:44:26'),(14,5,4,4.7,'Incredible ramen!','Kyoto has the best ramen in Manipal. Chicken ramen is a must try, rich broth and perfectly cooked noodles.','2026-04-05','approved','2026-04-05 00:50:51'),(15,9,1,4.8,'Amazing place','Had a nice time with my friends','2026-04-05','approved','2026-04-05 10:32:25'),(17,5,2,3.4,'Very Good','A must go-to place for Japanese food lovers','2026-04-05','approved','2026-04-05 11:58:02'),(22,9,9,4.0,'Nice Place','Must try the cheesecake','2026-04-06','approved','2026-04-06 11:57:16'),(23,3,9,3.0,'Spent more than 3 mins here','Went with my OC and ended up staying there for more than 3 minutes. Broke my own record hehe(although i just played game on my phone there) but nice place.','2026-04-06','approved','2026-04-06 12:00:29'),(40,2,20,5.0,'Amazingggg','must try the wings here',NULL,'approved','2026-04-08 05:18:00'),(44,9,20,4.1,'nice','nice only',NULL,'approved','2026-04-08 05:48:51'),(45,5,20,4.1,'nice place','went there with my friends',NULL,'approved','2026-04-08 05:52:14'),(46,7,2,4.4,'nice place','costly',NULL,'approved','2026-04-08 06:16:34'),(47,4,2,2.4,NULL,NULL,NULL,'approved','2026-04-08 10:41:43'),(48,9,22,4.6,NULL,NULL,NULL,'approved','2026-04-08 10:43:08'),(49,6,2,4.7,NULL,NULL,NULL,'approved','2026-04-08 12:07:10'),(50,11,3,4.5,'Beautiful new spot','Loved the aesthetic vibe and ambience. Food was great and the place feels very premium for Manipal.','2026-04-07','approved','2026-04-08 14:34:18'),(52,3,2,4.1,NULL,NULL,NULL,'approved','2026-04-12 14:24:17');
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_review_insert` AFTER INSERT ON `reviews` FOR EACH ROW BEGIN
  UPDATE restaurants
  SET avg_rating = (
    SELECT ROUND(AVG(rating), 2)
    FROM reviews
    WHERE restaurant_id = NEW.restaurant_id
      AND status = 'approved'
  )
  WHERE restaurant_id = NEW.restaurant_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_review_update` AFTER UPDATE ON `reviews` FOR EACH ROW BEGIN
  UPDATE restaurants
  SET avg_rating = (
    SELECT ROUND(AVG(rating), 2)
    FROM reviews
    WHERE restaurant_id = NEW.restaurant_id
      AND status = 'approved'
  )
  WHERE restaurant_id = NEW.restaurant_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_review_delete` AFTER DELETE ON `reviews` FOR EACH ROW BEGIN
  UPDATE restaurants
  SET avg_rating = COALESCE(
    (
      SELECT ROUND(AVG(rating), 2)
      FROM reviews
      WHERE restaurant_id = OLD.restaurant_id
        AND status = 'approved'
    ), 0.00
  )
  WHERE restaurant_id = OLD.restaurant_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `search_logs`
--

DROP TABLE IF EXISTS `search_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `search_logs` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `search_query` varchar(300) DEFAULT NULL,
  `cuisine_filter` int DEFAULT NULL,
  `price_filter` enum('$','$$','$$$','$$$$') DEFAULT NULL,
  `rating_filter` decimal(2,1) DEFAULT NULL,
  `results_count` int DEFAULT NULL,
  `searched_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  KEY `user_id` (`user_id`),
  KEY `cuisine_filter` (`cuisine_filter`),
  CONSTRAINT `search_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `search_logs_ibfk_2` FOREIGN KEY (`cuisine_filter`) REFERENCES `cuisines` (`cuisine_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `search_logs`
--

LOCK TABLES `search_logs` WRITE;
/*!40000 ALTER TABLE `search_logs` DISABLE KEYS */;
INSERT INTO `search_logs` VALUES (1,3,'best ice cream manipal',5,'$',4.0,3,'2026-03-29 23:40:03'),(2,4,'italian food manipal',7,'$$$',NULL,2,'2026-03-29 23:40:03'),(3,5,'cafe near mit road',4,'$$',4.0,4,'2026-03-29 23:40:03'),(4,6,'fine dining manipal',NULL,'$$$',4.5,3,'2026-03-29 23:40:03'),(5,7,'middle eastern food manipal',8,'$$$',NULL,1,'2026-03-29 23:40:03');
/*!40000 ALTER TABLE `search_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_activity_log`
--

DROP TABLE IF EXISTS `user_activity_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_activity_log` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `action` varchar(100) NOT NULL,
  `performed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_activity_log_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_activity_log`
--

LOCK TABLES `user_activity_log` WRITE;
/*!40000 ALTER TABLE `user_activity_log` DISABLE KEYS */;
INSERT INTO `user_activity_log` VALUES (1,3,'SEARCH','2026-03-29 23:40:03','2026-04-07 21:46:33'),(2,3,'VIEW_RESTAURANT','2026-03-29 23:40:03','2026-04-07 21:46:33'),(3,3,'SUBMIT_REVIEW','2026-03-29 23:40:03','2026-04-07 21:46:33'),(4,3,'BOOKMARK','2026-03-29 23:40:03','2026-04-07 21:46:33'),(5,4,'SEARCH','2026-03-29 23:40:03','2026-04-07 21:46:33'),(6,4,'VIEW_RESTAURANT','2026-03-29 23:40:03','2026-04-07 21:46:33'),(7,4,'BOOKMARK','2026-03-29 23:40:03','2026-04-07 21:46:33'),(8,5,'SEARCH','2026-03-29 23:40:03','2026-04-07 21:46:33'),(9,5,'SUBMIT_REVIEW','2026-03-29 23:40:03','2026-04-07 21:46:33'),(10,6,'SEARCH','2026-03-29 23:40:03','2026-04-07 21:46:33'),(11,6,'VIEW_RESTAURANT','2026-03-29 23:40:03','2026-04-07 21:46:33'),(12,6,'SUBMIT_REVIEW','2026-03-29 23:40:03','2026-04-07 21:46:33'),(13,7,'SEARCH','2026-03-29 23:40:03','2026-04-07 21:46:33'),(14,7,'BOOKMARK','2026-03-29 23:40:03','2026-04-07 21:46:33'),(15,7,'SUBMIT_REVIEW','2026-03-29 23:40:03','2026-04-07 21:46:33'),(16,20,'signup','2026-04-07 21:46:59','2026-04-07 21:46:59'),(17,20,'review_added','2026-04-07 21:47:30','2026-04-07 21:47:30'),(18,21,'signup','2026-04-07 22:06:12','2026-04-07 22:06:12'),(19,21,'review_added','2026-04-07 22:07:35','2026-04-07 22:07:35'),(20,8,'review_added','2026-04-08 05:04:55','2026-04-08 05:04:55'),(21,20,'review_added','2026-04-08 05:18:00','2026-04-08 05:18:00'),(22,20,'review_added','2026-04-08 05:41:35','2026-04-08 05:41:35'),(23,20,'review_added','2026-04-08 05:42:46','2026-04-08 05:42:46'),(24,20,'review_added','2026-04-08 05:45:18','2026-04-08 05:45:18'),(25,20,'review_added','2026-04-08 05:48:51','2026-04-08 05:48:51'),(26,20,'review_added','2026-04-08 05:52:14','2026-04-08 05:52:14'),(27,2,'review_added','2026-04-08 06:16:34','2026-04-08 06:16:34'),(28,2,'review_added','2026-04-08 10:41:43','2026-04-08 10:41:43'),(29,22,'signup','2026-04-08 10:42:49','2026-04-08 10:42:49'),(30,22,'review_added','2026-04-08 10:43:08','2026-04-08 10:43:08'),(31,2,'review_added','2026-04-08 12:07:11','2026-04-08 12:07:11'),(32,2,'review_added','2026-04-08 14:34:53','2026-04-08 14:34:53'),(33,2,'review_added','2026-04-12 14:24:17','2026-04-12 14:24:17');
/*!40000 ALTER TABLE `user_activity_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_lists`
--

DROP TABLE IF EXISTS `user_lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_lists` (
  `list_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `list_name` varchar(150) NOT NULL,
  `is_public` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`list_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_lists_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_lists`
--

LOCK TABLES `user_lists` WRITE;
/*!40000 ALTER TABLE `user_lists` DISABLE KEYS */;
INSERT INTO `user_lists` VALUES (1,3,'Budget Eats Under Rs 100',1,'2026-03-29 23:40:03'),(2,4,'Manipal Date Night Spots',1,'2026-03-29 23:40:03'),(3,5,'Best Cafes to Study In',1,'2026-03-29 23:40:03'),(4,6,'Special Occasion Places',0,'2026-03-29 23:40:03'),(5,7,'Weekend Hangout Spots',1,'2026-03-29 23:40:03');
/*!40000 ALTER TABLE `user_lists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_preferences`
--

DROP TABLE IF EXISTS `user_preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_preferences` (
  `pref_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `preferred_price` enum('$','$$','$$$','$$$$') DEFAULT NULL,
  `max_distance_km` int DEFAULT '10',
  `notify_offers` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`pref_id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `user_preferences_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_preferences`
--

LOCK TABLES `user_preferences` WRITE;
/*!40000 ALTER TABLE `user_preferences` DISABLE KEYS */;
INSERT INTO `user_preferences` VALUES (1,3,'$',2,1),(2,4,'$$',3,1),(3,5,'$$',2,0),(4,6,'$$$',5,1),(5,7,'$$',3,1);
/*!40000 ALTER TABLE `user_preferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_profiles`
--

DROP TABLE IF EXISTS `user_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_profiles` (
  `profile_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `full_name` varchar(150) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `avatar_url` varchar(500) DEFAULT NULL,
  `city_id` int DEFAULT NULL,
  `gender` enum('Male','Female','Other','Prefer not to say') DEFAULT NULL,
  PRIMARY KEY (`profile_id`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `city_id` (`city_id`),
  CONSTRAINT `user_profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `user_profiles_ibfk_2` FOREIGN KEY (`city_id`) REFERENCES `cities` (`city_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_profiles`
--

LOCK TABLES `user_profiles` WRITE;
/*!40000 ALTER TABLE `user_profiles` DISABLE KEYS */;
INSERT INTO `user_profiles` VALUES (1,1,'Ananya Saras',NULL,NULL,1,'Female'),(2,2,'Anjali Pranav',NULL,NULL,1,'Female'),(3,3,'Rahul Shenoy',NULL,NULL,1,'Male'),(4,4,'Priya Kamath',NULL,NULL,1,'Female'),(5,5,'Kiran Kumar',NULL,NULL,1,'Male'),(6,6,'Sneha Rao',NULL,NULL,1,'Female'),(7,7,'Arjun Nair',NULL,NULL,1,'Male'),(8,8,'Shaan Chopra',NULL,NULL,NULL,NULL),(9,9,'Upasana Patnaik',NULL,NULL,NULL,NULL),(10,10,'Trusha',NULL,NULL,NULL,NULL),(11,20,'michelle',NULL,NULL,NULL,NULL),(12,21,'Michelle',NULL,NULL,NULL,NULL),(13,22,'Juwairiyah',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `user_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `security_question` varchar(255) DEFAULT NULL,
  `security_answer` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_user_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'ananya_s','ananya@learner.manipal.edu','ananya123',1,'2026-03-29 23:40:03','What is your pet name?','tommy'),(2,'anjali_p','anjali@learner.manipal.edu','$2b$10$UGPbz8Pj4fmLmooDbyt6ZOEw83tqr48v94GUYOA/JhbwVMysP5i66',1,'2026-03-29 23:40:03','What is your hometown?','patna'),(3,'rahul_mit','rahul@learner.manipal.edu','rahul123',1,'2026-03-29 23:40:03','What is your fav colour?','pink'),(4,'priya_kmc','priya@learner.manipal.edu','priya123',1,'2026-03-29 23:40:03','Who is your fav bollywood actor?','rk'),(5,'kiran_mahe','kiran@learner.manipal.edu','kiran123',1,'2026-03-29 23:40:03','Where is your hometown?','udupi'),(6,'sneha_ds','sneha@learner.manipal.edu','sneha123',1,'2026-03-29 23:40:03','What is your fav movie?','znmd'),(7,'arjun_tech','arjun@learner.manipal.edu','arjun123',1,'2026-03-29 23:40:03','What is your non-fav band?','Microsoft'),(8,'shaan_chopra04','shaan_chopra04@manipaleats.local','@shaan_crypto',1,'2026-04-05 14:24:55','What is your favourite music band?','oasis'),(9,'uppu_311','uppu_311@manipaleats.local','@trusha311',1,'2026-04-06 11:56:48','What is your school\'s name?','mit'),(10,'turusha','turusha@manipaleats.local','@why6characters',1,'2026-04-06 12:02:44','What is your mother tongue?','marathi'),(20,'michu','michu@manipaleats.local','hey123',1,'2026-04-07 21:46:59',NULL,NULL),(21,'michuu','michuu@manipaleats.local','$2b$10$4SJyBZXiwoXaF3s1FuLB7ODTFHb5B7VXHzR8gUNYTqtgP1IEGRDge',1,'2026-04-07 22:06:12','What is your best friend\'s name?','uppu'),(22,'juwii','juwii@learner.manipal.edu','$2b$10$KFf3N8vQ2BwFln2HQFtyzeLd8eMoups0buzWilgx1Ch2TYNxekzUe',1,'2026-04-08 10:42:49','What is your best friend\'s name?','$2b$10$qS3C83ZV.4WQ/lWG8YnGm.TLLogXKwsG.PCBdRkyZzlkwK.ThvUDy');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-12 20:28:54
