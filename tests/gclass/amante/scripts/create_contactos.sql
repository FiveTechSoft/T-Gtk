CREATE TABLE `contactos` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(50) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Nombre del contacto',
  `Telefono` varchar(15) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Telefono donde localizarlo',
  `email` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'mail para notificar posible incidencia.',
  `notas` text COLLATE utf8_spanish_ci,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci COMMENT='Contactos para una incidencia'