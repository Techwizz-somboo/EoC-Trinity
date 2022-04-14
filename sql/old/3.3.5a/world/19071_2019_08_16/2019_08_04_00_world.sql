-- quest pools no longer support nesting, but they also don't need it
DROP TABLE IF EXISTS `quest_pool_members`;
CREATE TABLE `quest_pool_members` (
  `questId` int(10) unsigned not null,
  `poolId` int(10) unsigned not null,
  `poolIndex` tinyint(2) unsigned not null COMMENT 'Multiple quests with the same index will always spawn together!',
  `description` varchar(255) default null,
  PRIMARY KEY (`questId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TEMPORARY TABLE `_temp_pool_quests` (
  `sortIndex` int auto_increment not null,
  `questId` int(10) unsigned not null,
  `subPool` int(10) unsigned,
  `topPool` int(10) unsigned not null,
  `description` varchar(255) default null,
  PRIMARY KEY (`sortIndex`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `quest_pool_template`;
CREATE TABLE `quest_pool_template` (
  `poolId` mediumint(8) unsigned not null,
  `numActive` int(10) unsigned not null COMMENT 'Number of indices to have active at any time',
  `description` varchar(255) default null,
  PRIMARY KEY (`poolId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- copy any quest pool templates over
INSERT INTO `quest_pool_template` (`poolId`, `numActive`, `description`)
SELECT DISTINCT pt.`entry`,pt.`max_limit`,pt.`description` FROM `quest_pool_members` qpm LEFT JOIN `pool_template` pt ON (qpm.`poolId` = pt.`entry`);

-- and delete them from the original table
DELETE pt FROM `pool_template` pt LEFT JOIN `quest_pool_template` qpt ON qpt.`poolId`=pt.`entry` WHERE qpt.`poolId` is not null;
