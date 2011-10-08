CREATE TABLE `rel_maquina_programas` (
  `id_maquina` bigint(20) unsigned NOT NULL DEFAULT '0',
  `id_programa` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_maquina`,`id_programa`),
  KEY `fk_programa` (`id_programa`),
  CONSTRAINT `fk_maquina` FOREIGN KEY (`id_maquina`) REFERENCES `maquina` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_programa` FOREIGN KEY (`id_programa`) REFERENCES `programas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci ROW_FORMAT=FIXED COMMENT='Que programas tiene determinada máquina'