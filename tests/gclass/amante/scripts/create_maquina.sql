CREATE TABLE `maquina` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) CHARACTER SET latin1 NOT NULL,
  `ip` varchar(16) COLLATE utf8_spanish_ci NOT NULL,
  `sistema_operativo` varchar(30) COLLATE utf8_spanish_ci DEFAULT NULL,
  `id_hotel` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_hotel_maquina` (`id_hotel`),
  CONSTRAINT `fk_hotel_maquina` FOREIGN KEY (`id_hotel`) REFERENCES `hoteles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci COMMENT='Maquina a conectarnos'