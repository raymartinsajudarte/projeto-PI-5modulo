CREATE DATABASE  IF NOT EXISTS `db_barbearia_avenida` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `db_barbearia_avenida`;
-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: db_barbearia_avenida
-- ------------------------------------------------------
-- Server version	8.0.43

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
-- Table structure for table `tb_agendamento_servicos`
--

DROP TABLE IF EXISTS `tb_agendamento_servicos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_agendamento_servicos` (
  `id_agendamento_servico` int NOT NULL AUTO_INCREMENT,
  `id_agendamento` int NOT NULL,
  `id_servico` int NOT NULL,
  `valor_unitario` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id_agendamento_servico`),
  UNIQUE KEY `uq_agendamento_servico` (`id_agendamento`,`id_servico`),
  KEY `fk_agend_svc` (`id_servico`),
  CONSTRAINT `fk_agend_svc` FOREIGN KEY (`id_servico`) REFERENCES `tb_servicos` (`id_servico`),
  CONSTRAINT `fk_agendamento` FOREIGN KEY (`id_agendamento`) REFERENCES `tb_agendamentos` (`id_agendamento`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_agendamento_servicos`
--

LOCK TABLES `tb_agendamento_servicos` WRITE;
/*!40000 ALTER TABLE `tb_agendamento_servicos` DISABLE KEYS */;
INSERT INTO `tb_agendamento_servicos` VALUES (1,1,1,40.00),(2,1,2,25.00),(3,2,1,40.00),(7,4,1,40.00),(8,4,2,25.00),(9,4,3,10.00),(10,5,1,40.00),(11,5,2,25.00),(12,6,1,40.00),(13,6,2,25.00),(14,6,3,10.00),(15,7,1,40.00),(16,8,1,40.00),(17,9,1,40.00),(18,9,2,25.00);
/*!40000 ALTER TABLE `tb_agendamento_servicos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_agendamentos`
--

DROP TABLE IF EXISTS `tb_agendamentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_agendamentos` (
  `id_agendamento` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int NOT NULL,
  `id_pagamento` int NOT NULL,
  `valor` decimal(10,2) DEFAULT NULL,
  `dia` date NOT NULL,
  `hora` time NOT NULL,
  `status` varchar(30) DEFAULT 'confirmado',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_agendamento`),
  KEY `fk_usuario` (`id_usuario`),
  KEY `fk_pagamento` (`id_pagamento`),
  CONSTRAINT `fk_pagamento` FOREIGN KEY (`id_pagamento`) REFERENCES `tb_formas_pagamento` (`id_forma_pagamento`),
  CONSTRAINT `fk_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `tb_usuarios` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_agendamentos`
--

LOCK TABLES `tb_agendamentos` WRITE;
/*!40000 ALTER TABLE `tb_agendamentos` DISABLE KEYS */;
INSERT INTO `tb_agendamentos` VALUES (1,2,1,65.00,'2026-04-20','14:00:00','confirmado','2026-04-19 14:33:12'),(2,4,2,40.00,'2026-04-22','16:00:00','confirmado','2026-04-19 15:07:31'),(4,2,3,75.00,'2026-04-23','10:00:00','confirmado','2026-04-19 15:11:03'),(5,5,3,65.00,'2026-05-21','10:00:00','confirmado','2026-05-11 20:05:46'),(6,6,3,75.00,'2026-05-16','09:00:00','confirmado','2026-05-15 22:19:56'),(7,7,1,40.00,'2026-05-22','10:00:00','confirmado','2026-05-15 22:25:13'),(8,7,4,40.00,'2026-05-27','09:00:00','cancelado','2026-05-23 15:00:59'),(9,7,1,65.00,'2026-05-27','11:00:00','confirmado','2026-05-26 21:29:33');
/*!40000 ALTER TABLE `tb_agendamentos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_formas_pagamento`
--

DROP TABLE IF EXISTS `tb_formas_pagamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_formas_pagamento` (
  `id_forma_pagamento` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `ativo` tinyint DEFAULT '1',
  PRIMARY KEY (`id_forma_pagamento`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_formas_pagamento`
--

LOCK TABLES `tb_formas_pagamento` WRITE;
/*!40000 ALTER TABLE `tb_formas_pagamento` DISABLE KEYS */;
INSERT INTO `tb_formas_pagamento` VALUES (1,'crédito',1),(2,'débito',1),(3,'dinheiro',1),(4,'pix',1);
/*!40000 ALTER TABLE `tb_formas_pagamento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_perfis`
--

DROP TABLE IF EXISTS `tb_perfis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_perfis` (
  `id_perfil` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) NOT NULL,
  `ativo` tinyint DEFAULT '1',
  PRIMARY KEY (`id_perfil`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_perfis`
--

LOCK TABLES `tb_perfis` WRITE;
/*!40000 ALTER TABLE `tb_perfis` DISABLE KEYS */;
INSERT INTO `tb_perfis` VALUES (1,'administrador',1),(2,'gestor',1),(3,'usuario',1);
/*!40000 ALTER TABLE `tb_perfis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `tb_relat_agendamentos`
--

DROP TABLE IF EXISTS `tb_relat_agendamentos`;
/*!50001 DROP VIEW IF EXISTS `tb_relat_agendamentos`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `tb_relat_agendamentos` AS SELECT 
 1 AS `id_agendamento`,
 1 AS `id_usuario`,
 1 AS `nome`,
 1 AS `foto`,
 1 AS `descricao servicos`,
 1 AS `valor servicos`,
 1 AS `valor total`,
 1 AS `dia`,
 1 AS `hora`,
 1 AS `forma_pagamento`,
 1 AS `status`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tb_servicos`
--

DROP TABLE IF EXISTS `tb_servicos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_servicos` (
  `id_servico` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(150) NOT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `valor` decimal(10,2) NOT NULL,
  `duracao_minutos` int NOT NULL,
  `ativo` tinyint DEFAULT '1',
  PRIMARY KEY (`id_servico`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_servicos`
--

LOCK TABLES `tb_servicos` WRITE;
/*!40000 ALTER TABLE `tb_servicos` DISABLE KEYS */;
INSERT INTO `tb_servicos` VALUES (1,'corte cabelo','-',40.00,40,1),(2,'barba','-',25.00,30,1),(3,'sobrancelha','-',10.00,5,1),(4,'luzes','-',80.00,90,1),(5,'pigmentacao cabelo','-',30.00,20,0),(6,'pigmentacao barba','-',20.00,15,0);
/*!40000 ALTER TABLE `tb_servicos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_usuarios`
--

DROP TABLE IF EXISTS `tb_usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_usuarios` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(150) NOT NULL,
  `nome_usuario` varchar(50) NOT NULL,
  `email` varchar(150) NOT NULL,
  `celular` varchar(11) DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `senha_hash` varchar(255) NOT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `reset_token_expires_at` datetime DEFAULT NULL,
  `status` tinyint DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_usuarios`
--

LOCK TABLES `tb_usuarios` WRITE;
/*!40000 ALTER TABLE `tb_usuarios` DISABLE KEYS */;
INSERT INTO `tb_usuarios` VALUES (2,'Júlio Braido','JBraido11','jbraido@gmail.com','19977776666','/uploads/user_2_1775609023234.png','$2b$10$G3hPsb/jrR5AQhQYvr.Ruu5zR/MWaZBdfnU9KTUsOUY0Kpd3WUU5G',NULL,NULL,1,'2026-04-02 23:20:24'),(3,'Ray Martins','RayMartins555','ray.martins@gmail.com','19922221000','/uploads/user_3_1775609068667.png','$2b$10$OHabQN.bBbszWh9pcZBhIOA8gC.msrFPMVcjaHvOabXtaN0hWnfVm',NULL,NULL,1,'2026-04-02 23:23:36'),(4,'João Victor Marcolino','JoãoViana96','joao.karnero@gmail.com','19988880022','/uploads/user_4_1775609345386.png','$2b$10$VDetOMpbvcQkIN28VZKXB.txGBP..q.zej.1jiQbfv89Da24sDQbC','4b581e98ae30dcd266f3990fb21e655fbf1b1a71','2026-04-21 17:29:43',1,'2026-04-07 21:37:07'),(5,'Agnaldo','agnaldo.souza','rayeleoterio08@gmail.com',NULL,NULL,'$2b$10$IDBva/UI1DI7dGG9NCJhcungUq9j8avYsxVSXO9F/HdgWNcjaRSdC',NULL,NULL,1,'2026-05-11 19:55:00'),(6,'Marcelo Ciacco','marcelo99','teste@testemarcelo.com','19999993333',NULL,'$2b$10$4jCaDXBJC5rwIELavmQrXOTUKYZ.mu7.Z4e4777Kl/.1Ow9oKuLFy',NULL,NULL,1,'2026-05-15 22:16:50'),(7,'julio b','julio22','juliottt@jteste.com','99999888777',NULL,'$2b$10$rIZlW77flz5yiucY2HlUo.i9t/XYW9E4zPG4zsXSeRbOTz3hnF2xG',NULL,NULL,1,'2026-05-15 22:20:34');
/*!40000 ALTER TABLE `tb_usuarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_usuarios_perfis`
--

DROP TABLE IF EXISTS `tb_usuarios_perfis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_usuarios_perfis` (
  `id_usuario` int NOT NULL,
  `id_perfil` int NOT NULL,
  PRIMARY KEY (`id_usuario`,`id_perfil`),
  KEY `id_perfil` (`id_perfil`),
  CONSTRAINT `tb_usuarios_perfis_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `tb_usuarios` (`id_usuario`),
  CONSTRAINT `tb_usuarios_perfis_ibfk_2` FOREIGN KEY (`id_perfil`) REFERENCES `tb_perfis` (`id_perfil`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_usuarios_perfis`
--

LOCK TABLES `tb_usuarios_perfis` WRITE;
/*!40000 ALTER TABLE `tb_usuarios_perfis` DISABLE KEYS */;
INSERT INTO `tb_usuarios_perfis` VALUES (2,3),(3,3),(4,3),(5,3),(6,3),(7,3);
/*!40000 ALTER TABLE `tb_usuarios_perfis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `tb_relat_agendamentos`
--

/*!50001 DROP VIEW IF EXISTS `tb_relat_agendamentos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`adm_barber`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `tb_relat_agendamentos` AS select `a`.`id_agendamento` AS `id_agendamento`,`b`.`id_usuario` AS `id_usuario`,`b`.`nome` AS `nome`,`b`.`foto` AS `foto`,group_concat(`e`.`nome` separator ' | ') AS `descricao servicos`,group_concat(concat('R$ ',convert(format(`d`.`valor_unitario`,2,'pt_BR') using utf8mb4)) separator ' | ') AS `valor servicos`,`a`.`valor` AS `valor total`,date_format(`a`.`dia`,'%Y-%m-%d') AS `dia`,time_format(`a`.`hora`,'%H:%i') AS `hora`,`c`.`nome` AS `forma_pagamento`,`a`.`status` AS `status` from ((((`tb_agendamentos` `a` join `tb_usuarios` `b` on((`a`.`id_usuario` = `b`.`id_usuario`))) join `tb_formas_pagamento` `c` on((`a`.`id_pagamento` = `c`.`id_forma_pagamento`))) join `tb_agendamento_servicos` `d` on((`a`.`id_agendamento` = `d`.`id_agendamento`))) join `tb_servicos` `e` on((`d`.`id_servico` = `e`.`id_servico`))) group by `a`.`id_agendamento`,`b`.`nome`,`b`.`foto`,`a`.`valor`,`a`.`dia`,`a`.`hora`,`c`.`nome`,`a`.`status` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-28 21:18:31
