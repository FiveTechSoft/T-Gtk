CREATE TABLE `usuarios` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) CHARACTER SET latin1 NOT NULL COMMENT 'Nombre del usuario',
  `email` varchar(50) CHARACTER SET latin1 NOT NULL COMMENT 'email donde enviar notificaciones',
  `telefono` varchar(15) CHARACTER SET latin1 NOT NULL COMMENT 'telefono de contacto',
  `asignar_tareas` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Puede asignar tareas',
  `ver_tareas` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Puede ver tareas de otros usuarios',
  `add_tareas` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Puede add tareas',
  `password` varchar(10) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Password para entrar en el sistema Helpdesk',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci COMMENT='Usuarios de Incidencias.'