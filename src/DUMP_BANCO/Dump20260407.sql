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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_servicos`
--

LOCK TABLES `tb_servicos` WRITE;
/*!40000 ALTER TABLE `tb_servicos` DISABLE KEYS */;
INSERT INTO `tb_servicos` VALUES (1,'corte cabelo','-',40.00,40,1),(2,'corte cabelo','-',40.00,40,1),(3,'barba','-',25.00,30,1),(4,'sobrancelha','-',10.00,5,1),(5,'descoloração','-',80.00,90,1),(6,'pigmentacao cabelo','-',30.00,20,1),(7,'pigmentacao barba','-',20.00,15,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_usuarios`
--

LOCK TABLES `tb_usuarios` WRITE;
/*!40000 ALTER TABLE `tb_usuarios` DISABLE KEYS */;
INSERT INTO `tb_usuarios` VALUES (2,'Júlio Braido','JBraido11','jbraido@gmail.com','19977776666','/uploads/user_2_1775609023234.png','$2b$10$G3hPsb/jrR5AQhQYvr.Ruu5zR/MWaZBdfnU9KTUsOUY0Kpd3WUU5G',NULL,NULL,1,'2026-04-02 23:20:24'),(3,'Ray Martins','RayMartins555','raymartins@gmail.com','19922221111','/uploads/user_3_1775609068667.png','$2b$10$OHabQN.bBbszWh9pcZBhIOA8gC.msrFPMVcjaHvOabXtaN0hWnfVm',NULL,NULL,1,'2026-04-02 23:23:36'),(4,'João Victor Viana','JoãoViana96','joao.teste@gmail.com','19988880000','/uploads/user_4_1775609345386.png','$2b$10$sxVDgW.SWjt3lsNX3mW/ROK7eSIADz4KgispzfvZxbcrtEG4SEPYa',NULL,NULL,1,'2026-04-07 21:37:07');
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
INSERT INTO `tb_usuarios_perfis` VALUES (2,3),(3,3),(4,3);
/*!40000 ALTER TABLE `tb_usuarios_perfis` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-07 21:51:06
