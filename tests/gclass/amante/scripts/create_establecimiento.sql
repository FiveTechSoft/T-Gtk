CREATE TABLE `establecimiento` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_cadena` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'A que cadena pertenece',
  `nombre` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Nombre del establecimiento',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `cadena` (`id_cadena`),
  CONSTRAINT `fk_cadena_establecimiento` FOREIGN KEY (`id_cadena`) REFERENCES `cadena` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci COMMENT='Establecimiento'
