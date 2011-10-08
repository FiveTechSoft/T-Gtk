CREATE TABLE `rel_cadena_establecimiento` (
  `id_cadena` smallint(5) unsigned NOT NULL,
  `id_establecimiento` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id_cadena`,`id_establecimiento`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci COMMENT='Establecimientos que pertenecen a un cadena'
