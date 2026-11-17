-- EL ULTIMO ELFO: EL DESPERTAR DE UNA LEYENDA
-- Esquema MySQL 8.0+; seguro para crear tablas en una BD nueva.
-- utf8mb4 conserva acentos, eñes y símbolos.
CREATE DATABASE IF NOT EXISTS `el_ultimo_elfo` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `el_ultimo_elfo`;
SET NAMES utf8mb4;

-- ability
CREATE TABLE IF NOT EXISTS `ability` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(190) NOT NULL,
  `magic_family` VARCHAR(255) NOT NULL,
  `description` TEXT NOT NULL,
  `gameplay_usage` TEXT NULL,
  `canon_status` VARCHAR(255) NOT NULL DEFAULT 'historia',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_ability_1` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- chapter
CREATE TABLE IF NOT EXISTS `chapter` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(190) NOT NULL,
  `synopsis` TEXT NOT NULL,
  `kevin_age` INT NULL,
  `stage_type` VARCHAR(255) NOT NULL DEFAULT 'principal',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- cinematic
CREATE TABLE IF NOT EXISTS `cinematic` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `chapter_id` INT NULL,
  `title` VARCHAR(190) NOT NULL,
  `trigger_event` VARCHAR(255) NOT NULL,
  `storyboard` TEXT NOT NULL,
  `camera_note` TEXT NULL,
  `suggested_duration_seconds` INT NULL,
  `canon_status` VARCHAR(255) NOT NULL DEFAULT 'adaptacion_jugable',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_cinematic_1` (`title`),
  CONSTRAINT `fk_cinematic_chapter_id` FOREIGN KEY (`chapter_id`) REFERENCES `chapter` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- game
CREATE TABLE IF NOT EXISTS `game` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(190) NOT NULL,
  `subtitle` VARCHAR(255) NULL,
  `genre` VARCHAR(255) NOT NULL,
  `protagonist_id` INT NULL,
  `age_start` INT NULL,
  `age_final` INT NULL,
  `ancient_war_years_ago` INT NULL,
  `synopsis` TEXT NOT NULL,
  `canon_note` TEXT NULL,
  `version` VARCHAR(255) NOT NULL DEFAULT '1.0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- lore_issue
CREATE TABLE IF NOT EXISTS `lore_issue` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `field_name` VARCHAR(255) NOT NULL,
  `original_conflict` TEXT NOT NULL,
  `recommended_resolution` TEXT NULL,
  `resolution_status` VARCHAR(255) NOT NULL DEFAULT 'pendiente',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- race
