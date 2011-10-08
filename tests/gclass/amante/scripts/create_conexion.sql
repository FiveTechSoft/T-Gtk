CREATE TABLE `conexion` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_tipo` tinyint(3) unsigned NOT NULL COMMENT 'Especifica que tipo de conexion',
  `id_maquina` bigint(20) unsigned NOT NULL COMMENT 'Que maquina usa esta conexion',
  `descripcion` mediumtext CHARACTER SET latin1 NOT NULL COMMENT 'Observaciones de la conexion',
  `prioridad` tinyint(3) unsigned NOT NULL COMMENT 'Indica el orden a seguir en la conexion.',
  `usuario` varchar(40) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Usurio de la conexion.',
  `password` varchar(30) COLLATE utf8_spanish_ci NOT NULL COMMENT 'password de la conexion',
  `notas` text COLLATE utf8_spanish_ci,
  PRIMARY KEY (`id`),
  KEY `fk_maquina_conexion` (`id_maquina`),
  CONSTRAINT `fk_maquina_conexion` FOREIGN KEY (`id_maquina`) REFERENCES `maquina` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci COMMENT='Como conectar a la maquina'