CREATE TABLE `rel_usuarios_grupo` (
  `id_usuario` int(10) unsigned NOT NULL,
  `id_grupo` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`id_usuario`,`id_grupo`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci COMMENT='A que grupos pertenece un usuario'