CREATE TABLE IF NOT EXISTS `race` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(190) NOT NULL,
  `summary` TEXT NOT NULL,
  `lifespan_years` INT NULL,
  `typical_magic` VARCHAR(255) NULL,
  `playable` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_race_1` (`name`),
  CONSTRAINT `chk_race_playable` CHECK (`playable` IN (0, 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- rank_level
CREATE TABLE IF NOT EXISTS `rank_level` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `symbol` VARCHAR(190) NOT NULL,
  `strength_order` INT NOT NULL,
  `human_population_percent` DOUBLE NULL,
  `notes` TEXT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_rank_level_1` (`strength_order`),
  UNIQUE KEY `uq_rank_level_2` (`symbol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- character
CREATE TABLE IF NOT EXISTS `character` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(190) NOT NULL,
  `race_id` INT NOT NULL,
  `rank_id` INT NULL,
  `role` VARCHAR(255) NOT NULL,
  `introduction` TEXT NULL,
  `first_chapter_id` INT NULL,
  `age_first_appearance` INT NULL,
  `status_final` VARCHAR(255) NULL,
  `canon_status` VARCHAR(255) NOT NULL DEFAULT 'historia',
  `asset_key` VARCHAR(190) NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_character_1` (`asset_key`),
  UNIQUE KEY `uq_character_2` (`name`),
  INDEX `idx_char_race` (`race_id`),
  CONSTRAINT `fk_character_first_chapter_id` FOREIGN KEY (`first_chapter_id`) REFERENCES `chapter` (`id`),
  CONSTRAINT `fk_character_rank_id` FOREIGN KEY (`rank_id`) REFERENCES `rank_level` (`id`),
  CONSTRAINT `fk_character_race_id` FOREIGN KEY (`race_id`) REFERENCES `race` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- character_ability
CREATE TABLE IF NOT EXISTS `character_ability` (
  `character_id` INT NOT NULL,
  `ability_id` INT NOT NULL,
  `learned_age` INT NULL,
  `notes` TEXT NULL,
  PRIMARY KEY (`character_id`, `ability_id`),
  CONSTRAINT `fk_character_ability_ability_id` FOREIGN KEY (`ability_id`) REFERENCES `ability` (`id`),
  CONSTRAINT `fk_character_ability_character_id` FOREIGN KEY (`character_id`) REFERENCES `character` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- dialogue
CREATE TABLE IF NOT EXISTS `dialogue` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `chapter_id` INT NULL,
  `speaker_id` INT NULL,
  `context_tag` VARCHAR(255) NOT NULL,
  `line` TEXT NOT NULL,
  `original_or_adapted` VARCHAR(255) NOT NULL DEFAULT 'adaptado',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_dialogue_speaker_id` FOREIGN KEY (`speaker_id`) REFERENCES `character` (`id`),
  CONSTRAINT `fk_dialogue_chapter_id` FOREIGN KEY (`chapter_id`) REFERENCES `chapter` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- faction
CREATE TABLE IF NOT EXISTS `faction` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(190) NOT NULL,
  `description` TEXT NOT NULL,
  `leader_character_id` INT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_faction_1` (`name`),
  CONSTRAINT `fk_faction_leader_character_id` FOREIGN KEY (`leader_character_id`) REFERENCES `character` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- faction_member
CREATE TABLE IF NOT EXISTS `faction_member` (
  `faction_id` INT NOT NULL,
  `character_id` INT NOT NULL,
  `membership` VARCHAR(255) NULL,
  PRIMARY KEY (`faction_id`, `character_id`),
  CONSTRAINT `fk_faction_member_character_id` FOREIGN KEY (`character_id`) REFERENCES `character` (`id`),
  CONSTRAINT `fk_faction_member_faction_id` FOREIGN KEY (`faction_id`) REFERENCES `faction` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- region
CREATE TABLE IF NOT EXISTS `region` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(190) NOT NULL,
  `race_id` INT NULL,
  `description` TEXT NOT NULL,
  `canon_status` VARCHAR(255) NOT NULL DEFAULT 'adaptacion',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_region_1` (`name`),
  CONSTRAINT `fk_region_race_id` FOREIGN KEY (`race_id`) REFERENCES `race` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- location
CREATE TABLE IF NOT EXISTS `location` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(190) NOT NULL,
  `region_id` INT NULL,
  `location_type` VARCHAR(255) NULL,
  `description` TEXT NULL,
  `canon_status` VARCHAR(255) NOT NULL DEFAULT 'historia',
  `accessible_from_chapter` INT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_location_1` (`name`),
  INDEX `idx_location_region` (`region_id`),
  CONSTRAINT `fk_location_region_id` FOREIGN KEY (`region_id`) REFERENCES `region` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- enemy_type
CREATE TABLE IF NOT EXISTS `enemy_type` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(190) NOT NULL,
  `description` TEXT NOT NULL,
  `race_id` INT NULL,
  `location_id` INT NULL,
  `canon_status` VARCHAR(255) NOT NULL DEFAULT 'historia',
  `suggested_level` INT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_enemy_type_1` (`name`),
  CONSTRAINT `fk_enemy_type_location_id` FOREIGN KEY (`location_id`) REFERENCES `location` (`id`),
  CONSTRAINT `fk_enemy_type_race_id` FOREIGN KEY (`race_id`) REFERENCES `race` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- item
CREATE TABLE IF NOT EXISTS `item` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(190) NOT NULL,
  `category` VARCHAR(255) NOT NULL,
  `description` TEXT NOT NULL,
  `mechanic` TEXT NULL,
  `initial_location_id` INT NULL,
  `original_owner_id` INT NULL,
  `rarity` VARCHAR(255) NOT NULL DEFAULT 'historia',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_item_1` (`name`),
  CONSTRAINT `fk_item_original_owner_id` FOREIGN KEY (`original_owner_id`) REFERENCES `character` (`id`),
  CONSTRAINT `fk_item_initial_location_id` FOREIGN KEY (`initial_location_id`) REFERENCES `location` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- puzzle
CREATE TABLE IF NOT EXISTS `puzzle` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(190) NOT NULL,
  `location_id` INT NULL,
  `chapter_id` INT NULL,
  `clue` TEXT NOT NULL,
  `solution` TEXT NOT NULL,
  `gameplay_mechanic` TEXT NOT NULL,
  `solved_by` VARCHAR(255) NULL,
  `canon_status` VARCHAR(255) NOT NULL DEFAULT 'historia',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_puzzle_1` (`name`),
  CONSTRAINT `fk_puzzle_chapter_id` FOREIGN KEY (`chapter_id`) REFERENCES `chapter` (`id`),
  CONSTRAINT `fk_puzzle_location_id` FOREIGN KEY (`location_id`) REFERENCES `location` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- quest
CREATE TABLE IF NOT EXISTS `quest` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(190) NOT NULL,
  `chapter_id` INT NOT NULL,
  `location_id` INT NULL,
  `quest_type` VARCHAR(255) NOT NULL DEFAULT 'principal',
  `objective` TEXT NOT NULL,
  `quest_prerequisite_id` INT NULL,
  `suggested_reward` TEXT NULL,
  `canon_status` VARCHAR(255) NOT NULL DEFAULT 'adaptacion_jugable',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_quest_1` (`title`),
  INDEX `idx_quest_chapter` (`chapter_id`),
  CONSTRAINT `fk_quest_quest_prerequisite_id` FOREIGN KEY (`quest_prerequisite_id`) REFERENCES `quest` (`id`),
  CONSTRAINT `fk_quest_location_id` FOREIGN KEY (`location_id`) REFERENCES `location` (`id`),
  CONSTRAINT `fk_quest_chapter_id` FOREIGN KEY (`chapter_id`) REFERENCES `chapter` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- quest_puzzle
CREATE TABLE IF NOT EXISTS `quest_puzzle` (
  `quest_id` INT NOT NULL,
  `puzzle_id` INT NOT NULL,
  PRIMARY KEY (`quest_id`, `puzzle_id`),
  CONSTRAINT `fk_quest_puzzle_puzzle_id` FOREIGN KEY (`puzzle_id`) REFERENCES `puzzle` (`id`),
  CONSTRAINT `fk_quest_puzzle_quest_id` FOREIGN KEY (`quest_id`) REFERENCES `quest` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- quest_step
CREATE TABLE IF NOT EXISTS `quest_step` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `quest_id` INT NOT NULL,
  `step_number` INT NOT NULL,
  `objective` TEXT NOT NULL,
  `interaction` TEXT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_quest_step_1` (`quest_id`, `step_number`),
  INDEX `idx_quest_step` (`quest_id`, `step_number`),
  CONSTRAINT `fk_quest_step_quest_id` FOREIGN KEY (`quest_id`) REFERENCES `quest` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- relationship
CREATE TABLE IF NOT EXISTS `relationship` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `character_a_id` INT NOT NULL,
  `character_b_id` INT NOT NULL,
  `relationship_type` VARCHAR(190) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_relationship_1` (`character_a_id`, `character_b_id`, `relationship_type`),
  CONSTRAINT `fk_relationship_character_b_id` FOREIGN KEY (`character_b_id`) REFERENCES `character` (`id`),
  CONSTRAINT `fk_relationship_character_a_id` FOREIGN KEY (`character_a_id`) REFERENCES `character` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- save_slot
CREATE TABLE IF NOT EXISTS `save_slot` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `slot_name` VARCHAR(255) NOT NULL,
  `player_character_id` INT NOT NULL,
  `current_chapter_id` INT NULL,
  `current_location_id` INT NULL,
  `level` INT NOT NULL DEFAULT 1,
  `current_hp` INT NOT NULL DEFAULT 100,
  `max_hp` INT NOT NULL DEFAULT 100,
  `created_utc` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `saved_utc` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `chk_save_slot_level` CHECK (`level` >= 1),
  CONSTRAINT `fk_save_slot_current_location_id` FOREIGN KEY (`current_location_id`) REFERENCES `location` (`id`),
  CONSTRAINT `fk_save_slot_current_chapter_id` FOREIGN KEY (`current_chapter_id`) REFERENCES `chapter` (`id`),
  CONSTRAINT `fk_save_slot_player_character_id` FOREIGN KEY (`player_character_id`) REFERENCES `character` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- save_flag
CREATE TABLE IF NOT EXISTS `save_flag` (
  `save_slot_id` INT NOT NULL,
  `flag_key` VARCHAR(190) NOT NULL,
  `flag_value` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`save_slot_id`, `flag_key`),
  CONSTRAINT `fk_save_flag_save_slot_id` FOREIGN KEY (`save_slot_id`) REFERENCES `save_slot` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- save_inventory
CREATE TABLE IF NOT EXISTS `save_inventory` (
  `save_slot_id` INT NOT NULL,
  `item_id` INT NOT NULL,
  `quantity` INT NOT NULL DEFAULT 1,
  PRIMARY KEY (`save_slot_id`, `item_id`),
  CONSTRAINT `chk_save_inventory_quantity` CHECK (`quantity` >= 0),
  CONSTRAINT `fk_save_inventory_item_id` FOREIGN KEY (`item_id`) REFERENCES `item` (`id`),
  CONSTRAINT `fk_save_inventory_save_slot_id` FOREIGN KEY (`save_slot_id`) REFERENCES `save_slot` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- save_quest_state
CREATE TABLE IF NOT EXISTS `save_quest_state` (
  `save_slot_id` INT NOT NULL,
  `quest_id` INT NOT NULL,
  `state` VARCHAR(255) NOT NULL,
  `step_number` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`save_slot_id`, `quest_id`),
  CONSTRAINT `chk_save_quest_state_state` CHECK (`state` IN ('bloqueada', 'disponible', 'activa', 'completada')),
  CONSTRAINT `fk_save_quest_state_quest_id` FOREIGN KEY (`quest_id`) REFERENCES `quest` (`id`),
  CONSTRAINT `fk_save_quest_state_save_slot_id` FOREIGN KEY (`save_slot_id`) REFERENCES `save_slot` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- story_event
CREATE TABLE IF NOT EXISTS `story_event` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `chapter_id` INT NULL,
  `event_title` TEXT NOT NULL,
  `kevin_age` INT NULL,
  `location_id` INT NULL,
  `description` TEXT NOT NULL,
  `event_type` VARCHAR(255) NOT NULL DEFAULT 'historia',
  PRIMARY KEY (`id`),
  INDEX `idx_event_chapter` (`chapter_id`),
  CONSTRAINT `fk_story_event_location_id` FOREIGN KEY (`location_id`) REFERENCES `location` (`id`),
  CONSTRAINT `fk_story_event_chapter_id` FOREIGN KEY (`chapter_id`) REFERENCES `chapter` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- subrace
CREATE TABLE IF NOT EXISTS `subrace` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `race_id` INT NOT NULL,
  `name` VARCHAR(190) NOT NULL,
  `description` TEXT NULL,
  `canon_status` VARCHAR(255) NOT NULL DEFAULT 'pendiente',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_subrace_1` (`race_id`, `name`),
  CONSTRAINT `fk_subrace_race_id` FOREIGN KEY (`race_id`) REFERENCES `race` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Las vistas consultan directamente las tablas normalizadas.
CREATE OR REPLACE VIEW `vw_character_roster` AS
SELECT c.`id`, c.`name`, r.`name` AS `race`, COALESCE(rl.`symbol`, '—') AS `rank`, c.`role`, c.`canon_status`
FROM `character` c JOIN `race` r ON r.`id` = c.`race_id`
LEFT JOIN `rank_level` rl ON rl.`id` = c.`rank_id`;

CREATE OR REPLACE VIEW `vw_quest_path` AS
SELECT q.`id`, q.`title`, ch.`title` AS `chapter`, q.`objective`, q.`quest_type`, q.`quest_prerequisite_id`
FROM `quest` q JOIN `chapter` ch ON q.`chapter_id` = ch.`id`;

-- Carga inicial de la historia; ejecutar solo sobre las tablas vacías.
USE `el_ultimo_elfo`;
SET NAMES utf8mb4;
START TRANSACTION;
-- ability: 17 registros
INSERT INTO `ability` (`id`, `name`, `magic_family`, `description`, `gameplay_usage`, `canon_status`) VALUES
  (1, 'Ilusión de apariencia humana', 'Ilusión', 'Kevin disimula sus rasgos élficos.', 'Disfraz social y diálogos por reputación.', 'historia'),
  (2, 'Señuelo ilusorio', 'Ilusión', 'Kevin crea una copia falsa de sí mismo.', 'Distracción de enemigos, placas y acertijos.', 'historia'),
  (3, 'Visión de ilusiones', 'Ilusión', 'La lente revela caminos ocultos e ilusiones enemigas.', 'Activar pistas y detectar objetivos auténticos.', 'historia'),
  (4, 'Llamarada', 'Fuego', 'Kevin lanza fuego, inicialmente difícil de controlar.', 'Combate y encendido de objetos.', 'historia'),
  (5, 'Ráfaga de fuego', 'Fuego', 'Kevin utiliza fuego para atravesar distancias cortas.', 'Movilidad de corto alcance.', 'historia'),
  (6, 'Aumento de fuerza', 'Físico', 'Kevin desarrolla fuerza de forma inusual.', 'Combate y desplazamiento de mecanismos.', 'historia'),
  (7, 'Llama dorada', 'Fuego', 'En el clímax, Kevin controla fuego blanco y dorado.', 'Habilidad final de la historia.', 'historia'),
  (8, 'Corriente de viento', 'Viento', 'Narek genera ráfagas y mueve aspas o agua.', 'Planeo, impulso y rompecabezas ambientales.', 'historia'),
  (9, 'Velocidad en ráfagas', 'Velocidad', 'Camila recorre distancias cortas rápidamente.', 'Interruptores temporizados.', 'historia'),
  (10, 'Memorias del corazón', 'Corazón', 'Veyra puede revelar recuerdos que conservan los objetos.', 'Diálogos, pistas y recuerdos ocultos.', 'historia'),
  (11, 'Protección del corazón', 'Corazón', 'Veyra protege y consuela a aliados.', 'Escudo cooperativo.', 'historia'),
  (12, 'Manipulación de oscuridad', 'Oscuridad', 'Darel sostiene o absorbe sombras.', 'Cruzar áreas oscuras y proteger caminos.', 'historia'),
  (13, 'Siluetas oscuras', 'Oscuridad', 'Maelthar proyecta formas para engañar a testigos.', 'Encuentros con señuelos y prueba de evidencia.', 'historia'),
  (14, 'Dominio abisal', 'Oscuridad', 'Varkhazar busca absorber energías usando la Corona Abisal.', 'Poder del jefe final.', 'historia'),
  (15, 'Espada del rango Z', 'Armas', 'Harl lucha con una espada de gran tamaño.', 'Acompañante en la fase final.', 'historia'),
  (16, 'Lanza y barrera', 'Armas', 'Mylanda lucha con lanza y barreras.', 'Acompañante en la fase final.', 'historia'),
  (17, 'Memoria del Héroe del Alba', 'Legado', 'Recuerdo ancestral de Ardan que vive en Kevin.', 'Revelación narrativa final.', 'historia');

-- chapter: 12 registros
INSERT INTO `chapter` (`id`, `title`, `synopsis`, `kevin_age`, `stage_type`) VALUES
  (1, 'El camino más allá del bosque', 'Kevin sale de la casa de sus abuelos con bastón y brújula.', 12, 'principal'),
  (2, 'El observatorio y el zorro del viento', 'Kevin descubre un fragmento de corazón, rescata a Narek y comienza su aventura compartida.', 12, 'principal'),
  (3, 'El bosque que no aparecía en los mapas', 'Kevin conoce Lethwyn y aprende a revelar ilusiones con su lente.', NULL, 'principal'),
  (4, 'La voz del corazón', 'Veyra aporta su magia de recuerdos y el grupo investiga los ataques.', NULL, 'principal'),
  (5, 'La chica de las estrellas', 'Kevin conoce a Camila en la Biblioteca Sumergida de Asterion.', 15, 'principal'),
  (6, 'Las cinco pruebas', 'El grupo obtiene piezas de defensa en cinco santuarios y suma a Darel.', NULL, 'principal'),
  (7, 'El día que todos lo llamaron monstruo', 'Maelthar incrimina a Kevin tras el sabotaje del puente de Vardel.', NULL, 'principal'),
  (8, 'Los diez de rango Z', 'Harl y Mylanda muestran el nivel de poder que habían ocultado.', NULL, 'principal'),
  (9, 'La última puerta', 'Cinco razas se movilizan hacia la Fortaleza del Eclipse y se revela la verdad sobre Maelthar.', 18, 'principal'),
  (10, 'El regreso del héroe', 'La identidad de Ardan se manifiesta y los aliados vencen a Varkhazar.', 18, 'principal'),
  (11, 'El mundo después de la guerra', 'Comienza la reconciliación y Kevin deja de ocultar su identidad.', 18, 'epilogo'),
  (12, 'Escena poscréditos', 'Lucifer Asterion despierta y anticipa un conflicto futuro.', NULL, 'poscreditos');

-- cinematic: 12 registros
INSERT INTO `cinematic` (`id`, `chapter_id`, `title`, `trigger_event`, `storyboard`, `camera_note`, `suggested_duration_seconds`, `canon_status`) VALUES
  (1, 1, 'La despedida', 'Comenzar nueva partida', 'Kevin recibe el bastón y la brújula; se despide de sus abuelos y sale del bosque.', 'Primeros planos de objetos y seguimiento de espaldas.', 60, 'adaptacion_jugable'),
  (2, 2, 'El nuevo compañero', 'Liberar a Narek', 'Kevin libera al zorro, el viento y el fuego los ayudan a huir, y Narek decide acompañarlo.', 'Plano corto del zorro y plano amplio del cañón.', 45, 'adaptacion_jugable'),
  (3, 3, 'El rostro al descubierto', 'Entrar al bosque de Lethwyn', 'La lluvia deshace la ilusión y los guardianes observan las orejas de Kevin.', 'Transición de cámara detrás del protagonista a guardianes.', 40, 'adaptacion_jugable'),
  (4, 5, 'La estrella errante', 'Primer encuentro con Camila', 'Kevin y Camila se conocen en la biblioteca y cooperan ante la inundación.', 'Plano alternado entre anillos y la lanza.', 75, 'adaptacion_jugable'),
  (5, 6, 'El demonio que eligió', 'Encontrar a Darel', 'Darel explica que abandonó la guardia del Rey y se une a los aliados.', 'Contraste entre sombra y siluetas iluminadas.', 50, 'adaptacion_jugable'),
  (6, 7, 'El puente de Vardel', 'Completar acción del núcleo', 'El mecanismo colapsa, Maelthar incrimina a Kevin y la gente descubre su identidad.', 'Vista del puente seguida de reacción de la multitud.', 90, 'adaptacion_jugable'),
  (7, 8, 'El secreto del rango Z', 'Regresar al hogar', 'Harl y Mylanda revelan que están entre los diez humanos Z.', 'Entrada a la casa y enfoque a las armas.', 60, 'adaptacion_jugable'),
  (8, 9, 'La verdad de Maelthar', 'Derrotar a Maelthar', 'Veyra proyecta la prueba del sabotaje de Vardel.', 'Cámara orbital del recuerdo mágico.', 65, 'adaptacion_jugable'),
  (9, 10, 'El legado de Ardan', 'Inicio de segunda fase del Rey', 'Kevin descubre la memoria del Héroe del Alba y controla la llama dorada.', 'Transición de memoria ancestral a Kevin.', 90, 'adaptacion_jugable'),
  (10, 10, 'La llama de todos', 'Completar cinco símbolos', 'Los aliados sostienen la última llama, el Rey cae y la Corona Abisal se rompe.', 'Plano conjunto de las cinco razas.', 80, 'adaptacion_jugable'),
  (11, 11, 'Un nuevo comienzo', 'Final del epílogo', 'Kevin regresa a Vardel sin ocultar su identidad y homenajea a quienes ayudaron.', 'Plano abierto de la ciudad reconstruida.', 70, 'adaptacion_jugable'),
  (12, 12, 'El despertar de Lucifer', 'Después de créditos', 'Lucifer Asterion abre los ojos en su cámara subterránea.', 'Plano al trono y fundido a negro.', 35, 'adaptacion_jugable');

-- game: 1 registros
INSERT INTO `game` (`id`, `title`, `subtitle`, `genre`, `protagonist_id`, `age_start`, `age_final`, `ancient_war_years_ago`, `synopsis`, `canon_note`, `version`) VALUES
  (1, 'El Último Elfo: El Despertar de una Leyenda', 'La llama de las cinco razas', 'RPG 3D de mundo abierto', 1, 12, 18, 3000, 'Kevin Onems Lupsus Karlhan, un elfo criado por humanos, recorre un mundo de cinco razas, reúne aliados y reliquias, enfrenta prejuicios, descubre que porta una parte del alma de Ardan Solvar y se opone al Rey Demonio Varkhazar Noctivar.', 'La historia original indica dos cronologías incompatibles sobre el despertar del Rey Demonio. No se ha fijado una fecha oficial; revisar lore_issue.', '1.0');

-- lore_issue: 4 registros
INSERT INTO `lore_issue` (`id`, `field_name`, `original_conflict`, `recommended_resolution`, `resolution_status`) VALUES
  (1, 'despertar_rey_demonio', 'Al salir Kevin a los 12 años se afirma que Varkhazar lleva 18 años preparando su retorno; al cumplir Kevin 18 se afirma que despertó hace 18 años.', 'Aclarar si el Rey despertó antes del nacimiento de Kevin o si empezó a reunir una guardia antes de recuperar conciencia. No modificar hasta que el autor lo decida.', 'pendiente'),
  (2, 'orden_ultimo_mural', 'El texto indica que cinco símbolos deben encenderse según un mural, pero no especifica el orden exacto.', 'Definir el diseño visual del mural y su orden antes de programar el puzzle final.', 'pendiente'),
  (3, 'subrazas', 'El concepto original menciona subespecies y variantes para cada raza, pero sin nombres ni atributos concretos.', 'Agregar especies/castas/variantes a subrace cuando el autor establezca el canon.', 'pendiente'),
  (4, 'rangos_kevin', 'El trasfondo describe a Kevin en rango C y la historia lo mide como B al iniciar la aventura.', 'Interpretar como progresión C hacia B, pero confirmar edades exactas de cada ascenso.', 'pendiente');

-- race: 5 registros
INSERT INTO `race` (`id`, `name`, `summary`, `lifespan_years`, `typical_magic`, `playable`) VALUES
  (1, 'Elfos', 'Raza de Kevin; vinculada a ilusiones y bosques protegidos.', 300, 'Ilusión', 1),
  (2, 'Humanos', 'Civilizaciones, artefactos, armas y sistema de rangos.', NULL, 'Combate, velocidad y técnicas', 1),
  (3, 'Animales', 'Personas de rasgos animales, como Narek, el zorro gris.', 120, 'Magia elemental y fuerza', 1),
  (4, 'Espíritus', 'Seres vinculados a recuerdos, emociones y magia del corazón.', 350, 'Corazón y recuerdos', 1),
  (5, 'Demonios', 'Seres que pueden utilizar la oscuridad; no todos apoyan al Rey Demonio.', 1500, 'Oscuridad', 1);

-- rank_level: 9 registros
INSERT INTO `rank_level` (`id`, `symbol`, `strength_order`, `human_population_percent`, `notes`) VALUES
  (1, 'G', 1, 27.0, 'Sistema de rangos; porcentaje referido a humanos'),
  (2, 'F', 2, 20.0, 'Sistema de rangos; porcentaje referido a humanos'),
  (3, 'E', 3, 13.0, 'Sistema de rangos; porcentaje referido a humanos'),
  (4, 'D', 4, 12.0, 'Sistema de rangos; porcentaje referido a humanos'),
  (5, 'C', 5, 10.0, 'Kevin alcanzó rango C antes de iniciar su viaje'),
  (6, 'B', 6, 8.0, 'Cristal registra a Kevin como B durante su aventura'),
  (7, 'A', 7, 7.0, 'Sistema de rangos; porcentaje referido a humanos'),
  (8, 'S', 8, 2.99999998, 'Sistema de rangos; porcentaje referido a humanos'),
  (9, 'Z', 9, 2e-08, 'Solo diez humanos pertenecen a Z; Harl y Mylanda son dos');

-- character: 17 registros
INSERT INTO `character` (`id`, `name`, `race_id`, `rank_id`, `role`, `introduction`, `first_chapter_id`, `age_first_appearance`, `status_final`, `canon_status`, `asset_key`) VALUES
  (1, 'Kevin Onems Lupsus Karlhan', 1, 6, 'Protagonista', 'Elfo criado por dos humanos; usa ilusión, fuego y gran fuerza.', 1, 12, 'Sobrevive y rechaza ocultar sus orejas.', 'historia', 'kevin'),
  (2, 'Harl Lupsus', 2, 9, 'Abuelo adoptivo', 'Humano de rango Z retirado; enseña a Kevin a luchar con control.', 1, NULL, 'Fallece protegiendo a Kevin.', 'historia', 'harl'),
  (3, 'Mylanda Karlhan', 2, 9, 'Abuela adoptiva', 'Humana de rango Z retirada; usa lanza y barreras.', 1, NULL, 'Fallece protegiendo a Kevin.', 'historia', 'mylanda'),
  (4, 'Narek Silev', 3, NULL, 'Aliado', 'Zorro gris que manipula el viento; amigo de Kevin.', 2, NULL, 'Ayuda a proteger su aldea.', 'historia', 'narek'),
  (5, 'Aelwen Aralis', 1, NULL, 'Guardiana', 'Guardiana de Lethwyn, enseña a Kevin a mirar más allá de la ilusión.', 3, NULL, 'Permanece vinculada a Lethwyn.', 'historia', 'aelwen'),
  (6, 'Veyra', 4, NULL, 'Aliada', 'Espíritu capaz de percibir emociones conservadas en objetos.', 4, NULL, 'Ayuda en la reconstrucción; su luz se debilita.', 'historia', 'veyra'),
  (7, 'Camila Vesperine Stardew', 2, NULL, 'Aliada', 'Cartógrafa y combatiente humana, dos años mayor que Kevin.', 5, 17, 'Acompaña a Kevin después de la guerra.', 'historia', 'camila'),
  (8, 'Darel Vhal', 5, NULL, 'Aliado', 'Demonio que abandona la guardia del Rey por desacuerdo con sus métodos.', 6, NULL, 'Ayuda a demonios que quieren vivir en paz.', 'historia', 'darel'),
  (9, 'Varkhazar Noctivar', 5, NULL, 'Antagonista principal', 'Rey Demonio que busca dominar la energía de las cinco razas.', 1, NULL, 'Derrotado; la Corona Abisal se rompe.', 'historia', 'varkhazar'),
  (10, 'Maelthar', 5, NULL, 'Antagonista', 'General que manipula siluetas oscuras para incriminar a Kevin.', 7, NULL, 'Derrotado en la fortaleza.', 'historia', 'maelthar'),
  (11, 'Ardan Solvar', 2, NULL, 'Héroe antiguo', 'Héroe del Alba que selló a Varkhazar hace 3000 años.', 10, NULL, 'Su legado y parte de su alma viven en Kevin.', 'historia', 'ardan'),
  (12, 'Lucifer Asterion', 5, NULL, 'Antagonista futuro', 'Dios del Infierno revelado al final de la historia.', 12, NULL, 'Despierta en poscréditos.', 'historia', 'lucifer'),
  (13, 'Selene Arvelis', 1, NULL, 'Concepto representativo', 'Concepto visual elfo vinculado a conocimiento perdido e ilusión.', NULL, NULL, NULL, 'concepto_visual', 'selene'),
  (14, 'Ryder Valen', 2, NULL, 'Concepto representativo', 'Concepto visual humano especializado en armas.', NULL, NULL, NULL, 'concepto_visual', 'ryder'),
  (15, 'Kairo Felnar', 3, NULL, 'Concepto representativo', 'Concepto visual animal con fuerza salvaje y elemento.', NULL, NULL, NULL, 'concepto_visual', 'kairo'),
  (16, 'Aelina Hareth', 4, NULL, 'Concepto representativo', 'Concepto visual espíritu con magia del corazón.', NULL, NULL, NULL, 'concepto_visual', 'aelina'),
  (17, 'Veldrak Noctis', 5, NULL, 'Concepto representativo', 'Concepto visual demonio de poder destructivo.', NULL, NULL, NULL, 'concepto_visual', 'veldrak');

-- character_ability: 18 registros
INSERT INTO `character_ability` (`character_id`, `ability_id`, `learned_age`, `notes`) VALUES
  (1, 1, NULL, 'Ilusión desde pequeño'),
  (1, 2, NULL, 'Aprende en el Laberinto'),
  (1, 3, NULL, 'Requiere lente encantada'),
  (1, 4, 10, 'Fuego aparece a los diez años'),
  (1, 5, NULL, 'Mejora durante las cinco pruebas'),
  (1, 6, NULL, 'Talento de aprendizaje y fuerza'),
  (1, 7, 18, 'Despertar final'),
  (1, 17, 18, 'Revelación del alma de Ardan'),
  (4, 8, NULL, 'Afinidad con el viento'),
  (7, 9, NULL, 'Ráfagas breves'),
  (6, 10, NULL, 'Recuerdos en objetos'),
  (6, 11, NULL, 'Defensa y cuidado'),
  (8, 12, NULL, 'Magia demoníaca propia'),
  (10, 13, NULL, 'Engaños de Vardel'),
  (9, 14, NULL, 'Magia del Rey'),
  (2, 15, NULL, 'Habilidad oculta'),
  (3, 16, NULL, 'Habilidad oculta'),
  (11, 17, NULL, 'Legado del héroe');

-- dialogue: 11 registros
INSERT INTO `dialogue` (`id`, `chapter_id`, `speaker_id`, `context_tag`, `line`, `original_or_adapted`) VALUES
  (1, 1, 2, 'despedida', 'No necesitas demostrarle nada al mundo.', 'original'),
  (2, 1, 3, 'despedida', 'Pero sí tienes que aprender a decidir qué hacer con ellas.', 'original'),
  (3, 2, 4, 'amistad', '¿Y eso es un problema?', 'original'),
  (4, 3, 5, 'mentor', 'Puede ocultar lo que eres, pero también puede mostrarte lo que los demás no ven.', 'original'),
  (5, 5, 7, 'confianza', 'No vuelvas a decidir por mí qué puedo aceptar.', 'original'),
  (6, 6, 8, 'desercion', 'No todos los demonios quieren la guerra.', 'original'),
  (7, 7, 7, 'reconciliacion', 'Te equivocaste. Pero eso no significa que quisieras hacer daño.', 'adaptado'),
  (8, 10, 11, 'legado', 'Mi vida terminó hace mucho tiempo. La tuya te pertenece.', 'original'),
  (9, 10, 1, 'identidad', 'Soy Kevin Onems Lupsus Karlhan.', 'original'),
  (10, 11, 1, 'epilogo', 'No vuelvan a decidir quién es alguien solo por sus orejas, sus cuernos o su magia.', 'original'),
  (11, 12, 12, 'amenaza', 'Varkhazar ha caído.', 'original');

-- faction: 4 registros
INSERT INTO `faction` (`id`, `name`, `description`, `leader_character_id`) VALUES
  (1, 'Compañeros de Kevin', 'Grupo de las cinco razas formado durante la aventura.', 1),
  (2, 'Guardia del Rey Demonio', 'Fuerzas que buscan imponer el dominio de Varkhazar.', 9),
  (3, 'Guardianes de Lethwyn', 'Elfos que custodian el bosque oculto.', 5),
  (4, 'Opositores demonios', 'Demonios que rechazan el mandato de Varkhazar.', 8);

-- faction_member: 9 registros
INSERT INTO `faction_member` (`faction_id`, `character_id`, `membership`) VALUES
  (1, 1, 'Líder narrativo'),
  (1, 4, 'Compañero'),
  (1, 6, 'Compañera'),
  (1, 7, 'Compañera'),
  (1, 8, 'Compañero'),
  (2, 9, 'Rey'),
  (2, 10, 'General'),
  (3, 5, 'Guardiana'),
  (4, 8, 'Aliado');

-- region: 9 registros
INSERT INTO `region` (`id`, `name`, `race_id`, `description`, `canon_status`) VALUES
  (1, 'Zona del hogar de Kevin', NULL, 'Bosque donde Kevin vive con Harl y Mylanda.', 'adaptacion_cartografica'),
  (2, 'Alturas de las Tres Lunas', NULL, 'Montañas y ruinas que rodean al observatorio.', 'adaptacion_cartografica'),
  (3, 'Bosque de Lethwyn', 1, 'Refugio elfo protegido por ilusiones.', 'historia'),
  (4, 'Tierras del manantial', 4, 'Área espiritual alrededor del manantial donde vive Veyra.', 'adaptacion_cartografica'),
  (5, 'Asterion', 2, 'Área de la biblioteca sumergida.', 'adaptacion_cartografica'),
  (6, 'Territorios de los cinco santuarios', NULL, 'Áreas de las cinco pruebas antiguas.', 'adaptacion_cartografica'),
  (7, 'Vardel', 2, 'Ciudad humana con un puente y defensas antiguas.', 'historia'),
  (8, 'Dominio del Eclipse', 5, 'Entorno de la fortaleza del Rey Demonio.', 'adaptacion_cartografica'),
  (9, 'Profundidades desconocidas', 5, 'Zona oculta que se muestra después de los créditos.', 'adaptacion_cartografica');

-- location: 17 registros
INSERT INTO `location` (`id`, `name`, `region_id`, `location_type`, `description`, `canon_status`, `accessible_from_chapter`) VALUES
  (1, 'Casa de Harl y Mylanda', 1, 'Hogar', 'Lugar donde Kevin creció; punto inicial del viaje.', 'descripcion_de_historia', 1),
  (2, 'Observatorio de las Tres Lunas', 2, 'Ruina', 'Ruina de los tres espejos y la inscripción de las estrellas.', 'historia', 2),
  (3, 'Cañón de Narek', 2, 'Cañón', 'Zona de rescate del zorro atrapado por una red.', 'descripcion_de_historia', 2),
  (4, 'Bosque de Lethwyn', 3, 'Bosque', 'Región elfa oculta por ilusiones.', 'historia', 3),
  (5, 'Laberinto del Rostro Verdadero', 3, 'Templo', 'Puertas y espejos que ocultan una lente encantada.', 'historia', 3),
  (6, 'Manantial de Veyra', 4, 'Manantial', 'Manantial protegido por cuatro estatuas de emociones.', 'nombre_descriptivo', 4),
  (7, 'Biblioteca Sumergida de Asterion', 5, 'Biblioteca', 'Ruina inundada donde el grupo obtiene un mapa de las cinco pruebas.', 'historia', 5),
  (8, 'Torre de los Engranajes', 6, 'Santuario humano', 'Prueba de engranajes y mecanismos.', 'historia', 6),
  (9, 'Pico del Vendaval', 6, 'Santuario animal', 'Prueba de corrientes de aire y banderas.', 'historia', 6),
  (10, 'Bosque de los Espejos', 6, 'Santuario elfo', 'Prueba de reflejos e ilusiones.', 'historia', 6),
  (11, 'Jardín del Corazón', 6, 'Santuario espíritu', 'Prueba de recuerdos y piedras del corazón.', 'historia', 6),
  (12, 'Cripta de Obsidiana', 6, 'Santuario demonio', 'Prueba de luz y sombra; encuentro con Darel.', 'historia', 6),
  (13, 'Ciudad de Vardel', 7, 'Ciudad', 'Ciudad donde Kevin es acusado de traición.', 'historia', 7),
  (14, 'Puente de Vardel', 7, 'Puente', 'Estructura con un mecanismo saboteado por Maelthar.', 'nombre_descriptivo', 7),
  (15, 'Fortaleza del Eclipse', 8, 'Fortaleza', 'Bastión de Varkhazar y lugar de la batalla final.', 'historia', 9),
  (16, 'Cámara de la Corona Abisal', 8, 'Sala final', 'Cámara del combate decisivo y los cinco símbolos.', 'nombre_descriptivo', 10),
  (17, 'Cámara subterránea de Lucifer', 9, 'Escena poscréditos', 'Lugar donde Lucifer despierta en un trono de piedra.', 'nombre_descriptivo', 12);

-- enemy_type: 6 registros
INSERT INTO `enemy_type` (`id`, `name`, `description`, `race_id`, `location_id`, `canon_status`, `suggested_level`) VALUES
  (1, 'Criaturas oscuras parecidas a lobos', 'Bloquean un puente en la primera aventura y aparecen durante ataques.', NULL, 2, 'historia', NULL),
  (2, 'Criaturas oscuras del cañón', 'Amenazan a Narek antes de que Kevin lo rescate.', NULL, 3, 'historia', NULL),
  (3, 'Patrullas en Vardel', 'Soldados que persiguen a Kevin tras ser acusado.', 2, 13, 'adaptacion_jugable', NULL),
  (4, 'Servidores del Rey Demonio', 'Fuerzas de Varkhazar y Maelthar.', 5, 15, 'historia', NULL),
  (5, 'Maelthar (jefe)', 'General demonio que crea siluetas oscuras.', 5, 15, 'historia', NULL),
  (6, 'Varkhazar Noctivar (jefe final)', 'Rey Demonio que utiliza copias y la Corona Abisal.', 5, 16, 'historia', NULL);

-- item: 13 registros
INSERT INTO `item` (`id`, `name`, `category`, `description`, `mechanic`, `initial_location_id`, `original_owner_id`, `rarity`) VALUES
  (1, 'Bastón de fresno', 'Arma', 'Talla de Harl con la que Kevin sale de casa.', 'Arma inicial que se pierde en el final.', 1, 1, 'historia'),
  (2, 'Brújula de cobre', 'Historia', 'Regalo de Mylanda a Kevin.', 'Objeto clave y pista de Veyra.', 1, 1, 'historia'),
  (3, 'Fragmento de Corazón', 'Mejora', 'Cristal que aumenta la resistencia.', 'Cuatro fragmentos forman un corazón y amplían vida máxima.', 2, NULL, 'historia'),
  (4, 'Lente encantada', 'Herramienta', 'Permite revelar ilusiones y caminos ocultos.', 'Habilita visión especial.', 5, 1, 'historia'),
  (5, 'Estrella Errante', 'Arma', 'Lanza ligera de Camila.', 'Arma de Camila con mejoras posteriores.', 7, 7, 'historia'),
  (6, 'Mapa de Asterion', 'Historia', 'Mapa de cinco santuarios y la fortaleza.', 'Desbloquea rutas de misiones.', 7, 7, 'historia'),
  (7, 'Corona Abisal', 'Reliquia', 'Permite a Varkhazar dominar la energía de las cinco razas.', 'Objeto del antagonista; no es equipable por Kevin.', 16, 9, 'historia'),
  (8, 'Pieza del santuario humano', 'Reliquia', 'Una de las cinco piezas de la defensa antigua.', 'Abre el mecanismo de la fortaleza.', 8, NULL, 'adaptacion_jugable'),
  (9, 'Pieza del santuario animal', 'Reliquia', 'Una de las cinco piezas de la defensa antigua.', 'Abre el mecanismo de la fortaleza.', 9, NULL, 'adaptacion_jugable'),
  (10, 'Pieza del santuario elfo', 'Reliquia', 'Una de las cinco piezas de la defensa antigua.', 'Abre el mecanismo de la fortaleza.', 10, NULL, 'adaptacion_jugable'),
  (11, 'Pieza del santuario espíritu', 'Reliquia', 'Una de las cinco piezas de la defensa antigua.', 'Abre el mecanismo de la fortaleza.', 11, NULL, 'adaptacion_jugable'),
  (12, 'Pieza del santuario demonio', 'Reliquia', 'Una de las cinco piezas de la defensa antigua.', 'Abre el mecanismo de la fortaleza.', 12, NULL, 'adaptacion_jugable'),
  (13, 'Insignias de rango Z', 'Historia', 'Insignias de Harl y Mylanda.', 'Objeto narrativo del epílogo.', 1, NULL, 'historia');

-- puzzle: 11 registros
INSERT INTO `puzzle` (`id`, `name`, `location_id`, `chapter_id`, `clue`, `solution`, `gameplay_mechanic`, `solved_by`, `canon_status`) VALUES
  (1, 'Los tres espejos', 2, 2, 'La estrella que guía, la estrella que cae y la estrella que nunca se mueve.', 'Alinear los tres espejos siguiendo el mural: guía, fugaz, fija.', 'Orientar espejos para reflejar luz.', 'Kevin', 'historia'),
  (2, 'El rostro verdadero', 5, 3, 'No sigas al reflejo que te imita. Sigue al que revela lo que falta.', 'Elegir la puerta cuyo reflejo no muestra la llama de Kevin.', 'Ilusión + inspección visual.', 'Kevin', 'historia'),
  (3, 'Las cuatro emociones', 6, 4, 'El miedo se reconoce, la pena se comparte, la ira se suelta y la esperanza se conserva.', 'Interpretar y activar las estatuas según el mensaje de emociones.', 'Estatuas interactivas; orden textual.', 'Kevin, Narek, Veyra', 'historia'),
  (4, 'Los anillos de Asterion', 7, 5, 'La que guía primero, la que cae después, la que permanece al final.', 'Ordenar anillos guía, fugaz, fija y mantener interruptores activos.', 'Anillos, placa, agua y velocidad.', 'Kevin, Camila, Narek, Veyra', 'historia'),
  (5, 'Engranajes humanos', 8, 6, 'Los engranajes pequeños deben mover los grandes.', 'Montar la transmisión con los engranajes pequeños impulsando a los grandes.', 'Piezas móviles, golpe de lanza y fuerza.', 'Kevin y Camila', 'historia'),
  (6, 'Canales del vendaval', 9, 6, 'La posición de las banderas revela la secuencia de viento.', 'Orientar ráfagas en tubos de piedra según las banderas.', 'Viento y plataformas.', 'Narek', 'historia'),
  (7, 'Sombra distinta', 10, 6, 'El sendero real proyecta una sombra distinta.', 'Usar la lente para elegir el pasillo sin reflejo idéntico.', 'Lente, espejos y señales.', 'Kevin', 'historia'),
  (8, 'Piedras del corazón', 11, 6, 'Los recuerdos no deben ser borrados para superar la prueba.', 'Revelar recuerdos y aceptarlos sin intentar alterarlos.', 'Interacción narrativa con piedras.', 'Veyra', 'historia'),
  (9, 'Detrás de la luz', 12, 6, 'No sigas la luz; busca lo que deja detrás.', 'Usar la sombra para localizar las puertas escondidas.', 'Luz, sombras y habilidad de Darel.', 'Darel', 'historia'),
  (10, 'La puerta de cinco símbolos', 15, 9, 'Cinco piezas deben quedar en el sitio correcto; las pistas están en la fortaleza.', 'Utilizar las cinco piezas y las habilidades de los aliados; no se indica un orden universal en el texto.', 'Cooperación de habilidades y encaje de reliquias.', 'Kevin, Narek, Camila, Veyra, Darel', 'historia'),
  (11, 'El mural final', 16, 10, 'Un mural muestra el orden de cinco símbolos.', 'Activar los cinco símbolos en el orden mostrado en el mural; la secuencia exacta aún no está escrita en la historia.', 'Cinco interruptores bajo presión del jefe.', 'Los cinco compañeros', 'historia');

-- quest: 18 registros
INSERT INTO `quest` (`id`, `title`, `chapter_id`, `location_id`, `quest_type`, `objective`, `quest_prerequisite_id`, `suggested_reward`, `canon_status`) VALUES
  (1, 'El primer paso', 1, 1, 'principal', 'Dejar el hogar, aprender movimiento y consultar la brújula.', NULL, 'Bastón y brújula', 'adaptacion_jugable'),
  (2, 'El orden de las estrellas', 2, 2, 'principal', 'Entrar al observatorio y recuperar el Fragmento de Corazón.', 1, '1 Fragmento de Corazón', 'adaptacion_jugable'),
  (3, 'Rescatar al zorro', 2, 3, 'principal', 'Liberar a Narek y escapar de las criaturas oscuras.', 2, 'Narek como aliado', 'adaptacion_jugable'),
  (4, 'La senda oculta', 3, 4, 'principal', 'Encontrar el bosque y superar el Laberinto del Rostro Verdadero.', 3, 'Lente encantada y señuelo', 'adaptacion_jugable'),
  (5, 'Cuatro emociones', 4, 6, 'principal', 'Abrir el manantial y conocer los recuerdos de Veyra.', 4, 'Veyra como aliada', 'adaptacion_jugable'),
  (6, 'La biblioteca inundada', 5, 7, 'principal', 'Colaborar con Camila y recuperar el mapa de los cinco santuarios.', 5, 'Camila como aliada; mapa', 'adaptacion_jugable'),
  (7, 'El santuario de los humanos', 6, 8, 'principal', 'Resolver los engranajes y recuperar la pieza humana.', 6, 'Pieza humana', 'adaptacion_jugable'),
  (8, 'El santuario de los animales', 6, 9, 'principal', 'Dirigir el viento y obtener la pieza animal.', 7, 'Pieza animal', 'adaptacion_jugable'),
  (9, 'El santuario de los elfos', 6, 10, 'principal', 'Distinguir el camino real con la lente.', 8, 'Pieza elfa', 'adaptacion_jugable'),
  (10, 'El santuario de los espíritus', 6, 11, 'principal', 'Comprender los recuerdos de las piedras del corazón.', 9, 'Pieza espíritu', 'adaptacion_jugable'),
  (11, 'El santuario de los demonios', 6, 12, 'principal', 'Encontrar la puerta y conocer a Darel.', 10, 'Pieza demonio; Darel como aliado', 'adaptacion_jugable'),
  (12, 'La sombra sobre Vardel', 7, 14, 'principal', 'Investigar el sabotaje y escapar de una acusación falsa.', 11, 'Cambio de reputación', 'adaptacion_jugable'),
  (13, 'El secreto de los abuelos', 8, 1, 'principal', 'Regresar a casa y descubrir la verdad sobre Harl y Mylanda.', 12, 'Harl y Mylanda como aliados', 'adaptacion_jugable'),
  (14, 'Hacia la Fortaleza del Eclipse', 9, 15, 'principal', 'Reunir a las razas, colocar piezas y cruzar la última puerta.', 13, 'Acceso a fortaleza', 'adaptacion_jugable'),
  (15, 'Desenmascarar a Maelthar', 9, 15, 'principal', 'Probar el sabotaje de Vardel y superar al general.', 14, 'Revelación de la verdad', 'adaptacion_jugable'),
  (16, 'La llama de las cinco razas', 10, 16, 'principal', 'Activar cinco símbolos y vencer a Varkhazar en equipo.', 15, 'Final principal', 'adaptacion_jugable'),
  (17, 'La reconstrucción', 11, 13, 'epilogo', 'Volver a Vardel y participar en la reconciliación.', 16, 'Cierre de historia', 'adaptacion_jugable'),
  (18, 'La puerta bajo el mundo', 12, 17, 'poscreditos', 'Mostrar la aparición de Lucifer Asterion.', 17, 'Gancho narrativo siguiente historia', 'adaptacion_jugable');

-- quest_puzzle: 11 registros
INSERT INTO `quest_puzzle` (`quest_id`, `puzzle_id`) VALUES
  (2, 1),
  (4, 2),
  (5, 3),
  (6, 4),
  (7, 5),
  (8, 6),
  (9, 7),
  (10, 8),
  (11, 9),
  (14, 10),
  (16, 11);

-- quest_step: 55 registros
INSERT INTO `quest_step` (`id`, `quest_id`, `step_number`, `objective`, `interaction`) VALUES
  (1, 1, 1, 'Hablar con Harl y Mylanda', 'Diálogo introductorio'),
  (2, 1, 2, 'Recoger el bastón y la brújula', 'Interacción con objetos'),
  (3, 1, 3, 'Abandonar el bosque', 'Marcador de salida'),
  (4, 2, 1, 'Leer inscripción y mural', 'Inspeccionar el techo'),
  (5, 2, 2, 'Alinear espejos', 'Rompecabezas'),
  (6, 2, 3, 'Recoger Fragmento de Corazón', 'Inventario'),
  (7, 3, 1, 'Encontrar el cañón', 'Exploración'),
  (8, 3, 2, 'Liberar a Narek', 'Interactuar con la red'),
  (9, 3, 3, 'Salir con ayuda del viento', 'Cooperación'),
  (10, 4, 1, 'Entrar en Lethwyn', 'Explorar bosque ilusorio'),
  (11, 4, 2, 'Hablar con Aelwen', 'Diálogo'),
  (12, 4, 3, 'Reconocer puerta distinta', 'Puzzle espejos'),
  (13, 4, 4, 'Recoger lente', 'Objeto especial'),
  (14, 5, 1, 'Investigar el manantial', 'Exploración'),
  (15, 5, 2, 'Leer el mensaje emocional', 'Inscripción'),
  (16, 5, 3, 'Resolver estatuas', 'Interacción'),
  (17, 5, 4, 'Hablar con Veyra', 'Nueva aliada'),
  (18, 6, 1, 'Encontrar a Camila', 'Escena'),
  (19, 6, 2, 'Resolver anillos y placas', 'Acción cooperativa'),
  (20, 6, 3, 'Recuperar mapa', 'Objeto de misión'),
  (21, 7, 1, 'Montar engranajes', 'Puzzle'),
  (22, 7, 2, 'Recoger pieza humana', 'Reliquia'),
  (23, 8, 1, 'Observar banderas', 'Pista visual'),
  (24, 8, 2, 'Orientar corrientes', 'Habilidad Narek'),
  (25, 8, 3, 'Recoger pieza animal', 'Reliquia'),
  (26, 9, 1, 'Usar lente', 'Habilidad Kevin'),
  (27, 9, 2, 'Elegir sendero real', 'Puzzle'),
  (28, 9, 3, 'Recoger pieza elfa', 'Reliquia'),
  (29, 10, 1, 'Escuchar los recuerdos', 'Habilidad Veyra'),
  (30, 10, 2, 'Superar prueba', 'Puzzle'),
  (31, 10, 3, 'Recoger pieza espíritu', 'Reliquia'),
  (32, 11, 1, 'Descubrir la sombra', 'Habilidad oscuridad'),
  (33, 11, 2, 'Conocer a Darel', 'Diálogo'),
  (34, 11, 3, 'Recoger pieza demonio', 'Reliquia'),
  (35, 12, 1, 'Investigar maquinaria', 'Inspección'),
  (36, 12, 2, 'Intentar detener el núcleo', 'Escena de evento'),
  (37, 12, 3, 'Escapar de las patrullas', 'Fase de reputación'),
  (38, 13, 1, 'Regresar a la casa', 'Viaje'),
  (39, 13, 2, 'Ver el combate de los abuelos', 'Escena'),
  (40, 13, 3, 'Unirse a sus abuelos', 'Aliados'),
  (41, 14, 1, 'Reunir pruebas y aliados', 'Escena con las cinco razas'),
  (42, 14, 2, 'Encajar cinco piezas', 'Puzzle'),
  (43, 14, 3, 'Coordinar cinco habilidades', 'Cooperación'),
  (44, 15, 1, 'Seguir el rastro del general', 'Explorar'),
  (45, 15, 2, 'Revelar recuerdo del sabotaje', 'Habilidad Veyra'),
  (46, 15, 3, 'Derrotar a Maelthar', 'Encuentro contra jefe'),
  (47, 16, 1, 'Proteger al grupo y resistir', 'Combate'),
  (48, 16, 2, 'Encontrar al verdadero Rey', 'Habilidad lente'),
  (49, 16, 3, 'Leer mural y activar cinco símbolos', 'Puzzle cooperativo'),
  (50, 16, 4, 'Usar la llama dorada', 'Cinemática y cierre');
INSERT INTO `quest_step` (`id`, `quest_id`, `step_number`, `objective`, `interaction`) VALUES
  (51, 17, 1, 'Regresar a Vardel', 'Escena'),
  (52, 17, 2, 'Hablar con sus habitantes', 'Diálogo'),
  (53, 17, 3, 'Participar en la reconstrucción', 'Objetivo epílogo'),
  (54, 18, 1, 'Mostrar trono subterráneo', 'Cinemática'),
  (55, 18, 2, 'Revelar a Lucifer', 'Escena poscréditos');

-- relationship: 11 registros
INSERT INTO `relationship` (`id`, `character_a_id`, `character_b_id`, `relationship_type`, `description`) VALUES
  (1, 1, 2, 'familia', 'Harl adoptó a Kevin y le enseñó a usar su fuerza con responsabilidad.'),
  (2, 1, 3, 'familia', 'Mylanda adoptó a Kevin y le regaló la brújula.'),
  (3, 1, 4, 'amistad', 'Kevin rescató a Narek en un cañón.'),
  (4, 1, 6, 'alianza', 'Veyra descubre un recuerdo antiguo en Kevin.'),
  (5, 1, 7, 'amistad_creciente', 'Kevin y Camila aprenden a confiar uno en otro; existe cariño no definido.'),
  (6, 1, 8, 'alianza', 'Darel se une contra el dominio de Varkhazar.'),
  (7, 1, 11, 'legado_espiritual', 'Parte del alma de Ardan renació en Kevin.'),
  (8, 9, 10, 'mando', 'Maelthar sirve a Varkhazar.'),
  (9, 8, 9, 'antiguo_mando', 'Darel desertó de la guardia de Varkhazar.'),
  (10, 1, 9, 'enemistad', 'Kevin intenta detener el control de todas las razas.'),
  (11, 1, 5, 'mentoria', 'Aelwen enseña a Kevin nuevas formas de utilizar la ilusión.');

-- save_slot: 0 registros
-- save_flag: 0 registros
-- save_inventory: 0 registros
-- save_quest_state: 0 registros
-- story_event: 15 registros
INSERT INTO `story_event` (`id`, `chapter_id`, `event_title`, `kevin_age`, `location_id`, `description`, `event_type`) VALUES
  (1, 1, 'Inicio del viaje', 12, 1, 'Kevin parte con la brújula de Mylanda y el bastón de Harl.', 'historia'),
  (2, 2, 'Primer Fragmento de Corazón', 12, 2, 'Kevin resuelve el observatorio y encuentra un fragmento de vida.', 'historia'),
  (3, 2, 'Rescate de Narek', 12, 3, 'Kevin libera a Narek Silev y ambos viajan juntos.', 'historia'),
  (4, 3, 'Encuentro con la guardiana', NULL, 4, 'Aelwen Aralis le enseña el valor de ver más allá de las apariencias.', 'historia'),
  (5, 4, 'Recuerdo de Ardan', NULL, 6, 'Veyra percibe un antiguo guerrero en la brújula de Kevin.', 'historia'),
  (6, 5, 'Encuentro con Camila', 15, 7, 'Camila, de 17 años, acompaña al grupo después de recuperar el mapa.', 'historia'),
  (7, 6, 'Cinco reliquias reunidas', NULL, 12, 'El grupo supera los cinco santuarios y conoce a Darel.', 'historia'),
  (8, 7, 'Sabotaje de Vardel', NULL, 14, 'Maelthar prepara la caída del puente y Kevin es acusado de traición.', 'historia'),
  (9, 8, 'Revelación del rango Z', NULL, 1, 'Se descubre que los dos abuelos adoptivos están entre los diez humanos Z.', 'historia'),
  (10, 9, 'Coalición de las cinco razas', 18, 15, 'Las fuerzas de las razas se reúnen ante Varkhazar.', 'historia'),
  (11, 9, 'Maelthar descubierto', 18, 15, 'El grupo demuestra que el general saboteó Vardel.', 'historia'),
  (12, 10, 'Despertar de la llama dorada', 18, 16, 'Kevin comprende que lleva una parte del alma de Ardan.', 'historia'),
  (13, 10, 'Derrota de Varkhazar', 18, 16, 'Los cinco compañeros actúan juntos y la Corona Abisal se quiebra.', 'historia'),
  (14, 11, 'Reconstrucción de Vardel', 18, 13, 'Kevin vuelve a Vardel y comienza una etapa de reconciliación.', 'historia'),
  (15, 12, 'La nueva amenaza', NULL, 17, 'Lucifer Asterion despierta bajo las tierras conocidas.', 'historia');

-- subrace: 0 registros
COMMIT;
-- Los campos de save_* están vacíos hasta que haya partidas guardadas.
