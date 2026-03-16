-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: opinix_db
-- ------------------------------------------------------
-- Server version	8.0.45

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
-- Table structure for table `ai_models`
--

DROP TABLE IF EXISTS `ai_models`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_models` (
  `ai_model_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `model_name` varchar(100) NOT NULL,
  `ai_type` enum('SUMMARIZER','SENTIMENT','OTHER') NOT NULL DEFAULT 'SUMMARIZER',
  `version` varchar(50) NOT NULL DEFAULT 'v1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ai_model_id`),
  KEY `idx_ai_type` (`ai_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `answer_options`
--

DROP TABLE IF EXISTS `answer_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `answer_options` (
  `answer_id` bigint unsigned NOT NULL,
  `option_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`answer_id`,`option_id`),
  KEY `fk_ansopt_option` (`option_id`),
  CONSTRAINT `fk_ansopt_answer` FOREIGN KEY (`answer_id`) REFERENCES `answers` (`answer_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ansopt_option` FOREIGN KEY (`option_id`) REFERENCES `question_options` (`option_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `answers`
--

DROP TABLE IF EXISTS `answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `answers` (
  `answer_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `response_id` bigint unsigned NOT NULL,
  `question_id` bigint unsigned NOT NULL,
  `answer_text` text,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`answer_id`),
  UNIQUE KEY `uq_one_answer_per_question_per_response` (`response_id`,`question_id`),
  KEY `idx_answers_response` (`response_id`),
  KEY `idx_answers_question` (`question_id`),
  CONSTRAINT `fk_answers_question` FOREIGN KEY (`question_id`) REFERENCES `questions` (`question_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_answers_response` FOREIGN KEY (`response_id`) REFERENCES `responses` (`response_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `poll_answers`
--

DROP TABLE IF EXISTS `poll_answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `poll_answers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `choice_value` varchar(255) DEFAULT NULL,
  `numeric_value` double DEFAULT NULL,
  `raw_value` text,
  `question_id` bigint DEFAULT NULL,
  `response_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKadkddhulnyisam193sr3y9t0l` (`question_id`),
  KEY `FKarewnrl4wmssulqmyyqsk8cks` (`response_id`),
  CONSTRAINT `FKadkddhulnyisam193sr3y9t0l` FOREIGN KEY (`question_id`) REFERENCES `poll_questions` (`id`),
  CONSTRAINT `FKarewnrl4wmssulqmyyqsk8cks` FOREIGN KEY (`response_id`) REFERENCES `poll_responses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `poll_questions`
--

DROP TABLE IF EXISTS `poll_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `poll_questions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `column_index` int NOT NULL,
  `label` varchar(255) DEFAULT NULL,
  `original_header` varchar(255) DEFAULT NULL,
  `role` enum('FEEDBACK','IGNORE','METADATA') DEFAULT NULL,
  `type` enum('CHOICE','EMAIL','NUMBER','OTHER','RATING','TEXT','TIMESTAMP') DEFAULT NULL,
  `poll_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKdiuqaq869156f0k67iwxvbysb` (`poll_id`),
  CONSTRAINT `FKdiuqaq869156f0k67iwxvbysb` FOREIGN KEY (`poll_id`) REFERENCES `polls` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `poll_responses`
--

DROP TABLE IF EXISTS `poll_responses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `poll_responses` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `row_index` int NOT NULL,
  `poll_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKav9pr8gw2ckyx0yyebtskli8d` (`poll_id`),
  CONSTRAINT `FKav9pr8gw2ckyx0yyebtskli8d` FOREIGN KEY (`poll_id`) REFERENCES `polls` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `polls`
--

DROP TABLE IF EXISTS `polls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `polls` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `source` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `question_options`
--

DROP TABLE IF EXISTS `question_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `question_options` (
  `option_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `question_id` bigint unsigned NOT NULL,
  `option_text` varchar(255) NOT NULL,
  `sort_order` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`option_id`),
  KEY `idx_qopts_question` (`question_id`),
  CONSTRAINT `fk_qopts_question` FOREIGN KEY (`question_id`) REFERENCES `questions` (`question_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `questions` (
  `question_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `survey_id` bigint unsigned NOT NULL,
  `question_text` varchar(500) NOT NULL,
  `question_type` enum('OPEN','SINGLE_CHOICE','MULTI_CHOICE') NOT NULL,
  `is_multi_answer` tinyint(1) NOT NULL DEFAULT '0',
  `sort_order` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`question_id`),
  KEY `idx_questions_survey` (`survey_id`),
  CONSTRAINT `fk_questions_survey` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`survey_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `responses`
--

DROP TABLE IF EXISTS `responses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `responses` (
  `response_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `survey_id` bigint unsigned NOT NULL,
  `respondent_user_id` bigint unsigned NOT NULL,
  `submitted_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`response_id`),
  UNIQUE KEY `uq_one_response_per_user_per_survey` (`survey_id`,`respondent_user_id`),
  KEY `idx_responses_survey` (`survey_id`),
  KEY `idx_responses_user` (`respondent_user_id`),
  CONSTRAINT `fk_responses_respondent` FOREIGN KEY (`respondent_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_responses_survey` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`survey_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `summaries`
--

DROP TABLE IF EXISTS `summaries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `summaries` (
  `summary_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `survey_id` bigint unsigned NOT NULL,
  `owner_user_id` bigint unsigned NOT NULL,
  `ai_model_id` bigint unsigned NOT NULL,
  `summary_text` longtext NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`summary_id`),
  KEY `idx_summaries_survey` (`survey_id`),
  KEY `idx_summaries_owner` (`owner_user_id`),
  KEY `idx_summaries_model` (`ai_model_id`),
  CONSTRAINT `fk_summaries_model` FOREIGN KEY (`ai_model_id`) REFERENCES `ai_models` (`ai_model_id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_summaries_owner` FOREIGN KEY (`owner_user_id`) REFERENCES `users` (`user_id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_summaries_survey` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`survey_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `surveys`
--

DROP TABLE IF EXISTS `surveys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `surveys` (
  `survey_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `due_date` date DEFAULT NULL,
  `estimated_time_minutes` int DEFAULT NULL,
  `is_open` tinyint(1) NOT NULL DEFAULT '1',
  `owner_user_id` bigint unsigned NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`survey_id`),
  KEY `idx_surveys_owner` (`owner_user_id`),
  KEY `idx_surveys_is_open` (`is_open`),
  CONSTRAINT `fk_surveys_owner_user` FOREIGN KEY (`owner_user_id`) REFERENCES `users` (`user_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `full_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('POLLSTER','RESPONDENT','ADMIN') NOT NULL DEFAULT 'RESPONDENT',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `active` bit(1) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uq_users_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-17  0:04:58
